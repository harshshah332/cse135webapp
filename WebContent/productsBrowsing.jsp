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

 <div style="width:80%; position:center; ">
		<h3>Hi, <%= session.getAttribute( "name") %>.</h3>
</div>

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
	String url="jdbc:postgresql://localhost/cse135";
    String postgresUsername="postgres";
    String password="postgres";
	conn =DriverManager.getConnection(url, postgresUsername, password);
	
    stmt = conn.createStatement();
    
    String action=null,name=null,unit=null,cat=null;
    int pid=-1,cid=-1,cost=-1;
    try
    {
        // every action must be paired with a pid
        action = request.getParameter("action");
        pid = Integer.parseInt(request.getParameter("pid"));
    }
    catch (Exception e)
    {
        action = null;
        pid = -1;
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
        cost = -1;
    }
    %>
<%--layout is 2 columns: 1st column has 2 rows  (search & category list)
                         2nd column has 1 row   (result)
    2 variables: selection & search
        selection saved when clicking on a category   (radio? link?)
            category = selected
            if selected == All products, category = *
        search updated on button press/submission or while typing?
            contains search as substring
            if searched == "", search = * --%>

<%-- search --%>
<form action="productBrowsing.jsp" method="POST">
    <input type="text" name="cid" id="cid" value="<%=cid%>" style="display:none">
</form>

<%-- list categories --%>
<%SQL = "SELECT id,name FROM categories";
rs=stmt.executeQuery(SQL);
// ALL PRODUCTS?
while(rs.next()) {
  %><a href="productsBrowsing.jsp?cid=<%=rs.getInt("id")%>"><%=rs.getString("name")%></a><br><%
}%>
<%--  --%>
<%--  --%>
<%--  --%>

<%-- do query 
     SELECT       WHERE (p.name LIKE %str%) AND (c.id == p.catid) && (c.name == category) --%>
<%if (request.getParameter("cat")!=null && !request.getParameter("cat").equals("all")) {
    rs=stmt.executeQuery("SELECT * FROM products WHERE catid=(SELECT id FROM categories WHERE name="+request.getParameter("cat")+")");
}
else {
    rs=stmt.executeQuery("SELECT * FROM products");
}%>

<table border="1">
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>SKU</th>
    <th>Category ID</th>
    <th>Price</th>
    <th>Click to order this product</th>
</tr>

<%-- -------- Iteration Code -------- --%>
<%
    // Iterate over the ResultSet
    while (rs.next()) {
%>

	<tr>
	    <form action="productBrowsing.jsp" method="POST">
	    <input type="hidden" name="action" value="update"/>
	    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
	
	    <%-- Get the id --%>
	    <td>
	        <%=rs.getInt("id")%>
	    </td>
	
	    <%-- Get the name --%>
	    <td>
	        <input value="<%=rs.getString("name")%>" name="name" size="15"/>
	    </td>
	
	    <%-- Get the sku --%>
	    <td>
	        <input value="<%=rs.getString("sku")%>" name="sku" size="15"/>
	    </td>
	
	    <%-- Get the cid --%>
	    <td>
	        <input value="<%=rs.getInt("catid")%>" name="cid" size="15"/>
	    </td>
    
        <%-- Get the price --%>
        <td>
            <input value="<%=rs.getInt("price")%>" name="price" size="15"/>
        </td>
            </form>

        <%-- Link --%>
        <td>
            <a href="productOrder.jsp?prodid=<%=rs.getInt("id")%>">Order <%=rs.getString("name")%></a>
        </td>
	</tr>
  <%}%>

<%}
finally
{
    if (conn != null) conn.close();
    if (stmt != null) stmt.close();
    if (pstmt != null) pstmt.close();
    if (rs != null) rs.close();
}%>

</body>
</html>