package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        //HASH INPUT PASSWORD
        String hashedPassword = PasswordUtil.hashPassword(password);

        User user = UserDAO.login(email, hashedPassword);

        if (user != null) {

            HttpSession session = req.getSession();

            //Session timeout (15 minutes)
            session.setMaxInactiveInterval(15 * 60);

            session.setAttribute("user", user);

            //Role-based redirect
            if (user.getRole().equalsIgnoreCase("student")) {
                res.sendRedirect("studentDashboard");

            } else if (user.getRole().equalsIgnoreCase("admin")) {
                res.sendRedirect("jsp/adminDashboard.jsp");

            } else {
                res.sendRedirect("department");
            }

        } else {
            res.sendRedirect("jsp/login.jsp?error=1");
        }
    }
}