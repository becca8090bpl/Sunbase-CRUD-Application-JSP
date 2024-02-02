<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login Page</title>
    <!-- Include jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form id="loginForm" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="button" onclick="authenticateUser()">Login</button>
            </div>
        </form>
    </div>

    <!-- Script for handling login -->
    <script>
        function authenticateUser() {
            var username = $("#username").val();
            var password = $("#password").val();
          
            // Make AJAX call to authentication API
            $.ajax({
                type: "POST",
                url: "authentication.jsp",
                data: { username: username, password: password },
                datatype: 'json',
                success: function(response) {
                    var token = response.token || response;
                   // alert(token);
                    if (token) {
                        // Authentication succeeded
                        localStorage.setItem("token", token);
                        console.log(token);
                        
                        window.location.href = "customerList.jsp";
                    } else {
                        // Authentication failed
                        alert("Authentication failed. Please check your credentials.");
                    }
                },

                error: function() {
                    alert("Authentication failed. Please check your credentials.");
                }
            });
        }
    </script>
</body>
</html>
