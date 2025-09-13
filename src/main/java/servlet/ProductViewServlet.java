package servlet;

import dao.ProductDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ProductViewServlet")
public class ProductViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(req.getParameter("productId"));

            ProductDAO productDAO = new ProductDAO();
            productDAO.recordProductView(productId);

            res.setContentType("application/json");
            res.getWriter().write("{\"status\":\"success\"}");
        } catch (NumberFormatException e) {
            res.setContentType("application/json");
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid product ID\"}");
        } catch (Exception e) {
            res.setContentType("application/json");
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"status\":\"error\", \"message\":\"An unexpected error occurred\"}");
            e.printStackTrace();
        }
    }
}