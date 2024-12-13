<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Class_mst"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Class_mstService"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>

<%
	StringBuffer sb = new StringBuffer(); 
	String admin_id = ComUtil.chNull(request.getParameter("admin_id"));
	String class_id = ComUtil.chNull(request.getParameter("class_id"));
	

	sb.append("["); 
    
	User_mstService userService = new User_mstService(); 
	Class_mstService classService = new Class_mstService(); 
	Class_mst classInfo = classService.select(ComUtil.getLongNumber(class_id)); 
	
	String whereOption = " WHERE C.ADMIN_ID='" + admin_id + "' AND C.USER_ID IN (" + classInfo.getUser_ids() + ")"; 
	
	List<User_mst> list = userService.selectList(whereOption); 

	for( int i=0; i<list.size(); i++ ) {
		User_mst code = (User_mst)list.get(i); 
		if( i > 0 ) sb.append(", "); 
		sb.append("{" + "\"id\":\"" +code.getUser_id() + "\", \"name\":\"" +code.getUser_nm() + "\" } "); 
		
	}
  	sb.append("]"); 
  	
  	out.print(sb.toString()); 
 
%>