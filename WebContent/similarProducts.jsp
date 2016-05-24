<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Similar Products Page</title>
</head>


<% 
	Connection conn = null;
	try {
		Class.forName("org.postgresql.Driver");
		String url="jdbc:postgresql://localhost/cse135";
	    String user="postgres";
	    String password="postgres";
		conn =DriverManager.getConnection(url, user, password);
	}
	catch (Exception e) {}
	
	
	Statement stmt = conn.createStatement();

	ResultSet rs = null;  
	ArrayList<Integer> productlist = new ArrayList<Integer>();
	ResultSet productSet = stmt.executeQuery("SELECT * from Products");
	
	
	while(productSet.next()) {
		productlist.add(productSet.getInt("id"));		
	}
	
	
%>


<table class="table table-striped">
	<th>Product 1 Name</th>
	<th>Product 2 Name</th>
	<th>Cosine Similarity</th>
<% for(int i=0; i< productlist.size(); i++) { 
	
	
	
	rs = stmt.executeQuery("SELECT COALESCE (SUM(orders.price), 0)  FROM orders where orders.product_id = " + productlist.get(i) );
	int p1TotalSales = rs.getInt(1); 
	
	
	for(int j=0; j< productlist.size(); j++) {

		rs = stmt.executeQuery("SELECT COALESCE (SUM(orders.price), 0) FROM orders where orders.product_id = " + productlist.get(j) );
	
		int p2TotalSales = rs.getInt(1); 
		int numerator = p1TotalSales + p2TotalSales;
		
		
		
		int denom = 
		
	
	
	
	
	
	}

}


%>




	<tr>
		<td><%=rs.getString("product_name")%></td>
		<td><%=rs.getInt("quantity")%></td>
		<td><%=rs.getFloat("price")%></td>
	</tr>
<% } %>
</table>




	
	
	
<body>

</body>
</html>