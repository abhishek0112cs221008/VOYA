
<%@ page import="java.util.*, model.Product, dao.ProductDAO, dao.ReviewDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Initialise DAOs
    ProductDAO dao = new ProductDAO();
    ReviewDAO reviewDAO = new ReviewDAO();

    String search = request.getParameter("search");
    List<Product> products;

    if (search != null && !search.isEmpty()) {
        products = dao.searchProducts(search);
    } else {
        products = dao.getAllProducts();
    }

    Map<String, List<Product>> categoryMap = new LinkedHashMap<>();
    for (Product p : products) {
        categoryMap.computeIfAbsent(p.getCategory(), k -> new ArrayList<>()).add(p);
    }

    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voya – Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- This is the line that adds your logo to the browser tab -->
     <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='15' fill='#000000' /><text x='50' y='65' font-family='Inter, sans-serif' font-size='40' font-weight='bold' fill='#FFFFFF' text-anchor='middle'>VOYA</text></svg>">
    <link rel="stylesheet" href="css/logo.css">
    <link rel="icon" href="assets/logo2.png">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #ffffff;
            color: #333;
            line-height: 1.6;
        }

        /* Header Navigation - Exact Margerita Style */
        .main-header {
            background: #ffffff;
            border-bottom: 1px solid #e5e5e5;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            height: 70px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-section img {
            width: 35px;
            height: 35px;
            border-radius: 4px;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: #000;
            text-decoration: none;
            letter-spacing: -0.5px;
        }

        .main-nav {
            display: flex;
            gap: 40px;
            align-items: center;
        }

        .nav-item {
            color: #000;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: color 0.3s ease;
        }

        .nav-item:hover {
            color: #666;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .search-icon, .cart-icon, .user-icon {
            font-size: 18px;
            color: #000;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .search-icon:hover, .cart-icon:hover, .user-icon:hover {
            color: #666;
        }

        .cart-badge {
            position: relative;
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #000;
            color: white;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 50%;
            min-width: 16px;
            text-align: center;
            font-weight: 600;
        }

        /* Search Modal */
        .search-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
        }

        .search-content {
            background: white;
            padding: 30px;
            margin: 100px auto;
            max-width: 500px;
            border-radius: 8px;
        }

        .search-input {
            width: 100%;
            padding: 15px;
            border: 1px solid #e5e5e5;
            border-radius: 4px;
            font-size: 16px;
            outline: none;
        }

        .search-input:focus {
            border-color: #000;
        }

        /* Main Content Layout */
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Results Header */
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 0 20px 0;
            border-bottom: 1px solid #e5e5e5;
            margin-bottom: 30px;
        }

        .results-count {
            font-size: 14px;
            color: #666;
            font-weight: 400;
        }

        .view-toggles {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .view-btn {
            background: none;
            border: none;
            padding: 8px;
            cursor: pointer;
            color: #ccc;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .view-btn.active {
            color: #000;
        }

        /* Products Grid - Exact Margerita Layout */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            margin-bottom: 60px;
        }

        .product-item {
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .product-image-container {
            position: relative;
            width: 100%;
            height: 300px;
            overflow: hidden;
            background: #f8f8f8;
            margin-bottom: 15px;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-item:hover .product-image {
            transform: scale(1.05);
        }

        /* Product Action Buttons - Margerita Style */
        .product-actions {
            position: absolute;
            top: 15px;
            right: 15px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .product-item:hover .product-actions {
            opacity: 1;
        }

        .action-btn {
            width: 35px;
            height: 35px;
            background: white;
            border: none;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            color: #666;
        }

        .action-btn:hover {
            background: #000;
            color: white;
        }

        /* Quick View Button */
        .quick-view-btn {
            position: absolute;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            border: 1px solid #000;
            padding: 8px 16px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            opacity: 0;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .product-item:hover .quick-view-btn {
            opacity: 1;
        }

        .quick-view-btn:hover {
            background: #000;
            color: white;
        }

        /* Product Information */
        .product-brand {
            font-size: 11px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .product-title {
            font-size: 14px;
            color: #000;
            margin-bottom: 8px;
            font-weight: 500;
            line-height: 1.3;
        }

        .product-price {
            font-size: 14px;
            color: #000;
            font-weight: 600;
        }

        /* Stock Badges */
        .stock-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            padding: 4px 8px;
            font-size: 10px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            border-radius: 2px;
        }

        .sold-out {
            background: #000;
            color: white;
        }

        .low-stock {
            background: #ff4444;
            color: white;
        }

        .free-shipping {
            background: #00aa44;
            color: white;
        }

        /* Add to Cart Form */
        .add-to-cart-form {
            margin-top: 10px;
        }

        .add-cart-btn {
            width: 100%;
            background: #000;
            color: white;
            border: none;
            padding: 12px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: background 0.3s ease;
            font-weight: 500;
        }

        .add-cart-btn:hover:not(:disabled) {
            background: #333;
        }

        .add-cart-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        /* Category Sections */
        .category-section {
            margin-bottom: 60px;
        }

        .category-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .category-title {
            font-size: 28px;
            font-weight: 700;
            color: #000;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .category-subtitle {
            font-size: 14px;
            color: #666;
            font-weight: 400;
        }

        /* Color Swatches */
        .color-options {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }

        .color-swatch {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 1px solid #e5e5e5;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .color-swatch:hover {
            transform: scale(1.1);
        }

        .color-red { background: #dc2626; }
        .color-coffee { background: #8b4513; }
        .color-yellow { background: #eab308; }
        .color-maroon { background: #800000; }

        /* Footer */
        .site-footer {
            background: #f8f8f8;
            text-align: center;
            padding: 40px 20px;
            margin-top: 80px;
            border-top: 1px solid #e5e5e5;
        }

        .footer-text {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Load More Button */
        .load-more {
            text-align: center;
            margin: 40px 0;
        }

        .load-more-btn {
            background: none;
            border: 1px solid #000;
            padding: 15px 30px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .load-more-btn:hover {
            background: #000;
            color: white;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .products-grid {
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }
            
            .main-nav {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }
            
            .product-image-container {
                height: 250px;
            }
            
            .header-container {
                padding: 15px;
            }
            
            .category-title {
                font-size: 24px;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
            
            .header-actions {
                gap: 15px;
            }
        }

        /* No Products State */
        .no-products {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }

        .no-products h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #000;
            font-weight: 600;
        }

        .no-products p {
            font-size: 14px;
            color: #666;
        }

        /* Dark Mode Support */
        .dark-mode {
            background: #1a1a1a;
            color: #e5e5e5;
        }

        .dark-mode .main-header {
            background: #1a1a1a;
            border-bottom-color: #333;
        }

        .dark-mode .logo-text,
        .dark-mode .nav-item,
        .dark-mode .search-icon,
        .dark-mode .cart-icon,
        .dark-mode .user-icon {
            color: #e5e5e5;
        }

        .dark-mode .product-image-container {
            background: #333;
        }

        .dark-mode .product-title,
        .dark-mode .product-price,
        .dark-mode .category-title {
            color: #e5e5e5;
        }

        .dark-mode .add-cart-btn {
            background: #e5e5e5;
            color: #1a1a1a;
        }
        
        /* Dropdown Container */
.nav-dropdown {
    position: relative;
}

/* Dropdown Trigger */
.dropdown-trigger {
    display: flex;
    align-items: center;
    gap: 5px;
    position: relative;
}

.dropdown-icon {
    font-size: 12px;
    transition: transform 0.3s ease;
}

.nav-dropdown:hover .dropdown-icon {
    transform: rotate(180deg);
}

/* Dropdown Menu */
.dropdown-menu {
    position: absolute;
    top: 100%;
    left: 0;
    background: white;
    min-width: 220px;
    border: 1px solid #e5e5e5;
    border-radius: 12px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 1000;
    padding: 8px 0;
    margin-top: 8px;
    backdrop-filter: blur(10px);
}

.nav-dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

/* Dropdown Items */
.dropdown-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 20px;
    color: #333;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    text-transform: capitalize;
    letter-spacing: 0;
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
}

.dropdown-item:hover {
    background: linear-gradient(90deg, #f8f9fa 0%, #e9ecef 100%);
    color: #000;
    transform: translateX(5px);
}

.category-icon {
    font-size: 12px;
    color: #666;
    transition: color 0.3s ease;
}

.dropdown-item:hover .category-icon {
    color: #007bff;
}

.item-count {
    font-size: 12px;
    color: #999;
    font-weight: 400;
    margin-left: auto;
}

.dropdown-divider {
    height: 1px;
    background: #e5e5e5;
    margin: 8px 0;
}

.show-all {
    border-top: 1px solid #f0f0f0;
    margin-top: 8px;
    padding-top: 16px;
    font-weight: 600;
    color: #007bff;
}

.show-all:hover {
    background: linear-gradient(90deg, #e3f2fd 0%, #bbdefb 100%);
    color: #0056b3;
}

/* Arrow indicator for dropdown */
.dropdown-menu::before {
    content: '';
    position: absolute;
    top: -6px;
    left: 20px;
    width: 12px;
    height: 12px;
    background: white;
    border: 1px solid #e5e5e5;
    border-bottom: none;
    border-right: none;
    transform: rotate(45deg);
}

/* Active category highlight */
.dropdown-item.active {
    background: linear-gradient(90deg, #007bff 0%, #0056b3 100%);
    color: white;
}

.dropdown-item.active .category-icon,
.dropdown-item.active .item-count {
    color: white;
}

/* Loading state */
.dropdown-item.loading {
    opacity: 0.7;
    pointer-events: none;
}

.dropdown-item.loading::after {
    content: '';
    width: 12px;
    height: 12px;
    border: 2px solid #ddd;
    border-top-color: #007bff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-left: auto;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Dark mode support */
.dark-mode .dropdown-menu {
    background: #2d2d2d;
    border-color: #404040;
}

.dark-mode .dropdown-menu::before {
    background: #2d2d2d;
    border-color: #404040;
}

.dark-mode .dropdown-item {
    color: #e5e5e5;
}

.dark-mode .dropdown-item:hover {
    background: linear-gradient(90deg, #404040 0%, #555 100%);
    color: white;
}

.dark-mode .dropdown-divider {
    background: #404040;
}

.dark-mode .show-all {
    color: #66b3ff;
    border-top-color: #404040;
}

/* Mobile responsiveness */
@media (max-width: 1024px) {
    .nav-dropdown {
        position: static;
    }
    
    .dropdown-menu {
        position: static;
        opacity: 1;
        visibility: visible;
        transform: none;
        box-shadow: none;
        border: none;
        background: transparent;
        padding: 0;
        margin: 0;
        backdrop-filter: none;
    }
    
    .dropdown-menu::before {
        display: none;
    }
    
    .dropdown-item {
        padding: 8px 0;
        justify-content: flex-start;
    }
    
    .dropdown-item:hover {
        transform: none;
        background: transparent;
    }
}
    </style>
</head>
<body class="light-mode">

<!-- Header Navigation -->
<header class="main-header">
    <div class="header-container">
        <a href="#" class="voya-logo text-decoration-none">
                    <span class="letter letter-v">V</span><span class="letter letter-o">O</span><span class="letter letter-y">Y</span><span class="letter letter-a">A</span>
                </a>
        
        <!--nav bar------------->
        <nav class="main-nav">
            <a href="HomeServlet" class="nav-item" onclick="scrollToTop()">Home</a>

            <!-- Categories Dropdown -->
            <div class="nav-dropdown">
                <a href="#" class="nav-item dropdown-trigger">
                    Categories
                    <i class="fa-solid fa-chevron-down dropdown-icon"></i>
                </a>
                <div class="dropdown-menu">
                    <% for (String category : categoryMap.keySet()) { %>
                        <a href="#" class="dropdown-item" onclick="scrollToCategory('<%= category %>')">
                            <i class="fa-solid fa-tag category-icon"></i>
                            <%= category %>
                            <span class="item-count">(<%= categoryMap.get(category).size() %>)</span>
                        </a>
                    <% } %>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item show-all" onclick="showAllCategories()">
                        <i class="fa-solid fa-th-large"></i>
                        Show All Categories
                    </a>
                </div>
            </div>

<!--            <a href="#" class="nav-item">Shop All</a>
            <a href="#" class="nav-item">About Us</a>-->
            <a href="jsp/viewOrders.jsp" class="nav-item">View My Orders</a>
        </nav>

        
        
        <!--====================================================================================-->
        
        <div class="header-actions">
            <i class="fa-solid fa-search search-icon" id="searchIcon"></i>
            
            <div class="cart-badge">
                <a href="jsp/cart.jsp">
                    <i class="fa-solid fa-shopping-bag cart-icon"></i>
                    <span class="cart-count"><%= session.getAttribute("cart") != null ? ((List)session.getAttribute("cart")).size() : 0 %></span>
                </a>
            </div>
            
            <div style="display: flex; gap: 15px; align-items: center;">
                <a href="jsp/userProfile.jsp">
                    <i class="fa-solid fa-user user-icon"></i>
                </a>
                <button id="themeToggle" style="background: none; border: none; cursor: pointer;">
                    <i class="fa-solid fa-moon" style="font-size: 18px; color: #000;"></i>
                </button>
                <a href="jsp/logout.jsp" style="background: #000; color: white; padding: 8px 16px; text-decoration: none; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 500;">Logout</a>
            </div>
        </div>
    </div>
</header>

<!-- Search Modal -->
<div class="search-modal" id="searchModal">
    <div class="search-content">
        <form action="HomeServlet" method="get">
            <input type="text" name="search" class="search-input" placeholder="Search products..." 
                   value="<%= search != null ? search : "" %>" autofocus>
        </form>
        <button onclick="closeSearch()" style="position: absolute; top: 10px; right: 15px; background: none; border: none; font-size: 24px; cursor: pointer;">&times;</button>
    </div>
</div>

<!-- Main Content -->
<div class="page-container">
    <!-- Results Header -->
    <div class="results-header">
        <span class="results-count">
            You've viewed <%= products.stream().mapToInt(p -> 1).sum() %> of <%= products.stream().mapToInt(p -> 1).sum() %> products
        </span>
        
        <div class="view-toggles">
            <button class="view-btn" title="List View">
                <i class="fa-solid fa-list"></i>
            </button>
            <button class="view-btn" title="Grid View">
                <i class="fa-solid fa-th-large"></i>
            </button>
            <button class="view-btn active" title="Card View">
                <i class="fa-solid fa-th"></i>
            </button>
            <button class="view-btn" title="Large Grid">
                <i class="fa-solid fa-th-large"></i>
            </button>
        </div>
    </div>

    <% if (categoryMap.isEmpty()) { %>
        <div class="no-products">
            <h3>No Products Found</h3>
            <p>Try adjusting your search or browse our categories.</p>
        </div>
    <% } %>

    <% for (Map.Entry<String, List<Product>> entry : categoryMap.entrySet()) { %>
    <div class="category-section">
        <div class="category-header">
            <h2 class="category-title"><%= entry.getKey().toUpperCase() %></h2>
            <p class="category-subtitle">Discover our collection</p>
        </div>
        
        <div class="products-grid">
            <% for (Product p : entry.getValue()) {
                double avgRating = reviewDAO.getAverageRatingForProduct(p.getId());
                int reviewCount = reviewDAO.getReviewCountForProduct(p.getId());
                int productCount = p.getQuantity();
            %>
            <div class="product-item" data-price="<%= p.getPrice() %>" data-quantity="<%= productCount %>" data-category="<%= p.getCategory() %>">
                <div class="product-image-container">
                    <img src="<%= p.getImageUrl() != null && !p.getImageUrl().isEmpty() ? p.getImageUrl() : "assets/no-image.png" %>"
                         alt="<%= p.getName() %>" class="product-image"
                         onerror="this.src='assets/no-image.png'">
                    
                    <!-- Stock Badges -->
                    <% if (productCount == 0) { %>
                        <div class="stock-badge sold-out">Sold Out</div>
                    <% } else if (productCount < 5) { %>
                        <div class="stock-badge low-stock">Only <%= productCount %> left</div>
                    <% } %>
                    
                    <% if(p.getPrice() > 599.00) { %>    
                        <div class="stock-badge free-shipping">Free Shipping</div>
                    <% } %>
                    
                    <!-- Product Actions -->
                    <div class="product-actions">
                        <button class="action-btn" title="Add to Wishlist">
                            <i class="fa-solid fa-heart"></i>
                        </button>
                        <button class="action-btn" title="Compare">
                            <i class="fa-solid fa-exchange-alt"></i>
                        </button>
                    </div>
                    
                    <!-- Quick View -->
                    <button class="quick-view-btn" onclick="window.location.href='jsp/productDetails.jsp?id=<%= p.getId() %>'">
                        Quick View
                    </button>
                </div>
                
                <div class="product-info">
                    <div class="product-brand">VOYA</div>
                    <div class="product-title"><%= p.getName() %></div>
                    <div class="product-price">Rs. <%= String.format("%.2f", p.getPrice()) %></div>
                    
                    <!-- Color Options (if applicable) -->
                    <div class="color-options">
                        <div class="color-swatch color-red"></div>
                        <div class="color-swatch color-coffee"></div>
                        <div class="color-swatch color-yellow"></div>
                    </div>
                    
                    <!-- Rating Display -->
                    <% if (reviewCount > 0) { %>
                        <div style="font-size: 12px; color: #666; margin-top: 5px;">
                            ⭐ <%= String.format("%.1f", avgRating) %> (<%= reviewCount %> reviews)
                        </div>
                    <% } %>
                    
                    <!-- Add to Cart Form -->
                    <form method="post" action="CartServlet" class="add-to-cart-form">
                        <input type="hidden" name="action" value="add">
			<input type="hidden" name="productId" value="<%= p.getId() %>">
                        <button type="submit" class="add-cart-btn" <%= productCount == 0 ? "disabled" : "" %>>
                            <% if (productCount == 0) { %>
                                Sold Out
                            <% } else { %>
                                Add to Cart
                            <% } %>
                        </button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
    
    <!-- Load More Button (Static for now) -->
    <div class="load-more">
        <button class="load-more-btn">Load More Products</button>
    </div>
</div>

<!-- Footer -->
<footer class="site-footer">
		<a href="#" class="voya-logo text-decoration-none">
                    <span class="letter letter-v">V</span><span class="letter letter-o">O</span><span class="letter letter-y">Y</span><span class="letter letter-a">A</span>
                </a>
    <p class="footer-text">© 2025 Voya. All Rights Reserved.</p>
</footer>
<script>
//    
//    
//    document.addEventListener('DOMContentLoaded', () => {
//    // Search Modal
//    const searchIcon = document.getElementById('searchIcon');
//    const searchModal = document.getElementById('searchModal');
//    
//    searchIcon.addEventListener('click', () => {
//        searchModal.style.display = 'block';
//    });
//    
//    window.closeSearch = () => {
//        searchModal.style.display = 'none';
//    };
//    
//    // Close modal on outside click
//    searchModal.addEventListener('click', (e) => {
//        if (e.target === searchModal) {
//            closeSearch();
//        }
//    });
//    
//    // Theme Toggle
//    const themeToggle = document.getElementById('themeToggle');
//    if (themeToggle) {
//        themeToggle.addEventListener('click', () => {
//            document.body.classList.toggle('dark-mode');
//            const isDark = document.body.classList.contains('dark-mode');
//            localStorage.setItem('theme', isDark ? 'dark' : 'light');
//            themeToggle.innerHTML = isDark ? 
//                '<i class="fa-solid fa-sun" style="font-size: 18px; color: #e5e5e5;"></i>' : 
//                '<i class="fa-solid fa-moon" style="font-size: 18px; color: #000;"></i>';
//        });
//    }
//
//    // Load saved theme
//    const savedTheme = localStorage.getItem('theme') || 'light';
//    document.body.className = savedTheme + '-mode';
//    if (themeToggle && savedTheme === 'dark') {
//        themeToggle.innerHTML = '<i class="fa-solid fa-sun" style="font-size: 18px; color: #e5e5e5;"></i>';
//    }
//
//    // View Toggle Functionality
//    const viewBtns = document.querySelectorAll('.view-btn');
//    const productsGrid = document.querySelector('.products-grid');
//    
//    viewBtns.forEach((btn, index) => {
//        btn.addEventListener('click', () => {
//            viewBtns.forEach(b => b.classList.remove('active'));
//            btn.classList.add('active');
//            
//            switch(index) {
//                case 0: // List view
//                    productsGrid.style.gridTemplateColumns = '1fr';
//                    break;
//                case 1: // Small grid
//                    productsGrid.style.gridTemplateColumns = 'repeat(3, 1fr)';
//                    break;
//                case 2: // Default grid
//                    productsGrid.style.gridTemplateColumns = 'repeat(4, 1fr)';
//                    break;
//                case 3: // Large grid
//                    productsGrid.style.gridTemplateColumns = 'repeat(5, 1fr)';
//                    break;
//            }
//        });
//    });
//
//    // Add to Cart Functionality (Updated to fix bugs and improve reliability)
////    const addToCartForms = document.querySelectorAll('.add-to-cart-form');
////    addToCartForms.forEach(form => {
////        form.addEventListener('submit', async function(e) {
////            // Prevent the default form submission (page reload)
////            e.preventDefault();
////
////            const submitBtn = this.querySelector('.add-cart-btn');
////            const originalText = submitBtn.innerHTML;
////            
////            // Check if the button is already disabled (e.g., sold out or currently processing)
////            if (submitBtn.disabled) return;
////            
////            submitBtn.innerHTML = 'Adding...';
////            submitBtn.disabled = true;
////
////            // Get the product ID from the hidden input
////            const productIdInput = this.querySelector('input[name="productId"]');
////            const actionInput = this.querySelector('input[name="action"]');
////            const productId = productIdInput ? productIdInput.value : '';
////            const action = actionInput ? actionInput.value : '';
////
////            // Construct URL-encoded form data manually
////            const params = new URLSearchParams();
////            params.append('productId', productId);
////            params.append('action', action);
////
////            try {
////                // Send an asynchronous request to the server with a URL-encoded body
////                const response = await fetch('CartServlet', {
////                    method: 'POST',
////                    headers: {
////                        'Content-Type': 'application/x-www-form-urlencoded'
////                    },
////                    body: params
////                });
////
////                if (response.ok) {
////                    const newCartCount = await response.text();
////                    const cartCountSpan = document.querySelector('.cart-count');
////                    
////                    // Check if the response is a valid number before updating the UI
////                    if (cartCountSpan && !isNaN(parseInt(newCartCount))) {
////                        cartCountSpan.textContent = newCartCount;
////                        submitBtn.innerHTML = 'Added ✓';
////                        submitBtn.style.background = '#00aa44';
////                    } else {
////                        throw new Error('Server response was not a valid number.');
////                    }
////                } else {
////                    console.error('Failed to add item to cart:', response.statusText);
////                    submitBtn.innerHTML = 'Failed!';
////                    submitBtn.style.background = '#dc2626';
////                }
////            } catch (error) {
////                console.error('Error adding to cart. Please check your network and server response.', error);
////                submitBtn.innerHTML = 'Error!';
////                submitBtn.style.background = '#dc2626';
////            } finally {
////                // Reset the button to its original state after a short delay
////                setTimeout(() => {
////                    submitBtn.innerHTML = originalText;
////                    submitBtn.style.background = '#000';
////                    submitBtn.disabled = false;
////                }, 1500);
////            }
////        });
////    });
////
////    // Color Swatch Selection
////    const colorSwatches = document.querySelectorAll('.color-swatch');
////    colorSwatches.forEach(swatch => {
////        swatch.addEventListener('click', function() {
////            const parent = this.parentElement;
////            parent.querySelectorAll('.color-swatch').forEach(s => {
////                s.style.border = '1px solid #e5e5e5';
////            });
////            this.style.border = '2px solid #000';
////        });
////    });
////
////    // Smooth scroll for better UX
////    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
////        anchor.addEventListener('click', function (e) {
////            e.preventDefault();
////            const target = document.querySelector(this.getAttribute('href'));
////            if (target) {
////                target.scrollIntoView({
////                    behavior: 'smooth',
////                    block: 'start'
////                });
////            }
////        });
////    });
//
//    // Load More Button
//    const loadMoreBtn = document.querySelector('.load-more-btn');
//    if (loadMoreBtn) {
//        // This is a placeholder. In a real application, you would
//        // use an AJAX request to fetch more products from the server.
//        // For this example, we will just simulate a loading state.
//        loadMoreBtn.addEventListener('click', () => {
//            loadMoreBtn.textContent = 'Loading...';
//            loadMoreBtn.disabled = true;
//
//            setTimeout(() => {
//                // Simulate successful loading
//                console.log("More products loaded.");
//                // In a real scenario, you'd append the new product HTML here.
//                loadMoreBtn.textContent = 'No More Products';
//                loadMoreBtn.disabled = true;
//            }, 1500);
//        });
//    }
//});

document.addEventListener('DOMContentLoaded', () => {
    // Search Modal
    const searchIcon = document.getElementById('searchIcon');
    const searchModal = document.getElementById('searchModal');
    
    searchIcon.addEventListener('click', () => {
        searchModal.style.display = 'block';
    });
    
    window.closeSearch = () => {
        searchModal.style.display = 'none';
    };
    
    // Close modal on outside click
    searchModal.addEventListener('click', (e) => {
        if (e.target === searchModal) {
            closeSearch();
        }
    });
    
    // Theme Toggle
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            document.body.classList.toggle('dark-mode');
            const isDark = document.body.classList.contains('dark-mode');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            themeToggle.innerHTML = isDark ? 
                '<i class="fa-solid fa-sun" style="font-size: 18px; color: #e5e5e5;"></i>' : 
                '<i class="fa-solid fa-moon" style="font-size: 18px; color: #000;"></i>';
        });
    }

    // Load saved theme
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.className = savedTheme + '-mode';
    if (themeToggle && savedTheme === 'dark') {
        themeToggle.innerHTML = '<i class="fa-solid fa-sun" style="font-size: 18px; color: #e5e5e5;"></i>';
    }

    // View Toggle Functionality
    const viewBtns = document.querySelectorAll('.view-btn');
    const productsGrid = document.querySelector('.products-grid');
    
    viewBtns.forEach((btn, index) => {
        btn.addEventListener('click', () => {
            viewBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            switch(index) {
                case 0: // List view
                    productsGrid.style.gridTemplateColumns = '1fr';
                    break;
                case 1: // Small grid
                    productsGrid.style.gridTemplateColumns = 'repeat(3, 1fr)';
                    break;
                case 2: // Default grid
                    productsGrid.style.gridTemplateColumns = 'repeat(4, 1fr)';
                    break;
                case 3: // Large grid
                    productsGrid.style.gridTemplateColumns = 'repeat(5, 1fr)';
                    break;
            }
        });
    });

    // Add to Cart Animation
//    const addToCartBtns = document.querySelectorAll('.add-cart-btn');
//    addToCartBtns.forEach(btn => {
//        btn.addEventListener('click', function(e) {
//            if (!this.disabled) {
//                const originalText = this.innerHTML;
//                this.innerHTML = 'Adding...';
//                this.disabled = true;
//                
//                setTimeout(() => {
//                    this.innerHTML = 'Added ✓';
//                    this.style.background = '#00aa44';
//                    
//                    setTimeout(() => {
//                        this.innerHTML = originalText;
//                        this.style.background = '#000';
//                        this.disabled = false;
//                    }, 2000);
//                }, 1000);
//            }
//        });
//    });

    // Color Swatch Selection
    const colorSwatches = document.querySelectorAll('.color-swatch');
    colorSwatches.forEach(swatch => {
        swatch.addEventListener('click', function() {
            const parent = this.parentElement;
            parent.querySelectorAll('.color-swatch').forEach(s => {
                s.style.border = '1px solid #e5e5e5';
            });
            this.style.border = '2px solid #000';
        });
    });

    // Smooth scroll for better UX
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Load More Button
    const loadMoreBtn = document.querySelector('.load-more-btn');
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function() {
            this.innerHTML = 'Loading...';
            this.disabled = true;
            
            // Simulate loading more products
            setTimeout(() => {
                this.innerHTML = 'Load More Products';
                this.disabled = false;
            }, 2000);
        });
    }

    // Image lazy loading for better performance
    const images = document.querySelectorAll('.product-image');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.src;
                img.classList.add('loaded');
                observer.unobserve(img);
            }
        });
    });

    images.forEach(img => {
        imageObserver.observe(img);
    });

    // Quick view functionality
    const quickViewBtns = document.querySelectorAll('.quick-view-btn');
    quickViewBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            // The onclick in HTML will handle navigation
        });
    });

    // Product card click handler
    const productItems = document.querySelectorAll('.product-item');
    productItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Don't trigger if clicking on buttons
            if (!e.target.closest('.action-btn') && 
                !e.target.closest('.quick-view-btn') && 
                !e.target.closest('.add-cart-btn') &&
                !e.target.closest('.color-swatch')) {
                
                const quickViewBtn = this.querySelector('.quick-view-btn');
                if (quickViewBtn) {
                    quickViewBtn.click();
                }
            }
        });
    });

    // Wishlist functionality
    const wishlistBtns = document.querySelectorAll('.action-btn');
    wishlistBtns.forEach(btn => {
        const icon = btn.querySelector('i');
        if (icon && icon.classList.contains('fa-heart')) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const heartIcon = this.querySelector('i');
                
                if (heartIcon.classList.contains('fa-heart') && !heartIcon.classList.contains('fas')) {
                    heartIcon.classList.remove('fa-heart');
                    heartIcon.classList.add('fas', 'fa-heart');
                    this.style.color = '#ff4444';
                } else {
                    heartIcon.classList.remove('fas');
                    heartIcon.classList.add('fa-heart');
                    this.style.color = '#666';
                }
            });
        }
    });

    // Search functionality
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.form.submit();
            }
        });
    }

    // Escape key to close modals
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (searchModal.style.display === 'block') {
                closeSearch();
            }
        }
    });

    // Add smooth transitions to all interactive elements
    const style = document.createElement('style');
    style.textContent = `
        .product-image {
            transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .product-item:hover .product-image {
            transform: scale(1.03);
        }
        
        .color-swatch {
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .action-btn, .quick-view-btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .add-cart-btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        /* Enhanced hover effects */
        .product-item {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .product-item:hover {
            transform: translateY(-2px);
        }
        
        /* Loading states */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }
        
        .loaded {
            animation: fadeIn 0.3s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    `;
    document.head.appendChild(style);

    // Initialize product filtering if filters exist
    const filterCheckboxes = document.querySelectorAll('input[type="checkbox"]');
    const productCards = document.querySelectorAll('.product-item');

    if (filterCheckboxes.length > 0) {
        filterCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const selectedCategories = Array.from(document.querySelectorAll('input[name="category"]:checked')).map(cb => cb.value);
                const selectedPrices = Array.from(document.querySelectorAll('input[name="price"]:checked')).map(cb => cb.value);
                const selectedAvailability = Array.from(document.querySelectorAll('input[name="availability"]:checked')).map(cb => cb.value);

                productCards.forEach(card => {
                    const category = card.dataset.category;
                    const price = parseFloat(card.dataset.price);
                    const quantity = parseInt(card.dataset.quantity);

                    const matchesCategory = selectedCategories.length === 0 || selectedCategories.includes(category);
                    
                    const matchesPrice = selectedPrices.length === 0 || selectedPrices.some(range => {
                        if (range === '0-500') return price < 500;
                        if (range === '500-1000') return price >= 500 && price <= 1000;
                        if (range === '1000-max') return price > 1000;
                        return false;
                    });
                    
                    const matchesAvailability = selectedAvailability.length === 0 || selectedAvailability.some(status => {
                        if (status === 'in-stock') return quantity > 0;
                        if (status === 'low-stock') return quantity > 0 && quantity < 5;
                        return false;
                    });

                    if (matchesCategory && matchesPrice && matchesAvailability) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    }
});


    // Enhanced dropdown functionality with section scrolling
document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.querySelector('.nav-dropdown');
    const dropdownTrigger = dropdown.querySelector('.dropdown-trigger');
    const dropdownMenu = dropdown.querySelector('.dropdown-menu');
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target)) {
            dropdown.classList.remove('active');
        }
    });
    
    // Prevent dropdown from closing when clicking inside
    dropdownMenu.addEventListener('click', function(e) {
        e.stopPropagation();
    });
});

// Scroll to specific category function
function scrollToCategory(categoryName) {
    // Close dropdown after selection
    const dropdown = document.querySelector('.nav-dropdown');
    dropdown.classList.remove('active');
    
    // Find the category section
    const categorySections = document.querySelectorAll('.category-section');
    let targetSection = null;
    
    categorySections.forEach(section => {
        const categoryTitle = section.querySelector('.category-title');
        if (categoryTitle && categoryTitle.textContent.trim().toLowerCase() === categoryName.toLowerCase()) {
            targetSection = section;
        }
    });
    
    if (targetSection) {
        // Add loading state to the clicked item
        const clickedItem = event.target.closest('.dropdown-item');
        if (clickedItem) {
            clickedItem.classList.add('loading');
            setTimeout(() => {
                clickedItem.classList.remove('loading');
            }, 1000);
        }
        
        // Smooth scroll to the section
        targetSection.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
        
        // Highlight the category temporarily
        const categoryTitle = targetSection.querySelector('.category-title');
        if (categoryTitle) {
            categoryTitle.style.color = '#007bff';
            categoryTitle.style.transform = 'scale(1.05)';
            categoryTitle.style.transition = 'all 0.3s ease';
            
            setTimeout(() => {
                categoryTitle.style.color = '';
                categoryTitle.style.transform = '';
            }, 2000);
        }
        
        // Show visual feedback
        showNotification(`Scrolled to ${categoryName} section`);
    } else {
        showNotification(`Category "${categoryName}" not found`, 'error');
    }
}

// Scroll to top function
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
    showNotification('Scrolled to top');
}

// Show all categories function
function showAllCategories() {
    const dropdown = document.querySelector('.nav-dropdown');
    dropdown.classList.remove('active');
    
    // Show all hidden category sections
    const categorySections = document.querySelectorAll('.category-section');
    categorySections.forEach(section => {
        section.style.display = 'block';
        section.style.animation = 'fadeIn 0.5s ease-in';
    });
    
    // Scroll to first category
    if (categorySections.length > 0) {
        categorySections[0].scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }
    
    showNotification(`Showing all ${categorySections.length} categories`);
}

// Notification system
function showNotification(message, type = 'success') {
    // Remove existing notification
    const existingNotif = document.querySelector('.nav-notification');
    if (existingNotif) {
        existingNotif.remove();
    }
    
    // Create notification
    const notification = document.createElement('div');
    notification.className = `nav-notification ${type}`;
    notification.innerHTML = `
        <i class="fa-solid fa-{type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        background: type === 'success' ? '#28a745' : '#dc3545'};
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 2000;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        font-weight: 500;
        transform: translateX(100%);
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    `;
    
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Auto remove
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 300);
    }, 3000);
}

// Mark active category in dropdown
function updateActiveCategory() {
    const categorySections = document.querySelectorAll('.category-section');
    const dropdownItems = document.querySelectorAll('.dropdown-item:not(.show-all)');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const categoryTitle = entry.target.querySelector('.category-title');
                if (categoryTitle) {
                    const categoryName = categoryTitle.textContent.trim();
                    
                    // Remove active class from all dropdown items
                    dropdownItems.forEach(item => item.classList.remove('active'));
                    
                    // Add active class to current category
                    dropdownItems.forEach(item => {
                        const itemText = item.textContent.replace(/\(\d+\)/, '').trim();
                        if (itemText === categoryName) {
                            item.classList.add('active');
                        }
                    });
                }
            }
        });
    }, {
        rootMargin: '-20% 0px -70% 0px'
    });
    
    categorySections.forEach(section => {
        observer.observe(section);
    });
}

// Initialize active category tracking
document.addEventListener('DOMContentLoaded', function() {
    updateActiveCategory();
});



</script>
