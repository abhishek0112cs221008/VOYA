<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map, java.util.stream.Collectors, java.util.ArrayList, java.util.HashMap" %>
<%
    // Redirect if not logged in as an admin
    String adminEmail = (String) session.getAttribute("userEmail");
    if (adminEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Prevent caching of the page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - VOYA</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/logo2.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    <style>
        :root {
            --primary-dark: #000000;
            --primary-hover: #333333;
            --text-primary: #212121;
            --text-secondary: #878787;
            --bg-light: #f8f8f8;
            --card-bg: #ffffff;
            --border-color: #e0e0e0;
            --card-shadow: rgba(0, 0, 0, 0.05);
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
        }

        .navbar {
            background-color: var(--card-bg);
            box-shadow: 0 2px 4px var(--card-shadow);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary-dark) !important;
        }

        .dashboard-header {
            font-size: 2rem;
            font-weight: 700;
            margin: 40px 0 30px;
            text-align: center;
        }

        .stat-card {
            border: none;
            border-radius: 8px;
            background: var(--card-bg);
            box-shadow: 0 4px 12px var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            padding: 25px;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.08);
        }
        
        .stat-card h5 {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .stat-card p {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }

        .nav-links-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-top: 40px;
        }
        
        .nav-link-btn {
            padding: 12px 24px;
            font-weight: 600;
            border-radius: 4px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: background-color 0.3s ease;
            background-color: var(--primary-dark);
            color: white;
        }

        .nav-link-btn:hover {
            background-color: var(--primary-hover);
            color: white;
        }

        .chart-container {
            position: relative;
            height: 400px;
            width: 100%;
        }

        .chart-card {
            border: none;
            border-radius: 8px;
            background: var(--card-bg);
            box-shadow: 0 4px 12px var(--card-shadow);
            padding: 25px;
            min-height: 400px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .chart-card h5 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }

        footer {
            margin-top: 50px;
            padding: 20px;
            background-color: var(--card-bg);
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-secondary);
            border-top: 1px solid var(--border-color);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">Voya Admin</a>
        <div class="d-flex align-items-center ms-auto">
            <span class="me-3"><i class="fas fa-user-circle"></i> <%= adminEmail %></span>
            <a href="jsp/logout.jsp" class="btn btn-dark btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <h1 class="dashboard-header">Admin Overview</h1>

    <div class="row g-4">
        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <h5>Total Products</h5>
                <p><%= request.getAttribute("totalProducts") %></p>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <h5>Total Customers</h5>
                <p><%= request.getAttribute("totalCustomers") %></p>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <h5>Total Orders</h5>
                <p><%= request.getAttribute("totalOrders") %></p>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <h5>Pending Orders</h5>
                <p><%= request.getAttribute("pendingOrders") %></p>
            </div>
        </div>
    </div>
    
    <div class="row g-4 mt-5">
        <div class="col-12">
            <div class="chart-card">
                <h5>Monthly Sales Trend</h5>
                <div class="chart-container">
                    <canvas id="monthlySalesChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="chart-card">
                <h5>Top 5 Best-Selling Products</h5>
                <div class="chart-container">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="chart-card">
                <h5>Order Status Distribution</h5>
                <div class="chart-container" style="max-width: 400px; max-height: 400px;">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="nav-links-container">
        <a href="jsp/viewProducts.jsp" class="nav-link-btn"><i class="fas fa-boxes"></i> Manage Products</a>
        <a href="<%= request.getContextPath() %>/ViewCustomers" class="nav-link-btn"><i class="fas fa-user-friends"></i> View Customers</a>
        <a href="<%= request.getContextPath() %>/ViewOrdersAdmin" class="nav-link-btn"><i class="fas fa-truck"></i> View Orders</a>
    </div>
</div>

<footer>
    &copy; 2025 Voya | Admin Panel. All rights reserved.
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Retrieve data from servlet attributes
        <%
            List<Map<String, Object>> monthlySales = (List<Map<String, Object>>) request.getAttribute("monthlySales");
            List<Map<String, Object>> topSellingProducts = (List<Map<String, Object>>) request.getAttribute("topSellingProducts");
            List<Map<String, Object>> orderStatusCounts = (List<Map<String, Object>>) request.getAttribute("orderStatusCounts");
            
            // Handle null data by providing empty lists
            if (monthlySales == null) monthlySales = new ArrayList<>();
            if (topSellingProducts == null) topSellingProducts = new ArrayList<>();
            if (orderStatusCounts == null) orderStatusCounts = new ArrayList<>();

            // Convert monthly sales data into a format for Chart.js
            String monthlyLabels = monthlySales.stream()
                .map(m -> "'" + m.get("month") + "'")
                .collect(Collectors.joining(","));
            
            String monthlyData = monthlySales.stream()
                .map(m -> String.valueOf(m.get("total_sales")))
                .collect(Collectors.joining(","));
                
            // Convert top selling products data
            String productLabels = topSellingProducts.stream()
                .map(p -> "'" + p.get("product_name") + "'")
                .collect(Collectors.joining(","));
            
            String productData = topSellingProducts.stream()
                .map(p -> String.valueOf(p.get("total_quantity")))
                .collect(Collectors.joining(","));
            
            // Convert order status data
            String statusLabels = orderStatusCounts.stream()
                .map(s -> "'" + s.get("status") + "'")
                .collect(Collectors.joining(","));
            
            String statusData = orderStatusCounts.stream()
                .map(s -> String.valueOf(s.get("count")))
                .collect(Collectors.joining(","));
        %>


        // Chart 1: Monthly Sales Trend (Line Chart)
        if (<%= monthlySales.size() %> > 0) {
            const monthlySalesCtx = document.getElementById('monthlySalesChart').getContext('2d');
            new Chart(monthlySalesCtx, {
                type: 'line',
                data: {
                    labels: [<%= monthlyLabels %>],
                    datasets: [{
                        label: 'Sales (INR)',
                        data: [<%= monthlyData %>],
                        backgroundColor: 'rgba(0, 0, 0, 0.1)',
                        borderColor: '#000000',
                        borderWidth: 2,
                        tension: 0.4,
                        pointBackgroundColor: '#000000',
                        pointBorderColor: '#fff',
                        pointHoverRadius: 6,
                        pointHoverBackgroundColor: '#000000'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Total Sales (INR)'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Month'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(context.parsed.y);
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        } else {
            document.getElementById('monthlySalesChart').parentElement.innerHTML = '<p class="text-muted text-center">No monthly sales data available.</p>';
        }
        
        // Chart 2: Top Best-Selling Products (Bar Chart)
        if (<%= topSellingProducts.size() %> > 0) {
            const topProductsCtx = document.getElementById('topProductsChart').getContext('2d');
            new Chart(topProductsCtx, {
                type: 'bar',
                data: {
                    labels: [<%= productLabels %>],
                    datasets: [{
                        label: 'Total Items Sold',
                        data: [<%= productData %>],
                        backgroundColor: [
                            '#000000', '#333333', '#666666', '#999999', '#cccccc'
                        ],
                        borderColor: '#fff',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Quantity Sold'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        } else {
            document.getElementById('topProductsChart').parentElement.innerHTML = '<p class="text-muted text-center">No top-selling product data available.</p>';
        }

        // Chart 3: Order Status Distribution (Pie Chart)
        if (<%= orderStatusCounts.size() %> > 0) {
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: [<%= statusLabels %>],
                    datasets: [{
                        label: 'Order Status',
                        data: [<%= statusData %>],
                        backgroundColor: [
                            '#000000', '#6c757d', '#28a745', '#ffc107', '#dc3545'
                        ],
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right'
                        }
                    }
                }
            });
        } else {
            document.getElementById('statusChart').parentElement.innerHTML = '<p class="text-muted text-center">No order status data available.</p>';
        }
    });
</script>

</body>
</html>