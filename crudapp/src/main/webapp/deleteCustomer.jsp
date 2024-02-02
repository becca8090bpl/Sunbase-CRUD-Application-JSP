<%@ page import="java.sql.*" %>

<%
    // Retrieve customer ID from the form
    String customerId = request.getParameter("customerId");

    // Check if customer ID is not empty
    if (customerId != null && !customerId.isEmpty()) {
        Connection dbConnection = null;

        try {
            // Establish a connection to the database
            Class.forName("com.mysql.jdbc.Driver");
            dbConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunbase?characterEncoding=utf8", "root", "root");

            // Delete the customer data from the database based on customer ID
            try (PreparedStatement preparedStatement = dbConnection.prepareStatement("DELETE FROM customer WHERE uuid=?")) {
                preparedStatement.setString(1, customerId);

                // Execute the delete query
                int rowsDeleted = preparedStatement.executeUpdate();

                // Check if the deletion was successful
                if (rowsDeleted > 0) {
                    // Redirect back to the customer list page
                    response.sendRedirect("customerList.jsp");
                } else {
                    out.println("Error: Customer not found or could not be deleted.");
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
