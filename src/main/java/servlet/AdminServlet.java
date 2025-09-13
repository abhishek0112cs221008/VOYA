package servlet;

import dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminServlet") 
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminEmail = (String) session.getAttribute("userEmail");

        if (adminEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int totalProducts = 0;
        int totalCustomers = 0;
        int totalOrders = 0;
        int pendingOrders = 0;

        List<Map<String, Object>> monthlySales = new ArrayList<>();
        List<Map<String, Object>> topSellingProducts = new ArrayList<>();
        List<Map<String, Object>> orderStatusCounts = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();

            // 1. Fetch basic statistics
            ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM products");
            if (rs1.next()) totalProducts = rs1.getInt(1);

            // Corrected query for total customers
            ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role = 'customer'");
            if (rs2.next()) totalCustomers = rs2.getInt(1);

            ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM orders");
            if (rs3.next()) totalOrders = rs3.getInt(1);

            ResultSet rs4 = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status = 'Pending'"); // 'Pending' with a capital 'P'
            if (rs4.next()) pendingOrders = rs4.getInt(1);

            // 2. Fetch data for Monthly Sales Chart
            // CORRECTED: Join with products table to get price for total sales
            String salesSql = "SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(o.quantity * p.price) AS total_sales " +
                              "FROM orders o JOIN products p ON o.product_id = p.id " +
                              "GROUP BY month ORDER BY month";
            try (PreparedStatement salesPs = conn.prepareStatement(salesSql);
                 ResultSet salesRs = salesPs.executeQuery()) {
                while (salesRs.next()) {
                    Map<String, Object> dataPoint = new HashMap<>();
                    dataPoint.put("month", salesRs.getString("month"));
                    dataPoint.put("total_sales", salesRs.getDouble("total_sales"));
                    monthlySales.add(dataPoint);
                }
            }

            // 3. Fetch data for Top Selling Products Chart
            // CORRECTED: Use 'orders' table directly instead of 'order_items'
            String topProductsSql = "SELECT p.name AS product_name, SUM(o.quantity) AS total_quantity " +
                                    "FROM orders o JOIN products p ON o.product_id = p.id " +
                                    "GROUP BY p.id, p.name ORDER BY total_quantity DESC LIMIT 5";
            try (PreparedStatement topProductsPs = conn.prepareStatement(topProductsSql);
                 ResultSet topProductsRs = topProductsPs.executeQuery()) {
                while (topProductsRs.next()) {
                    Map<String, Object> dataPoint = new HashMap<>();
                    dataPoint.put("product_name", topProductsRs.getString("product_name"));
                    dataPoint.put("total_quantity", topProductsRs.getInt("total_quantity"));
                    topSellingProducts.add(dataPoint);
                }
            }

            // 4. Fetch data for Order Status Distribution Chart
            // CORRECTED: Use 'orders' table directly
            String statusSql = "SELECT status, COUNT(*) AS count FROM orders GROUP BY status";
            try (PreparedStatement statusPs = conn.prepareStatement(statusSql);
                 ResultSet statusRs = statusPs.executeQuery()) {
                while (statusRs.next()) {
                    Map<String, Object> dataPoint = new HashMap<>();
                    dataPoint.put("status", statusRs.getString("status"));
                    dataPoint.put("count", statusRs.getInt("count"));
                    orderStatusCounts.add(dataPoint);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not load dashboard data.");
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlySales", monthlySales);
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("orderStatusCounts", orderStatusCounts);

        RequestDispatcher rd = request.getRequestDispatcher("jsp/admin.jsp");
        rd.forward(request, response);
    }
}