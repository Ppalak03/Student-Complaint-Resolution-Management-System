package model;

public class Complaint {

    private int id;
    private String title;
    private String description;
    private String department;
    private String status;
    private String filePath;
    private int userId;
    private String createdAt; 
    private String resolutionDetails;

    //Default Constructor
    public Complaint() {}

    //Constructor (without file)
    public Complaint(String title, String description, String status, int userId) {
        this.title = title;
        this.description = description;
        this.status = status;
        this.userId = userId;
    }

    //Constructor (with file)
    public Complaint(String title, String description, String status, String filePath, int userId) {
        this.title = title;
        this.description = description;
        this.status = status;
        this.filePath = filePath;
        this.userId = userId;
    }

    //Constructor for fetching
    public Complaint(int id, String title, String description, String status, String filePath, int userId) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.status = status;
        this.filePath = filePath;
        this.userId = userId;
    }

    //Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }  
    
    public String getResolutionDetails() { return resolutionDetails; }
    public void setResolutionDetails(String resolutionDetails) { this.resolutionDetails = resolutionDetails; } 
    
    }