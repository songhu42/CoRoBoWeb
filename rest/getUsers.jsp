<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>

<%
	StringBuffer sb = new StringBuffer(); 
	String admin_id = ComUtil.chNull(request.getParameter("admin_id"));
	String whereOption = " WHERE C.ADMIN_ID='" + admin_id + "' "; 

	sb.append("["); 
    
	User_mstService comService = new User_mstService(); 
	List<User_mst> list = comService.selectList(whereOption); 

	for( int i=0; i<list.size(); i++ ) {
		User_mst code = (User_mst)list.get(i); 
		if( i > 0 ) sb.append(", "); 
		sb.append("{" + "\"id\":\"" +code.getUser_id() + "\", \"name\":\"" +code.getUser_nm() + "\" } "); 
		
	}
  	sb.append("]"); 
  	
  	out.print(sb.toString()); 
 
%>