<%@ page import="org.apache.commons.logging.*" %>

<%@ page import="com.tobesoft.xplatform.data.*" %>
<%@ page import="com.tobesoft.xplatform.tx.*" %>

<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>

<%@ page contentType="text/xml; charset=UTF-8" %>

<%
// PlatformData 
PlatformData o_xpData = new PlatformData();

int nErrorCode = 0;
String strErrorMsg = "START";
String sTest="111";

try {	
	/******* JDBC Connection *******/
	Connection conn = null;
	Statement  stmt = null;
	ResultSet  rs   = null;
	String     SQL  = "";
	DataSet    dso   = null; 
	try { 
		//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		//conn = DriverManager.getConnection("jdbc:sqlserver://127.0.0.1:1433;DatabaseName=EDU;User=edu;Password=edu123");
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "edu", "1234");
    
		stmt = conn.createStatement();
		
		String id= request.getParameter("id");

//System.out.println("id===>" + id);
		//조회버튼을 클릭했을때 사용되는 부분
		if(id.equals("search")){		
			/******* SQL ************/
			SQL="SELECT empcd,empnm, empzipcd, value "+
			"FROM empbasics_t a, comcd_t b "+
			"WHERE a.empzipcd = b.code " +
			"AND b.div='zip' " +
			"ORDER BY empcd";
					
			rs = stmt.executeQuery(SQL);
		  
			/********* Dataset **********/
			
			dso = new DataSet("ds_empList");
		  
	 	    dso.addColumn("empcd",    DataTypes.STRING  , 4   );
		    dso.addColumn("empnm",    DataTypes.STRING  , 20  );
		    dso.addColumn("empzipcd", DataTypes.STRING  , 5   );
		    dso.addColumn("value",    DataTypes.STRING  , 50  );
	
		  	  
		    while(rs.next())
		    {
			  	int row = dso.newRow();
		
			  	dso.set(row ,"empcd"    ,rs.getString("empcd"));
			  	dso.set(row ,"empnm"    ,rs.getString("empnm"));
			  	dso.set(row ,"empzipcd" ,rs.getString("empzipcd"));
			  	dso.set(row ,"value"    ,rs.getString("value"));
			}
		}else if(id.equals("onload")){
			/******* SQL ************/
			SQL="SELECT code empzipcd, value FROM comcd_t WHERE div='zip'";
					
			rs = stmt.executeQuery(SQL);
		  
			/********* Dataset **********/
			
			dso = new DataSet("ds_inner");
		  
		    dso.addColumn("empzipcd", DataTypes.STRING  , 5   );
		    dso.addColumn("value",    DataTypes.STRING  , 50  );
	
		  	  
		    while(rs.next())
		    {
			  	int row = dso.newRow();
		
			  	dso.set(row ,"empzipcd" ,rs.getString("empzipcd"));
			  	dso.set(row ,"value"    ,rs.getString("value"));
			}
		}
		// DataSet-->PlatformData
		o_xpData.addDataSet(dso);

		
		nErrorCode = 0;
		strErrorMsg = "SUCC";
		
	} catch (SQLException e) {
		
		nErrorCode = -1;
		strErrorMsg = e.getMessage();
		
	}	
	
	/******** JDBC Close ********/
	if ( stmt != null ) try { stmt.close(); } catch (Exception e) {nErrorCode = -2; strErrorMsg = e.getMessage();}
	if ( conn != null ) try { conn.close(); } catch (Exception e) {nErrorCode = -3; strErrorMsg = e.getMessage();}
			
} catch (Throwable th) {
	nErrorCode = -4;
	strErrorMsg = th.getMessage();

}

// VariableList 
VariableList varList = o_xpData.getVariableList();
		
strErrorMsg=sTest;
		
//Variable--> VariableList
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg", strErrorMsg);


// HttpPlatformResponse 
HttpPlatformResponse pRes = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "UTF-8");
pRes.setData(o_xpData);

// Send data
pRes.sendData();
%>
