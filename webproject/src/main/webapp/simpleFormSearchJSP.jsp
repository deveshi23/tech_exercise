<%@ page language="java" import="java.sql.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Simple DB Connection</title>
</head>
<body>
	<h1 align="center"> Database Result (JSP) </h1>
	<%!String keywordDesc;%>
	
	<%keywordDesc = request.getParameter("keywordDesc");%>
	
	<%=runMySQL()%>

	<%!String runMySQL() throws SQLException {
		System.out.println("[DBG] User entered keyword Description: " + keywordDesc);
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("Where is your MySQL JDBC Driver?");
			e.printStackTrace();
			return null;
		}

		System.out.println("MySQL JDBC Driver Registered!");
		Connection connection = null;

		try {
			connection = DriverManager.getConnection("jdbc:mysql://ec2-18-218-38-2.us-east-2.compute.amazonaws.com:3306/myDB?useSSL=false", "techex", "password");
			
		} catch (SQLException e) {
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return null;
		}

		if (connection != null) {
			System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}

		PreparedStatement query = null;
		StringBuilder sb = new StringBuilder();

		try {
			connection.setAutoCommit(false);

			if (keywordDesc.isEmpty()) {
				String selectSQL = "SELECT * FROM myTB";
				query = connection.prepareStatement(selectSQL);
			} else {
				String selectSQL = "SELECT * FROM myTB WHERE MYSTUFF LIKE ?";
				String theDesc = keywordDesc + "%";
				query = connection.prepareStatement(selectSQL);
				query.setString(1, theDesc);
			}
			
			ResultSet rs = query.executeQuery();
			while (rs.next()) {
				int id = rs.getInt("id");
				String userTask = rs.getString("mystuff").trim();
				

				// Display values to console.
				System.out.println("ID: " + id + ", ");
				System.out.println("Desccription: " + userTask + ", ");
				
				// Display values to webpage.
				sb.append("ID: " + id + ", ");
				sb.append("User: " + userTask + "; ");
				
			}
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}%>

	<a href=/webproject/simpleFormSearchJSP.html>Search Data</a> <br>
</body>
</html>