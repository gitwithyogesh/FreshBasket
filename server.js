const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());
const path = require('path');
app.use(express.static(path.join(__dirname)));

app.get('/', (req, res) => {
    res.status(200).send('FreshBasket Backend is Running 🚀');
});

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    ssl: {
        rejectUnauthorized: false
    }
});

// Test Connection
db.getConnection((err, conn) => {
    if (err) {
        console.error('❌ Database connection failed:', err.message);
    } else {
        console.log('✅ Connected to MySQL Database!');
        conn.release();
    }
});

// --- API ENDPOINTS ---

// 1. Fetch all products
app.get('/api/products', (req, res) => {
    db.query('SELECT * FROM products', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 2. User Signup
app.post('/api/signup', (req, res) => {
    const { name, email, password } = req.body;
    const sql = 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)';
    db.query(sql, [name, email, password], (err, result) => {
        if (err) {
            if (err.code === 'ER_DUP_ENTRY') return res.status(400).json({ error: 'Email already exists' });
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: 'Signup successful', userId: result.insertId });
    });
});

// 3. User Login
app.post('/api/login', (req, res) => {
    const { email, password } = req.body;
    const sql = 'SELECT * FROM users WHERE email = ? AND password = ?';
    db.query(sql, [email, password], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(401).json({ error: 'Invalid credentials' });
        res.json({ message: 'Login successful', user: results[0] });
    });
});

// 4. Place Order
app.post('/api/place-order', (req, res) => {
    const { userEmail, total, discount, method, items, address } = req.body;
    console.log('📦 Incoming Order Request:', { userEmail, total, itemsCount: items?.length });

    db.getConnection((err, conn) => {
        if (err) {
            console.error('❌ Connection Pool Error:', err.message);
            return res.status(500).json({ error: 'Database connection failed' });
        }

        conn.beginTransaction(err => {
            if (err) {
                console.error('❌ Transaction Start Error:', err.message);
                conn.release();
                return res.status(500).json({ error: 'Transaction failed' });
            }

            // 1. Save Address if provided
            if (address) {
                const addrInsert = 'INSERT INTO addresses (user_email, full_name, phone, street_address, city, state, pin_code) VALUES (?, ?, ?, ?, ?, ?, ?)';
                conn.query(addrInsert, [userEmail, address.name, address.phone, address.address || 'N/A', address.city || 'N/A', address.state || 'N/A', address.pin || 'N/A'], (err) => {
                    if (err) console.error('⚠️ Address save failed (non-critical):', err.message);
                });
            }

            // 2. Insert Order
            const orderSql = 'INSERT INTO orders (user_email, total_amount, discount_amount, payment_method) VALUES (?, ?, ?, ?)';
            conn.query(orderSql, [userEmail, total, discount || 0, method], (err, result) => {
                if (err) {
                    console.error('❌ Order Insert Failed:', err.message);
                    return conn.rollback(() => {
                        res.status(500).json({ error: 'Order failed: ' + err.message });
                        conn.release();
                    });
                }

                const orderId = result.insertId;
                const itemSql = 'INSERT INTO order_items (order_id, product_name, quantity, price_at_time) VALUES (?, ?, ?, ?)';

                let completed = 0;
                if (!items || items.length === 0) {
                    return conn.commit(err => {
                        if (err) return conn.rollback(() => { res.status(500).json({ error: 'Commit failed' }); conn.release(); });
                        res.json({ message: 'Order placed successfully (no items)', orderId });
                        conn.release();
                    });
                }

                items.forEach(item => {
                    conn.query(itemSql, [orderId, item.name, item.qty, item.price], (err) => {
                        if (err) {
                            console.error('❌ Item Insert Failed:', err.message);
                            return conn.rollback(() => {
                                res.status(500).json({ error: 'Item failed: ' + err.message });
                                conn.release();
                            });
                        }
                        completed++;
                        if (completed === items.length) {
                            conn.commit(err => {
                                if (err) {
                                    console.error('❌ Commit Failed:', err.message);
                                    return conn.rollback(() => { res.status(500).json({ error: 'Commit failed' }); conn.release(); });
                                }
                                console.log('✅ Order Placed Successfully:', orderId);
                                res.json({ message: 'Order placed successfully', orderId });
                                conn.release();
                            });
                        }
                    });
                });
            });
        });
    });
});

// 5. Get User Orders
app.get('/api/orders/:email', (req, res) => {
    const sql = `
        SELECT o.*, GROUP_CONCAT(CONCAT(oi.product_name, ' x ', oi.quantity)) as items_summary
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        WHERE o.user_email = ?
        GROUP BY o.id
        ORDER BY o.order_date DESC
    `;
    db.query(sql, [req.params.email], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// const PORT = process.env.PORT || 8080;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on port ${PORT}`);
});