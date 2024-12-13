<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Feedback_res"%>
<%@ page import="com.humanval.sipt.service.Feedback_resService"%>
<%
	Feedback_resService service = new Feedback_resService(); 
	Feedback_res info = new Feedback_res(); 
	
	long seq_no = ComUtil.getLongNumber(request.getParameter("seq_no")); 
	long user_id = ComUtil.getLongNumber(request.getParameter("user_id"));
	int res_type = ComUtil.getIntNumber(request.getParameter("res_type"));
	int res_st = ComUtil.getIntNumber(request.getParameter("res_st"));
		
	info.setSeq_no(seq_no); 
	info.setUser_id(user_id); 
	info.setRes_type(res_type); 
	info.setRes_st(res_st); 
	
	System.out.println("seq_no:" + seq_no + " user_id : " + user_id + " res_type : " + res_type + " res_st : " + res_st); 
	
	service.updateResType(info); 
	
	out.print("{}");
		
%>