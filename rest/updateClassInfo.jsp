<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Class_info"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.humanval.sipt.service.Class_infoService"%>

<%
try {
	String admin_id = ComUtil.chNull(request.getParameter("admin_id"));
	String idKey = ComUtil.chNull(request.getParameter("idKey"));
	String strTm = ComUtil.chNull(request.getParameter("strTm"));
	String endTm = ComUtil.chNull(request.getParameter("endTm"));

	String[] keys = idKey.split("_"); 
	String class_dt = keys[1];  
	long class_id = ComUtil.getLongNumber(keys[0]); 
	long user_id = ComUtil.getLongNumber(keys[2]);  
	System.out.println("idKey : " + idKey ); 
			
	Class_infoService infoService = new Class_infoService(); 
	Class_info info = infoService.selectByString(class_dt, class_id, user_id);
	
	// 날짜가 바뀔 수 있어서 삭제후 Insert 해준다..
	infoService.delete(info); 
	
	/*
	SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-ddHHmm");

	// 2024-10-18T07:30:00.000Z
	Date newStrDt= ComUtil.getLocalDate(strTm);
	Date newEndDt= ComUtil.getLocalDate(endTm); 

	String newStrDtStr = timeFormat.format(newStrDt); 
	String newEndDtStr = timeFormat.format(newEndDt); 
	
	String dayStr = newStrDtStr.substring(0, 10);
	Date new_class_dt = ComUtil.getDate(dayStr); 
	int str_tm = Integer.parseInt(newStrDtStr.substring(10)); 
	int end_tm = Integer.parseInt(newEndDtStr.substring(10)); 
	*/
	// 한국시간으로 변경해서 넘어온다. 
	String dayStr = strTm.substring(0, 10);
	Date new_class_dt = ComUtil.getDate(dayStr); 
	int str_tm = Integer.parseInt(strTm.substring(11, 16).replace(":", "")); 
	int end_tm = Integer.parseInt(endTm.substring(11, 16).replace(":", "")); 
	
	info.setClass_dt(new_class_dt); 
	info.setStr_tm(str_tm); 
	info.setEnd_tm(end_tm); 
	
	infoService.insert(info);
	// 기존 생성일자를 그대로 유지하기 위해 update한다. 
	infoService.updateDates(info); 

	out.print("{\"result\":\"OK\"}"); 
} catch(Exception e) {
	e.printStackTrace();
	out.print("{\"result\":\"FAIL\"}"); 
}

%>