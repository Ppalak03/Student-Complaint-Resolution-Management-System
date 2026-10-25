package controller;

import dao.ComplaintDAO;
import model.Complaint;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewComplaints")
public class ViewComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int userId = user.getId();

        List<Complaint> list = ComplaintDAO.getComplaintsByUser(userId);

        request.setAttribute("complaints", list);

        RequestDispatcher rd = request.getRequestDispatcher("jsp/viewComplaints.jsp");
        rd.forward(request, response);
    }
}