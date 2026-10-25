<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");
if(user == null){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Student Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

/* Background */
body {
    background: linear-gradient(135deg, #667eea, #764ba2);
    font-family: 'Segoe UI';
}

/* Glass Dashboard */
.dashboard {
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    border-radius: 20px;
    padding: 30px;
    margin-top: 30px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    color: white;
}

/*  Profile */
.profile-box {
    text-align: center;
    margin-bottom: 25px;
}

.profile-box img {
    width: 90px;
    border-radius: 50%;
    border: 3px solid white;
}

/* Cards */
.card-box {
    border-radius: 15px;
    padding: 20px;
    font-weight: bold;
    transition: 0.3s;
    color: white;
}

.card-box:hover {
    transform: translateY(-5px) scale(1.03);
}

/* Card Colors */
.bg1 { background: linear-gradient(45deg,#4facfe,#00f2fe); }
.bg2 { background: linear-gradient(45deg,#f6d365,#fda085); }
.bg3 { background: linear-gradient(45deg,#43e97b,#38f9d7); }
.bg4 { background: linear-gradient(45deg,#ff6a6a,#ff9966); }

/*  Buttons */
.action-btn {
    width: 100%;
    padding: 15px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: bold;
    transition: 0.3s;
}

.action-btn:hover {
    transform: scale(1.05);
}

/* Chart */
canvas {
    max-height: 280px;
}

/* Logout */
.logout-btn {
    border-radius: 10px;
}

/* Section Title */
.section-title {
    font-weight: bold;
    margin-bottom: 10px;
}

</style>

</head>

<body>

<div class="container">
<div class="dashboard">

<!--  PROFILE -->
<div class="profile-box">
    <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png">
    <h4 class="mt-2"><%= user.getName() %></h4>
    <p class="text-light">🎓 Student</p>
</div>

<!-- STATS -->
<div class="row text-center mb-4">

    <div class="col-md-3">
        <div class="card-box bg1">
            📋 Total <br>
            ${total != null ? total : 0}
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box bg2">
            ⏳ Pending <br>
            ${pending != null ? pending : 0}
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box bg3">
            ✅ Resolved <br>
            ${resolved != null ? resolved : 0}
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box bg4">
            ❌ Rejected <br>
            ${rejected != null ? rejected : 0}
        </div>
    </div>

</div>

<!-- CHART -->
<div class="mb-4">
    <h5 class="text-center section-title">📊 Complaint Overview</h5>
    <canvas id="complaintChart"></canvas>
</div>

<!--  ACTION BUTTONS -->
<div class="row text-center">

    <div class="col-md-6 mb-3">
        <a href="<%= request.getContextPath() %>/jsp/submitComplaint.jsp"
           class="btn btn-primary action-btn">
           ➕ Submit Complaint
        </a>
    </div>

    <div class="col-md-6 mb-3">
        <a href="<%= request.getContextPath() %>/viewComplaints"
           class="btn btn-success action-btn">
           📋 View Complaints
        </a>
    </div>

</div>

<!--  LOGOUT -->
<div class="text-center mt-4">
    <a href="<%= request.getContextPath() %>/logout"
       class="btn btn-danger logout-btn">
       🚪 Logout
    </a>
</div>

</div>
</div>

<!--  CHART SCRIPT -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    var pending = <%= request.getAttribute("pending") != null ? request.getAttribute("pending") : 0 %>;
    var resolved = <%= request.getAttribute("resolved") != null ? request.getAttribute("resolved") : 0 %>;
    var rejected = <%= request.getAttribute("rejected") != null ? request.getAttribute("rejected") : 0 %>;

    var ctx = document.getElementById('complaintChart').getContext('2d');

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Pending', 'Resolved', 'Rejected'],
            datasets: [{
                data: [pending, resolved, rejected],
                backgroundColor: [
                    '#f6d365',
                    '#43e97b',
                    '#ff6a6a'
                ]
            }]
        }
    });

});
</script>

</body>
</html>