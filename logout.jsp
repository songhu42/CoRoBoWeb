<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%
try{  
    
    // 세션 삭제
    session.invalidate();
    
    // 자동 로그인 쿠키 삭제
    Cookie[] cookiesDel = request.getCookies();
    for (int i = 0; i < cookiesDel.length; i++) {
        Cookie thisCookie = cookiesDel[i];
        if ("AUTOLOGIN_ID".equals(thisCookie.getName()) || "AUTOLOGIN_ENC".equals(thisCookie.getName())) {
            thisCookie.setMaxAge(0);
            response.addCookie(thisCookie); 
        }
    }
    
    //out.println(ComUtil.redirect("/index.jsp"));

    response.sendRedirect("admin.jsp");
    return; 
    
}catch(Exception e){
	e.printStackTrace();
}
%>