<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Hashtable" %>  
<%@ page import="com.humanval.sipt.util.InitConfig" %>   
<%@ page import="com.humanval.sipt.util.ComUtil" %>  
<%@ page import="com.humanval.sipt.service.Admin_mstService" %>  
<%@ page import="com.humanval.sipt.dao.Admin_mst" %>
<%@ page import="com.humanval.sipt.util.Crypto" %>

<%
Admin_mstService mgrSrv = new Admin_mstService(); 
InitConfig conf = new InitConfig(); 

try {	
	Admin_mst user = mgrSrv.isAdminMobile(request); 
	
	if( user != null)   {
		String userId  = ComUtil.chNull(user.getAdmin_id());
		String passwd = ComUtil.chNull(user.getPasswd());
		
           // 비밀번호 암복호화 처리 루틴
       	if(Crypto.checkPassword(passwd, request.getParameter("input_pw"))){
               // session create 
               session = request.getSession(true);
               session.setAttribute("userId"    , userId);
               session.setAttribute("userNm"    , user.getAdmin_nm()); 
               session.setAttribute("userIp"    , request.getRemoteAddr());
			session.setAttribute("i18n"     , "ko_KR");    
			session.setAttribute("userMail"    , user.getEmail());    
			session.setAttribute("telNo"     , user.getTel_no());   
			session.setAttribute("authLevel"     , user.getAuth_level());   

	        
	        // 자동로그인 여부 .. 
	        String auto_login = request.getParameter("auto_login"); 
	        
	        if( "on".equals(auto_login) ) {
	        	String encStr = "";
	        	String randStr    = "";
	        	
	        	String ipAddress  = request.getHeader("X-FORWARDED-FOR");  
	        	if(ipAddress == null) {
	        		ipAddress = request.getRemoteAddr();
	        		System.out.println("IP Address in head is null and get ip : " + ipAddress); 
	        	}  

	        	try{
	        		// 랜덤한 키값을 생성(여기서는 5문자를 생성함)
	        	 	StringBuffer sbKey = new StringBuffer();
	        		while(sbKey.length() < 10){
	        	    	sbKey.append((char)((Math.random() * 26) + 65));
	        	    }
	        		randStr    = sbKey.toString();
	        		encStr = Crypto.encrypt(randStr);
	        	}catch(Exception e) {
	        	    e.printStackTrace();  
	        	}
				// 쿠키에 아이디 저장
				Cookie idCookie = new Cookie("AUTOLOGIN_ID", userId);
				idCookie.setMaxAge(2592000);    // 한달간 저장(최대 자동로그인 기간은 한달)
				response.addCookie(idCookie);
				
				// 쿠키에 암호화된 문자열 저장
				Cookie encCookie = new Cookie("AUTOLOGIN_ENC", encStr);
				encCookie.setMaxAge(2592000);
				response.addCookie(encCookie);
				
				// enc 키값을 DB에 저장
				mgrSrv.insertAutoLoginKey(userId, encStr, ipAddress); 
	        }
	        // go_url is not used now .. 
	        out.println(ComUtil.parentRedirect("./admin.jsp"));
	        
           } else {
              	out.println(ComUtil.alert("패스워드를 정확히 입력하세요."));
           		return;
           }

	} 
	else {
	    // 사용자없음
       	out.println(ComUtil.alert("사용자 정보가 없습니다."));
        return;
	}
}
catch(Exception e) {
	e.printStackTrace();
}
%>

