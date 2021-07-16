<%@ page import="org.apache.commons.logging.*"%>

<%@ page import="com.tobesoft.xplatform.data.*"%>
<%@ page import="com.tobesoft.xplatform.tx.*"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>

<%@ page contentType="text/xml; charset=UTF-8"%>
<%
//PlatformData 
PlatformData o_xpData = new PlatformData();

//HttpPlatformRequest
HttpPlatformRequest pReq = new HttpPlatformRequest(request);

//XML parsing
pReq.receiveData();

//PlatformData 
PlatformData i_xpData = pReq.getData();

//Get
VariableList in_vl = i_xpData.getVariableList();
String in_var2 = in_vl.getString("sVal1");
DataSet dsi = i_xpData.getDataSet("ds_empList_c");


DataSet dso = null;
int nErrorCode = 0;
String strErrorMsg = "START";
String sTest = "11";



try {
	/******* JDBC Connection *******/
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String SQL = "";

	try {
		//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		//conn = DriverManager.getConnection("jdbc:sqlserver://127.0.0.1:1433;DatabaseName=EDU;User=edu;Password=edu123");

		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "edu", "1234");
		
		stmt = conn.createStatement();
		
		String id = request.getParameter("id");
		int i;
		//System.out.println("id===>" + id);
		//조회버튼을 클릭했을때 사용되는 부분
		if (id.equals("save")) {
			System.out.println(id);
			System.out.println(dsi.getRowCount());
			
			String org_id = dsi.getString(0, 0);
			String org_id1 = dsi.getString(0, "empcd");
			String org_id2 = dsi.getString(0, "empnm");
			String org_id3 = dsi.getString(0, "empzipcd");
			System.out.println("org_id===>" + org_id1 + org_id2 + org_id3 );
			
			
			
			/******* SQL ************/
		
			SQL = "MERGE INTO empbasics_t " + 
					"USING dual " + 
					"ON (empcd='" + org_id + "') " +
					"WHEN MATCHED THEN " + 
						"UPDATE SET " + 
							"empnm='"    + dsi.getString(0, "empnm")     + "'," + 
							"empzipcd='" + dsi.getString(0, "empzipcd")  + "' " +
					 "WHEN NOT MATCHED THEN " +
						 "INSERT (empcd, empnm, empzipcd) "   + 
					 		"VALUES (" + "'" + org_id     + "', "            +
										"'" + dsi.getString(0, "empnm")    + "', " +
										"'" + dsi.getString(0, "empzipcd") + "')";

			
				}
		
		stmt.executeUpdate(SQL);
		
	} catch (SQLException e) {

		nErrorCode = -1;
		strErrorMsg = e.getMessage();

	}

	/******** JDBC Close ********/
	if (stmt != null)try {stmt.close();} catch (Exception e) {nErrorCode = -1;strErrorMsg = e.getMessage();}
	if (conn != null)try {conn.close();} catch (Exception e) {nErrorCode = -1;strErrorMsg = e.getMessage();}

	nErrorCode = 0;
	strErrorMsg = "SUCC";

} catch (Throwable th) {
	nErrorCode = -1;
	strErrorMsg = th.getMessage();

}

// VariableList 
VariableList varList = i_xpData.getVariableList();

//Variable--> VariableList
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg", strErrorMsg);
varList.add("out_var", in_var2);

// HttpPlatformResponse 
HttpPlatformResponse pRes = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "UTF-8");
pRes.setData(o_xpData);

// Send data
pRes.sendData();
%>
