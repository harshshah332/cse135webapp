<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Check
</title>
</head>
<body>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.util.*"%>


<% 
	int loginSuceed = 0; 
	String username = (request.getParameter("username")).trim().toLowerCase();
	if (username.length()>0 && username !=null ) {
		
		System.out.println(username);
	
		Connection conn=null;
		Statement stmt;
		String SQL=null;
		int userID = -1;  //set the general error flag int of the userID
		String role = null; //the role of the user, initially set to null 
		String name = null; //the role of the user, initially set to null 
		String age = null; //the age of the user, initially set to null 
		String state = null; //the state of the user, initially set to null 
		ResultSet rs;
		PreparedStatement pstmt = null;
		try{ Class.forName("org.postgresql.Driver"); System.out.println("we good");}
		catch(Exception e){System.out.println("Driver Error has occured");}
		
		try{
			boolean userExist = false;
			System.out.println("1");
			String url="jdbc:postgresql://localhost/cse135";
		    String user="postgres";
		    String password="postgres";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			SQL="select * from users where name=?";
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, username);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
					
				userExist = true;
				userID = rs.getInt("id");		
				role = rs.getString("role");
				name = rs.getString("name");
				state = rs.getString("state");
				age = rs.getString("age");
			}
			
			if (userExist == true){ //set the userID in the session
				session.setAttribute( "userID", userID );
				session.setAttribute( "role", role );
				session.setAttribute( "name", name );
				session.setAttribute( "state", state );
				session.setAttribute( "age", age );
				session.setAttribute( "loginSuceed", 1); 
				response.sendRedirect("productOrder.jsp"); //for testing purposes
				//	response.sendRedirect("home.jsp") //this is the actual line
						
				// Close the connections and statements
				rs.close();
				// Close the Statement
				stmt.close();
				// Close the Connection
				conn.close();

			}
			else {
			//	out.println("No user found with that name. Please retry. ");
				session.setAttribute( "loginSuceed", 2 );
				loginSuceed = 2; 
				//response.sendRedirect("login.jsp"); 
			}
			
 		}
		
		catch(Exception e) {
			out.println(e.getMessage());
		}
		 
	}
	else {
		session.setAttribute( "loginSuceed", 0 );
		loginSuceed = 0;
		
	}
	
	if ( loginSuceed == 0){
		
%>

<h3>An error has occurred. Please try again. </h3>

	<div style="display:block; position:absolute; width: 100%; padding: 10px 12px;  "> 
		<form action="login_check.jsp" method="POST">
			<input type="text" placeholder="Username" name="username">
			<button type="submit" class="btn btn-default">Log In</button>
			<a href="signup.jsp" >Signup as a new user</a>
		</form>
	</div>
<% 		
	}
	
	else {
		
		%>
	<h3>There is no user with that username. Please try again. </h3>
	
		<div style="display:block; position:absolute; width: 100%; padding: 10px 12px;  "> 
			<form action="login_check.jsp" method="POST">
				<input type="text" placeholder="Username" name="username">
				<button type="submit" class="btn btn-default">Log In</button>
				<a href="signup.jsp" >Signup as a new user</a>
			</form>
		</div>
		<% 		
		}
	
%>
</body>
</html>