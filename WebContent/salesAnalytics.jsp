<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<title>CSE135 Project</title>
</head>
<form action="salesAnalytics.jsp" method="post">

<body>
<div class="collapse navbar-collapse">
	<ul class="nav navbar-nav">
		<li><a href="login.jsp">LOGIN</a></li>
		<li><a href="signup.jsp">SIGN UP</a></li>
	</ul>
</div>
<div>


  
    <div class="form-group">
  	<label for="rows">Rows</label>
  	<select name="rows" id="rows" class="form-control">
	    <option value="customer">Customer</option>
	    <option value="state">State</option>
	</select>
	
	    <div class="form-group">
  	<label for="order">Order</label>
  	<select name="order" id="order" class="form-control">
	    <option value="alphabetical_order">Alphabetical</option>
	    <option value="totalorder">Total k</option>
	</select>
	
	
	    <div class="form-group">
  	<label for="filter">Filter</label>
  	<select name="filter" id="filter" class="form-control">
	    <option value="all_filter">All</option>
	    <option value="customer_filter">Customer</option>
	</select>
	
	
  </div>

    <div class="form-group">
  	<input class="btn btn-primary" type="submit" value="Generate Data">
  </div>
  
</form>

<% 

String rows= ""; 
String order= ""; 
String state = "";

	

	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs, r1, r2, r3, r4 = null;
	String SQL = null; 
	Statement stmt = null;
	try {
		Class.forName("org.postgresql.Driver");
    String url = "jdbc:postgresql://localhost/Momo";
    String admin = "Momo";
    String password = "";
    conn = DriverManager.getConnection(url, admin, password);
    System.out.println("GOOD DRIVER");

 
		    rows = request.getParameter("rows");
		    order = request.getParameter("order");
		     state = request.getParameter("filter");
		     
		
       %>
       <table border = "2">
       <tr> XXXX </tr>
       <% 
      if(rows.equals("customer") && order.equals("alphabetical_order")){
    	  if(state.equals("all_filter")){
    	    String sql = "SELECT users.id, users.name, COALESCE (SUM(o.price), 0) AS amount" + 
				   " FROM (SELECT name, id FROM users)" +
				   " AS users LEFT JOIN orders o" +  
				   " ON (o.user_id = users.id)" + 
				   " GROUP BY users.id, users.name" +
				   " ORDER BY users.name asc"		;
    	    stmt = conn.createStatement();
    	    rs = stmt.executeQuery(sql);
    	    	
    	   
    	    while(rs.next()){
	    	 
    	     String sql3 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
   					" FROM (SELECT id, name FROM products) AS prod" + 
   					" LEFT JOIN orders ON (orders.product_id = prod.id and orders.user_id =" +Integer.toString(rs.getInt("id"))+ ")" +  
   					" GROUP BY prod.id, prod.name" + 
   					" order by prod.name asc";	
   		   
   		   stmt = conn.createStatement();
   		   r2 = stmt.executeQuery(sql3);
   		   
    	       while(r2.next()){
    	    	   %>
    	    	   <tr><td><%=rs.getString("name") %> 
    	    	   </td>
    	    	   <td>  <%= r2.getInt("amount") %> </td> </tr>
    	    	   <% 
    	       }
    	    }
    	    
    	    String sql2 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
    				" FROM (SELECT id, name FROM products) AS prod" +
    				" LEFT JOIN orders ON (orders.product_id = prod.id)" +
    				" GROUP BY prod.id, prod.name" +
    				" order by prod.name asc";
    	    stmt = conn.createStatement();
    	    r1 = stmt.executeQuery(sql2);
    	   
    	    
  		   while(r1.next()){
  			   %>
  			   <tr> <%=r1.getString("name") %> </tr>
  			   <% 
  		     	
      }
     %>
     </table>
     <% 
    	  }
    	  else if(state.equals("customer_filter")){
    		 %> <table border = "2"> 
    		 <% 
    		 String sql = "SELECT users.id, users.name, COALESCE (SUM(o.price), 0) AS amount" + 
				   " FROM (SELECT name, id FROM users)" +
				   " AS users LEFT JOIN orders o" +  
				   " ON (o.user_id = users.id)" + 
				   " GROUP BY users.id, users.name" +
				   " ORDER BY users.name asc"		;
    	    stmt = conn.createStatement();
    	    rs = stmt.executeQuery(sql);
    	    
    	    %> </table> <% 
    	    }
	
	
	
	}
       
		
	if(rows == null || rows.trim() == ""){
		rows = "customer";		
	}
       stmt.close();
       conn.close();
		
	}

	 catch (Exception e) {}
%>



</body>
</html>

