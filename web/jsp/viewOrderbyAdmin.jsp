<%@ page import="java.util.*" %>
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
    <title>Admin - View Orders</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/logo2.png">
    
    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary-dark: #000000;
            --primary-hover: #333333;
            --success-green: #198754;
            --text-dark: #212529;
            --text-muted: #6c757d;
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
            margin-top: 40px;
            margin-bottom: 40px;
            background: var(--card-bg);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        thead th {
            background-color: var(--primary-dark) !important;
            color: white;
        }

        .status-form .btn-success {
            background-color: var(--success-green);
            border-color: var(--success-green);
        }
        
        .table-hover tbody tr:hover {
            background-color: #f1f3f6;
        }
        .table-container .table > thead > tr > th {
            background-color: #000000 !important;
            color: #ffffff !important;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">Voya Admin</a>
        <div class="d-flex align-items-center ms-auto">
            <span class="me-3"><i class="bi bi-person-circle"></i> <%= adminEmail %></span>
            <a href="jsp/logout.jsp" class="btn btn-dark btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <a href="AdminServlet" class="btn btn-link mt-3"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>

    <div class="table-container">
        <h2 class="mb-4 text-center">All Customer Orders</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead style="color: white">
                    <tr>
                        <th>Order ID</th>
                        <th>Customer Email</th>
                        <th>Product ID</th>
                        <th>Quantity</th>
                        <th>Order Date</th>
                        <th>Delivery Address</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> orders = (List<Map<String, String>>) request.getAttribute("orders");
                        if (orders != null && !orders.isEmpty()) {
                            for (Map<String, String> order : orders) {
                    %>
                    <tr>
                        <td><%= order.get("id") %></td>
                        <td><%= order.get("user_email") %></td>
                        <td><%= order.get("product_id") %></td>
                        <td><%= order.get("quantity") %></td>
                        <td><%= order.get("order_date") %></td>
                        <td>
                            <% if (order.get("street") != null) { %>
                                <%= order.get("full_name") %>, <%= order.get("street") %>, <%= order.get("city") %>, <%= order.get("state") %> - <%= order.get("pincode") %>, Phone: <%= order.get("phone") %>
                            <% } else { %>
                                Not Available
                            <% } %>
                        </td>
                        <td>
                            <form action="<%= request.getContextPath() %>/OrderServlet" method="post" class="d-flex gap-2">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="<%= order.get("id") %>">
                                <select name="status" class="form-select form-select-sm">
                                    <option value="Pending" <%= "Pending".equals(order.get("status")) ? "selected" : "" %>>Pending</option>
                                    <option value="Shipped" <%= "Shipped".equals(order.get("status")) ? "selected" : "" %>>Shipped</option>
                                    <option value="Delivered" <%= "Delivered".equals(order.get("status")) ? "selected" : "" %>>Delivered</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-success">Update</button>
                            </form>
                        </td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr>
                        <td colspan="7" class="text-center text-muted">No orders available.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<footer class="bg-white text-center py-3">
    &copy; 2025 Voya | Admin Panel
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
