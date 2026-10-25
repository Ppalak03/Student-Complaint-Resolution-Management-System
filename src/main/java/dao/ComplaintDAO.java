package dao;

import java.sql.*;
import java.util.*;
import model.Complaint;
import util.DBConnection;

public class ComplaintDAO {

    //ADD COMPLAINT
    public static boolean addComplaint(Complaint c) {
        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO complaints(title, description, status, file_path, user_id, department, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, c.getTitle());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getStatus());
            ps.setString(4, c.getFilePath());
            ps.setInt(5, c.getUserId());
            ps.setString(6, c.getDepartment());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    //GET USER COMPLAINTS
public static List<Complaint> getComplaintsByUser(int userId) {

    List<Complaint> list = new ArrayList<>();

    try {
        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM complaints WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Complaint c = new Complaint();

            c.setId(rs.getInt("id"));
            c.setTitle(rs.getString("title"));
            c.setDescription(rs.getString("description"));
            c.setStatus(rs.getString("status"));
            c.setFilePath(rs.getString("file_path"));
            c.setCreatedAt(rs.getString("created_at"));
            c.setResolutionDetails(rs.getString("resolution"));

            list.add(c);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

//GET COMPLAINTS BY DEPARTMENT
public static List<Complaint> getDepartmentComplaints(String dept, String keyword, String status) {

    List<Complaint> list = new ArrayList<>();

    try {
        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM complaints WHERE department=?";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND title LIKE ?";
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND status=?";
        }

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, dept);

        int index = 2;

        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(index++, "%" + keyword + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            ps.setString(index++, status);
        }

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Complaint c = new Complaint();

            c.setId(rs.getInt("id"));
            c.setTitle(rs.getString("title"));
            c.setStatus(rs.getString("status"));
            c.setFilePath(rs.getString("file_path"));

            list.add(c);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    //COUNT BY DEPARTMENT + STATUS (For Chart)
    public static int getDeptCount(String dept, String status) {

        int count = 0;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM complaints WHERE department=? AND status=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, dept);
            ps.setString(2, status);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    //UPDATE STATUS + RESOLUTION 
    public static boolean updateStatus(int id, String status, String resolution) {

        boolean result = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql;

            // If resolution provided
            if (resolution != null && !resolution.isEmpty()) {
                sql = "UPDATE complaints SET status=?, resolution=? WHERE id=?";
            } else {
                sql = "UPDATE complaints SET status=? WHERE id=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, status);

            if (resolution != null && !resolution.isEmpty()) {
                ps.setString(2, resolution);
                ps.setInt(3, id);
            } else {
                ps.setInt(2, id);
            }

            result = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    //ASSIGN DEPARTMENT (By Admin)
    public static boolean assignDepartment(int id, String dept) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE complaints SET department=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, dept);
            ps.setInt(2, id);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

}