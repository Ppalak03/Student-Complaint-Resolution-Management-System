package dao;

import java.sql.*;
import util.DBConnection;
import model.Feedback;

public class FeedbackDAO {

    //ADD FEEDBACK (ONLY IF RESOLVED + NOT ALREADY GIVEN)
    public static boolean addFeedback(int complaintId, int rating, String comments) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            //Check complaint status
            String check = "SELECT status FROM complaints WHERE id=?";
            PreparedStatement ps1 = con.prepareStatement(check);
            ps1.setInt(1, complaintId);
            ResultSet rs = ps1.executeQuery();

            if (rs.next() && rs.getString("status").equalsIgnoreCase("Resolved")) {

                //Prevent duplicate
                if (isFeedbackGiven(complaintId)) {
                    return false;
                }

                String sql = "INSERT INTO feedback (complaint_id, rating, comments, feedback_date) VALUES (?, ?, ?, NOW())";
                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, complaintId);
                ps.setInt(2, rating);
                ps.setString(3, comments);

                status = ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    //CHECK IF FEEDBACK EXISTS
    public static boolean isFeedbackGiven(int complaintId) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM feedback WHERE complaint_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, complaintId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    //GET FEEDBACK DATA
    public static Feedback getFeedbackByComplaintId(int complaintId) {

        Feedback f = null;

        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM feedback WHERE complaint_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, complaintId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                f = new Feedback();
                f.setComplaintId(rs.getInt("complaint_id"));
                f.setRating(rs.getInt("rating"));
                f.setComments(rs.getString("comments"));
                f.setFeedbackDate(rs.getTimestamp("feedback_date"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return f;
    }
}