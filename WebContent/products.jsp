<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Products</title>
</head>
<body>

<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.util.*"%>

<%
String role = null;
role = (String) session.getAttribute("role");
if (role != null && role.equals("owner"))
{%>
    <%-- links for owners --%>
    <a href = "categories.jsp">Categories</a> <br>
    <a href = "products.jsp">Products</a> <br>
		<a href = "productsBrowsing.jsp">Products Browsing</a> <br>
		<a href = "productOrder.jsp">Product Order</a> <br>
		<a href = "buyShoppingCart.jsp">Buy Shopping Cart</a> <br>
		
    <%-- owner can insert new products --%>
    <%--   text box: name, sku, & list price --%>
    <%--     TODO: sanitize inputs? --%>
    <%--   drop menu: categories --%>
    <div style="display:block; position:absolute; width:100%; padding:10px 12px;">
      <%-- TODO: products_alter.jsp
           INSERT INTO products (...) --%>
		  <form action="products_alter.jsp" method="POST">
		    <input type="text" placeholder="Item Name" name="item">
        <input type="text" placeholder="SKU" name="sku">
        <input type="text" placeholder="Price" name="price">
          <select name="categories">
            <%-- TODO: list all categories
                 SELECT c.name FROM categories c --%>
            <option value="category">Category
          </select>
        <input type="hidden" name="dropdown" id="dropdown">
		    <button type="submit" class="btn btn-default">Add Product</button>
		  </form>
		</div> <br>
		
		<%-- TODO: some div/popup with result of insert --%>
	    <%-- TODO: insert successful --%>
	    <%-- TODO: insert failed --%>
	    <h3>Failed to insert new product!</h3>
		
    <%-- layout is 2 columns: 1st column has 2 rows  (search & category list)
                              2nd column has 1 row   (result)
         2 variables: selection & search
             selection saved when clicking on a category   (radio? link?)
                 category = selected
                 if selected == All products, category = *
             search updated on button press/submission or while typing?
                 contains search as substring
                 if searched == "", search = * --%>
    <%-- do query 
         SELECT       WHERE (p.name LIKE %str%) AND (c.id == p.catid) && (c.name == category) --%>
    <%-- return result in 2nd column (possible 3rd/4th column for update/delete fields?) --%>
    
    <%-- TODO: PRODUCT BROWSING JSP IS BASICALLY COLUMNS 1 & 2 --%>
<%
}
else
{%>
  <%-- if user not an owner --%>
  <%-- role == null, means user should also not have access to owner view --%>
  <a href = "productsBrowsing.jsp">Products Browsing</a> <br>
  <a href = "productOrder.jsp">Product Order</a> <br>
  <a href = "buyShoppingCart.jsp">Buy Shopping Cart</a> <br>
  
  <%-- warning, owners only --%>
  <h3>Sorry, this page is available to owners only.</h3>
<%
}%>

</body>
</html>