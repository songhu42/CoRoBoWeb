<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>
<%
	User_mstService service = new User_mstService(); 
	User_mst info = new User_mst(); 
	

	List<Com_code> userGradeList = codeService.selectList("A16");  
	List<Com_code> userStateList = codeService.selectList("A02");  

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selUserId = ComUtil.chNull(request.getParameter("selUserId"));

	System.out.println("action : " + saveAction + " selUserId : " + selUserId); 
	

	// N : New Save, U : Update Save, D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(ComUtil.getLongNumber(selUserId));  
	} else if( !saveAction.equals("") ) {
		long user_id = ComUtil.getLongNumber(request.getParameter("user_id"));
		String user_nm = new String(ComUtil.chNull(request.getParameter("user_nm")).getBytes("8859_1"), "UTF-8");
		String user_nic = new String(ComUtil.chNull(request.getParameter("user_nic")).getBytes("8859_1"), "UTF-8");
		String user_grade = ComUtil.chNull(request.getParameter("user_grade"));

		String tel_no = ComUtil.chNull(request.getParameter("tel_no"));
		String add_tel = ComUtil.chNull(request.getParameter("add_tel"));
		String email = ComUtil.chNull(request.getParameter("email"));

		String state = ComUtil.chNull(request.getParameter("state"));

		info.setAdmin_id(userId); 
		info.setUser_id(user_id); 
		info.setUser_nm(user_nm); 
		info.setUser_nic(user_nic); 
		info.setUser_grade(user_grade); 
		info.setTel_no(tel_no); 
		info.setAdd_tel(add_tel); 
		info.setEmail(email); 
		info.setState(state); 

		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			service.update(info); 
			
		} else if( saveAction.equals("N") ) {
			service.insert(info); 
		}
		
	} else {
		info.setAdmin_id(userId); 
		info.setUser_nm(""); 
		info.setUser_nic(""); 
		info.setUser_grade(""); 
		info.setTel_no(""); 
		info.setAdd_tel(""); 
		info.setEmail(""); 
		info.setState(""); 
	}
	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>CoRoBo 서비스 관리</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="휴먼밸, 영단어신, 바이오범프, 철학, 채식" />

		<script src="assets/js/jquery.min.js"></script>
		<script src="assets/js/jquery.modal.js"></script>
		<script src="assets/js/sido.js"></script> 
		<script src="assets/js/hsmutil.js?ver=2"></script> 
			
		<link rel="stylesheet" href="assets/css/main.css" /> 
		<link rel="stylesheet" href="assets/css/jquery.modal.css" /> 
		<link rel="stylesheet" href="assets/css/hsm.css?ver=2" /> 
<script >
</script>
	</head>
	<body class="is-preload popup">
			<section class="wrapper">
					<div class="popup">
						<section class="write">
							<div class="content">
								<h2>사용자 등록</h2>
								
<form name="writeform" method="POST"  action="editUserMst.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selUserId" id="selUserId" value="<%=selUserId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;사용자 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="20%" />
		 <col width="10%" />
		 <col width="20%" />
		 <col width="10%" />
		 <col width="30%" />
	  </colgroup>

	<tr>
		<th class="mandatory">ID</th>
		<td colspan="1"><input type="text" name="user_id" size="30" maxlength="30" class="f_input" value="<%=info.getUser_id()%>" readonly ></td>
		<th class="mandatory">사용자명</th>
		<td colspan="1"><input type="text" name="user_nm" size="30" maxlength="30" class="f_input" value="<%=info.getUser_nm()%>"></td>
		<th class="mandatory">닉네임</th>
		<td colspan="1"><input type="text" name="user_nic" size="30" maxlength="30" class="f_input" value="<%=info.getUser_nic()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">회원등급</th>
		<td colspan="1">
				<select name="user_grade" id="user_grade" class="f_select">
<%
	for(int i=0; i<userGradeList.size(); i++ ) {
		Com_code code = (Com_code)userGradeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getUser_grade()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th class="mandatory">전화번호</th>
		<td colspan="1"><input type="text" name="tel_no" size="30" maxlength="30" class="f_input" value="<%=info.getTel_no()%>"></td>

		<th class="mandatory">회원상태</th>
		<td colspan="1">
				<select name="state" id="user_grade" class="f_select">
<%
	for(int i=0; i<userStateList.size(); i++ ) {
		Com_code code = (Com_code)userStateList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getState()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		  		
		<input type="hidden" name="add_tel" size="30" maxlength="30" class="f_input" value="<%=info.getAdd_tel()%>">
		</td>
	</tr>


	<tr>

	</tr>



</table>

<div class="admin_button">
<% if( saveAction.equals("E") ) { %>
	<input type="button" class="small action" value="수정하기" onclick="check_form('U');"/>
	<input type="button" class="small action" value="삭제하기" onclick="check_form('D');"/>
<% } else { %>
	<input type="button" class="small action" value="등록하기" onclick="check_form('N');"/>
<% } %>

	<input type="button" class="small action" value="닫기" onclick="javascript:window.close();"/> 
</div>

</form>
							</div>

						</section>
						<!-- end write -->
	</div>

</section>						
			
		
<script>


(function($) {
	
	<%
	if( saveAction.equals("N") || saveAction.equals("D") || saveAction.equals("U") ) {
		if( saveAction.equals("N") || saveAction.equals("U") ) {
	%>
			alert("저장 되었습니다!"); 
	<%
		}  else {
		%>
			alert("삭제 되었습니다!"); 
		<%
		}  
		%>

		window.opener.goSearch(); 
		window.close(); 
	<%
	}
	%>
	
})(jQuery);


function send_sms(msg) {
	var send_url = "http://" + window.location.host;  
	if( $("#isSMS").val() == "N" ) return; 
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:send_url + "/rest/sendReqSms.jsp?msg=" + msg,
        success:function(response){
        	var res = response.result;
        	console.log("sms result : " + res); 
        	
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
            console.log("Fail to connect to address server : " + textStatus + " Error : " + errorThrown);  
        }   
	});

}

function check_form(cmd) {
	var form = document.writeform; 
	
	if( cmd == "D" ) {
		if (confirm('정말 삭제 하시겠습니까?')) {
			form.saveAction.value = cmd; 
			form.submit();
       }
	} else { 
		if( form.user_nm.value == "") {
			      alert('사용자명을 입력하세요!');
			      form.user_nm.focus();
			      return false;
			      
		   } else if( form.user_nic.value == "") {
			      alert('닉네임을 입력하세요!');
			      form.user_nic.focus();
			      return false;
		   } else if( form.tel_no.value == "") {
			      alert('전화번호를 입력하세요!');
			      form.tel_no.focus();
			      return false;
		   }

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>