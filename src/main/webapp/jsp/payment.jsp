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
        <div class="payment-header border-bottom pb-3 mb-3">
            <h2><i class="bi bi-wallet2"></i> Complete Payment</h2>
        </div>
        
        <div class="payment-details">
            <p class="text-muted">Please make a payment to the UPI ID below to confirm your order.</p>
            
            <div class="upi-info text-start">
                <div>UPI ID: <strong>abc@okbizaxis</strong></div>
                <div class="mt-2">Amount: <span class="amount">?<%= totalAmount %></span></div>
            </div>
            
            <form action="../OrderServlet" method="post">
                <input type="hidden" name="paymentId" value="UPI-<%= System.currentTimeMillis() %>">
                <input type="hidden" name="amount" value="<%= totalAmount %>">
                <button type="submit" class="btn btn-success w-100 btn-lg">
                    <i class="bi bi-check-circle"></i> I Have Paid
                </button>
            </form>

            <a href="cart.jsp" class="btn btn-link mt-3">Back to Cart</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const savedTheme = localStorage.getItem('theme') || 'light';
            if (savedTheme === 'dark') {
                document.body.classList.add('dark-mode');
            }
        });
    </script>
</body>
</html>
