<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonParser" %>

<%
    String token = (String) request.getSession().getAttribute("token");
Connection dbConnection =null;
    // Check if the token is available
    if (token != null && !token.isEmpty()) {
        try {
            // Establish a connection to the database
            Class.forName("com.mysql.jdbc.Driver");
             dbConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunbase?characterEncoding=utf8", "root", "root");

            // API URL for getting customer list
            String apiUrl = "https://qa.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=get_customer_list";

            // Create URL object and open connection
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // Set the request method and headers
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "Bearer " + token);

            // Get response code
            int responseCode = connection.getResponseCode();

            // Check if the request was successful
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read the response
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                    StringBuilder resp = new StringBuilder();
                    String line;

                    while ((line = reader.readLine()) != null) {
                        resp.append(line);
                    }

                    // Parse the response using JsonParser
                    JsonElement jsonElement = JsonParser.parseString(resp.toString());

                    // Check if the response is an array
                    if (jsonElement.isJsonArray()) {
                        JsonArray customerArray = jsonElement.getAsJsonArray();

                        // Display the data from the API response and store it in the database
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List</title>
    <style>
        /* Add some simple styling for better presentation */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid black;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .filter-form {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<h2>Customer List</h2>

<!-- Filter Form -->
<form action="" method="post" class="filter-form">
    <label for="filterText">Filter by:</label>
    <select name="filterCriteria">
        <option value="first_name">First Name</option>
        <option value="last_name">Last Name</option>
        <option value="email">Email</option>
        <!-- Add more criteria based on your data -->
    </select>
    <input type="text" name="filterText" id="filterText" placeholder="Enter filter text">
    <input type="submit" value="Filter">
</form>

<!-- Customer List Table -->
<table border="1">
    <thead>
        <tr>
            <th>UUID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Address</th>
            <th>City</th>
            <th>State</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <%
            // Filter Form Handling
            String filterCriteria = request.getParameter("filterCriteria");
            String filterText = request.getParameter("filterText");

            // Fetch data from the database with filtering
            try (PreparedStatement statement = dbConnection.prepareStatement("SELECT * FROM customer WHERE " + filterCriteria + " LIKE ?")) {
                statement.setString(1, "%" + filterText + "%");
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
        %>
                    <tr>
                        <td><%= resultSet.getString("uuid") %></td>
                        <td><%= resultSet.getString("first_name") %></td>
                        <td><%= resultSet.getString("last_name") %></td>
                        <td><%= resultSet.getString("address") %></td>
                        <td><%= resultSet.getString("city") %></td>
                        <td><%= resultSet.getString("state") %></td>
                        <td><%= resultSet.getString("email") %></td>
                        <td><%= resultSet.getString("phone") %></td>
                        <td>
                            <!-- Update button -->
                            <form action="updateCustomer.jsp" method="post">
                                <input type="hidden" name="customerId" value="<%= resultSet.getString("uuid") %>">
                                <input type="submit" value="Update">
                            </form>

                            <!-- Delete button -->
                            <form action="deleteCustomer.jsp" method="post">
                                <input type="hidden" name="customerId" value="<%= resultSet.getString("uuid") %>">
                                <input type="submit" value="Delete">
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace(); // Handle the exception as needed
            }
        %>
    </tbody>
</table>

</body>
</html>
<%
                    } else {
                        // Handle the case where the response is not an array
                        out.println("Error: Unexpected JSON format. Expected an array.");
                    }
                }
            } else {
                // Handle the case where the API request was not successful
                out.println("Error retrieving customer list. HTTP Status: " + responseCode);
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
        // Handle the case where the token is not available
        out.println("Authentication token not available. Please log in.");
    }
%>
