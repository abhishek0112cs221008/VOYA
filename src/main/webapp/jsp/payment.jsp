<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Replace with actual cart total logic
    double totalAmount = Double.parseDouble(request.getParameter("total"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Voya - Pay by UPI</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><rect width='100' height='100' rx='15' fill='#000000' /><text x='50' y='65' font-family='Inter, sans-serif' font-size='40' font-weight='bold' fill='#FFFFFF' text-anchor='middle'>VOYA</text></svg>">
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
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
            font-family: 'Inter', sans-serif;
            background: var(--bg-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--text-dark);
        }
        
        .payment-card {
            background: var(--card-bg);
            padding: 30px 40px;
            width: 100%;
            max-width: 450px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            text-align: center;
        }

        .payment-header h2 {
            font-weight: 700;
        }

        .upi-info {
            background: var(--bg-light);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .amount {
            color: var(--primary-dark);
            font-weight: 700;
            font-size: 1.5rem;
        }

        /* Mock Gateway Styles */
        .mock-payment-container {
            transition: all 0.5s ease-in-out;
        }
        
        .progress-bar {
            background-color: var(--primary-dark);
            transition: width 0.3s ease;
        }

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
    <div class="payment-card">
        
        <!-- Payment Details View -->
        <div id="details-view" class="mock-payment-container">
            <div class="payment-header border-bottom pb-3 mb-3">
                <h2><i class="bi bi-wallet2"></i> Complete Payment</h2>
            </div>
            
            <div class="payment-details">
                <p class="text-muted">Please make a payment to the UPI ID below to confirm your order.</p>
                
                <div class="upi-info text-start">
                    <div>UPI ID: <strong>voya.pay@okbizaxis</strong></div>
                    <div class="mt-2">Amount: <span class="amount">₹ <%= totalAmount %></span></div>
                </div>
                
                <!-- This form will submit after the mock payment is complete -->
                <form id="payment-form" action="../OrderServlet" method="post">
                    <input type="hidden" name="paymentId" value="UPI-<%= System.currentTimeMillis() %>">
                    <input type="hidden" name="amount" value="<%= totalAmount %>">
                    <button type="button" onclick="startPayment()" class="btn btn-dark w-100 btn-lg">
                        <i class="bi bi-play-circle"></i> Proceed to Pay
                    </button>
                </form>

                <a href="cart.jsp" class="btn btn-link mt-3">Back to Cart</a>
            </div>
        </div>

        <!-- Processing View (Hidden by default) -->
        <div id="processing-view" class="mock-payment-container d-none">
            <div class="payment-header border-bottom pb-3 mb-3">
                <h2><i class="bi bi-arrow-repeat"></i> Processing...</h2>
            </div>
            
            <div class="d-flex flex-column align-items-center justify-content-center pt-3">
                <div class="spinner-border text-dark mb-3" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="text-muted">Please wait while we process your payment.</p>
                <div class="progress w-100 mt-3" style="height: 12px;">
                    <div id="progress-bar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>
        </div>

        <!-- Success View (Hidden by default) -->
        <div id="success-view" class="mock-payment-container d-none">
            <div class="payment-header border-bottom pb-3 mb-3">
                <h2 class="text-success"><i class="bi bi-check-circle-fill"></i> Payment Successful!</h2>
            </div>
            
            <p class="text-muted">Your order has been placed successfully. Thank you for shopping with us!</p>
            <form id="submit-order-form" action="../OrderServlet" method="post">
                <input type="hidden" name="paymentId" value="UPI-<%= System.currentTimeMillis() %>">
                <input type="hidden" name="amount" value="<%= totalAmount %>">
                <button type="submit" class="btn btn-success w-100 btn-lg mt-3">
                    Go to Order Confirmation
                </button>
            </form>
            <a href="home.jsp" class="btn btn-link mt-2">Continue Shopping</a>
        </div>
    </div>

    <script>
        function startPayment() {
            const detailsView = document.getElementById('details-view');
            const processingView = document.getElementById('processing-view');
            const successView = document.getElementById('success-view');
            const progressBar = document.getElementById('progress-bar');
            
            detailsView.classList.add('d-none');
            processingView.classList.remove('d-none');
            
            let progress = 0;
            const interval = setInterval(() => {
                progress += 10;
                progressBar.style.width = progress + '%';
                if (progress >= 100) {
                    clearInterval(interval);
                    
                    // Simulate a slight delay before showing success
                    setTimeout(() => {
                        processingView.classList.add('d-none');
                        successView.classList.remove('d-none');
                        
                        // Automatically submit the form to the OrderServlet
                        document.getElementById('submit-order-form').submit();
                    }, 1000);
                }
            }, 200);
        }

        document.addEventListener('DOMContentLoaded', () => {
            const savedTheme = localStorage.getItem('theme') || 'light';
            if (savedTheme === 'dark') {
                document.body.classList.add('dark-mode');
            }
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
