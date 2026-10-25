package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet { 
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        String department = req.getParameter("department");

        
        if (!"department".equalsIgnoreCase(role)) {
            department = null; 
        }
        //HASH PASSWORD
        String hashedPassword = PasswordUtil.hashPassword(password);

        User user = new User(name, email, hashedPassword, role, department);

        boolean status = UserDAO.register(user);

        if (status) {
            res.sendRedirect("jsp/login.jsp?msg=registered");
        } else {
            res.sendRedirect("jsp/register.jsp?error=1");
        }
    }
}