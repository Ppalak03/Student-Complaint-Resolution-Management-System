package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.ComplaintDAO;
import model.Complaint;
import model.User;

@WebServlet("/department")
public class DepartmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    //LOAD DASHBOARD
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String department = user.getDepartment();

        List<Complaint> list = ComplaintDAO.getDepartmentComplaints(
                department, keyword, status);

        int pending = 0, progress = 0, resolved = 0, rejected = 0;

        for (Complaint c : list) {
            switch (c.getStatus()) {
                case "Pending": pending++; break;
                case "In Progress": progress++; break;
                case "Resolved": resolved++; break;
                case "Rejected": rejected++; break;
            }
        }

        req.setAttribute("list", list);
        req.setAttribute("pending", pending);
        req.setAttribute("progress", progress);
        req.setAttribute("resolved", resolved);
        req.setAttribute("rejected", rejected);

        RequestDispatcher rd = req.getRequestDispatcher("jsp/departmentDashboard.jsp");
        rd.forward(req, res);
    }

    //HANDLE START & RESOLVE BUTTONS
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");
        String resolution = req.getParameter("resolution");

        //UPDATE STATUS
        ComplaintDAO.updateStatus(id, status, resolution);

        //REDIRECT BACK TO SAME DASHBOARD
        res.sendRedirect("department");
    }
}