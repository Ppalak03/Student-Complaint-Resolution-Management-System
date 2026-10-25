package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.DBConnection;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet { 
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");
        String dept = req.getParameter("department");
        String resolution = req.getParameter("resolution");

        try {
            Connection con = DBConnection.getConnection();

            //Assign Department
            if (dept != null) {
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE complaints SET department=? WHERE id=?");
                ps.setString(1, dept);
                ps.setInt(2, id);
                ps.executeUpdate();
            }

            //Update Status + Resolution
            if (status != null) {

                if ("Resolved".equalsIgnoreCase(status)) {

                    PreparedStatement ps = con.prepareStatement(
                        "UPDATE complaints SET status=?, resolution=? WHERE id=?");

                    ps.setString(1, status);
                    ps.setString(2, resolution);
                    ps.setInt(3, id);

                    ps.executeUpdate();

                } else {

                    PreparedStatement ps = con.prepareStatement(
                        "UPDATE complaints SET status=? WHERE id=?");

                    ps.setString(1, status);
                    ps.setInt(2, id);

                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        res.sendRedirect("jsp/adminDashboard.jsp");
    }
}