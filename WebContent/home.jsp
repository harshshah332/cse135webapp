<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home</title>
</head>
<body>
<% Object name = session.getAttribute("name"); %>
<h4> WELCOME HOME, <%=name %>  </h4>

<%if(session.getAttribute("role").equals("owner"))
	{   %>
      <a href="categories.jsp" >Categories</a> <br>
      <a href="products.jsp" >Products</a> <br>
      <a href = "productsBrowsing,.jsp"> Products Browsing</a> <br>
      <a href="productOrder.jsp" >Product Order</a> <br>
      <a href = "buyShoppingCart.jsp">Buy Shopping Cart</a><br>
      
      <%
	}
 
else if(session.getAttribute("role").equals("customer"))
{
	
      %>
      <a href = "productsBrowsing,.jsp"> Products Browsing</a> <br>
      <a href="productOrder.jsp" >Product Order</a> <br>
      <a href = "buyShoppingCart.jsp">Buy Shopping Cart</a><br>

<% } %>
</body>
</html>