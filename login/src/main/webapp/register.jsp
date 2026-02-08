<!-- File: register.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>

<h2>Register</h2>

<form action="registerServlet" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br><br>

    <input type="submit" value="register">
</form>

<!-- Display error or success messages -->
<p style="color:red;">
    ${error != null ? error : ""}
</p>

<p style="color:green;">
    ${success != null ? success : ""}
</p>

<p>
    Already have an account? 
    <a href="login.jsp">Login here</a>
</p>

</body>
</html>
