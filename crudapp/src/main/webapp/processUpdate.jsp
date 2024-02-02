<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.Gson" %>

<%@ page import="java.sql.*" %>

<%
    // Retrieve data from the update form
    String customerId = request.getParameter("customerId");
    String updatedFirstName = request.getParameter("firstName");
    String updatedLastName = request.getParameter("lastName");
    String updatedAddress = request.getParameter("address");
    String updatedCity = request.getParameter("city");
    String updatedState = request.getParameter("state");
    String updatedEmail = request.getParameter("email");
    String updatedPhone = request.getParameter("phone");

    // Check if customer ID is not empty
    if (customerId != null && !customerId.isEmpty()) {
        Connection dbConnection = null;

        try {
            // Establish a connection to the database
            Class.forName("com.mysql.jdbc.Driver");
            dbConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunbase?characterEncoding=utf8", "root", "root");

            // Update customer data in the database based on customer ID
            try (PreparedStatement preparedStatement = dbConnection.prepareStatement(
                    "UPDATE customer SET first_name=?, last_name=?, address=?, city=?, state=?, email=?, phone=? WHERE uuid=?")) {

                preparedStatement.setString(1, updatedFirstName);
                preparedStatement.setString(2, updatedLastName);
                preparedStatement.setString(3, updatedAddress);
                preparedStatement.setString(4, updatedCity);
                preparedStatement.setString(5, updatedState);
                preparedStatement.setString(6, updatedEmail);
                preparedStatement.setString(7, updatedPhone);
                preparedStatement.setString(8, customerId);

                // Execute the update query
                int rowsUpdated = preparedStatement.executeUpdate();

                // Check if the update was successful
                if (rowsUpdated > 0) {
                    // Redirect back to the customer list page
                    response.sendRedirect("customerList.jsp");
                } else {
                    out.println("Error: Customer not found or no changes made.");
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
