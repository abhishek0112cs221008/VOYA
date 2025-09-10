<%@ page import="java.util.*, model.CartItem, model.Product, dao.ProductDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Fetch cart and user details from session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new ArrayList<>();

    double subtotal = 0;
    
    // Check for membership
    Boolean isMember = (Boolean) session.getAttribute("isMember");
    if (isMember == null) {
        isMember = false;
    }
    
    // Get all products to do a live stock check
    ProductDAO productDAO = new ProductDAO();
    List<Product> allProducts = productDAO.getAllProducts();
    Map<Integer, Product> allProductsMap = new HashMap<>();
    for(Product p : allProducts) {
        allProductsMap.put(p.getId(), p);
    }
    
    boolean hasInsufficientStock = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart - Voya</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="assets/logo2.png">

    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #000000;
            --primary-hover: #333333;
            --text-dark: #212121;
            --text-light: #878787;
            --bg-light: #f1f3f6;
            --card-bg: #ffffff;
            --border-color: #e0e0e0;
            --shadow: rgba(0, 0, 0, 0.05);
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
        }
        
        .header {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 18px 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header h1 {
            font-size: 1.6rem;
            font-weight: 700;
            margin: 0;
        }

        .cart-container {
            display: flex;
            gap: 20px;
            margin: 30px auto;
            max-width: 1200px;
            padding: 0 15px;
        }

        .cart-items {
            flex-grow: 1;
        }

        .cart-summary {
            flex-shrink: 0;
            width: 350px;
            background: var(--card-bg);
            border-radius: 8px;
            box-shadow: 0 2px 4px var(--shadow);
            padding: 20px;
            height: fit-content;
        }
        
        @media (max-width: 992px) {
            .cart-container {
                flex-direction: column;
            }
            .cart-summary {
                width: 100%;
            }
        }

        .cart-item-card {
            display: flex;
            background: var(--card-bg);
            border-radius: 8px;
            box-shadow: 0 2px 4px var(--shadow);
            padding: 15px;
            margin-bottom: 15px;
            align-items: flex-start;
        }
        .product-img {
            width: 110px;
            height: 110px;
            object-fit: contain;
            margin-right: 20px;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: var(--card-bg);
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

<div class="header">
    <h1><i class="bi bi-bag-check-fill"></i> Your Voya Cart</h1>
    <div>
        <a href="../HomeServlet" class="btn btn-dark"><i class="bi bi-arrow-left"></i> Back to Home</a>
        <button id="themeToggle" class="btn btn-outline-dark"><i class="bi bi-moon-fill"></i></button>
    </div>
</div>

<div class="cart-container">
<%
    if (cart.isEmpty()) {
%>
    <div class="empty-cart w-100">
        <h4>Your cart is empty</h4>
        <p>Looks like you haven't added anything to your cart yet.</p>
        <a href="../HomeServlet" class="btn btn-dark">Browse Products</a>
    </div>
<%
    } else {
%>
    <div class="cart-items">
        <h4>My Cart (<%= cart.size() %>)</h4>
    <%
        for (CartItem item : cart) {
            Product currentProduct = allProductsMap.get(item.getProduct().getId());
            if (currentProduct != null) {
                subtotal += item.getTotalPrice();
                if (item.getQuantity() > currentProduct.getQuantity()) {
                    hasInsufficientStock = true;
                }
            } else {
                hasInsufficientStock = true;
            }
    %>
        <div class="cart-item-card">
            <img class="product-img" src="<%= item.getProduct().getImageUrl() %>" alt="<%= item.getProduct().getName() %>">
            <div class="flex-grow-1">
                <h5><%= item.getProduct().getName() %></h5>
                <p class="text-muted">₹<%= item.getProduct().getPrice() %></p>
                <div class="d-flex justify-content-between align-items-center">
                    <form method="post" action="../CartServlet" class="d-flex align-items-center">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                        <div class="input-group">
                            <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>" class="btn btn-outline-secondary">-</button>
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="10" class="form-control text-center" style="max-width: 60px;">
                            <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>" class="btn btn-outline-secondary">+</button>
                        </div>
                    </form>
                    <form method="post" action="../CartServlet">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                        <button type="submit" class="btn btn-link text-danger"><i class="bi bi-trash"></i> Remove</button>
                    </form>
                </div>
            </div>
            <div class="fw-bold">₹<%= item.getTotalPrice() %></div>
        </div>
    <%
        }
    %>
    </div>
    
    <%
        double discountAmount = 0;
        double finalTotal = subtotal;
        if (isMember) {
            discountAmount = subtotal * 0.20;
            finalTotal = subtotal - discountAmount;
        }
    %>
    <div class="cart-summary">
        <h4>PRICE DETAILS</h4>
        <hr>
        <div class="d-flex justify-content-between mb-2">
            <span>Price (<%= cart.size() %> items)</span>
            <span>₹<%= String.format("%.2f", subtotal) %></span>
        </div>
        <% if (isMember) { %>
            <div class="d-flex justify-content-between mb-2 text-success">
                <span>Membership Discount (20%)</span>
                <span>- ₹<%= String.format("%.2f", discountAmount) %></span>
            </div>
        <% } %>
        <div class="d-flex justify-content-between mb-3">
            <span>Delivery Charges</span>
            <span class="text-success">FREE</span>
        </div>
        <hr>
        <div class="d-flex justify-content-between fw-bold fs-5">
            <span>Total Amount</span>
            <span>₹<%= String.format("%.2f", finalTotal) %></span>
        </div>
        <% if (!hasInsufficientStock) { %>
            <a href="checkout.jsp" class="btn btn-dark w-100 mt-3">Proceed to Checkout</a>
        <% } else { %>
            <button class="btn btn-dark w-100 mt-3" disabled>Proceed to Checkout</button>
            <p class="text-danger mt-2">Some items have insufficient stock.</p>
        <% } %>
    </div>
<%
    }
%>
</div>

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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
