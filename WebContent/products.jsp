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
//if (role != null && role.equals("owner"))
if (role == null)
{%>
    <%-- links for owners --%>
    <a href="categories.jsp">Categories</a>
    <br>
    <a href="products.jsp">Products</a>
    <br>
    <a href="productsBrowsing.jsp">Products Browsing</a>
    <br>
    <a href="productOrder.jsp">Product Order</a>
    <br>
    <a href="buyShoppingCart.jsp">Buy Shopping Cart</a>
    <br>

    <%
    Connection conn = null;
    Statement stmt = null;
    String SQL = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try
    { 
        Class.forName("org.postgresql.Driver");
        System.out.println("Good Driver");
    }
    catch(ClassNotFoundException e)
    {
        System.out.println("Asian Driver");
    }
    
    try
    {
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/app",
                                           "postgres",
                                           "postgres");
        stmt = conn.createStatement();
        
        String action=null,name=null,unit=null,cat=null;
        int cost=0;
        try {
            action = request.getParameter("action");
        }
        catch (Exception e) {
            action = null;
        }
        try {
            name = request.getParameter("item");
            unit = request.getParameter("sku");
            cat = request.getParameter("category");
            cost = Integer.parseInt(request.getParameter("price"));
        }
        catch (Exception e) {
            name = null;
            unit = null;
            cat = null;
            cost = 0;
        }
        %>
        <%-- owner can insert new products --%>
      <%if(("insert").equals(action))
        {
            if (name==null || unit==null || cat==null ||
                name=="" || unit=="" || cat=="" || cost<=0)
            {
                %><h3>Failed to insert new product!</h3><%
            }
            else
            {
            	try{
	                String SQL_I = "INSERT INTO products (name,SKU,catid,price) " +
	                               "SELECT '"+name+"','"+unit+"',c.id,"+cost+" " +
	                               "FROM categories c WHERE c.name='"+cat+"'";
	                conn.setAutoCommit(false);
	                if (stmt.executeUpdate(SQL_I)==1) {
	                    %><h3>Submitted product!</h3><%
	                }
	                else
	                {
	                    %><h3>Failed to insert new product!</h3><%
	                }
	                conn.commit();
	                conn.setAutoCommit(true);
            	}
            	catch(Exception e){
            		%><h3>Failed to insert new product!</h3><%
            		conn.setAutoCommit(true);
            	}
            }
        }%>
        <div style="display: block; position: absolute; width: 100%; padding: 10px 12px;">
            <form action="products.jsp" method="POST">
                <input type="text" name="action" id="action" value="insert"  style="display:none">
                <input type="text" placeholder="Item Name" name="item">
                <input type="text" placeholder="SKU" name="sku">
                <input type="text" placeholder="Price" name="price">
                <select name="category">
                  <%SQL = "SELECT c.name FROM categories c";
                    pstmt = conn.prepareStatement(SQL);
                    rs=pstmt.executeQuery();
                    while(rs.next()) {
                      %><option value=<%=rs.getString(1)%>><%=rs.getString(1)%></option><%
                    }%>
                </select>
                <input type="hidden" name="dropdown" id="dropdown">
                <button type="submit" class="btn btn-default">Add Product</button>
            </form>
        </div>
        <br>
    
        <%--layout is 2 columns: 1st column has 2 rows  (search & category list)
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
      <%}
        finally
        {
            if (conn != null) conn.close();
            if (stmt != null) stmt.close();
            if (pstmt != null) pstmt.close();
            if (rs != null) rs.close();
        }
}
else
{%>
    <%-- if user not an owner --%>
    <%-- role == null, means user should also not have access to owner view --%>
    <a href="productsBrowsing.jsp">Products Browsing</a>
    <br>
    <a href="productOrder.jsp">Product Order</a>
    <br>
    <a href="buyShoppingCart.jsp">Buy Shopping Cart</a>
    <br>

    <%-- warning, owners only --%>
    <h3>Sorry, this page is available to owners only.</h3>
    <%
}%>

</body>
</html>