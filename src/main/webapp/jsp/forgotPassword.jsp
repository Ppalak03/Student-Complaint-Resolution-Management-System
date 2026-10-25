<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* Background */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: linear-gradient(135deg, #667eea, #764ba2);
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Glass Card */
.card-box {
    width: 350px;
    padding: 30px;
    border-radius: 20px;
    background: rgba(255,255,255,0.15);
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
.form-control {
    border-radius: 10px;
}

/* Button */
.btn-custom {
    width: 100%;
    border-radius: 10px;
    font-weight: bold;
    background: linear-gradient(45deg,#ff758c,#ff7eb3);
    border: none;
    color: white;
    transition: 0.3s;
}

.btn-custom:hover {
    transform: scale(1.05);
}

/* Link */
.back-link {
    text-align: center;
    margin-top: 10px;
}

.back-link a {
    color: white;
    text-decoration: none;
    font-size: 14px;
}

.back-link a:hover {
    text-decoration: underline;
}

</style>

</head>

<body>

<div class="card-box">

    <h4 class="title"> Reset Password</h4>

    <form action="forgot" method="post">

        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>New Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <button class="btn btn-custom">Reset Password</button>

    </form>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/jsp/login.jsp">← Back to Login</a>
    </div>

</div>

</body>
</html>