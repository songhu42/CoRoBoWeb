<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Msg_tmplService"%>
<%@ page import="com.humanval.sipt.service.Class_mstService"%>
<%@ page import="com.humanval.sipt.service.Class_infoService"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>
<%@ page import="com.humanval.sipt.service.Admin_mstService"%>
<%@ page import="com.humanval.sipt.dao.Msg_tmpl"%>
<%@ page import="com.humanval.sipt.dao.Class_mst"%>
<%@ page import="com.humanval.sipt.dao.Class_info"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.dao.Admin_mst"%>

<%
	StringBuffer sb = new StringBuffer(); 
	String admin_id = ComUtil.chNull(request.getParameter("admin_id"));
	String msg_tmp_id = ComUtil.chNull(request.getParameter("msg_tmp_id"));

	try {
		long class_id = Long.parseLong(ComUtil.chNull(request.getParameter("class_id")));
		long user_id = Long.parseLong(ComUtil.chNull(request.getParameter("admin_id")));
		String class_dt = ComUtil.chNull(request.getParameter("class_dt"));

		String whereOption = " WHERE A.TMPL_ID=" + msg_tmp_id + " "; 
		// select all information tables
	    long tmpl_id = Long.parseLong(msg_tmp_id); 
	    
		Msg_tmplService tmplService = new Msg_tmplService(); 
		Msg_tmpl msg_tmpl = tmplService.select(tmpl_id); 
		
		String content = msg_tmpl.getContent(); 
		
		Class_mstService classMstService = new Class_mstService(); 
		Class_mst class_mst = classMstService.select(class_id); 
	
		Class_infoService classInfoService = new Class_infoService(); 
		Class_info class_info = classInfoService.selectByString(class_dt, class_id, user_id); 

		User_mstService userMstService = new User_mstService(); 
		User_mst user_mst = userMstService.select(user_id); 

		Admin_mstService adminMstService = new Admin_mstService(); 
		Admin_mst admin_mst = adminMstService.select(admin_id); 
		
		content = ComUtil.replaceTmpl(class_mst, content); 
		content = ComUtil.replaceTmpl(class_info, content); 
		content = ComUtil.replaceTmpl(user_mst, content); 
		content = ComUtil.replaceTmpl(admin_mst, content); 
		content = ComUtil.replaceTmpl("function", content); 

		sb.append("["); 
		
		
		Class_mstService msgService = new Class_mstService(); 
		List<Class_mst> list = msgService.selectList(whereOption); 
	
		for( int i=0; i<list.size(); i++ ) {
			User_mst code = (User_mst)list.get(i); 
			if( i > 0 ) sb.append(", "); 
			sb.append("{" + "\"id\":\"" +code.getUser_id() + "\", \"name\":\"" +code.getUser_nm() + "\" } "); 
			
		}
	  	sb.append("]"); 
	} catch(Exception e) {
		e.printStackTrace(); 
	}
  	
  	out.print(sb.toString()); 
 
%>