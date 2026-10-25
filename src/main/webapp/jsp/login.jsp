<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!--  Prevent back cache -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">

    <style>
        body {
            background: linear-gradient(135deg, #667eea, #764ba2);
            height: 100vh;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0px 10px 30px rgba(0,0,0,0.2);
        }
        .btn-custom {
            background: #667eea;
            color: white;
        }
        .btn-custom:hover {
            background: #5a67d8;
        }
		.back-link {
	    text-align: center;
	    margin-top: 10px;
		}

		.back-link a {
		    color: #764ba2;
		    text-decoration: none;
		    font-size: 16px;
		}
		
		.back-link a:hover {
		    text-decoration: underline;
		}
    </style>
</head>

<body class="d-flex justify-content-center align-items-center">

<div class="card p-4" style="width: 350px;">
    <h3 class="text-center mb-3">🔐 Login</h3>

    <!-- Alerts -->
    <%
        String error = request.getParameter("error");
        String msg = request.getParameter("msg");

        if ("1".equals(error)) {
    %>
        <div class="alert alert-danger">Invalid Email or Password!</div>
    <%
        }
        if ("registered".equals(msg)) {
    %>
        <div class="alert alert-success">Registration successful! Please login.</div>
    <%
        }
        if ("logout".equals(msg)) {
    %>
        <div class="alert alert-info">Logged out successfully!</div>
    <%
        }
        if ("expired".equals(msg)) {
    %>
        <div class="alert alert-warning">Session expired! Login again.</div>
    <%
        }
    %>

    <!-- Login Form -->
    <form action="../login" method="post" onsubmit="return validateForm()">

        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" id="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Password</label>
            <input type="password" name="password" id="password" class="form-control" required>
        </div>
		
		<div class="back-link">
        <a href="<%= request.getContextPath() %>/jsp/forgotPassword.jsp">Forgot Password</a>
    </div><br> 
		
        <button type="submit" class="btn btn-custom w-100">Login</button>
    </form>
</div>

<script>
function validateForm() {
    let email = document.getElementById("email").value.trim();
    let password = document.getElementById("password").value.trim();

    if (email === "" || password === "") {
        alert("All fields are required!");
        return false;
    }

    if (password.length < 4) {
        alert("Password must be at least 4 characters!");
        return false;
    }

    return true;
}
</script>

</body>
</html>