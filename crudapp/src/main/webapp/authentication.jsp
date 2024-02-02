<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="com.google.gson.JsonObject" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Prepare JSON input for authentication
    JsonObject jsonInput = new JsonObject();
    jsonInput.addProperty("login_id", username);
    jsonInput.addProperty("password", password);

    try {
        // Open connection to authentication API
        URL obj = new URL("https://qa.sunbasedata.com/sunbase/portal/api/assignment_auth.jsp");
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);

        // Send JSON input
        try (OutputStream os = con.getOutputStream()) {
            byte[] input = jsonInput.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Get response code
        int responseCode = con.getResponseCode();
        System.out.println("Authentication Response Code: " + responseCode);

        // Read response data
        try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
            StringBuilder response1 = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response1.append(responseLine.trim());
            }

            // Parse response to extract the token
            JsonObject jsonResponse = new JsonObject();
            String tokenKey = "\"access_token\":\"";
            int startIndex = response1.indexOf(tokenKey);
            if (startIndex != -1) {
                int endIndex = response1.indexOf("\"", startIndex + tokenKey.length());
                if (endIndex != -1) {
                    String token = response1.substring(startIndex + tokenKey.length(), endIndex);
                    jsonResponse.addProperty("token", token);
                    session.setAttribute("token", token);
                }
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse.toString());
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
%>
