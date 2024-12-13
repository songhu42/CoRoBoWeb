<%@ page contentType = "text/html;charset=UTF-8" %>
<%
String go_url = com.humanval.sipt.util.ComUtil.chNull(request.getParameter("go_url"));
%>
<html>
	<head>
		<title>관리자</title>
		<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, 
			minimum-scale=1.0, width=device-width, height=device-height-45">

		<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" /> 
		<link rel="stylesheet" href="/assets/css/login.css" />

		<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
		<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script> 

<script type="text/javascript" >
function checkvals() {

    if($('#input_id').val() == ""){
        alert('아이디를 입력하세요 ');
        $('#input_id').focus();
        return false;
    }

    
    if($('#input_pw').val() == ""){
        alert('패스위드를 입력하세요 ');
        $('#input_pw').focus();
        return false;
    }
	return true; 
}

</script>

	</head>
	<body onload="document.form.input_id.focus();"   >
	<form id="form" name="form" method="post" action="./loginMobile.jsp" target="frame_hide" >
		<input type="hidden" id="go_url" name="go_url" value="<%=go_url%>" />
		<section id="login_page" data-role="page" data-add-back-btn="false"  data-fullscreen="true"   >
			
			<h3>&nbsp;&nbsp;&nbsp;관리자 시스템에 오신것을 환영합니다!!</h3>

			<div class="ui-grid-a" style="height:40px">
				<div class="ui-block-a" style="width:100px;text-align:center">
					<label for="input_id" style="display:inline-block;text-align:center;padding-top:6px;">아이디</label>
				</div>
				<div class="ui-block-b"><input type="text" name="input_id" id="input_id" value="" /></div>	   
			</div>
			
			<div class="ui-grid-a" style="height:40px">
				<div class="ui-block-a" style="width:100px;text-align:center">
					<label for="input_pw" style="display:inline-block;text-align:center;padding-top:6px;">패스워드</label>
				</div>
				<div class="ui-block-b"><input type="password" name="input_pw" id="input_pw" value="" /></div>	   
			</div>
			
			<div class="ui-grid-a" style="height:50px">
				<div class="ui-block-a" style="width:100px;text-align:center">
					<label for="auto_login" style="display:inline-block;text-align:center;padding-top:10px;">자동 로그인</label>
				</div>
				<div class="ui-block-b">
					<select name="auto_login" id="auto_login" data-role="slider">
					<option value="on">On</option>
					<option value="off" selected >Off</option>
					</select>
				</div>
			</div>
			
			<div class="ui-grid-solo">
				<div class="ui-block-a" style="text-align:center">
				<button type="submit" data-inline="true"  data-icon="check">로그인</button>
				</div>
			</div>

		</section>
	</form>
	<iframe name="frame_hide" width="0" height="0"></iframe>
	</body>
</html>

