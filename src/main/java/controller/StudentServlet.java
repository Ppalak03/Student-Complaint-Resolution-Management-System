package controller;

import model.Complaint;
import model.User;
import dao.ComplaintDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/studentDashboard")
public class StudentServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }

        int userId = user.getId();

        List<Complaint> complaints = ComplaintDAO.getComplaintsByUser(userId);

        int total = complaints.size();
        int pending = 0, resolved = 0, rejected = 0;

        for (Complaint c : complaints) {

            switch (c.getStatus()) {
                case "Pending": pending++; break;
                case "Resolved": resolved++; break;
                case "Rejected": rejected++; break;
            }
        }

        request.setAttribute("total", total);
        request.setAttribute("pending", pending);
        request.setAttribute("resolved", resolved);
        request.setAttribute("rejected", rejected); 
        request.setAttribute("complaints", complaints);

        RequestDispatcher rd = request.getRequestDispatcher("jsp/studentDashboard.jsp");
        rd.forward(request, response);
    }
}