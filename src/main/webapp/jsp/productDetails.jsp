<%@ page import="model.Product, dao.ProductDAO, dao.ReviewDAO, model.Review" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String pidParam = request.getParameter("id");
    if (pidParam == null || pidParam.isEmpty()) {
        out.println("<p style='color:red;'>Invalid or missing product ID</p>");
        return;
    }

    int productId = Integer.parseInt(pidParam);
    ProductDAO dao = new ProductDAO();
    Product product = dao.getProductById(productId);

    if (product == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    // Load dynamic reviews
    ReviewDAO reviewDAO = new ReviewDAO();
    java.util.List<Review> reviews = reviewDAO.getReviewsByProductId(productId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= product.getName() %> - Voya</title>
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='15' fill='#000000' /><text x='50' y='65' font-family='Inter, sans-serif' font-size='40' font-weight='bold' fill='#FFFFFF' text-anchor='middle'>VOYA</text></svg>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="assets/logo2.png">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-dark: #000000;
            --text-dark: #212121;
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

        .product-img {
            width: 100%;
            border-radius: 8px;
        }
        
        .product-details-card {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 8px;
        }

        .breadcrumb-item a {
            text-decoration: none;
            color: var(--text-light);
        }

        .product-title {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .product-price {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--primary-dark);
        }

        .color-swatches .form-check-input {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: 2px solid var(--border-color);
        }
        .color-swatches .form-check-input:checked {
            border-color: var(--primary-dark);
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            width: fit-content;
        }
        .quantity-selector button {
            border: none;
            background: none;
            padding: 8px 12px;
        }
        .quantity-selector input {
            width: 50px;
            text-align: center;
            border: none;
            border-left: 1px solid var(--border-color);
            border-right: 1px solid var(--border-color);
        }

        .accordion-button:not(.collapsed) {
            color: var(--text-dark);
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<div class="container my-5">
    <div class="row g-5">
        <div class="col-lg-7">
            <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-img">
        </div>
        <div class="col-lg-5">
            <div class="product-details-card">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="../HomeServlet">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><%= product.getName() %></li>
                    </ol>
                </nav>
                
                <h1 class="product-title"><%= product.getName() %></h1>
                <p class="product-price">₹<%= product.getPrice() %></p>
                
                <form method="post" action="../CartServlet">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Color</label>
                        <div class="color-swatches d-flex gap-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="color" id="colorBlack" style="background-color: black;" checked>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="color" id="colorBrown" style="background-color: #8B4513;">
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="color" id="colorBeige" style="background-color: #F5F5DC;">
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Quantity</label>
                        <div class="quantity-selector">
                            <button type="button" onclick="this.nextElementSibling.stepDown()">-</button>
                            <input type="number" name="quantity" value="1" min="1" max="10" class="form-control form-control-sm border-0 text-center">
                            <button type="button" onclick="this.previousElementSibling.stepUp()">+</button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-dark btn-lg w-100"><i class="bi bi-cart-plus"></i> Add to Cart</button>
                </form>

                <div class="accordion mt-4" id="productInfoAccordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDescription">
                                Description
                            </button>
                        </h2>
                        <div id="collapseDescription" class="accordion-collapse collapse show" data-bs-parent="#productInfoAccordion">
                            <div class="accordion-body">
                                <%= product.getDescription() %>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseReviews">
                                Customer Reviews (<%= reviews.size() %>)
                            </button>
                        </h2>
                        <div id="collapseReviews" class="accordion-collapse collapse" data-bs-parent="#productInfoAccordion">
                            <div class="accordion-body">
                                <% if (reviews.isEmpty()) { %>
                                    <p class="text-muted">No reviews yet for this product.</p>
                                <% } else {
                                    for (Review r : reviews) { %>
                                    <div class="mb-3">
                                        <strong><%= r.getUserName() %></strong>
                                        <div class="text-warning mb-1">
                                            <% for (int i = 0; i < r.getRating(); i++) { %><i class="bi bi-star-fill"></i><% } %>
                                        </div>
                                        <p><%= r.getComment() %></p>
                                        <small class="text-muted">Reviewed on <%= r.getReviewDate() %></small>
                                    </div>
                                    <hr>
                                <% } } %>
                                
                                <h5 class="mt-4">Write a Review</h5>
                                <form action="../WriteReview" method="post">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <div class="mb-3">
                                        <input type="text" name="userName" class="form-control" placeholder="Your Name" required>
                                    </div>
                                    <div class="mb-3">
                                        <select name="rating" class="form-select" required>
                                            <option value="">Select a rating</option>
                                            <option value="5">5 - Excellent</option>
                                            <option value="4">4 - Good</option>
                                            <option value="3">3 - Average</option>
                                            <option value="2">2 - Poor</option>
                                            <option value="1">1 - Bad</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <textarea name="comment" class="form-control" rows="3" placeholder="Your Review" required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-dark">Submit Review</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
