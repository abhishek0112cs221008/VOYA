package servlet;

import dao.DBConnection;
import dao.ProductDAO;
import model.Product;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
	
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productDAO = new ProductDAO();
    }
	
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
        // Ensure user is logged in
        String userEmail = (String) req.getSession().getAttribute("userEmail");
        if (userEmail == null) {
            res.sendRedirect("index.html");
            return;
        }

        // Fetch all products or search results
        String search = req.getParameter("search");
        List<Product> products;
        if (search != null && !search.isEmpty()) {
            products = productDAO.searchProducts(search);
        } else {
            products = productDAO.getAllProducts();
        }

        // Organize products by category
        Map<String, List<Product>> categoryMap = new LinkedHashMap<>();
        for (Product p : products) {
            categoryMap.computeIfAbsent(p.getCategory(), k -> new ArrayList<>()).add(p);
        }
        
        // Fetch most viewed products (top 5 as an example)
        List<Product> topProducts = productDAO.getTopProductsByRecentViews(7 ,4);

        req.setAttribute("products", products); // For total count
        req.setAttribute("categoryMap", categoryMap);
        req.setAttribute("topProducts", topProducts);
        
        req.getRequestDispatcher("jsp/home.jsp").forward(req, res);
    }
}