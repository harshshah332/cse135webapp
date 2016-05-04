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
                try
                {
                    String SQL_I = "INSERT INTO products (name,SKU,catid,price) " +
                                   "SELECT '"+name+"','"+unit+"',c.id,"+cost+" " +
                                   "FROM categories c WHERE c.name='"+cat+"'";
                    conn.setAutoCommit(false);
                    if (stmt.executeUpdate(SQL_I)==1) {
                        // TODO: Summary of product?
                        %><h3>Submitted product!</h3><%
                    }
                    else
                    {
                        %><h3>Failed to insert new product!</h3><%
                    }
                    conn.commit();
                    conn.setAutoCommit(true);
                }
                catch (Exception e)
                {
                    %><h3>Failed to insert new product!</h3><%
                    conn.setAutoCommit(true);
                }
            }
        }
        else if(("update").equals(action))
        {
            if (name==null || unit==null || cat==null ||
                name=="" || unit=="" || cat=="" || cost<=0)
            {
                // all fields must be filled
                // could split for convenience, only update non-empty fields
                %><h3>Update failure!</h3><%
            }
            else
            {
                try
                {
                    String SQL_U = "UPDATE products "+
                                   "SET name='"+name+"',"+"SKU='"+unit+"',"+
                                       "catid=(SELECT c.id FROM categories c WHERE c.name='"+cat+"')"+
                                       ",price="+cost+
                                   "WHERE id="+pid;
                    conn.setAutoCommit(false);
                    if (stmt.executeUpdate(SQL_U)==1) {
                        %><h3>Update success!</h3><%
                    }
                    else
                    {
                        %><h3>Update failure!</h3><%
                    }
                    conn.commit();
                    conn.setAutoCommit(true);
                }
                catch (Exception e)
                {
                    %><h3>Update failure!</h3><%
                    conn.setAutoCommit(true);
                }
            }
        }
        else if(("delete").equals(action))
        {
            try
            {
                String SQL_U = "DELETE FROM products "+
                               "WHERE id="+pid;
                conn.setAutoCommit(false);
                if (stmt.executeUpdate(SQL_U)==1) {
                    %><h3>Delete success!</h3><%
                }
                else
                {
                    %><h3>Delete failure! Please enter a valid product id.</h3><%
                }
                conn.commit();
                conn.setAutoCommit(true);
                catch(Exception e){
                    %><h3>Failed to insert new product!</h3><%
                    conn.setAutoCommit(true);
                }
            catch (Exception e)
            {
                %><h3>Delete failure! Please enter a valid product id.</h3><%
                conn.setAutoCommit(true);
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
                    rs=stmt.executeQuery(SQL);
                    while(rs.next()) {
                      %><option value=<%=rs.getString(1)%>><%=rs.getString(1)%></option><%
                    }%>
                </select>
                <input type="hidden" name="dropdown" id="dropdown">
                <button type="submit" class="btn btn-default">Add Product</button>
            </form>
        </div>
        <br> <br>
    
        
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
        <form action="products.jsp" method="POST">
            <input type="text" name="cid" id="cid" value="<%=cid%>" style="display:none">
        </form>
        
        <%-- list categories --%>
      <%SQL = "SELECT id,name FROM categories";
        rs=stmt.executeQuery(SQL);
        // ALL PRODUCTS?
        while(rs.next()) {
          %><a href="products.jsp?cid="+<%=rs.getInt(1)%> target=\"_self\"><%=rs.getString(2)%></a><br><%
        }%>
        <%--  --%>
        <%--  --%>
        <%--  --%>
        
        <%-- do query 
             SELECT       WHERE (p.name LIKE %str%) AND (c.id == p.catid) && (c.name == category) --%>
      <%if (cat!=null && !cat.equals("all")) {
            rs=stmt.executeQuery("SELECT * FROM products WHERE catid=(SELECT id FROM categories WHERE name="+cat+")");
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
        </tr>

        <tr>
            <form action="products.jsp" method="POST">
                <input type="hidden" name="action" value="insert"/>
                <th>&nbsp;</th>
                <th><input value="" name="name" size="15"/></th>
                <th><input value="" name="sku" size="15"/></th>
                <th><input value="" name="cid" size="15"/></th>
                <th><input value="" name="price" size="15"/></th>
                <th><input type="submit" value="Insert"/></th>
            </form>
        </tr>

        <%-- -------- Iteration Code -------- --%>
        <%
            // Iterate over the ResultSet
            while (rs.next()) {
        %>

        <tr>
            <form action="products.jsp" method="POST">
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

            <%-- Button --%>
            <td><input type="submit" value="Update"></td>
            </form>
            <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" value="<%=rs.getInt("id")%>" name="pid"/>
            <%-- Button --%>
            <td><input type="submit" value="Delete"/></td>
            </form>
        </tr>
          <%}%>
        
        
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