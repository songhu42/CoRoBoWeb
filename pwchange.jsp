<%@ page contentType = "text/html;charset=UTF-8" %>
<%@ page import="com.humanval.sipt.service.Admin_mstService" %>
<%@ page import="com.humanval.sipt.util.Crypto" %>
<%@ include file="initPage.jsp" %>
<%

	String password = ""; 
	Admin_mstService service = new Admin_mstService();
	password = service.getPassword(userId); 
	
	if(request.getParameter("mode") != null){
	    String prevpw  = request.getParameter("prevpw");
	    String curpw     = request.getParameter("curpw");
	    String repw     = request.getParameter("repw");
	    String ci18n     = request.getParameter("i18n");
	
	    try{
	    	System.out.println(password + " : " + Crypto.encrypt(prevpw));
	    	if(!Crypto.encrypt(prevpw).equals(password)){
	    		out.println("<script language='javascript'>\n");
	    		out.println("alert('이전 패스워드가 틀렸습니다.');\n");
	    		out.println("</script>");
	    	}
	    	else{
		    	// 패스워드 암호화
		    	curpw = Crypto.encrypt(curpw);
		    	service.updatePasswd(userId, prevpw, curpw);
		    	
                out.println("<script language='javascript'>\n");
	    		out.println("alert('패스워드가 변경되었습니다.');\n");
                out.println("</script>");
	    	}
	    }
	    catch(Exception e){
	    	e.printStackTrace(); 
	    }
	}

%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>패스워드 변경</title>

<link rel="stylesheet" href="assets/css/main.css" /> 
<link rel="stylesheet" href="assets/css/hsm.css?ver=2" /> 

<script >
function savepw(){
	
	var frm = document.frm; 

// 	if(frm.prevpw.value == ""){
//         alert("이전 패스워드를 입력하세요.");
//         frm.prevpw.focus();
//         return false;
//     }
    if(frm.curpw.value == ""){
        alert("새로운 패스워드를 입력하세요.");
        frm.curpw.focus();
        return false;
    }
    if(frm.repw.value == ""){
        alert("패스워드 확인을 입력하세요.");
        frm.repw.focus();
        return false;
    }
    if(frm.repw.value != frm.curpw.value){
        alert("패스워드 확인이 일치하지 않습니다.");
        frm.repw.focus();
        return false;
    }

    frm.submit();
}

function winclose(){
	window.close();
}

</script>

</head>


<body>
<section class="content">
<form id="frm" name="frm" method="post" action="./admin.jsp?gCurMenuId=<%=gCurMenuId%>" >
<input type="hidden" name="mode" value="ok"/>

<table >
  <tr>
    <td><strong>이전 패스워드</strong></td>
    <td><input name="prevpw" type="password" id="prevpw" /><input name="passwd" type="hidden" id="passwd" value="<%=password%>"/></td>
  </tr>
  <tr>
    <td><strong>새 패스워드</strong></td>
    <td><input name="curpw" type="password" id="curpw" /></td>
  </tr>
  <tr>
    <td><strong>패스워드 확인</strong></td>
    <td><input name="repw" type="password" id="repw" /></td>
  </tr>
  <tr>
    <td colspan="2">
        <div align="center">
          <input type="button" onclick="javascript:savepw();" id="save" value="확인" />
          </div></td>
  </tr>
</table>
</form>
</section>
</body>
</html>
