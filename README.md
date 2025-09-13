# VOYA - Full-Stack E-commerce Web Application

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![Servlets](https://img.shields.io/badge/Servlets-007396?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)

VOYA is a complete, database-driven e-commerce website built from the ground up using Java Servlets, JSP, and MySQL. It simulates a real-world online store for a luxury handbag brand, featuring a full suite of functionalities for both customers and administrators.

---
## Key Features

### Customer-Facing:
* **User Authentication:** Secure user registration and login with password hashing.
* **Dynamic Product Catalog:** Browse a multi-category product listing fetched directly from the database.
* **Product Details:** View detailed information, images, and customer reviews for each product.
* **Shopping Cart:** A persistent, session-based cart to add, update, and remove items.
* **Wishlist:** Save favorite products for later.
* **User Profile:** Manage personal details, view saved addresses, and see order history.
* **Order Placement:** A simulated checkout process that records orders in the database.

### Admin Panel:
* **Dashboard Overview:** At-a-glance statistics for total products, customers, and orders.
* **Product Management (CRUD):** Full capabilities to Create, Read, Update, and Delete products in the catalog.
* **Order Management:** View all customer orders and update their status (e.g., Pending, Shipped, Delivered).
* **Customer Management:** View a list of all registered customers.
---



https://github.com/user-attachments/assets/e6f148be-d06a-47d7-a81d-a92a8b4bdfbd



---
## Built With

This project was built using the following technologies:

* **Backend:** Java, Servlets, JSP, JDBC
* **Database:** MySQL
* **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5
* **Server:** Apache Tomcat

---
## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* JDK 11 or later
* Apache Tomcat 9.0 or later
* MySQL Server 8.0 or later
* An IDE like Eclipse or IntelliJ IDEA

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/abhishek0112cs221008/VOYA.git
    ```
2.  **Database Setup:**
    * Create a new database in MySQL named `voya_db`.
    * Import the `voya_db.sql` file (you'll need to create this by exporting your database schema and data) to set up the required tables and data.
    * Update the database connection details in the `DBConnection.java` file with your MySQL username and password.

3.  **Deploy the Application:**
    * Open the project in your IDE.
    * Configure the Apache Tomcat server.
    * Build and deploy the application to the server.

4.  **Access the Application:**
    * Open your web browser and navigate to `http://localhost:8080/VOYA/` (or your specific project context path).
    * **Admin Login:** Use the admin credentials to access the dashboard.
    * **Customer:** Register a new account to start shopping.

---
## Contact

Your Name - Abhishek

Project Link: [https://github.com/abhishek0112cs221008/VOYA](https://github.com/your-username/voya-ecommerce)
