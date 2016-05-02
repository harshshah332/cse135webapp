<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>BuyShoppingCart</title>
</head>
<body>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" imort="java.util.*"%>

<%
	if(session.getAttribute("name")!=null || session.getAttribute("name") == null) {
%>

<div style="width:80%; position:absolute; top:0%;  ">

		<h3>Hi, <% (String)session.getAttribute( "name") %>! View Your Shopping Cart</h3>

		
		
</div>




<div style="width:20%; position:absolute; top:15%; left:0px; height:75%%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
		<tr><td><a href="products_browsing.jsp" target="_self">Show Products</a></td></tr>

	</table>	
</div>


<div style="width:79%; position:absolute; top:15%; right:0px; height:75%;">


<% 
	
	Connection conn=null;
	ResultSet rs=null;
	Statement stmt = null;
	String SQL=null;
	try { 
		try {
			Class.forName("org.postgresql.Driver");
			System.out.println("we good");
		}
		catch(Exception e) {
			System.out.println("Driver fddg");
		}
	
	
	String url="jdbc:postgresql://localhost/cse135";
    String user="postgres";
    String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	int userID = (Integer)session.getAttribute( "userID"); //get the userID of the logged in user
	SQL="select p.name, c.amount, p.price from products p, users u, carts c where c.userid=u.id and c.prodid=p.id and c.userid="+userID;
	rs=stmt.executeQuery(SQL);

	%>


	<table width=\"80%\"  border=\"2px\" align=\"center\">
	<tr align=\"center\">
		<td width=\"30%\"><B>Product Name</B></td>
		<td width=\"25%\"><B>Price</B></td>
		<td width=\"25%\"><B>Amount</B></td>
		<td width=\"20%\"><B>Amount Price</B></td>


	</tr>


<%
	String productName="";
	int amount=0;
	int productPrice=0, productTotalPrice=0, totalCartPrice=0;
	
	while(rs.next())
	{
		 productName=rs.getString(1);
		 amount=rs.getInt(2);
		 productPrice=rs.getInt(3);
		 productTotalPrice=amount*productPrice;
		 totalCartPrice+=productTotalPrice;

%>		 

	<tr align=\"center\">
		<td width=\"30%\"><B><%=productName%></B></td>
		<td width=\"25%\"><B>$<%=productPrice%></B></td>
		<td width=\"25%\"><B><%=amount%></B></td>
		<td width=\"20%\"><B>$<%=productTotalPrice%></B></td>


	</tr>

<%
	}
%>

	</table>

	<div style="width:80%; position:center; ">
		<h3>The final price of your shopping cart is $<%=totalCartPrice%>. Please confirm this before clicking 'purchase'. </h3>
	</div>

</div>
<div style="width:79%; position:absolute; top:95%; right:10%; height:10%; ">

		<h3>Payment Information</h3>
		<form class="form-horizontal" method="POST" action="confirmation.jsp">
			<input type="hidden" name="conf" value="true">
			<label for="card">Card Number</label>
			<input class="form-control" type="text" name="card" id ="card" placeholder="XXXX-XXXX-XXXX-XXXX">
			<input class="btn btn-primary" type="submit" value="Purchase">
		</form>
</div>

<% 	} 
	
	catch(Exception e)
	{
		out.println("Error has occured.<br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the home page and try again.</i></a></font><br>");
	
	}

	finally
	{
		if (conn != null)
			conn.close();
		if (rs != null)
			rs.close();
		if (stmt != null)
			stmt.close();
	}

	} else {
		out.println("You must log in. <br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the login page and try again.</i></a></font><br>");
		}

%> 


</body>
</html>