package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.*;
import javax.servlet.http.*;
import dao.DBConnection;

@WebServlet("/forgotPassword")
public class ForgotServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET password=? WHERE email=?"
            );

            ps.setString(1, password);
            ps.setString(2, email);

            int i = ps.executeUpdate();

            if(i > 0){
                response.sendRedirect("login.jsp?msg=reset");
            } else {
                response.sendRedirect("forgotPassword.jsp?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}