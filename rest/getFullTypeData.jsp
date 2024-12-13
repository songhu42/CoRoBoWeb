<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	String yo_type = ComUtil.chNull(request.getParameter("yo_type"));
	StringBuffer sb = new StringBuffer(); 
	
	// A01: 요양원, A02: 요양병원, A03: 요양원/병원 자리 
	String yoIndi = ""; 
	if( yo_type.equals("A01") ) yoIndi = "A0"; 
	else if( yo_type.equals("A02") ) yoIndi = "A1";
	else if( yo_type.equals("A03") ) yoIndi = "A2";
	
	sb.append("{");
	sb.append("\"result\": ["); 
    
    System.out.println("yo_type : " + yo_type); 
	if( !yo_type.equals("") ) {
		Com_codeService comService = new Com_codeService(); 
		List<Com_code> list = comService.selectList("A03"); 
	    int j=0; 
		for( int i=0; i<list.size(); i++ ) {
			Com_code code = (Com_code)list.get(i); 
			
			if( code.getCode_id().indexOf(yoIndi) < 0 ) continue; 
			if( j > 0 ) sb.append(", "); 
			sb.append("{" + "\"cd\":\"" +code.getCode_id() + "\", \"name\":\"" +code.getCode_nm() + "\" } "); 
			j++; 
		}
	}
  	sb.append("]}"); 
  	
  	out.print(sb.toString()); 
 
%>