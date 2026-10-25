<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,model.Complaint" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}

List<Complaint> list = (List<Complaint>) request.getAttribute("list");

int pending = request.getAttribute("pending") != null ? (int)request.getAttribute("pending") : 0;
int progress = request.getAttribute("progress") != null ? (int)request.getAttribute("progress") : 0;
int resolved = request.getAttribute("resolved") != null ? (int)request.getAttribute("resolved") : 0;
int rejected = request.getAttribute("rejected") != null ? (int)request.getAttribute("rejected") : 0;
%>

<!DOCTYPE html>
<html>
<head>
<title>Department Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    background: linear-gradient(135deg, #667eea, #764ba2);
    font-family: 'Segoe UI';
}

/* Glass UI */
.dashboard {
    background: rgba(255,255,255,0.2);
    backdrop-filter: blur(10px);
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

/* Buttons */
.btn-sm {
    border-radius: 20px;
}

/* Progress */
.progress {
    height: 8px;
    border-radius: 10px;
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
    <h3>Department Dashboard</h3>
    <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger">Logout</a>
</div>

<hr>

<!-- SEARCH -->
<form action="<%= request.getContextPath() %>/department" method="get" class="row g-2 mb-4">

    <div class="col-md-4">
        <input type="text" name="keyword" class="form-control" placeholder="Search by title">
    </div>

    <div class="col-md-3">
        <select name="status" class="form-select">
            <option value="">All Status</option>
            <option value="Pending">Pending</option>
            <option value="In Progress">In Progress</option>
            <option value="Resolved">Resolved</option>
            <option value="Rejected">Rejected</option>
        </select>
    </div>

    <div class="col-md-2">
        <button class="btn btn-primary w-100">Search</button>
    </div>

</form>

<!-- CARDS -->
<div class="row text-center mb-4">

    <div class="col-md-3">
        <div class="stat-card bg1">
            Total <br><%= pending+progress+resolved+rejected %>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card bg2">
            Pending <br><%= pending %>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card bg3">
            Resolved <br><%= resolved %>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card bg4">
            Rejected <br><%= rejected %>
        </div>
    </div>

</div>

<!-- CHART -->
<canvas id="chart"></canvas>

<script>
new Chart(document.getElementById("chart"), {
    type: 'doughnut',
    data: {
        labels: ['Pending','In Progress','Resolved','Rejected'],
        datasets: [{
            data: [<%=pending%>,<%=progress%>,<%=resolved%>,<%=rejected%>],
            backgroundColor: ['#ffc107','#0d6efd','#198754','#dc3545']
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
<th>Status</th>
<th>File</th>
<th>Action</th>
<th>Progress</th>
</tr>

<%
if(list != null && !list.isEmpty()){
for(Complaint c : list){

int progressPercent = 20;
String barColor = "bg-warning";

if("In Progress".equalsIgnoreCase(c.getStatus())) {
    progressPercent = 60;
    barColor = "bg-primary";
}
else if("Resolved".equalsIgnoreCase(c.getStatus())) {
    progressPercent = 100;
    barColor = "bg-success";
}
%>

<tr>

<td><%= c.getId() %></td>
<td><%= c.getTitle() %></td>
<td><%= c.getStatus() %></td>

<td>
<%
String files = c.getFilePath();

if(files != null && !files.trim().isEmpty()){

    String[] fileList = files.split(",");

    for(String f : fileList){

        String fileUrl = request.getContextPath() + "/file?name=" + f.trim();

        if(f.endsWith(".jpg") || f.endsWith(".png") || f.endsWith(".jpeg")){
%>

    <img src="<%= fileUrl %>" 
         style="width:50px;height:50px;border-radius:5px;margin:2px;cursor:pointer"
         onclick="window.open('<%= fileUrl %>')">

<%
        } else {
%>

    <a href="<%= fileUrl %>" target="_blank" 
       class="btn btn-secondary btn-sm m-1">File</a>

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
<td>

<% if("Pending".equalsIgnoreCase(c.getStatus())){ %>

<form action="<%= request.getContextPath() %>/department" method="post">
<input type="hidden" name="id" value="<%= c.getId() %>">
<input type="hidden" name="status" value="In Progress">
<button class="btn btn-warning btn-sm">Start</button>
</form>

<% } else if("In Progress".equalsIgnoreCase(c.getStatus())){ %>

<form action="<%= request.getContextPath() %>/department" method="post">
<input type="hidden" name="id" value="<%= c.getId() %>">
<input type="hidden" name="status" value="Resolved">

<textarea name="resolution" required class="form-control mb-1" placeholder="Enter resolution"></textarea>
<button class="btn btn-success btn-sm">Resolve</button>
</form>

<% } else { %>
<span class="text-muted">Completed</span>
<% } %>

</td>

<td>
<div class="progress">
<div class="progress-bar <%= barColor %>" style="width:<%=progressPercent%>%"></div>
</div>
</td>

</tr>

<% }} else { %>

<tr><td colspan="6">No complaints found</td></tr>

<% } %>

</table>

</div>
</div>

</body>
</html>