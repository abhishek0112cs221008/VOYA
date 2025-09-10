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
    <title>View Customers - Voya</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/logo2.png">
    
    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary-dark: #000000;
            --danger-red: #dc3545;
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
        <h2 class="mb-4 text-center">All Registered Customers</h2>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th scope="col">Customer ID</th>
                        <th scope="col">Full Name</th>
                        <th scope="col">Email Address</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> customers = (List<Map<String, String>>) request.getAttribute("customers");
                        if (customers != null && !customers.isEmpty()) {
                            for (Map<String, String> cust : customers) {
                    %>
                    <tr>
                        <td><%= cust.get("id") %></td>
                        <td><%= cust.get("name") %></td>
                        <td><%= cust.get("email") %></td>
                        <td>
                            <a href="ViewCustomers?action=delete&id=<%= cust.get("id") %>" class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this user?');">
                                <i class="bi bi-trash3"></i> Delete
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="4" class="text-center text-muted">No customers found.</td>
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
