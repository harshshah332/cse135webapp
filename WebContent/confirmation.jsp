<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Confirmation</title>
</head>
<body>

<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.util.*"%>

<%
String name = null;
name = (String)session.getAttribute("name");  //get the role of the logged in user
if(name!=null ) {
%>

	
	<div style="width:79%; position:absolute; top:0%; right:10%; height:10%;">
	
			<h3>Hi, <% (String)session.getAttribute( "name") %>! Here is your Purchase Confirmation</h3>
	</div>
	
	
	
	
	<div style="width:20%; position:absolute; top:15%; left:0px; height:75%%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
		<table width="100%">
			<tr><td><a href="products_browsing.jsp" target="_self">Browse Products</a></td></tr>
	<!-- 		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr> -->
		</table>	
	</div>
	
	
	<div style="width:79%; position:absolute; top:15%; right:0px; height:75%;">



<% 

	Connection conn=null;
	Statement stmt;
	String SQL=null;
	try{ Class.forName("org.postgresql.Driver"); System.out.println("we good");}
	catch(Exception e){System.out.println("Driver fddg");}
	
	String cardString = null; 
    int cardNumber = 0;
	int userID = (Integer)session.getAttribute( "userID"); //get the userID of the logged in user
	ResultSet rs;
	PreparedStatement prep; 
	try { cardString = request.getParameter("card"); } catch(Exception e){cardString=null;}
	try {
		cardNumber =  Integer.parseInt(cardString);
	
		if (cardNumber > 0) {

			try {
				System.out.println("1");
				String url="jdbc:postgresql://localhost/cse135";
			    String user="postgres";
			    String password="postgres";
				conn =DriverManager.getConnection(url, user, password);
				stmt =conn.createStatement();
			



				SQL="select p.name, c.amount, p.price, c.prodid from products p, users u, carts c where c.userid=u.id and c.prodid=p.id and c.userid="+userID;
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
				int amount=0; int productPrice=0; int productTotalPrice=0, totalCartPrice=0, productID = 0;
				String insertPurchase = "INSERT INTO purchases (userid, prodid, amount, price, date) VALUES ("+userID+", ?, ?, ?, ?)"; 
			
				while(rs.next())
				{
					 productName=rs.getString(1);
					 amount=rs.getInt(2);
					 productID = rs.getInt("prodid");
					 productPrice=rs.getInt(3);
					 productTotalPrice=amount*productPrice;
					 totalCartPrice+=productTotalPrice;
					 		
					 prep = conn.prepareStatement(insertPurchase);
					
					 prep.setInt(1, rs.getInt("prodid"));
					 
					 prep.setInt(2, amount);
					 prep.setInt(3, productPrice);
					
					/*
					 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");      
    				 Date dateWithoutTime = sdf.parse(sdf.format(new Date()));    				 
					 prep.setInt(4, dateWithoutTime.toString());
					 */


					 System.out.println("rs is  " + rs.getInt("prodid"));
					
				
					try{
					 prep = conn.prepareStatement(insertPurchase);
					 prep.setInt(1, rs.getInt("prodid"));
					 prep.setInt(2, amount);
					 prep.setInt(3, productPrice);
					 prep.setString(4, "55");
					 prep.executeUpdate();
		    		}
									
					catch(Exception e)
					{
						out.println("An internal error has occured.<br><a href=\"buyShoppingCart.jsp\" target=\"_self\"><i>Please go back to your shopping cart.</i></a><br>");
					}
					 
					 
					 
					 
%>		 

					<tr align=\"center\">
						<td width=\"30%\"><B><%=productName%></B></td>
						<td width=\"25%\"><B>$<%=productPrice%></B></td>
						<td width=\"25%\"><B><%=amount%></B></td>
						<td width=\"20%\"><B>$<%=productTotalPrice%></B></td>
	
	
					</tr>

<%
				
%>

					</table>
	
	
<%
				}

					SQL="delete from carts where userid ="+userID;
					stmt.executeUpdate(SQL);
%>


	
	
					<div style="width:80%; position:center; ">
						<h3>The total amount for your order is $<%=totalCartPrice%>. Thank you for shopping with us.</h3>
					</div>
<%
				
			}
			catch(Exception e) {
				out.println("An internal error has occured.<br><a href=\"buyShoppingCart.jsp\" target=\"_self\"><i>Please go back to your shopping cart.</i></a><br>");
			}

		}

		else {
			out.println("Error. Please enter  a valid credit card numnber.  <br> Please <a href=\"buyShoppingCart.jsp\" target=\"_self\">try again. </a>");
		}
	}

	catch(Exception e) 
	{ 
		out.println("Error. Please enter  a valid credit card numnber.  <br> Please <a href=\"buyShoppingCart.jsp\" target=\"_self\">try again. </a>");
	}


} //if else from the top

else {
		out.println("You must log in. <br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the login page and try again.</i></a></font><br>");
}

%>
	
	
</div>




</body>
</html>