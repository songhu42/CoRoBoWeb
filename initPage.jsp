<%@ page import="java.text.*" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="com.humanval.sipt.dao.Admin_mst"%>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>
<%@ page import="com.humanval.sipt.service.Admin_mstService"%>
<%@ page import="com.humanval.sipt.dao.User_cookie"%>
<%@ page import="java.util.List"%>

<%
Admin_mstService mgrSrv = new Admin_mstService(); 
Com_codeService codeService = new Com_codeService(); 

session = request.getSession(false);
String userId = ""; 
String authLevel = ""; 

String login_yn = ComUtil.chNull(request.getParameter("login"));

String go_url = ComUtil.chNull(request.getRequestURI()); 
String login_url = "/login.jsp?go_url=" + go_url; 

String gCurMenuId = ComUtil.chNull(request.getParameter("gCurMenuId"));
String gCurPageNo = ComUtil.chNull(request.getParameter("gCurPageNo"));


boolean isLogined = true;

if(session == null) {
	System.out.println("Session was closed!!"); 
	isLogined = false; 
} else {
	if( session.getAttribute("userId") == null ) {
		isLogined = false; 
	}
}

//자동 로그인 처리 .. 
if( !isLogined ) {
 // 쿠키값을 체크.
 String idStr = "";
 String encStr = "";
 Cookie[] cookies = request.getCookies();
 
 if( cookies != null ) {
     for (int i = 0; i < cookies.length; i++) {
         Cookie thisCookie = cookies[i];
         if ("AUTOLOGIN_ID".equals(thisCookie.getName())) idStr = thisCookie.getValue();
         if ("AUTOLOGIN_ENC".equals(thisCookie.getName())) encStr = thisCookie.getValue();
     }
     
     System.out.println("idStr : " + idStr + " encStr : " + encStr); 

 }

 // 자동로그인  
 if( !idStr.equals("") ){
     List<?> cookieList = mgrSrv.getAutoLoginKey(idStr); 
		if( encStr == null || cookieList == null || cookieList.size() == 0 ) {
	        System.out.println("checkEnc is null...");  
	        if( login_yn.equals("Y") ) {
	       	 response.sendRedirect(login_url);
	            return; 
	        }
		}
		
		boolean isMatch = false; 
		for( int i=0; i<cookieList.size(); i++ ) {
			User_cookie coo = (User_cookie)cookieList.get(i); 
			String checkEnc = coo.getAuto_login_key(); 
			if( encStr.equals(checkEnc) ) {
				isMatch = true; 
				break; 
			}
		}

     if( isMatch ) {
         // 쿠키정보를 업데이트한다(쿠키 저장기간이 한달로 지정되어 있으므로 그냥 두면 한달 뒤에 끊겨버림. 새로 갱신.)
         Cookie[] cookiesDel = request.getCookies();
         for (int i = 0; i < cookiesDel.length; i++) {
             Cookie thisCookie = cookiesDel[i];
             if ("AUTOLOGIN_ID".equals(thisCookie.getName()) || "AUTOLOGIN_ENC".equals(thisCookie.getName())) {
                 thisCookie.setMaxAge(2592000);    // 한달간 저장
                 response.addCookie(thisCookie); 
             }
         }
         userId = idStr; 
         System.out.println("isMatch true : " + userId);
         
         // 로그인 수행
         Admin_mst user = mgrSrv.isAdmin(userId); 
         // session create 
         session = request.getSession(true);
         session.setAttribute("userId"    , userId);
         session.setAttribute("userNm"    , user.getAdmin_nm()); 
         session.setAttribute("userIp"    , request.getRemoteAddr());
		session.setAttribute("i18n"     , "ko_KR");    
		session.setAttribute("userMail"    , user.getEmail());    
		session.setAttribute("telNo"     , user.getTel_no());   
		session.setAttribute("authLevel"     , user.getAuth_level());   
		isLogined = true; 

     } else {
		System.out.println("Cookie info is not match to user info!!"); 
	     if( login_yn.equals("Y") ) {
	    	 response.sendRedirect(login_url);
	         return; 
	     }
     }
 } else {
     if( login_yn.equals("Y") ) {
    	 response.sendRedirect(login_url);
         return; 
     }
 }
}
     
userId     = (String)session.getAttribute("userId"); 
String userNm     = (String)session.getAttribute("userNm"); 
String userMail     = (String)session.getAttribute("userMail"); 
String telNo      = (String)session.getAttribute("telNo"); 
authLevel     = (String)session.getAttribute("authLevel"); 
if( authLevel == null ) authLevel = "U"; 

%>
