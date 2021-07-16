<!-- 1.library import -->
<%@ page import="java.sql.*"%>
<%@ page import="com.tobesoft.xplatform.data.*"%>
<%@ page import="com.tobesoft.xplatform.tx.*"%>
<!-- 2. mime type define -->
<%@ page contentType="text/xml; charset=UTF-8"%>
<%
/** 3.XPLATFORM Basic Object creation **/
PlatformData readdata = new PlatformData();

/** 6.1 ErrorCode, ErrorMsg creation **/
int nErrorCode = 0;
String strErrorMsg = "START";
try {
	/** 4. receive client request **/
	// not need to receive
	/** 5. handle data : load data from file **/
	
	/** 5.1 load data from file **/
	//String sourceFilename = "./saveFile.bin";
	//InputStream source = new FileInputStream(sourceFilename);
	//PlatformRequest req = new PlatformRequest(source, PlatformType.CONTENT_TYPE_BINARY);
	//req.receiveData();
	//source.close();
	
	/** 5.1 copy data from loaded data to Dataset **/
	//readdata = req.getData();
	
	/** 6.2 set the ErrorCode and ErrorMsg about success**/
	nErrorCode = 0;
	strErrorMsg = "SUCC";
} catch (Throwable th) {
	/** 6.3 set the ErrorCode and ErrorMsg about fail **/
	nErrorCode = -1;
	strErrorMsg = th.getMessage();
}
/** 6.4 save the ErrorCode and ErrorMsg for sending Client **/
VariableList varList = readdata.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg", strErrorMsg);
/** 7. send the result data to Client **/
HttpPlatformResponse res = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "UTF-8");
res.setData(readdata);
res.sendData();
%>
