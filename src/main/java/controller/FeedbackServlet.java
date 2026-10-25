package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

import dao.FeedbackDAO;

@WebServlet("/submitFeedback")
public class FeedbackServlet extends HttpServlet { 
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");

        boolean status = FeedbackDAO.addFeedback(complaintId, rating, comments);

        //USE status
        if(status){
            response.sendRedirect("jsp/viewComplaints.jsp?msg=success");
        } else {
            response.sendRedirect("jsp/viewComplaints.jsp?msg=failed");
        }
    }
}