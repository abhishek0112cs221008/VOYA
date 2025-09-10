
package servlet;

import dao.UserDAO;
import model.User;
import security.HashUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/RegisterServlet") // Optional if web.xml already maps this
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Get user input
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String rawPassword = req.getParameter("password");
        String password = HashUtil.hashPassword(rawPassword);

        // Set user details
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole("customer"); // default role

        // Register user using DAO
        UserDAO dao = new UserDAO();
        boolean registered = dao.registerUser(user);

        if (registered) {
            // If registration is successful, create a session to log the user in
            HttpSession session = req.getSession();
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getName());
            session.setAttribute("user", user); // Store the full user object if needed

            // Redirect to the home servlet, now as a logged-in user
            res.sendRedirect("HomeServlet");
//            // Success: redirect to login
//            res.sendRedirect("HomeServlet");
        } else {
            // Failure: back to register with error
            res.sendRedirect("index.html?error=1");
        }
    }
}
//=======
//package servlet;
//
//import dao.UserDAO;
//import model.User;
//import security.HashUtil;
//
//import javax.servlet.*;
//import javax.servlet.http.*;
//import javax.servlet.annotation.WebServlet;
//import java.io.IOException;
//
//@WebServlet("/RegisterServlet") // Optional if web.xml already maps this
//public class RegisterServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse res)
//            throws ServletException, IOException {
//
//        // Get user input
//        String name = req.getParameter("name");
//        String email = req.getParameter("email");
//        String rawPassword = req.getParameter("password");
//        String password = HashUtil.hashPassword(rawPassword);
//
//        // Set user details
//        User user = new User();
//        user.setName(name);
//        user.setEmail(email);
//        user.setPassword(password);
//        user.setRole("customer"); // default role
//
//        // Register user using DAO
//        UserDAO dao = new UserDAO();
//        boolean registered = dao.registerUser(user);
//
//        if (registered) {
//            // Success: redirect to login
//            res.sendRedirect("jsp/home.jsp");
//        } else {
//            // Failure: back to register with error
//            res.sendRedirect("jsp/register.jsp?error=1");
//        }
//    }
//}