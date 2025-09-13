
package servlet;

import dao.CartItemDAO;
import dao.UserDAO;
import model.CartItem;
import model.User;
import security.HashUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        // Get form input from the login page
        String email = req.getParameter("email");
        String inputPassword = req.getParameter("password");
        
        // --- Input Validation ---
        if (email == null || email.isEmpty() || inputPassword == null || inputPassword.isEmpty()) {
            HttpSession session = req.getSession();
            session.setAttribute("loginErrorMsg", "Please enter both email and password.");
            res.sendRedirect("jsp/login.jsp");
            return;
        }

        // Hash the input password for secure comparison
        String hashedPassword = HashUtil.hashPassword(inputPassword);

        // Authenticate user with the database
        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, hashedPassword);
        
        if (user != null) {
            // --- Successful Login ---
            HttpSession session = req.getSession(true); // Create a new session if one doesn't exist
            
            // Set user-specific data in the session
            session.setAttribute("user", user);
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getName());
            
            // Load and set user's cart from the database
            List<CartItem> cart = CartItemDAO.getCartItemsByUserEmail(email);
            session.setAttribute("cart", cart);
            
            // Load and set membership status
            boolean isMember = UserDAO.isMember(email);
            session.setAttribute("isMember", isMember);
            
            // Redirect based on user's role
            String role = user.getRole();
            if ("admin".equalsIgnoreCase(role)) {
                res.sendRedirect("AdminServlet"); 
            } else {
            	res.sendRedirect("HomeServlet");
            }
        } else {
            // --- Failed Login ---
            // Redirect back to the login page with an error message
            HttpSession session = req.getSession();
            session.setAttribute("loginErrorMsg", "Invalid email or password. Please try again.");
            res.sendRedirect("jsp/login.jsp");
        }
    }
}