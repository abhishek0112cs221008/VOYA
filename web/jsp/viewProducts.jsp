<%@ page import="java.util.*, model.Product, dao.ProductDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String adminEmail = (String) session.getAttribute("userEmail");
    if (adminEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - View Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/logo2.png">

    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary-dark: #000000;
            --text-dark: #212529;
            --bg-light: #f8f8f8;
            --card-bg: #ffffff;
            --border-color: #dee2e6;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
        }

        .navbar {
            background-color: var(--card-bg);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .table-container {
            margin: 40px auto;
            max-width: 1100px;
            background: var(--card-bg);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        thead th {
            background-color: var(--primary-dark) !important;
            color: white;
        }
        .table-container .table > thead > tr > th {
            background-color: #000000 !important;
            color: #ffffff !important;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">Voya Admin</a>
        <div class="d-flex align-items-center ms-auto">
            <span class="me-3"><i class="bi bi-person-circle"></i> <%= adminEmail %></span>
            <a href="logout.jsp" class="btn btn-dark btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <a href="../AdminServlet" class="btn btn-link mt-3"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>

    <!-- Product Table -->
    <div class="table-container">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>All Products</h3>
            <a href="addProduct.jsp" class="btn btn-dark"><i class="bi bi-plus-circle"></i> Add Product</a>
        </div>

        <%
            ProductDAO dao = new ProductDAO();
            List<Product> list = dao.getAllProducts();
            if (list.isEmpty()) {
        %>
            <div class="alert alert-warning text-center">No products found.</div>
        <%
            } else {
        %>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Name</th>
                        <th scope="col">Category</th>
                        <th scope="col">Price (₹)</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Description</th>
                        <th scope="col">Image</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Product p : list) {
                %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><%= p.getName() %></td>
                        <td><%= p.getCategory() %></td>
                        <td>₹<%= p.getPrice() %></td>
                        <td><%= p.getQuantity() %></td>
                        <td><%= p.getDescription() %></td>
                        <td>
                            <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                                <img src="<%= p.getImageUrl() %>" class="product-img" alt="product image">
                            <% } else { %>
                                <span class="text-muted">No Image</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="../ProductServlet?action=edit&id=<%= p.getId() %>" class="btn btn-sm btn-outline-dark me-1">
                                <i class="bi bi-pencil-square"></i> Edit
                            </a>
                            <a href="../ProductServlet?action=delete&id=<%= p.getId() %>" class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this product?');">
                                <i class="bi bi-trash3"></i> Delete
                            </a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<!-- Footer -->
<footer class="bg-white text-center py-3">
    &copy; 2025 Voya | Admin Panel
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
