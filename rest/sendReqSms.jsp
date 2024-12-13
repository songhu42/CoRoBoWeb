<%@ page contentType = "text/json;charset=utf-8" %> 
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="com.humanval.sipt.util.SMS"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.dao.Sms_his"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>
<%@ page import="com.humanval.sipt.service.Sms_hisService"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	String msg = ComUtil.chNull(request.getParameter("msg")); 
	String tel_no = ComUtil.chNull(request.getParameter("tel_no")); 
	String req_type = ComUtil.chNull(request.getParameter("req_type")); 
	StringBuffer sb = new StringBuffer(); 
	
	User_mstService service = new User_mstService(); 
	User_mst user = service.select("admin"); 

	Sms_hisService smsService = new Sms_hisService(); 
	Sms_his sms = new Sms_his(); 
	String result = ""; 
	sms.setReq_st(0); 

	boolean isSuccess = false; 
	boolean isQuick = true; 
	
	sb.append("{");
	
	try {
		String desc = "빠른상담요청 연락처 : " + tel_no + " 내용 : " + msg; 
		String title = "신규매물 등록 요청"; 
		// 매물/매수/컨설팅 등록은 tel_no가 안들어 온다.. 
		if( tel_no.equals("") ) {
			desc = msg;
			isQuick = false; 
			if( req_type.equals("C") ) title = "신규 컨설팅 요청"; 
			else if( req_type.equals("C") ) title = "신규 매수 등록 요청";
		}
		
		if( !user.getMob_no1().equals("") ) {
			String receiver = user.getMob_no1(); 
			sms.setMob_no1(receiver); 
			
			String res = ""; 
			if( isQuick ) res = SMS.sendQuicReq(receiver, desc);
			else res = SMS.sendReqReg(receiver, title, desc);
			
			if( res.equals("1") ) {
				isSuccess = true;
				result = "성공1"; 
			} else {
				result += " 실패1"; 
			}
		}
		
		if( !user.getMob_no2().equals("") ) {
			String receiver = user.getMob_no2(); 
			sms.setMob_no2(receiver); 
			
			String res = ""; 
			if( isQuick ) res = SMS.sendQuicReq(receiver, desc);
			else res = SMS.sendReqReg(receiver, title, desc);

			if( res.equals("1") ) {
				isSuccess = true; 
				result += " 성공2"; 
			} else {
				result += " 실패2"; 
			}
		} 
		
		if( !user.getMob_no3().equals("") ) {
			String receiver = user.getMob_no3(); 
			sms.setMob_no3(receiver); 
			
			String res = ""; 
			if( isQuick ) res = SMS.sendQuicReq(receiver, desc);
			else res = SMS.sendReqReg(receiver, title, desc);

			if( res.equals("1") ) {
				isSuccess = true; 
				result += " 성공3"; 
			} else {
				result += " 실패3"; 
			}
		}  
		
		sms.setResult(result); 
		sms.setMsg(desc); 
		smsService.insert(sms); 
		
		if( isSuccess ) sb.append("\"result\": \"Y\""); 
		else sb.append("\"result\": \"N\"");
	} catch(Exception e ) {
		if( isSuccess ) sb.append("\"result\": \"Y\""); 
		else sb.append("\"result\": \"N\"");
	}

	sb.append("}"); 

  	
  	out.print(sb.toString()); 
 
%>