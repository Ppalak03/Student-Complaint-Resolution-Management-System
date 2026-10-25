package controller;

import java.io.File;
import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.ComplaintDAO;
import model.Complaint;
import model.User;

@WebServlet("/complaint")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1MB
    maxFileSize = 1024 * 1024 * 5,     // 5MB per file
    maxRequestSize = 1024 * 1024 * 25  // 25MB total (for multiple files)
)
public class ComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    //Permanent upload folder
    private static final String UPLOAD_DIR = "C:/SCRMS_Uploads";

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        //Session check
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        //Form data
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String department = req.getParameter("department");

        String filePath = null;

        try {

            
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            //Get all file parts
            Collection<Part> parts = req.getParts();

            StringBuilder fileNames = new StringBuilder();

            for (Part part : parts) {

                
                if (part.getName().equals("files") && part.getSize() > 0) {

                    String fileName = part.getSubmittedFileName();

                    if (fileName != null && !fileName.trim().isEmpty()) {

                        
                        String newFileName = System.currentTimeMillis() + "_" + fileName;

                        String fullPath = UPLOAD_DIR + File.separator + newFileName;

                        
                        part.write(fullPath);

                       
                        fileNames.append(newFileName).append(",");
                    }
                }
            }

            // Remove last comma
            if (fileNames.length() > 0) {
                filePath = fileNames.substring(0, fileNames.length() - 1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //Save complaint
        Complaint c = new Complaint();
        c.setTitle(title);
        c.setDescription(description);
        c.setDepartment(department);
        c.setStatus("Pending");
        c.setUserId(userId);
        c.setFilePath(filePath); 

        boolean status = ComplaintDAO.addComplaint(c);

        //Redirect with message
        if (status) {
            res.sendRedirect("studentDashboard?msg=success");
        } else {
            res.sendRedirect("jsp/submitComplaint.jsp?msg=error");
        }
    }
}