package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/file")
public class FileDownloadServlet extends HttpServlet { 
	
	private static final long serialVersionUID = 1L;

    private static final String UPLOAD_DIR = "C:/SCRMS_Uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("name");

        if (fileName == null) {
            response.getWriter().println("File not found");
            return;
        }

        File file = new File(UPLOAD_DIR + File.separator + fileName);

        if (!file.exists()) {
            response.getWriter().println("File not found");
            return;
        }

        FileInputStream fis = new FileInputStream(file);
        OutputStream os = response.getOutputStream();

        response.setContentType(getServletContext().getMimeType(fileName));
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

        byte[] buffer = new byte[1024];
        int bytesRead;

        while ((bytesRead = fis.read(buffer)) != -1) {
            os.write(buffer, 0, bytesRead);
        }

        fis.close();
        os.close();
    }
}