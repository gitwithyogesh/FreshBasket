# 🧺 FreshBasket - Fresh Groceries Delivered Fast

FreshBasket is a modern, full-stack e-commerce platform designed for selling fresh produce, fruits, dairy, and pantry essentials. It features a sleek, responsive UI with a robust Node.js backend and MySQL database integration.

---

## 🌟 Key Features

-   **🌓 Dynamic Theme Toggle**: Seamlessly switch between Light and Dark modes.
-   **🔍 Advanced Search**: Real-time search suggestions for quick product discovery.
-   **🛒 Advanced Cart & Wishlist**: Manage your shopping lists with a smooth, interactive experience.
-   **⚡ Quick View**: Instantly view product details without leaving the main grid.
-   **🔒 Secure Authentication**: Full user signup and login functionality.
-   **📄 Multi-step Checkout**: Smooth ordering process including Address, Payment (COD/UPI/Card), and Order Summary.
-   **📱 Fully Responsive**: Optimized for all device sizes (Desktop, Tablet, Mobile).
-   **📊 Database Driven**: Products, users, and orders are persisted in a MySQL database.

---

## 🛠️ Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Backend** | Node.js, Express.js |
| **Database** | MySQL |
| **State Management** | LocalStorage (for persistent preferences) |
| **Development** | Nodemon, Dotenv, CORS |

---

## 🚀 Getting Started

### Prerequisites

-   [Node.js](https://nodejs.org/) (v14+ recommended)
-   [MySQL Server](https://www.mysql.com/)

### Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/gitwithyogesh/FreshBasket.git
    cd FreshBasket
    ```

2.  **Install Dependencies**
    ```bash
    npm install
    ```

3.  **Database Setup**
    -   Create a database named `freshbasket`.
    -   Import the schema from [FreshBasket_Schema.sql](file:///c:/Users/YOGESH/OneDrive/Desktop/FreshBasket/FreshBasket_Schema.sql).
    ```bash
    mysql -u root -p freshbasket < FreshBasket_Schema.sql
    ```

4.  **Environment Configuration**
    -   Create a `.env` file in the root directory and add your database credentials:
    ```env
    DB_HOST=localhost
    DB_USER=root
    DB_PASSWORD=your_password
    DB_NAME=freshbasket
    PORT=5000
    ```

5.  **Run the Application**
    ```bash
    # Start the server
    npm start

    # Start in development mode (with nodemon)
    npm run dev
    ```

6.  **Access the Website**
    Open `http://localhost:5000` in your browser.

---

## 📂 Project Structure

```text
FreshBasket/
├── .env                    # Environment variables
├── FreshBasket_Schema.sql   # Database schema
├── index.html              # Main frontend entry point
├── server.js               # Backend API server (Express)
├── style1.css              # Main stylesheet
├── package.json            # Project dependencies and scripts
└── ...                     # Images and other assets
```

---

## 🧪 API Endpoints

-   `GET /api/products` - Fetch all products.
-   `POST /api/signup` - Register a new user.
-   `POST /api/login` - Authenticate user.
-   `POST /api/place-order` - Create a new order with items and address.
-   `GET /api/orders/:email` - Fetch order history for a specific user.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📝 License

This project is licensed under the ISC License.

---

**Developed with ❤️ by [Yogesh](https://github.com/gitwithyogesh)**
