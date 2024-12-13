<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	String sido = ComUtil.chNull(request.getParameter("sido"));
	StringBuffer sb = new StringBuffer(); 
	
	sb.append("{");
	sb.append("\"result\": ["); 
    
    System.out.println("sido : " + sido); 
	if( !sido.equals("") ) {
		Com_codeService comService = new Com_codeService(); 
		List<Com_code> list = comService.selectList(sido); 
	    System.out.println("size : " + list.size()); 
		for( int i=0; i<list.size(); i++ ) {
			Com_code code = (Com_code)list.get(i); 
			if( i > 0 ) sb.append(", "); 
			sb.append("{" + "\"cd\":\"" +code.getCode_id() + "\", \"addr_name\":\"" +code.getCode_nm() + "\" } "); 
			
		}
	}
  	sb.append("]}"); 
  	
  	out.print(sb.toString()); 
 
%>