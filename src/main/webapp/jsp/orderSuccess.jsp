<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed - Voya</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='15' fill='#000000' /><text x='50' y='65' font-family='Inter, sans-serif' font-size='40' font-weight='bold' fill='#FFFFFF' text-anchor='middle'>VOYA</text></svg>">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-dark: #000000;
            --success-green: #198754;
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .success-box {
            max-width: 500px;
            width: 100%;
            padding: 40px;
            background-color: var(--card-bg);
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            text-align: center;
        }

        .success-icon {
            font-size: 4rem;
            color: var(--success-green);
            margin-bottom: 20px;
        }

        h2 {
            font-weight: 700;
            margin-bottom: 10px;
        }

        .message-text {
            color: var(--text-light);
            margin-bottom: 30px;
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

<div class="success-box">
    <div class="success-icon">
        <i class="bi bi-check-circle-fill"></i>
    </div>
    
    <%
        String membershipMessage = (String) session.getAttribute("membershipMessage");
        if (membershipMessage != null) {
    %>
        <div class="alert alert-success">
            <%= membershipMessage %>
        </div>
    <%
        session.removeAttribute("membershipMessage"); // Display once then remove
        }
    %>
    
    <h2>Order Placed Successfully!</h2>
    <p class="message-text">Thank you for your purchase from <strong>Voya</strong>. A confirmation email has been sent to you.</p>

    <div class="d-grid gap-2">
        <a href="viewOrders.jsp" class="btn btn-dark">
            <i class="bi bi-box-seam"></i> View My Orders
        </a>
        <a href="<%= request.getContextPath() %>/HomeServlet" class="btn btn-outline-dark">
            <i class="bi bi-house-fill"></i> Continue Shopping
        </a>
    </div>
</div>

<script>
    // On page load, apply the saved theme
    document.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme') || 'light';
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-mode');
        }
    });
</script>

</body>
</html>
