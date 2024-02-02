package crudapp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.DriverManager;

public class Retrieve {
	 // Function to save customer data to the MySQL database
  public  void saveCustomerToDatabase(String uuid, String firstName, String lastName, String street, String address, String city, String state, String email, String phone) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Database connection configuration (replace with your database configuration)
            String jdbcUrl = "jdbc:mysql://localhost:3306/your_database_name";
            String dbUsername = "your_database_username";
            String dbPassword = "your_database_password";

            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

            // SQL query to insert or update customer data
            String sql = "REPLACE INTO customer (uuid, first_name, last_name, street, address, city, state, email, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uuid);
            stmt.setString(2, firstName);
            stmt.setString(3, lastName);
            stmt.setString(4, street);
            stmt.setString(5, address);
            stmt.setString(6, city);
            stmt.setString(7, state);
            stmt.setString(8, email);
            stmt.setString(9, phone);

            // Execute the query
            stmt.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // Handle the exception as needed
        } finally {
            try {
                // Close the database resources
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Function to retrieve customer data from the MySQL database
	public List<Customer> getCustomerListFromDatabase() {
	        List<Customer> customerList = new ArrayList<>();
	        Connection conn = null;
	        PreparedStatement stmt = null;
	        ResultSet rs = null;

	        try {
	            // Database connection configuration (replace with your database configuration)
	            String jdbcUrl = "jdbc:mysql://localhost:3306/sunbase";
	            String dbUsername = "root";
	            String dbPassword = "root";

	            // Load the JDBC driver
	            Class.forName("com.mysql.cj.jdbc.Driver");

	            // Establish the database connection
	            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

	            // SQL query to select customer data
	            String sql = "SELECT * FROM customer";
	            stmt = conn.prepareStatement(sql);

	            // Execute the query
	            rs = stmt.executeQuery();

	            // Process the result set
	            while (rs.next()) {
	                Customer customer = new Customer();
	                customer.setUuid(rs.getString("uuid"));
	                customer.setFirstName(rs.getString("first_name"));
	                customer.setLastName(rs.getString("last_name"));
	                customer.setStreet(rs.getString("street"));
	                customer.setAddress(rs.getString("address"));
	                customer.setCity(rs.getString("city"));
	                customer.setState(rs.getString("state"));
	                customer.setEmail(rs.getString("email"));
	                customer.setPhone(rs.getString("phone"));

	                // Add the customer to the list
	                customerList.add(customer);
	            }
	        } catch (ClassNotFoundException | SQLException e) {
	            e.printStackTrace(); // Handle the exception as needed
	        } finally {
	            try {
	                // Close the database resources
	                if (rs != null) {
	                    rs.close();
	                }
	                if (stmt != null) {
	                    stmt.close();
	                }
	                if (conn != null) {
	                    conn.close();
	                }
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }

	        return customerList;
	    }
	public String extractAccessToken(String jsonString) {
	    System.out.println("JSON Response: " + jsonString); // Print JSON for debugging

	    String tokenKey = "\"access_token\":\"";
	    int startIndex = jsonString.indexOf(tokenKey);
	    if (startIndex != -1) {
	        int endIndex = jsonString.indexOf("\"", startIndex + tokenKey.length());
	        if (endIndex != -1) {
	            String token = jsonString.substring(startIndex + tokenKey.length(), endIndex);
	            System.out.println("Extracted Token: " + token); // Print extracted token for debugging
	            return token;
	        }
	    }
	    return null;
	}

}
