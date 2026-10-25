<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String msg = request.getParameter("msg");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<style>
body {
    margin: 0;
    font-family: Arial;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    background: white;
    padding: 30px;
    border-radius: 12px;
    width: 350px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.3);
}

input, select {
    width: 100%;
    padding: 10px;
    margin: 8px 0;
    border-radius: 6px;
    border: 1px solid #ccc;
}

button {
    width: 100%;
    padding: 10px;
    background: #667eea;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background: #5a67d8;
}

.alert {
    padding: 10px;
    border-radius: 6px;
    margin-bottom: 10px;
    display: none;
}

.success { background: #d4edda; color: #155724; }
.error { background: #f8d7da; color: #721c24; }

.error-text {
    color: red;
    font-size: 12px;
}

.strength { font-size: 12px; }
.weak { color: red; }
.medium { color: orange; }
.strong { color: green; }

</style>

<script>
function showAlert(message, type) {
    let alertBox = document.getElementById("alertBox");
    alertBox.innerHTML = message;
    alertBox.className = "alert " + type;
    alertBox.style.display = "block";
}

//Field validation
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

//Email validation
function validateEmail() {
    let email = document.getElementById("email").value;
    let error = document.getElementById("emailError");

    let pattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;

    if (!pattern.test(email)) {
        error.innerText = "Invalid email format";
        return false;
    } else {
        error.innerText = "";
        return true;
    }
}

//Password strength
function checkPassword() {
    let pass = document.getElementById("password").value;
    let strength = document.getElementById("strength");

    if (pass.length < 6) {
        strength.innerText = "Weak";
        strength.className = "strength weak";
    } else if (/[A-Z]/.test(pass) && /[0-9]/.test(pass)) {
        strength.innerText = "Strong";
        strength.className = "strength strong";
    } else {
        strength.innerText = "Medium";
        strength.className = "strength medium";
    }
}

//Validation
function validateForm() {
    let name = validateField("name", "Name required");
    let email = validateField("email", "Email required") && validateEmail();
    let pass = validateField("password", "Password required");

    let password = document.getElementById("password").value;
    let confirm = document.getElementById("confirm").value;

    if (password !== confirm) {
        document.getElementById("confirmError").innerText = "Passwords do not match";
        return false;
    } else {
        document.getElementById("confirmError").innerText = "";
    }

    return name && email && pass;
}

function toggleDept(){
    let role = document.getElementById("role").value;
    let box = document.getElementById("deptBox");

    if(role === "department"){
        box.style.display = "block";
    } else {
        box.style.display = "none";
    }
}

</script>

</head>

<body>

<div class="container">

<h2 style="text-align:center;">Create Account</h2>

<div id="alertBox"></div>

<form action="<%= request.getContextPath() %>/register" method="post" onsubmit="return validateForm()">

    Name:
    <input type="text" id="name" name="name" onkeyup="validateField('name','Name required')">
    <div id="nameError" class="error-text"></div>

    Email:
    <input type="text" id="email" name="email" onkeyup="validateEmail()">
    <div id="emailError" class="error-text"></div>

    Password:
    <input type="password" id="password" name="password" onkeyup="checkPassword()">
    <div id="strength" class="strength"></div>
    <div id="passwordError" class="error-text"></div>

    Confirm Password:
    <input type="password" id="confirm" name="confirm">
    <div id="confirmError" class="error-text"></div>

    Role:
<select name="role" id="role" onchange="toggleDept()">
    <option value="student">Student</option>
    <option value="department">Department</option>
    <option value="admin">Admin</option>
</select>

<div id="deptBox" style="display:none;">
    Department:
    <select name="department">
        <option>IT</option>
        <option>Library</option>
        <option>Hostel</option>
        <option>Admin</option>
    </select>
</div>
    <button type="submit">Register</button>

</form>

<br>
<p style="text-align:center;">
    Already have an account? <a href="login.jsp">Login</a>
</p>

</div>

<!--  Backend Alerts -->
<script>
<%
if("registered".equals(msg)){
%>
showAlert("Registration Successful!", "success");
<%
} else if("1".equals(error)){
%>
showAlert("Registration Failed!", "error");
<%
}
%>
</script>

</body>
</html>