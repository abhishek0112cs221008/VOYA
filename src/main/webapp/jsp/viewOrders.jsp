<%@ page import="java.sql.*, model.Product, dao.ProductDAO" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Connection conn = dao.DBConnection.getConnection();
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM orders WHERE user_email='" + userEmail + "' ORDER BY order_date DESC");

    dao.ProductDAO dao = new dao.ProductDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - Voya</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="assets/logo2.png">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-dark: #000000;
            --text-dark: #212529;
            --text-light: #6c757d;
            --bg-light: #f8f9fa;
            --card-bg: #ffffff;
            --border-color: #dee2e6;
        }

        body {
            background: var(--bg-light);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
        }

        .order-card {
            background: var(--card-bg);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 24px;
            margin-bottom: 24px;
        }

        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        /* Dark Mode Styles */
        .dark-mode {
            --bg-light: #1a1a1a;
            --card-bg: #2b2b2b;
            --border-color: #444;
            --text-dark: #f1f1f1;
            --text-light: #bbb;
        }
    </style>
</head>
<body class="light-mode">

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="../HomeServlet" class="btn btn-link"><i class="bi bi-arrow-left"></i> Back to Home</a>
        <button id="themeToggle" class="btn btn-outline-dark"><i class="bi bi-moon-fill"></i></button>
    </div>
    <h1 class="mb-4">My Orders</h1>

    <%
        boolean hasOrders = rs.isBeforeFirst();
        if (hasOrders) {
            while (rs.next()) {
                int pid = rs.getInt("product_id");
                model.Product product = dao.getProductById(pid);
                String image = (product != null && product.getImageUrl() != null && !product.getImageUrl().isEmpty())
                                ? product.getImageUrl()
                                : "https://placehold.co/100x100/f8f9fa/6c757d?text=No+Image";

                String status = rs.getString("status");
                String statusClass = "";
                switch (status.toLowerCase()) {
                    case "pending": statusClass = "text-warning"; break;
                    case "shipped": statusClass = "text-primary"; break;
                    case "delivered": statusClass = "text-success"; break;
                }
    %>
    <div class="order-card">
        <div class="d-flex">
            <img src="<%= image %>" class="product-image" alt="Product Image">
            <div class="flex-grow-1 ms-4">
                <h5><%= product != null ? product.getName() : "Unknown Product" %></h5>
                <p class="text-muted">Order ID: #<%= rs.getInt("id") %></p>
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="mb-1"><strong>Quantity:</strong> <%= rs.getInt("quantity") %></p>
                        <p class="mb-0"><strong>Date:</strong> <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(rs.getTimestamp("order_date")) %></p>
                    </div>
                    <div class="text-end">
                        <p class="mb-1 fw-bold <%= statusClass %>"><%= status %></p>
                        <p class="mb-0"><strong>Payment ID:</strong> <%= rs.getString("payment_id") %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
            }
        } else {
    %>
    <div class="text-center p-5 bg-white rounded-3">
        <h3>You have no orders yet.</h3>
        <p class="text-muted">When you place an order, it will appear here.</p>
        <a href="../HomeServlet" class="btn btn-dark mt-3">Start Shopping</a>
    </div>
    <%
        }
        conn.close();
    %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const themeToggle = document.getElementById('themeToggle');
    const body = document.body;

    themeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        const isDarkMode = body.classList.contains('dark-mode');
        localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
        themeToggle.innerHTML = isDarkMode ? '<i class="bi bi-sun-fill"></i>' : '<i class="bi bi-moon-fill"></i>';
    });

    // On page load, apply saved theme
    document.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark') {
            body.classList.add('dark-mode');
            themeToggle.innerHTML = '<i class="bi bi-sun-fill"></i>';
        }
    });
</script>
</body>
</html>
