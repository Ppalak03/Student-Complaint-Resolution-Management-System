<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
if(session.getAttribute("user") == null){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Submit Complaint</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/*  Background */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: linear-gradient(135deg, #667eea, #764ba2);
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

/*  Glass Card */
.container-box {
    width: 420px;
    padding: 30px;
    border-radius: 20px;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    color: white;
}

/* Title */
.title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 20px;
}

/* Inputs */
input, select, textarea {
    width: 100%;
    padding: 10px;
    margin: 8px 0;
    border-radius: 8px;
    border: none;
    outline: none;
}

/* File input */
input[type="file"] {
    background: white;
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    background: linear-gradient(45deg,#ff758c,#ff7eb3);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    font-weight: bold;
    transition: 0.3s;
}

button:hover {
    transform: scale(1.05);
}

/* Alerts */
.alert {
    padding: 10px;
    border-radius: 8px;
    margin-bottom: 10px;
    display: none;
    text-align: center;
}

.success { background: #d4edda; color: #155724; }
.error { background: #f8d7da; color: #721c24; }

/* Validation */
.error-text {
    color: #ffcccc;
    font-size: 12px;
}

/* Back link */
.back-link {
    text-align: center;
    margin-top: 10px;
}

.back-link a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.back-link a:hover {
    text-decoration: underline;
}

</style>

<script>

// Validation
function validateField(id, msg) {
    let value = document.getElementById(id).value.trim();
    let error = document.getElementById(id + "Error");

    if (value === "") {
        error.innerText = msg;
        return false;
    } else {
        error.innerText = "";
        return true;
    }
}

// Final validation
function validateForm() {
    let title = validateField("title", "Title required");
    let desc = validateField("description", "Description required");
    return title && desc;
}

//  Alerts
function showAlert(message, type) {
    let alertBox = document.getElementById("alertBox");
    alertBox.innerHTML = message;
    alertBox.className = "alert " + type;
    alertBox.style.display = "block";
}

</script>

</head>

<body>

<div class="container-box">

<h3 class="title">📝 Submit Complaint</h3>

<div id="alertBox"></div>

<form action="<%=request.getContextPath()%>/complaint"
      method="post"
      enctype="multipart/form-data"
      onsubmit="return validateForm()">

    📌 Complaint Title
    <input type="text" id="title" name="title"
           onkeyup="validateField('title','Title required')">
    <div id="titleError" class="error-text"></div>

    📄 Description
    <textarea id="description" name="description" rows="3"
        onkeyup="validateField('description','Description required')"></textarea>
    <div id="descriptionError" class="error-text"></div>

    🏢 Department
    <select name="department">
        <option value="IT">IT</option>
        <option value="Library">Library</option>
		<option value="Hostel">Hostel</option>
        <option value="Admin">Admin</option>
    </select>

    📎 Attachment (optional)
    <input type="file" name="files" multiple>

    <button type="submit">🚀 Submit Complaint</button>

</form>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/studentDashboard">
        ⬅ Back to Dashboard
    </a>
</div>

</div>

<!--  Backend Alerts -->
<script>
<%
if("success".equals(msg)){
%>
showAlert("✅ Complaint Submitted Successfully!", "success");
<%
} else if("error".equals(msg)){
%>
showAlert("❌ Failed to submit complaint!", "error");
<%
}
%>
</script>

</body>
</html>