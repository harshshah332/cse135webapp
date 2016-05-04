<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New User</title>
</head>
<body>
<%@ page language = "java" import = "java.sql.*" %>
<%@ page language = "java" import = "java.util.*" %>

<% 
    String username = (request.getParameter("username")).trim().toLowerCase();
	String ageString = (request.getParameter("ageint").trim());
    String roleString = (request.getParameter("rolename"));
    String stateString = (request.getParameter("statename"));

    if(username.equals("") || ageString.equals("")){
    	
    
 %>
   
    <h4> Please don't leave any empty fields </h4>
    <form action = "signup.jsp">
    <input type="submit" class="btn btn-default" value="Try Again">
    </form>
<%
    }
else {
	
	Connection conn = null;
	
	Statement stmt = null;
	String SQL = null;
	int userID = -1;  
	ResultSet rs;
	PreparedStatement pstmt = null;
	String user = null;
	try{ 
		Class.forName("org.postgresql.Driver"); System.out.println("Sucessful driver connection");
		}
	catch(ClassNotFoundException e){
		System.out.println("Driver Error has occured");
		 }
	try {

		String url="jdbc:postgresql://localhost/cse135";
	    String postgresUsername="postgres";
	    String password="postgres";
		conn =DriverManager.getConnection(url, postgresUsername, password);
		
		
	    boolean userExist = false;
		stmt = conn.createStatement();
		SQL = "SELECT * FROM users WHERE name=?";
		pstmt = conn.prepareStatement(SQL);
		pstmt.setString(1, username);
		rs=pstmt.executeQuery();
		

		while(rs.next()){
			userExist = true;
			 user = rs.getString("name");
			 
		}
		if(username.equals(user)){
		 %>
		
	<h4> Username already exists, please choose a different one </h4>
    <form action = "signup.jsp">
    <input type="submit" class="btn btn-default" value="Try Again">
    </form>
		
		<% 
			
		}
		else if(userExist == false){
			int age = 0;
	    try{
		  age = Integer.parseInt(ageString);
	    }
	    
	    catch (Exception e){
	    	%>
	    	<h4> Sign up failed, please enter Valid Age</h4>
	    	<form action = "signup.jsp">
    <input type="submit" class="btn btn-default" value="Try Again">
    </form>
	    	<% 
	    	return; 
	    }
	      SQL = "INSERT INTO users (state,age,role,name) VALUES (?,?,?,?)";
	      pstmt = conn.prepareStatement(SQL);
	      pstmt.setString(1,stateString);
	      pstmt.setInt(2,age);
	      pstmt.setString(3,roleString);
	      pstmt.setString(4,username);
	      pstmt.executeUpdate();
	      
	   
			// Close the Statement
			stmt.close();
			// Close the Connection
			conn.close();

	      
	      %>
	      <h4> Successful Sign Up!</h4>
	      <form action = "signup.jsp">
    <input type="submit" class="btn btn-default" value="Create another user">
    </form>
	      <% 
		}
	

	} catch (SQLException e) {

		System.out.println("Connection Failed! Check output console");
		e.printStackTrace();
		return;

	}

	if (conn != null) {
		System.out.println("You made it, take control your database now!");
	} 

	
	
}
	
	
	%>
</body>
</html>