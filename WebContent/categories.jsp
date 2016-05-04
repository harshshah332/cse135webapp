<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Categories</title>
</head>
<body>

<%@ page language = "java" import = "java.sql.*" %>
<%@ page language = "java" import = "java.util.*" %>


      <a href="products.jsp" >Products</a> <br>
      <a href = "productsBrowsing.jsp"> Products Browsing</a> <br>
      <a href="productOrder.jsp" >Product Order</a> <br>
      <a href = "buyShoppingCart.jsp">Buy Shopping Cart</a><br>
      <a href = "home.jsp">HomePage</a><br>
      <br>
      
 <div style="width:80%; position:center; ">
		<h3>Hi, <%= session.getAttribute( "name") %>.</h3>
</div>
      
 <form action = "categories.jsp" method = "POST" >
<input type = "text" placeholder = "Product Category Name" name = "cname">
<input type = "text" placeholder = "Category Description"  name = "cdesc">
<input type="submit" name = "insert" class="btn btn-default" value="Insert">
<br> 
</form> 
<br>


<% 
String catName = null;
String catDesc = null;
if(request.getParameter("insert")!= null) {
 catName = request.getParameter("cname").trim().toLowerCase();
 catDesc = request.getParameter("cdesc").trim().toLowerCase();
}
	if(catName == "" || catDesc == "")
	{
		%>
		<h4> Please Don't input empty fields </h4>
			   <form action = "categories.jsp">
			   <input type="submit" class="btn btn-default" value="Try Again">
			   </form>
		<%
	}
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
		
		
		%>
		<table border = "2">
		<tr>
		    <td> ID </td>
			<td>CATEGORY NAME</td>
			<td>DESCRIPTION</td>
			
	   </tr>
	   
		<%
		SQL = "SELECT * from categories";
		stmt = conn.createStatement();
	    rs =stmt.executeQuery(SQL);
	  
	    while(rs.next()){
	  
	    	
	    	%>
	    	<%
	    	if(request.getParameter("delete_cat"+ rs.getString("name"))!= null){
		    	SQL = "DELETE FROM categories WHERE name = ?";
		    	pstmt = conn.prepareStatement(SQL);
		    	pstmt.setString(1, rs.getString("name"));
		    	pstmt.executeUpdate();
		    }
	    	
	    	if(request.getParameter("update_name"+ rs.getString("name"))!= null){
	    		String name = request.getParameter("upname" +rs.getString("name")).trim();
	    		if(!name.isEmpty()){
		    	SQL = "UPDATE categories SET name = ? WHERE name = ?";
		    	pstmt = conn.prepareStatement(SQL);
		    	pstmt.setString(1, name);
		    	pstmt.setString(2, rs.getString("name"));
		    	pstmt.executeUpdate();
	    		}
		    
		    }
	    	if(request.getParameter("update_desc"+ rs.getString("description"))!= null){
	    		String description = request.getParameter("updesc" +rs.getString("description")).trim();
	    		  if(!description.isEmpty()){
	    			
	    		  
		    	SQL = "UPDATE categories SET description = ? WHERE description = ?";
		    	pstmt = conn.prepareStatement(SQL);
		    	pstmt.setString(1, description);
		    	pstmt.setString(2, rs.getString("description"));
		    	pstmt.executeUpdate();
	    		  }
	    	}
	    	%>
	   <tr>
	   <td> <%=rs.getInt("id") %> </td>
	   <td><%=rs.getString("name") %></td>
       <td><%=rs.getString("description") %></td>
       <td>
        <form method="post">
        <input type="submit" name="delete_cat<%=rs.getString("name") %>" value="Delete" />
        </form>
       </td>
       <td>
        <form method="post">
        <input type = "text" name = "upname<%=rs.getString("name") %>" />
        <input type="submit" name="update_name<%=rs.getString("name") %>" value="Update Name" />
        </form>
       </td>
       <td>
        <form method="post">
        <input type = "text" name = "updesc<%=rs.getString("description") %>" />
        <input type="submit" name="update_desc<%=rs.getString("description") %>" value="Update Description" />
        </form>
       </td>
        
        </tr>
       
	    	<%
	    	
	    }
	    
	    
			
     %>
        </table>
     <%
      if(catName != "" && catDesc != "") {
 		stmt = conn.createStatement();
		SQL = "INSERT INTO categories (name, description) VALUES(?,?)";
		pstmt = conn.prepareStatement(SQL);
		pstmt.setString(1, catName);
		pstmt.setString(2, catDesc);
		pstmt.executeUpdate();
		
      }
        String username = null;
        stmt = conn.createStatement();
		SQL = "SELECT * FROM categories WHERE name=?";
		pstmt = conn.prepareStatement(SQL);
		pstmt.setString(1, catName);
		rs=pstmt.executeQuery();
		

		while(rs.next()){
			
			 username = rs.getString("name");
			 
		}
		if(catName.equals(username)){
	 
	%>
	   <form action = "categories.jsp">
	   <h4>Category Name already exists, please enter different one </h4>
	   </form>
	
	 <%	
	 
		}
     rs.close();
     stmt.close();
     conn.close();

	} catch (SQLException e) {

		System.out.println("Connection Failed! Check output console");
		e.printStackTrace();
		return;

	}

	if (conn != null) {
		System.out.println("You made it, take control your database now!");
	} 

	
	

  %>
  
     


</body>
</html>
