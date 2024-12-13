<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Admin_menu"%>
<%@ page import="com.humanval.sipt.service.Admin_menuService"%>
<%
	Admin_menuService service = new Admin_menuService(); 
	Admin_menu info = new Admin_menu(); 
	
	// request.setCharacterEncoding("utf-8");
	// response.setContentType("text/html;charset=utf-8");

	List<Com_code> contTypeList = codeService.selectList("A10"); 
	List<Com_code> authLevelList = codeService.selectList("A09"); 
	List<Com_code> openAreaList = codeService.selectList("A11"); 

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selMenuId = ComUtil.chNull(request.getParameter("selMenuId"));

	System.out.println("action : " + saveAction + " contTypeList : " + contTypeList.size() + " selMenuId : " + selMenuId); 
	
	
	// N : New Save => Close Window & reload parent
	// U : Update Save => Edit Mode
	// D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(selMenuId); 

	} else if( !saveAction.equals("") ) {
		String menu_id = ComUtil.chNull(request.getParameter("menu_id"));
		String menu_nm = new String(ComUtil.chNull(request.getParameter("menu_nm")).getBytes("8859_1"), "UTF-8");
		String grp_nm = new String(ComUtil.chNull(request.getParameter("grp_nm")).getBytes("8859_1"), "UTF-8");
		int grp_sorts = ComUtil.getIntNumber(request.getParameter("grp_sorts"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));
		String cont_type = ComUtil.chNull(request.getParameter("cont_type"));
		String content = new String(ComUtil.chNull(request.getParameter("content")).getBytes("8859_1"), "UTF-8"); 
		String auth_level = ComUtil.chNull(request.getParameter("auth_level"));
		int is_used = ComUtil.getIntNumber(request.getParameter("is_used"));
		String open_area = ComUtil.chNull(request.getParameter("open_area"));
		String popup_opt = ComUtil.chNull(request.getParameter("popup_opt"));
		String remrks = new String(ComUtil.chNull(request.getParameter("remrks")).getBytes("8859_1"), "UTF-8"); 
				
		info.setMenu_id(menu_id); 
		info.setMenu_nm(menu_nm); 
		info.setGrp_nm(grp_nm); 
		info.setGrp_sorts(grp_sorts); 
		info.setSorts(sorts); 
		info.setCont_type(cont_type); 
		info.setContent(content); 
		info.setAuth_level(auth_level); 
		info.setIs_used(is_used); 
		info.setOpen_area(open_area); 
		info.setPopup_opt(popup_opt); 
		info.setRemrks(remrks); 

		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			service.update(info); 
			
		} else if( saveAction.equals("N") ) {
			service.insert(info); 
		}
		
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
								<h2>어드민 메뉴 등록</h2>
								
<form name="writeform" method="POST"  action="editAdminMenu.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selMenuId" id="selMenuId" value="<%=selMenuId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;메뉴 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="15%" />
		 <col width="35%" />
		 <col width="15%" />
		 <col width="35%" />
	  </colgroup>

	<tr>
		<th class="mandatory">메뉴ID</th>
		<td colspan="1"><input type="text" name="menu_id" size="30" maxlength="30" class="f_input" value="<%=info.getMenu_id()%>"></td>
		<th class="mandatory">메뉴명</th>
		<td colspan="1"><input type="text" name="menu_nm" size="30" maxlength="30" class="f_input" value="<%=info.getMenu_nm()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">메뉴그룹명</th>
		<td colspan="1"><input type="text" name="grp_nm" size="30" maxlength="30" class="f_input" value="<%=info.getGrp_nm()%>"></td>
		<th class="mandatory">메뉴그룹순서</th>
		<td colspan="1"><input type="text" name="grp_sorts" size="10" maxlength="10" class="f_input" value="<%=info.getGrp_sorts()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">컨텐츠구분</th>
		<td colspan="1">
				<select name="cont_type" id="cont_type" class="f_select">
<%
	for(int i=0; i<contTypeList.size(); i++ ) {
		Com_code code = (Com_code)contTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getCont_type()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th class="mandatory">메뉴순서</th>
		<td colspan="1"><input type="text" name="sorts" size="10" maxlength="10" class="f_input" value="<%=info.getSorts()%>"></td>
	</tr>

	<tr>
	<th class="mandatory">컨텐츠내용</th>
	<td colspan="3"><textarea name="content" cols="72" rows="6" class="f_textarea"><%=info.getContent()%></textarea></td>
	</tr>
	
	<tr>
		<th class="mandatory">컨텐츠영역</th>
		<td colspan="1">
				<select name="open_area" id="open_area" class="f_select">
<%
	for(int i=0; i<openAreaList.size(); i++ ) {
		Com_code code = (Com_code)openAreaList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(code.getCode_id().equals(info.getOpen_area()))?" selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th >팝업옵션</th>
		<td colspan="1"><input type="text" name="popup_opt" size="100" maxlength="100" class="f_input" value="<%=info.getPopup_opt()%>"></td>
	</tr>


	<tr>
		<th class="mandatory">사용권한</th>
		<td colspan="1">
				<select name="auth_level" id="auth_level" class="f_select">
<%
	for(int i=0; i<authLevelList.size(); i++ ) {
		Com_code code = (Com_code)authLevelList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(code.getCode_id().equals(info.getAuth_level()))?" selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th class="mandatory">사용여부</th>
		<td colspan="1">
				<select name="is_used" id="is_used" class="f_select">
		  				<option value="1"  <%=(info.getIs_used() == 1 )?" selected ":"" %>>사용중</option>
		  				<option value="0"  <%=(info.getIs_used() == 0 )?" selected ":"" %>>사용안함</option>
		  		</select>
		</td>
	</tr>


	<tr>
	<th >참고사항</th>
	<td colspan="3"><textarea name="remrks" cols="72" rows="4" class="f_textarea"><%=info.getRemrks()%></textarea></td>
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
		
		if( form.menu_id.value == "" ) {
	      alert('메뉴ID를 입력하세요!');
	      form.menu_id.focus();
	      return false;
	      
		   } else if( form.menu_nm.value == "") {
			      alert('메뉴명을 입력하세요!');
			      form.menu_nm.focus();
			      return false;
			      
		   } else if( form.grp_nm.value == "") {
			      alert('그룹명을 입력하세요!');
			      form.grp_nm.focus();
			      return false;
			      
		   } else if( form.content.value == "") {
			      alert('컨텐츠 내용을 입력하세요!');
			      form.content.focus();
			      return false;
		   }

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>