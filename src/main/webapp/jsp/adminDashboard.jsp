<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,dao.DBConnection" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    background: linear-gradient(135deg, #4facfe, #00f2fe);
    font-family: 'Segoe UI';
}

/* Dashboard */
.dashboard {
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    border-radius: 20px;
    padding: 25px;
    margin-top: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

/* Header */
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* Cards */
.stat-card {
    border-radius: 15px;
    padding: 20px;
    color: white;
    font-weight: bold;
    transition: 0.3s;
}
.stat-card:hover {
    transform: translateY(-5px);
}

.bg1 { background: linear-gradient(45deg, #36d1dc, #5b86e5); }
.bg2 { background: linear-gradient(45deg, #f7971e, #ffd200); color:black; }
.bg3 { background: linear-gradient(45deg, #56ab2f, #a8e063); }
.bg4 { background: linear-gradient(45deg, #ff416c, #ff4b2b); }

/* Table */
.table {
    background: white;
    border-radius: 10px;
    overflow: hidden;
}
.table th {
    background: #343a40;
    color: white;
}

/* Files */
.file-box img {
    width: 50px;
    height: 50px;
    border-radius: 6px;
    margin: 2px;
    cursor: pointer;
}

/* Stars */
.star {
    color: gold;
    font-size: 16px;
}

/* Progress */
.progress {
    height: 8px;
}

/* Chart */
canvas {
    max-height: 250px;
    margin: auto;
    display: block;
}
</style>
</head>

<body>

<div class="container">
<div class="dashboard">

<!-- HEADER -->
<div class="header">
    <h3>Admin Dashboard</h3>
    <div>
        <a href="<%= request.getContextPath() %>/ReportServlet" class="btn btn-dark">Generate Report</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger">Logout</a>
    </div>
</div>

<hr>

<%
int pending=0, resolved=0, rejected=0, progress=0;

Connection con2 = DBConnection.getConnection();
Statement st2 = con2.createStatement();
ResultSet rs2 = st2.executeQuery("SELECT status, COUNT(*) as count FROM complaints GROUP BY status");

while(rs2.next()){
    String s = rs2.getString("status");

    if("Pending".equalsIgnoreCase(s)) pending = rs2.getInt("count");
    else if("Resolved".equalsIgnoreCase(s)) resolved = rs2.getInt("count");
    else if("Rejected".equalsIgnoreCase(s)) rejected = rs2.getInt("count");
    else if("In Progress".equalsIgnoreCase(s)) progress = rs2.getInt("count");
}
%>

<!-- CARDS -->
<div class="row text-center mb-4">
    <div class="col-md-3"><div class="stat-card bg1">Total<br><%= pending+progress+resolved+rejected %></div></div>
    <div class="col-md-3"><div class="stat-card bg2">Pending<br><%= pending %></div></div>
    <div class="col-md-3"><div class="stat-card bg3">Resolved<br><%= resolved %></div></div>
    <div class="col-md-3"><div class="stat-card bg4">Rejected<br><%= rejected %></div></div>
</div>

<!-- CHART -->
<canvas id="chart"></canvas>

<script>
new Chart(document.getElementById("chart"), {
    type: 'doughnut',
    data: {
        labels: ['Pending','In Progress','Resolved','Rejected'],
        datasets: [{
            data: [<%=pending%>,<%=progress%>,<%=resolved%>,<%=rejected%>]
        }]
    }
});
</script>

<hr>

<!-- TABLE -->
<table class="table table-bordered text-center">

<tr>
<th>ID</th>
<th>Title</th>
<th>Department</th>
<th>Files</th>
<th>Feedback</th>
<th>Resolution</th>
<th>Assign</th>
<th>Action</th>
<th>Progress</th>
</tr>

<%
Connection con = DBConnection.getConnection();

String sql = "SELECT c.*, f.rating, f.comments FROM complaints c LEFT JOIN feedback f ON c.id = f.complaint_id";

Statement st = con.createStatement();
ResultSet rs = st.executeQuery(sql);

while(rs.next()){

String status = rs.getString("status");
String dept = rs.getString("department");
String resolution = rs.getString("resolution");

int progressPercent = 20;
if("In Progress".equalsIgnoreCase(status)) progressPercent=60;
else if("Resolved".equalsIgnoreCase(status)) progressPercent=100;
%>

<tr>

<td><%= rs.getInt("id") %></td>
<td><%= rs.getString("title") %></td>

<td><%= (dept!=null?dept:"Not Assigned") %></td>

<!-- MULTIPLE FILES -->
<td class="file-box">
<%
String file = rs.getString("file_path");

if(file != null && !file.trim().isEmpty()){
    String[] files = file.split(",");

    for(String f : files){
        String url = request.getContextPath() + "/file?name=" + f;

        if(f.endsWith(".jpg") || f.endsWith(".png") || f.endsWith(".jpeg")){
%>
    <img src="<%= url %>" onclick="window.open('<%= url %>')">
<%
        } else {
%>
    <a href="<%= url %>" target="_blank" class="btn btn-sm btn-secondary m-1">File</a>
<%
        }
    }
} else {
%>
No File
<%
}
%>
</td>

<!-- FEEDBACK -->
<td>
<%
int rating = rs.getInt("rating");
String comment = rs.getString("comments");

if(comment != null){
for(int i=0;i<rating;i++){ %>
<span class="star">★</span>
<% } %>
<br><small><%= comment %></small>
<% } else { %>
No Feedback
<% } %>
</td>

<!-- RESOLUTION -->
<td><%= (resolution != null) ? resolution : "Not Added" %></td>

<!-- ASSIGN -->
<td>
<form action="<%= request.getContextPath() %>/AdminServlet" method="post">
<input type="hidden" name="id" value="<%= rs.getInt("id") %>">

<select name="department" class="form-select">
<option value="IT">IT</option>
<option value="Library">Library</option>
<option value="Hostel">Hostel</option>
<option value="Admin">Admin</option>
</select>

<button class="btn btn-primary btn-sm mt-1">Assign</button>
</form>
</td>

<!-- ACTION -->
<td>

<% if("Pending".equalsIgnoreCase(status)){ %>

<form action="<%= request.getContextPath() %>/AdminServlet" method="post">
<input type="hidden" name="id" value="<%= rs.getInt("id") %>">
<input type="hidden" name="status" value="In Progress">
<button class="btn btn-warning btn-sm">Start</button>
</form>

<% } else if("In Progress".equalsIgnoreCase(status)){ %>

<form action="<%= request.getContextPath() %>/AdminServlet" method="post">
<input type="hidden" name="id" value="<%= rs.getInt("id") %>">
<input type="hidden" name="status" value="Resolved">

<textarea name="resolution" class="form-control mb-1" required></textarea>
<button class="btn btn-success btn-sm">Resolve</button>
</form>

<% } else { %>
Done
<% } %>

</td>

<!-- PROGRESS -->
<td>
<div class="progress">
<div class="progress-bar bg-success" style="width:<%=progressPercent%>%"></div>
</div>
</td>

</tr>

<% } %>

</table>

</div>
</div>

</body>
</html>