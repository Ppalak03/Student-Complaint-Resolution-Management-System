package dao;

import java.sql.*;
import model.User;

public class UserDAO {

    public static boolean register(User u) {
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users (name,email,password,role,department) VALUES (?,?,?,?,?)"
            );

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getDepartment());

            return ps.executeUpdate() > 0; 

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static User login(String email, String password) {

    User user = null;

    try {
        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            user = new User(); //default constructor

            user.setId(rs.getInt("id")); 
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setDepartment(rs.getString("department"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return user;
}
}