<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>ProductOrder</title>
</head>
</body>

<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.util.*"%>


<%
	if(session.getAttribute("name")!=null || session.getAttribute("name") == null) {
%>


<div style="width:80%; position:center; ">

		<h3>Hi, <%= session.getAttribute( "name") %>Your Current Shopping Cart</h3>



</div>



<div style="width:20%; position:absolute; top:15%; left:0px; height:75%%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="buyShoppingCart.jsp" target="_self"> Shopping Cart</a></td></tr>
		<tr><td><a href="products_browsing.jsp" target="_self">Browse Products</a></td></tr>
	</table>	
</div>


<div style="width:79%; position:absolute; top:15%; right:0px; height:75%;">


<% 

Connection conn=null;
Statement stmt;
String SQL=null;
	try{Class.forName("org.postgresql.Driver");
	System.out.println("we good");
	
	
	}catch(Exception e){System.out.println("Driver Error, cannot connect. ");}
	
	
	String url="jdbc:postgresql://localhost/cse135";
    String user="postgres";
    String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	ResultSet rs=null;
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
	int amount=0; int productPrice=0; int productTotalPrice=0, totalCartPrice=0;
	
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
		<h3>The total price of your current shopping cart is $<%=totalCartPrice%></h3>
	</div>



</div>


<div style="width:79%; position:absolute; top:95%; right:0px; id;">
<%

int productID = 5; 

	rs=stmt.executeQuery("SELECT * FROM products where id="+productID+";");
	productName="";
	productPrice=0;
	if(rs.next())
	{
		productName=rs.getString(3);
		productPrice=rs.getInt(5);
	}

int prices = 10;
int val = 4;
%>
<form action="submitProductOrder.jsp" method="post">
<table width="70%"  border="1px" align="center">
	<input type="text" style="display:none" id="prodid" name="prodid" value="<%=productID%>">
	<input type="text" style="display:none" name="name" id="name" value="<%=productName%>">
	<input type="text" style="display:none" name="price" id="price" value="<%=productPrice%>">
	<tr align="center">
		<td width="20%"><B>Product:</B></td>
		<td align='left'><input type="text"  disabled="disabled" value="<%=productName%>"></td>
	</tr>
	<tr align="center">
		<td width="20%"><B>Price:</B></td>
		<td align='left'><input type="text" disabled="disabled" value="<%=productPrice%>"></td>
	</tr>
	<tr align="center">
		<td width="20%"><B>Amount:</B></td>
		<td align='left'><input type="text" name="amount" id="amount" value="1"></td>
	</tr>
	<tr align="center">
		<td colspan="2"><input type="submit" value="Add to Cart"></td>
	</tr>
	
</table>
</form>

</div>

<%
	} else {
		out.println("You must log in. <br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the login page and try again.</i></a></font><br>");
	}

%>

</body>
</html>