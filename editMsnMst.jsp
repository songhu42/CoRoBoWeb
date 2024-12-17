<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Msn_mst"%>
<%@ page import="com.humanval.sipt.service.Msn_mstService"%>
<%
	Msn_mstService service = new Msn_mstService(); 
	Msn_mst info = new Msn_mst(); 
	
	// request.setCharacterEncoding("utf-8");
	// response.setContentType("text/html;charset=utf-8");

	List<Com_code> msnTypeList = codeService.selectList("A01");  

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selMsnId = ComUtil.chNull(request.getParameter("selMsnId"));

	System.out.println("action : " + saveAction + " msnTypeList : " + msnTypeList.size() + " selMsnId : " + selMsnId); 
	
	
	// N : New Save => Close Window & reload parent
	// U : Update Save => Edit Mode
	// D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(Long.parseLong(selMsnId)); 

	} else if( !saveAction.equals("") ) {
		long msn_id = ComUtil.getLongNumber(request.getParameter("msn_id"));
		String msn_nm = new String(ComUtil.chNull(request.getParameter("msn_nm")).getBytes("8859_1"), "UTF-8");
		String msn_desc = new String(ComUtil.chNull(request.getParameter("msn_desc")).getBytes("8859_1"), "UTF-8");
		int robo_cnt = ComUtil.getIntNumber(request.getParameter("robo_cnt"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));

		String msn_tp = ComUtil.chNull(request.getParameter("msn_tp"));
		String robo_main = ComUtil.chNull(request.getParameter("robo_main"));
		String robo_sub1 = ComUtil.chNull(request.getParameter("robo_sub1"));

		info.setMsn_id(msn_id); 
		info.setMsn_nm(msn_nm); 
		info.setMsn_desc(msn_desc); 
		info.setRobo_cnt(robo_cnt); 
		info.setSorts(sorts); 
		info.setRobo_main(robo_main); 
		info.setRobo_sub1(robo_sub1); 

		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			service.update(info); 
		} else if( saveAction.equals("X") ) {
			service.update(info); 
			service.execute(info, true); 
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
		<meta name="keywords" content="ros2, python, AI, turtlebot3, robot, opencv" />

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
								
<form name="writeform" method="POST"  action="editMsnMst.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selMsnId" id="selMsnId" value="<%=selMsnId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;미션 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="15%" />
		 <col width="35%" />
		 <col width="15%" />
		 <col width="35%" />
	  </colgroup>

	<tr>
		<th class="mandatory">미션ID</th>
		<td colspan="1"><input type="text" name="msn_id" size="30" maxlength="30" class="f_input" value="<%=info.getMsn_id()%>" readonly></td>
		<th class="mandatory">미션명</th>
		<td colspan="1"><input type="text" name="msn_nm" size="30" maxlength="30" class="f_input" value="<%=info.getMsn_nm()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">미션설명</th>
		<td colspan="3"><input type="text" name="msn_desc" size="130"   class="f_input" value="<%=info.getMsn_desc()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">미션구분</th>
		<td colspan="1">
				<select name="msn_tp" id="msn_tp" class="f_select">
<%
	for(int i=0; i<msnTypeList.size(); i++ ) {
		Com_code code = (Com_code)msnTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getMsn_tp()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th class="mandatory">순서</th>
		<td colspan="1"><input type="text" name="sorts" size="10" maxlength="10" class="f_input" value="<%=info.getSorts()%>"></td>
	</tr>

	<tr>
		
		<th class="mandatory">메인로봇</th>
		<td colspan="1"><input type="hidden" name="robo_cnt" size="10" maxlength="10" class="f_input" value="2">
			<input type="text" name="robo_main" size="30" maxlength="30" class="f_input" value="<%=info.getRobo_main()%>"></td>
		<th class="mandatory">서브로봇</th>
		<td colspan="1"><input type="text" name="robo_sub1" size="30" maxlength="30" class="f_input" value="<%=info.getRobo_sub1()%>"></td>
	</tr>


</table>

<div class="admin_button">
<% if( saveAction.equals("E") ) { %>
	<input type="button" class="small action" value="수정하기" onclick="check_form('U');"/>
	<input type="button" class="small action" value="삭제하기" onclick="check_form('D');"/>
	<input type="button" class="small action" value="미션실행" onclick="check_form('X');"/>
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
	String alert_msg = "저장 되었습니다!"; 
	if( saveAction.equals("N") || saveAction.equals("D") || saveAction.equals("U")  || saveAction.equals("X")) {
		if( saveAction.equals("X") ) alert_msg = "미션이 실행 되었습니다!"; 
		else if( saveAction.equals("D") ) alert_msg = "삭제 되었습니다!"; 
	%>
		alert('<%=alert_msg%>');
		window.opener.goSearch(); 
		window.close(); 
	<%
	}
	%>
	
})(jQuery);


function check_form(cmd) {
	var form = document.writeform; 
	
	if( cmd == "D" ) {
		if (confirm('정말 삭제 하시겠습니까?')) {
			form.saveAction.value = cmd; 
			form.submit();
       }
	} else { 
		
		if( form.msn_id.value == "" ) {
	      alert('미션ID를 입력하세요!');
	      form.msn_id.focus();
	      return false;
	      
		   } else if( form.msn_nm.value == "") {
			      alert('미션명을 입력하세요!');
			      form.msn_nm.focus();
			      return false;
			      
		   } else if( form.msn_desc.value == "") {
			      alert('미션설명을 입력하세요!');
			      form.msn_desc.focus();
			      return false;
			      
		   } else if( form.robo_main.value == "") {
			      alert('메인로봇을 입력하세요!');
			      form.robo_main.focus();
			      return false;
		   } else if( form.robo_sub1.value == "") {
			      alert('서브로봇을 입력하세요!');
			      form.robo_sub1.focus();
			      return false;
		   }

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>