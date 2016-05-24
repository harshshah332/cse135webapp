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


<% 
String rows= ""; 
String order= ""; 
String state = "";
	
long   query1Start, query1Finish, query2Start, query2Finish, query3Start, query3Finish, query4Start, query4Finish;
double query1Time, query2Time, query3Time, query4Time;





	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs, r1, r2, r3, r4 = null;
	String SQL = null; 
	Statement stmt = null;
 	String row_offset = "";
 	String col_offset = "";
	try {
		Class.forName("org.postgresql.Driver");
		String url="jdbc:postgresql://localhost/cse135";
	    String user="postgres";
	    String password="postgres";
		conn =DriverManager.getConnection(url, user, password);
    System.out.println("GOOD DRIVER");
 
		    rows = request.getParameter("rows");
		    if(rows == null ){
		    	rows = "customer";
		    }
		    System.out.println("rows is " + rows);
		   
		    order = request.getParameter("order");
		    if(order == null){
		    	order = "alphabetical_order";
		    }
		    System.out.println("order is " + order);
		    
		    state = request.getParameter("filter");
		    if(state == null){
		    	state = "all_filter";
		    }
		    System.out.println("filter is " + state);
		    String sql, sql1, sql2, sql3 = "";
		     
		     
		    
		 	//r_offset and next_r_offset session variable
		 	if(request.getParameter("row_offset") != null && request.getParameter("row_offset").equals("0") == false)
		 	{
		 		row_offset = String.valueOf(Integer.valueOf(request.getParameter("row_offset")));
		 	}
		 	else
		 	{
		 		row_offset = "0";
		 	}
		 	//System.out.println("r_offset: " + r_offset);
		 	//System.out.println("next_r_offset: " + next_r_offset);
		 	
		 	//c_offset and next_c_offset session variable
		 	if(request.getParameter("col_offset") != null && request.getParameter("col_offset").equals("0") == false)
		 	{
		 		col_offset = String.valueOf(Integer.valueOf(request.getParameter("col_offset")));
		 	}
		 	else
		 	{
		 		col_offset = "0";
		 	}
		 	
		 	//System.out.println("c_offset: " + c_offset);
		 	//System.out.println("next_c_offset: " + next_c_offset);
		     
		
       %>
       
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
  	<% 
  	if(rows.equals("state")){ %>
 	 	<option value="customer">Customer</option>
  		<option value="state" selected >State</option> <%
	}
	else{ %>
 		<option value="customer" selected>Customer</option>
  		<option value="state" >State</option> <%
	} %>
			
	</select>
	
	<div class="form-group">
  	<label for="order">Order</label>
  	<select name="order" id="order" class="form-control">
  	
  	  	<% 
  	if(order.equals("alphabetical_order")){ %>
	    <option value="alphabetical_order" selected>Alphabetical</option>
	    <option value="totalorder">Total k</option> <%
	}
	else{ %>
	    <option value="alphabetical_order">Alphabetical</option>
	    <option value="totalorder" selected>Total k</option> <%
	} %>

	</select>

<%
	sql = "Select name, id from categories";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(sql);
%>
	
	    <div class="form-group">
  	<label for="filter">Filter</label>
  	<select name="filter" id="filter" class="form-control">
  		    <option value="all_filter" selected>All</option>

<%
	while (rs.next()){
		if(rs.getString(2).equals(state)){
%>
			<option value=  <%=rs.getString(2) %> selected> <%=rs.getString(1) %>    </option>	
<% 	
		}
		else { %>
			<option value=  <%=rs.getString(2) %> > <%=rs.getString(1) %>    </option>	<% 
		}
	}
%>

	</select>
	
	
  </div>

    <div class="form-group">
  	<input class="btn btn-primary" type="submit" value="Generate Data">
  </div>
  
</form>
       
       <table border = "2">
    
       <% 
    
       
      
       
      //query for row headers
 	if(rows.equals("customer") || rows.equals(null)){
 		
 		if(order.equals("alphabetical_order") || order.equals(null) ){
 			
 			sql1 = "SELECT users.id, users.name, COALESCE (SUM(o.price), 0) AS amount" + 
 					   " FROM (SELECT name, id FROM users ORDER BY name ASC OFFSET "+row_offset+" )" +
 					   " AS users LEFT JOIN orders o" +  
 					   " ON (o.user_id = users.id)" + 
 					   " GROUP BY users.id, users.name" +
 					   " ORDER BY users.name asc"		;
 			
 		}
 		
 		else{  //order by top K
 			
 			sql1 = "SELECT users.id, users.name, COALESCE (SUM(o.price), 0) AS amount" + 
					   " FROM (SELECT name, id FROM users ORDER BY name ASC OFFSET "+row_offset+" )" +
					   " AS users LEFT JOIN orders o" +  
					   " ON (o.user_id = users.id)" + 
					   " GROUP BY users.id, users.name" +
					   " order by COALESCE (SUM(o.price), 0)  desc"		;		
 		}
 	
 	}
 	
 	else{ //states for rows, not customers
 		
 		if(order.equals("alphabetical_order") || order.equals(null) ){
 			System.out.println("here state query ");
 			sql1 = "SELECT state from users ORDER BY state ASC OFFSET "+row_offset+"" ;
 		}
 		
 		else{  //order by top K
 			
 			sql1 = "SELECT state.state, COALESCE (SUM(o.price), 0) AS amount" + 
					   " FROM (SELECT state, id FROM users ORDER BY state ASC OFFSET "+row_offset+")" +
					   " AS state LEFT JOIN orders o" +  
					   " ON (o.user_id = state.id)" + 
					   " GROUP BY state.state" + 
					   " order by COALESCE (SUM(o.price), 0)  desc"		;	
 			
 		}
 	
 	} //end of row header query
       
       
       
    //query for product headers - alphabetical_order
    if(order.equals("alphabetical_order") || order.equals(null) ){
    	
    	
 		if(state.equals("all_filter") || state.equals(null) ){
 	        sql2 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
 	    			" FROM (SELECT id, name FROM products ORDER BY name ASC LIMIT 10  OFFSET "+col_offset+ ") AS prod" +
 	    			" LEFT JOIN orders ON (orders.product_id = prod.id)" +
 	    			" GROUP BY prod.id, prod.name" +
 	    			" order by prod.name asc";
 		}
 		else{
 			
 			//filter present
 	        sql2 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
 	    			" FROM (SELECT id, name FROM products where products.category_id = " +state+ 
 	        		" ORDER BY name ASC LIMIT 10 OFFSET "+col_offset+ ") AS prod" +
 	    			" LEFT JOIN orders ON (orders.product_id = prod.id)" +
 	    			" GROUP BY prod.id, prod.name" +
 	    			" order by prod.name asc";			
 		}   	
    }
 	
 	//query for product headers - top k
    else{
    	
    	
 		if(state.equals("all_filter") || state.equals(null) ){
 	        sql2 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
 	    			" FROM (SELECT id, name FROM products ORDER BY name ASC LIMIT 10 OFFSET "+col_offset+ ") AS prod" +
 	    			" LEFT JOIN orders ON (orders.product_id = prod.id)" +
 	    			" GROUP BY prod.id, prod.name" +
 	    			" order by COALESCE (SUM(orders.price), 0) desc";
 		}
 		else{
 			
 			//filter present
 	        sql2 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
 	    			" FROM (SELECT id, name FROM products where products.category_id = " +state+ 
 	        		" ORDER BY name ASC LIMIT 10 OFFSET "+col_offset+ ") AS prod" +
 	    			" LEFT JOIN orders ON (orders.product_id = prod.id)" +
 	    			" GROUP BY prod.id, prod.name" +
 	    			" order by COALESCE (SUM(orders.price), 0) desc ";			
 		} 
    }

 	/*
 	try{
 	stmt = conn.createStatement();
    r1 = stmt.executeQuery(sql1);
 	}
 	catch(Exception e){
 		System.out.println("here");
 	}

    try{
 	stmt = conn.createStatement();
   	r2 = stmt.executeQuery(sql2);
    }
    
    catch(Exception e){
 		System.out.println("here2");
 	} */

    
    query1Start = System.nanoTime();
 	stmt = conn.createStatement();
    r1 = stmt.executeQuery(sql1);
 	query1Finish = System.nanoTime();
 	
 	query1Time = (query1Finish - query1Start) / 1000000.0;
 	System.out.println("Query 1 time = " + query1Time);

 	
    query2Start = System.nanoTime();
    stmt = conn.createStatement();
    r2 = stmt.executeQuery(sql2);
    query2Finish = System.nanoTime();
 	
 	query2Time = (query2Finish - query2Start) / 1000000.0;
 	System.out.println("Query 2 time = " + query2Time);
    
    
    
   	   %> <tr> <td> nothing </td>
   	   
 <%   	    //loop for product headers
 	while(r2.next()){      %>
 			  
 		<td width=\"30%\" > <%=r2.getString("name") %> </td>
 			 
 			   
 	<% 	     	
     }
   	%> </tr> <% //end of product headers

   	
   	
 		   //loop through the users or states
 		   
 	
	while(r1.next()){
    	    	//query for row data
    	  //  	System.out.println(r1.getString(state) + " is state");
    	    			
    String rowName = "";    			
  
    	//System.out.println("here");
       	if(rows.equals("customer") || rows.equals(null)){
       		rowName = r1.getString(2);

       		if(order.equals("alphabetical_order") || order.equals(null)){
       		
	       		if(state.equals("all_filter") || state.equals(null) ){
			//		System.out.println("all no filter");
		    	    sql3 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
		   					" FROM (SELECT id, name FROM products LIMIT 10 OFFSET "+col_offset+ " ) AS prod" + 
		   					" LEFT JOIN orders ON (orders.product_id = prod.id and orders.user_id =" +Integer.toString(r1.getInt("id"))+ ")" +  
		   					" GROUP BY prod.id, prod.name" + 
		   					" order by prod.name asc";	
	       		}
	       		
	       		else { //category filter
			//		System.out.println("all cat filter");
		    	    sql3 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
		   					" FROM (SELECT id, name FROM products WHERE products.category_id = " +state+  " LIMIT 10 OFFSET "+col_offset+ ") AS prod" + 
		   					" LEFT JOIN orders ON (orders.product_id = prod.id and orders.user_id =" +Integer.toString(r1.getInt("id"))+ ")" +  
		   					" GROUP BY prod.id, prod.name" + 
		   					" order by prod.name asc";	
	       		}
       		}
       		
       		
       		
       		else{  //order by top k
       			System.out.println("before if");
	       		if(state.equals("all_filter") || state.equals(null) ){
	       			System.out.println("in first if");
			//		System.out.println("top k all filter");
		    	    sql3 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
		   					" FROM (SELECT id, name FROM products LIMIT 10 OFFSET "+col_offset+ ") AS prod" + 
		   					" LEFT JOIN orders ON (orders.product_id = prod.id and orders.user_id =" +Integer.toString(r1.getInt("id"))+ ")" +  
		   					" GROUP BY prod.id, prod.name" + 
		   					" order by COALESCE (SUM(orders.price), 0)  DESC ";	
	       		}
       		
	       		
	       		else { //category filter
	       			System.out.println("in else");
				//	System.out.println("top k cat filter");
		    	    sql3 = "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" + 
		   					" FROM (SELECT id, name FROM products WHERE products.category_id = " +state+  " LIMIT 10 OFFSET "+col_offset+ ") AS prod" + 
		   					" LEFT JOIN orders ON (orders.product_id = prod.id and orders.user_id =" +Integer.toString(r1.getInt("id"))+ ")" +  
		   					" GROUP BY prod.id, prod.name" + 
		   					" order by COALESCE (SUM(orders.price), 0) DESC	";	
	       		}
       		}  
       			
       	} //end of if in while
       	 
       	else{
       		System.out.println("STATES");
       		rowName = r1.getString(1);
 	    	String st = r1.getString(1); 
 	    	System.out.println(st);

       		if(order.equals("alphabetical_order") || order.equals(null)){
          
	       		if(state.equals("all_filter") || state.equals(null) ){
			//		System.out.println("all no filter");
 	    	
		 	    	sql3 =   "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" +
		 					" FROM (SELECT id, name FROM products LIMIT 10 OFFSET "+col_offset+ ") AS prod " +
		 					" LEFT JOIN orders ON (orders.product_id = prod.id " +
		 					" and orders.user_id in (select id from users where state = '" +rowName+  "' ) )" +
		 					" GROUP BY prod.id, prod.name " +
		 					" order by prod.name asc" ;	
		 	    	}
	       		
	       		else{
	       			
		 	    	sql3 =   "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" +
		 					" FROM (SELECT id, name FROM products WHERE products.category_id = " +state+  " LIMIT 10 OFFSET "+col_offset+ ") AS prod " +
		 					" LEFT JOIN orders ON (orders.product_id = prod.id " +
		 					" and orders.user_id in (select id from users where state = '" +rowName+  "' ) )" +
		 					" GROUP BY prod.id, prod.name " +
		 					" order by prod.name asc" ;	
	       		}
	       	}
       		
       		else{
                //top K
	       		if(state.equals("all_filter") || state.equals(null) ){
			//		System.out.println("all no filter");
 	    		//states top k no filter
		 	    	sql3 =   "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" +
		 					" FROM (SELECT id, name FROM products LIMIT 10 OFFSET "+col_offset+ ") AS prod " +
		 					" LEFT JOIN orders ON (orders.product_id = prod.id " +
		 					" and orders.user_id in (select id from users where state = '" +rowName+  "' ) )" +
		 					" GROUP BY prod.id, prod.name " +
		 					" order by COALESCE (SUM(orders.price), 0)  DESC" ;	
		 	    	}
	       		
	       		else{ //states top k cat filter 
	       			
		 	    	sql3 =   "SELECT prod.id, prod.name, COALESCE (SUM(orders.price), 0) AS amount" +
		 					" FROM (SELECT id, name FROM products WHERE products.category_id = " +state+  " LIMIT 10 OFFSET "+col_offset+ ") AS prod " +
		 					" LEFT JOIN orders ON (orders.product_id = prod.id " +
		 					" and orders.user_id in (select id from users where state = '" +rowName+  "' ) )" +
		 					" GROUP BY prod.id, prod.name " +
		 					" order by COALESCE (SUM(orders.price), 0)  DESC" ;	
	       		}
	       	}

       	} // end of if else for row data
       		

       		
       	//	System.out.println(sql3); 
       		//System.out.println("DSf"); 
	
    	   r3 = null;			
   		   
   		   stmt = conn.createStatement();
			try{
   		 	query3Start = System.nanoTime();
			stmt = conn.createStatement();
			r3 = stmt.executeQuery(sql3);
   		 	query3Finish = System.nanoTime();
   		 	
   		 	query3Time = (query3Finish - query3Start) / 1000000.0;
   		 	System.out.println("Query 3 time = " + query3Time);

   		   }
   		   catch(Exception e){
   			System.out.println("bad result set");
   		   }
   		   
   	//	System.out.println("befpre r3 while");
   		 %>
   		<tr> <td><%= rowName %> </td> 
   		<% 
   		//loop for row data
			while(r3.next()){
    		//	System.out.println("in r3 while");  %>
    	   		<td width=\"30%\" >  <%= r3.getInt("amount") %> </td> 
    	    	   
   <%		} //end of nested while
   			%> </tr>  <% 
   		
   		
   		
	} //end of first while
  	    

     %>
     
     
     <tr><td colspan="1">
     <% 
		int row_offset_updated = Integer.valueOf(row_offset) + 20;
     %>
	   	<form action="salesAnalytics.jsp" method="POST">
			<div class="form-group">
				<input type ="hidden" name=rows value="<%=rows%>">
				<input type ="hidden" name=filter value="<%=state%>">
				<input type ="hidden" name=order value="<%=order%>">
				<input type ="hidden" name=row_offset value="<%=row_offset_updated%>">
				<input type ="hidden" name=col_offset value="<%=col_offset%>">

			</div> <% 
			if(rows.equals("state")){ %>
				<button type="submit" class="btn btn-primary">Next 20 states</button> <%
			}
			else{ %>
				<button type="submit" class="btn btn-primary">Next 20 customers</button> <%
			}
			
			%>
			
		</form>
		</td>
		<td colspan="20">
		</td></tr>
     
     
          <tr><td colspan="1">
     <% 
		int col_offset_updated = Integer.valueOf(col_offset) + 10;
     %>
	   	<form action="salesAnalytics.jsp" method="POST">
			<div class="form-group">
				<input type ="hidden" name=rows value="<%=rows%>">
				<input type ="hidden" name=filter value="<%=state%>">
				<input type ="hidden" name=order value="<%=order%>">
				<input type ="hidden" name=row_offset value="<%=row_offset%>">
				<input type ="hidden" name=col_offset value="<%=col_offset_updated%>">

			</div>
			<button type="submit" class="btn btn-primary">Next 10 Products</button>
		</form>
		</td>
		<td colspan="20">
		</td></tr>
     
     
     
     
     </table>
     <% 
    	 
	}
	 catch (Exception e) {
		 System.out.println(e);
	 }  

       
		
	if(rows == null || rows.trim() == ""){
		rows = "customer";		
	}
       stmt.close();
       conn.close();
		

%>



</body>
</html>
