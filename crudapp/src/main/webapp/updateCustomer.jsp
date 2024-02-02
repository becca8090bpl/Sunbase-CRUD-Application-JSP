<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.google.gson.JsonObject" %>

<%
    // Retrieve the customer ID from the request parameter
    String customerId = request.getParameter("customerId");

    // Check if customer ID is not empty
    if (customerId != null && !customerId.isEmpty()) {
        Connection dbConnection = null;

        try {
            // Establish a connection to the database
            Class.forName("com.mysql.jdbc.Driver");
            dbConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunbase?characterEncoding=utf8", "root", "root");

            // Retrieve customer data from the database based on customer ID
            try (PreparedStatement preparedStatement = dbConnection.prepareStatement(
                    "SELECT * FROM customer WHERE uuid = ?")) {
                preparedStatement.setString(1, customerId);
                ResultSet resultSet = preparedStatement.executeQuery();

                // Check if customer data is found
                if (resultSet.next()) {
                    // Retrieve customer details
                    String firstName = resultSet.getString("first_name");
                    String lastName = resultSet.getString("last_name");
                    String address = resultSet.getString("address");
                    String city = resultSet.getString("city");
                    String state = resultSet.getString("state");
                    String email = resultSet.getString("email");
                    String phone = resultSet.getString("phone");

                    // Display the update form with pre-filled data
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Customer</title>
</head>
<body>

<h2>Update Customer</h2>

<form action="processUpdate.jsp" method="post">
    <input type="hidden" name="customerId" value="<%= customerId %>">
    <label for="firstName">First Name:</label>
    <input type="text" id="firstName" name="firstName" value="<%= firstName %>"><br>

    <label for="lastName">Last Name:</label>
    <input type="text" id="lastName" name="lastName" value="<%= lastName %>"><br>

    <label for="address">Address:</label>
    <input type="text" id="address" name="address" value="<%= address %>"><br>

    <label for="city">City:</label>
    <input type="text" id="city" name="city" value="<%= city %>"><br>

    <label for="state">State:</label>
    <input type="text" id="state" name="state" value="<%= state %>"><br>

    <label for="email">Email:</label>
    <input type="text" id="email" name="email" value="<%= email %>"><br>

    <label for="phone">Phone:</label>
    <input type="text" id="phone" name="phone" value="<%= phone %>"><br>

    <input type="submit" value="Update">
</form>

</body>
</html>
<%
                } else {
                    out.println("Error: Customer not found in the database.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Handle the exception as needed
        } finally {
            // Close the database connection
            try {
                if (dbConnection != null && !dbConnection.isClosed()) {
                    dbConnection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        out.println("Error: Customer ID not provided.");
    }
%>
