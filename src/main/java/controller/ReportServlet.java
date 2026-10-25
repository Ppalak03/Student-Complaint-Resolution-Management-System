package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.sql.*;

import dao.DBConnection;

// 🔥 iText 5 imports (make sure JAR added)
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        //PDF DOWNLOAD CHECK
        String download = req.getParameter("download");
        if ("pdf".equals(download)) {
            generatePDF(res);
            return;
        }

        //HTML UI
        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        out.println("<html><head>");
        out.println("<title>Complaint Report</title>");

        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css'>");

        out.println("<style>");
        out.println("body{background:#f4f6f9;font-family:Segoe UI;}");
        out.println(".card{border-radius:15px;box-shadow:0 5px 20px rgba(0,0,0,0.2);}");
        out.println(".table th{background:#343a40;color:white;}");
        out.println(".star{color:gold;font-size:14px;}");
        out.println("</style>");

        out.println("</head><body>");
        out.println("<div class='container mt-4'>");
        out.println("<div class='card p-4'>");

        out.println("<div class='d-flex justify-content-between'>");
        out.println("<h3>📊 Complaint Report</h3>");
        out.println("<a href='ReportServlet?download=pdf' class='btn btn-danger'>📄 Download PDF</a>");
        out.println("</div><hr>");

        out.println("<table class='table table-bordered text-center'>");
        out.println("<tr>");
        out.println("<th>ID</th><th>Title</th><th>Status</th><th>Department</th>");
        out.println("<th>Submitted On</th><th>Resolution</th><th>Feedback</th>");
        out.println("</tr>");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT c.*, f.rating, f.comments FROM complaints c " +
                         "LEFT JOIN feedback f ON c.id=f.complaint_id";

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {

                out.println("<tr>");

                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("<td>" + rs.getString("department") + "</td>");

                //DATE
                out.println("<td>" + rs.getString("created_at") + "</td>");

                //RESOLUTION
                String reso = rs.getString("resolution");
                out.println("<td>" + (reso != null ? reso : "Not Added") + "</td>");

                //FEEDBACK
                int rating = rs.getInt("rating");
                String comment = rs.getString("comments");

                out.println("<td>");

                if (comment != null) {
                    for (int i = 0; i < rating; i++) {
                        out.println("<i class='bi bi-star-fill star'></i>");
                    }
                    out.println("<br><small>" + comment + "</small>");
                } else {
                    out.println("No Feedback");
                }

                out.println("</td>");

                out.println("</tr>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        out.println("</table>");
        out.println("</div></div>");
        out.println("</body></html>");
    }

    //PDF GENERATION METHOD
    private void generatePDF(HttpServletResponse res) {

        try {
            res.setContentType("application/pdf");
            res.setHeader("Content-Disposition", "attachment; filename=ComplaintReport.pdf");

            Document doc = new Document();
            PdfWriter.getInstance(doc, res.getOutputStream());

            doc.open();

            // Title
            doc.add(new Paragraph("Complaint Report\n\n",
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));

            // Table (7 columns)
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);

            table.addCell("ID");
            table.addCell("Title");
            table.addCell("Status");
            table.addCell("Dept");
            table.addCell("Date");
            table.addCell("Resolution");
            table.addCell("Feedback");

            Connection con = DBConnection.getConnection();

            String sql = "SELECT c.*, f.rating, f.comments FROM complaints c " +
                         "LEFT JOIN feedback f ON c.id=f.complaint_id";

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {

                table.addCell(String.valueOf(rs.getInt("id")));
                table.addCell(rs.getString("title"));
                table.addCell(rs.getString("status"));
                table.addCell(rs.getString("department"));
                table.addCell(rs.getString("created_at"));

                String reso = rs.getString("resolution");
                table.addCell(reso != null ? reso : "Not Added");

                String feedback = rs.getString("comments");
                table.addCell(feedback != null ? feedback : "No Feedback");
            }

            doc.add(table);
            doc.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}