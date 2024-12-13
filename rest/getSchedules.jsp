<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Class_info"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Class_infoService"%>

<%
	StringBuffer sb = new StringBuffer(); 
	String admin_id = ComUtil.chNull(request.getParameter("admin_id"));
	String selWeek = ComUtil.chNull(request.getParameter("selWeek"));
	// 일단 다 가져오자.. 
	String whereOption = " WHERE A.ADMIN_ID='" + admin_id + "' "; 

	sb.append("["); 
    
	Class_infoService comService = new Class_infoService(); 
	List<Class_info> list = comService.selectList(whereOption); 

	for( int i=0; i<list.size(); i++ ) {
		Class_info code = (Class_info)list.get(i); 
		if( i > 0 ) sb.append(", "); 
		sb.append("{" + "\"class_dt\":\"" +ComUtil.getDateString(code.getClass_dt()) + "\", \"class_id\":\"" +code.getClass_id() + "\", \"user_id\":\"" +code.getUser_id() 
		+ "\", \"user_nm\":\"" +code.getUser_nm() + "\", \"str_tm\":\"" +code.getStr_tm() + "\", \"end_tm\":\"" +code.getEnd_tm() 
		+ "\", \"is_done\":\"" +code.getIs_done() + "\", \"content\":\"" +code.getContent() + "\", \"admin_id\":\"" +code.getAdmin_id() 
		 + "\", \"tot_times\":\"" +code.getTot_times()  + "\", \"cur_times\":\"" +code.getCur_times()  + "\", \"state\":\"" +code.getState() + "\" } "); 
		
	}
  	sb.append("]"); 
  	
  	// System.out.println(sb.toString()); 
  	
  	out.print(sb.toString().replaceAll("\r", "\\r").replaceAll("\n", "\\n")); 
 
%>