<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<%
if(session.getAttribute("name")!=null || session.getAttribute("name") == null) {
//	int userID  = (Integer)session.getAttribute("userID");
//	String role = (String)session.getAttribute("role");

	int userID = (Integer)session.getAttribute( "userID"); //get the userID of the logged in user
	String role = (String)session.getAttribute("role"); //get the role of the logged in user
	String  productName="", price_saved=null, amount_saved=null, prodid_saved=null;


	int productID=0, amount=0;
	int productPrice=0;
	try {
			productName =	request.getParameter("name"); 
			System.out.println(productName+ "name");

			price_saved		  =	request.getParameter("price"); 
			System.out.println(price_saved+ "price_saved");	

			amount_saved  =	request.getParameter("amount"); 
			System.out.println(amount_saved+ "amount_saved");	

			prodid_saved =	request.getParameter("prodid"); 
			System.out.println(prodid_saved+ "prodid_saved");	

			productPrice    = Integer.parseInt(price_saved.trim());
			System.out.println(productPrice+ "int price");	
 

			productID=Integer.parseInt(prodid_saved);
			System.out.println(productID+ "int prodid");
	
			
	}
	catch(Exception e) 
	{ 
		System.out.println("Unable to parseInt either productID or productPrice");
		productName=null; price_saved=null; amount_saved=null; prodid_saved=null;
	    productID=0; amount=0; productPrice=0;
	
	}
	try { 	
		System.out.println(amount_saved+ " before parse amount");	
		amount=Integer.parseInt(amount_saved.trim());
		System.out.println("0\n");
		if(amount>0)
			{
				System.out.println("Inside if amount>0. ");	
				Connection conn=null;
				Statement stmt;
				try
				{
					try {
						Class.forName("org.postgresql.Driver");
					}
					catch(Exception e){
						System.out.println("Driver error");
					}

					String url="jdbc:postgresql://localhost/cse135";
   				    String user="postgres";
    				String password="postgres";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					System.out.println("Connected to server" );
					int idd = 6;
					String  SQL="INSERT INTO carts ( userid, prodid, amount, price) VALUES( "+userID+", "+productID+", "+amount+","+productPrice+" );";
					
					try{
						conn.setAutoCommit(false);
						stmt.execute(SQL);
						conn.commit();
						conn.setAutoCommit(true);
							System.out.println("3\n");
						response.sendRedirect("buyShoppingCart.jsp");
					}
									
					catch(Exception e)
					{
						out.println("An internal error occured! Pleast try again. <a href=\"productOrder.jsp?id="+productID+"\" target=\"_self\">try again.</a>");
					}
				
					 
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>An internal Error occured!<br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the Home Page and try again.</i></a></font><br>");
						
				}
				finally
				{
				   conn.close();
				}
			} 
			else
			{
			out.println("Error! You must enter a positive integer for the amount. Please try aga Only a postive integer is allowed for the amount. Please <a href=\"productOrder.jsp?id="+productID+"\" target=\"_self\">try</a> again.");
			}
		}
		catch(Exception e) 
		{ 
			out.println("Error,<font color='#ff0000'> the amount should be integer. Please try again. <a href=\"productOrder.jsp?id="+productID+"\" target=\"_self\">Try again</a>");
		
		}

} else {
	out.println("You must log in. <br><a href=\"login.jsp\" target=\"_self\"><i>Please go back to the login page and try again.</i></a></font><br>");
	}
%>

</body>
</html>