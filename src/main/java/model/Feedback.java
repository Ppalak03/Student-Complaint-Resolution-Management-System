package model;

import java.sql.Timestamp;

public class Feedback {

    private int complaintId;
    private int rating;
    private String comments;
    private Timestamp feedbackDate; 

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getFeedbackDate() {   
        return feedbackDate;
    }

    public void setFeedbackDate(Timestamp feedbackDate) {  
        this.feedbackDate = feedbackDate;
    }
}