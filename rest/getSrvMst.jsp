<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.dao.Srv_mst"%>
<%@ page import="com.humanval.sipt.service.Srv_mstService"%>

<%
	String srv_id = ComUtil.chNull(request.getParameter("srv_id"));
	StringBuffer sb = new StringBuffer(); 
	
    System.out.println("srv_id : " + srv_id); 
	if( !srv_id.equals("") ) {
		Srv_mstService service = new Srv_mstService(); 
		Srv_mst srv = service.select(srv_id);   

		sb.append("{" + "\"srv_id\":\"" +srv.getSrv_id() + "\", \"srv_nm\":\"" +srv.getSrv_nm() + "\", \"srv_desc\":\"" +srv.getSrv_desc() + "\", \"srv_tp\":\"" +srv.getSrv_tp() + "\" } "); 
			 
	}
  	
  	out.print(sb.toString()); 
 
%>