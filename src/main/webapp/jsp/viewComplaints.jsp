<%@ page import="java.util.*,model.Complaint,model.User,model.Feedback,dao.FeedbackDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
User user = (User) session.getAttribute("user");

if(user == null){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}

List<Complaint> list = new ArrayList<>();
Object obj = request.getAttribute("complaints");

if(obj != null){
    list = (List<Complaint>) obj;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>My Complaints</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body {
    background: linear-gradient(135deg, #667eea, #764ba2);
    font-family: 'Segoe UI';
}

/* Container */
.main-box {
    background: white;
    border-radius: 20px;
    padding: 25px;
    margin-top: 30px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

/* Card */
.card-box {
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 20px;
    background: #f8f9fa;
    position: relative;
    transition: 0.3s;
}
.card-box:hover {
    transform: scale(1.01);
}

/* Title */
.title {
    font-size: 20px;
    font-weight: bold;
}

/* Status */
.status {
    position: absolute;
    top: 20px;
    right: 20px;
    padding: 6px 12px;
    border-radius: 20px;
    color: white;
    font-size: 12px;
}

.pending { background: orange; }
.progress { background: #007bff; }
.resolved { background: green; }
.rejected { background: red; }

/* Images */
.preview-img {
    width: 80px;
    height: 80px;
    border-radius: 10px;
    object-fit: cover;
    margin: 5px;
    cursor: pointer;
}

/* File container */
.file-box {
    margin-top: 10px;
}

/* Feedback stars */
.star {
    color: gold;
    font-size: 18px;
}

.feedback-box {
    background: #eef2ff;
    padding: 10px;
    border-radius: 10px;
    margin-top: 10px;
}

.top-buttons {
    position: absolute;
    top: 30px;
    right: 40px;
}

</style>
</head>

<body>

<div class="container">
<div class="main-box">

<h3>📋 My Complaints</h3>

<div class="top-buttons">
    <a href="<%= request.getContextPath() %>/studentDashboard" class="btn btn-light btn-sm">Dashboard</a>
    <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger btn-sm">Logout</a>
</div>

<hr>

<%
if(list != null && !list.isEmpty()){
for(Complaint c : list){

String statusClass = "pending";

if("In Progress".equalsIgnoreCase(c.getStatus())){
    statusClass = "progress";
} else if("Resolved".equalsIgnoreCase(c.getStatus())){
    statusClass = "resolved";
} else if("Rejected".equalsIgnoreCase(c.getStatus())){
    statusClass = "rejected";
}
%>

<!-- CARD -->
<div class="card-box">

<span class="status <%= statusClass %>">
    <%= c.getStatus() %>
</span>

<div class="title"><%= c.getTitle() %></div>
<div><%= c.getDescription() %></div>

<!--  MULTIPLE FILES -->
<div class="file-box">
<%
String file = c.getFilePath();

if(file != null && !file.trim().isEmpty()){
    String[] files = file.split(",");

    for(String f : files){

        String fileUrl = request.getContextPath() + "/file?name=" + f;

        if(f.endsWith(".jpg") || f.endsWith(".png") || f.endsWith(".jpeg")){
%>
    <img src="<%= fileUrl %>" class="preview-img"
         onclick="window.open('<%= fileUrl %>')">
<%
        } else {
%>
    <a href="<%= fileUrl %>" target="_blank"
       class="btn btn-sm btn-secondary m-1">
       📄 Download
    </a>
<%
        }
    }
} else {
%>
No Attachments
<%
}
%>
</div>

<!-- DETAILS -->
<div class="mt-2">
    <b>Department:</b> <%= c.getDepartment() != null ? c.getDepartment() : "Not Assigned" %><br>
    <b>Date:</b> <%= c.getCreatedAt() != null ? c.getCreatedAt() : "N/A" %><br>
    <b>Resolution:</b> <%= c.getResolutionDetails() != null ? c.getResolutionDetails() : "Not resolved yet" %>
</div>

<!--  FEEDBACK -->
<%
if("Resolved".equalsIgnoreCase(c.getStatus())){

boolean given = FeedbackDAO.isFeedbackGiven(c.getId());

if(given){
    Feedback fb = FeedbackDAO.getFeedbackByComplaintId(c.getId());
%>

<div class="feedback-box">

<%
for(int i=0;i<fb.getRating();i++){
%>
<span class="star">★</span>
<%
}
%>

<br>
<%= fb.getComments() %>

</div>

<%
} else {
%>

<div class="feedback-box">
<form action="<%= request.getContextPath() %>/submitFeedback" method="post">

<input type="hidden" name="complaintId" value="<%= c.getId() %>">

<select name="rating" class="form-control mb-1" required>
<option value="">Rating</option>
<option value="1">1 ⭐</option>
<option value="2">2 ⭐⭐</option>
<option value="3">3 ⭐⭐⭐</option>
<option value="4">4 ⭐⭐⭐⭐</option>
<option value="5">5 ⭐⭐⭐⭐⭐</option>
</select>

<input type="text" name="comments"
       class="form-control mb-1"
       placeholder="Write feedback..." required>

<button class="btn btn-success btn-sm">Submit Feedback</button>

</form>
</div>

<%
}
}
%>

</div>

<% }} else { %>

<p class="text-center">No complaints found</p>

<% } %>

</div>
</div>

</body>
</html>