<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body >
<%
if(session.getAttribute("name")!=null || session.getAttribute("name") == null)
{
//	int userID  = (Integer)session.getAttribute("userID");
//	String role = (String)session.getAttribute("role");

	int userid  = 1;
	String role = "customer";
	String  name=null, price_saved=null, amount_saved=null, prodid_saved=null;


	int prodid=0, amount=0;
	int price=0;
	try { 
			name =	request.getParameter("name"); 
			price_saved		  =	request.getParameter("price"); 
			amount_saved  =	request.getParameter("amount"); 
			prodid_saved =	request.getParameter("prodid"); 
			 price    = Integer.parseInt(price_saved);
			 prodid=Integer.parseInt(prodid_saved);
			
	}
	catch(Exception e) 
	{ 
		 name=null; price_saved=null; amount_saved=null; prodid_saved=null;
	      prodid=0; amount=0; price=0;
	
	}
	try { 		
		 amount=Integer.parseInt(amount_saved);
		if(amount>0)
			{
				 Connection conn=null;
				Statement stmt;
				try
				{
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			        String url="jdbc:postgresql://localhost/project3";
			        String user="postgres";
			        String password="postgres";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					String  SQL="INSERT INTO carts (userid, prodid, amount, price) VALUES("+userid+", "+prodid+", "+amount+","+price+" );";;
					
					try{
						conn.setAutoCommit(false);
						stmt.execute(SQL);
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("buyShoppingCart.jsp");
					}
					catch(Exception e)
					{
						out.println("Fail! Please <a href=\"productOrder.jsp?id="+prodid+"\" target=\"_self\">buy it</a> again.");
					}
				
					 
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
						
				}
				finally
				{
				   conn.close();
				}
			} 
			else
			{
			out.println("Fail! Only a postive integer is allowed for  <font color='#ff0000'>amount</font><br> Please <a href=\"productOrder.jsp?id="+prodid+"\" target=\"_self\">buy it</a> again.");
			}
		}
		catch(Exception e) 
		{ 
			out.println("Fail, <font color='#ff0000'>amount</font> should be an integer, please check your input. <a href=\"productOrder.jsp?id="+prodid+"\" target=\"_self\">Try again</a>");
		
		}
}
%>

</body>
</html>