<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Class_mst"%> 
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Class_mstService"%> 

<%
	StringBuffer sb = new StringBuffer(); 
	String admin_id = ComUtil.chNull(request.getParameter("admin_id")); 
	

	sb.append("["); 
    
	String whereOption = " WHERE A.ADMIN_ID='" + admin_id + "' AND A.STATE != 'D'"; 
	Class_mstService classService = new Class_mstService();  
	
	List<Class_mst> list = classService.selectList(whereOption); 

	for( int i=0; i<list.size(); i++ ) {
		Class_mst code = (Class_mst)list.get(i); 
		if( i > 0 ) sb.append(", "); 
		sb.append("{" + "\"id\":\"" +code.getClass_id() + "\", \"name\":\"" +code.getUser_ids_nm() + "\" } "); 
		
	}
  	sb.append("]"); 
  	
  	out.print(sb.toString()); 
 
%>