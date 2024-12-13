<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Msn_srv"%>
<%@ page import="com.humanval.sipt.service.Msn_srvService"%>
<%@ page import="com.humanval.sipt.dao.Parm_info"%>
<%@ page import="com.humanval.sipt.service.Parm_infoService"%>

<%
	Msn_srvService service = new Msn_srvService(); 
	Parm_infoService parmService = new Parm_infoService(); 
	Msn_srv info = new Msn_srv(); 
	

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selMsnSeq = ComUtil.chNull(request.getParameter("selMsnSeq"));

	System.out.println("action : " + saveAction + " selMsnSeq : " + selMsnSeq); 
	
	List<Parm_info> parmInfoList = new ArrayList<Parm_info>(); 

	// N : New Save => Close Window & reload parent
	// U : Update Save => Edit Mode
	// D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(Long.parseLong(selMsnSeq)); 
		parmInfoList = parmService.selectList(" WHERE A.SRV_SEQ = " + info.getSrv_seq()); 
	} else if( !saveAction.equals("") ) {
		long msn_seq = ComUtil.getLongNumber(request.getParameter("msn_seq"));
		long msn_id = ComUtil.getLongNumber(request.getParameter("msn_id"));
		long srv_seq = ComUtil.getLongNumber(request.getParameter("srv_seq"));
		long srv_id = ComUtil.getLongNumber(request.getParameter("srv_id"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));

		info.setMsn_seq(msn_seq); 
		info.setMsn_id(msn_id); 
		info.setSrv_seq(srv_seq); 
		info.setSrv_id(srv_id); 
		info.setSorts(sorts); 
		System.out.println("msn_seq : " + msn_seq + " sorts : " + sorts); 
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
								
<form name="writeform" method="POST"  action="editMsnSrv.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selMsnSeq" id="selMsnSeq" value="<%=selMsnSeq%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;미션 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="15%" />
		 <col width="35%" />
		 <col width="15%" />
		 <col width="35%" />
	  </colgroup>

	<tr>
		<th class="mandatory">미션 ID</th>
		<td colspan="1"><input type="hidden" name="msn_seq" size="30" maxlength="30" class="f_input" value="<%=info.getMsn_seq()%>" readonly></td>
		<td colspan="1"><input type="text" name="msn_id" size="30" maxlength="30" class="f_input" value="<%=info.getMsn_id()%>" readonly></td>
		<th class="mandatory">미션명</th>
		<td colspan="1"><input type="text" name="msn_nm" size="30" maxlength="30" class="f_input" value="<%=info.getMsn_nm()%>" readonly></td>
	</tr>

	<tr>
		<th class="mandatory">미션설명</th>
		<td colspan="3"><input type="text" name="msn_desc" size="130"   class="f_input" value="<%=info.getMsn_desc()%>" readonly></td>
	</tr>

	<tr>
		<th class="mandatory">서비스 Seq</th>
		<td colspan="1"><input type="text" name="srv_seq" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_seq()%>" readonly></td>
		<th class="mandatory">서비스 ID</th>
		<td colspan="1"><input type="text" name="srv_id" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_id()%>" readonly></td>
	</tr>

	<tr>
		<th class="mandatory">서비스 Call</th>
		<td colspan="1"><input type="text" name="srv_call" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_call()%>" readonly></td>
		<th class="mandatory">실행순서</th>
		<td colspan="1"><input type="text" name="sorts" size="30" maxlength="30" class="f_input" value="<%=info.getSorts()%>" ></td>
	</tr>

	<tr>
		<th class="mandatory">서비스 설명</th>
		<td colspan="3"><input type="text" name="srv_detail" size="130"   class="f_input" value="<%=info.getSrv_detail()%>" readonly></td>
	</tr>



</table>

<div class="title_section"><i class="fa fa-home"></i>&nbsp;파라메터 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="20%" />
		 <col width="20%" />
		 <col width="20%" /> 
		 <col width="20%" />
	  </colgroup>

	<tr>
		<th class="mandatory">파라메터 ID</th>
		<th class="mandatory">파라메터 값</th>
		<th class="mandatory">파라메터 설명</th>
		<th class="mandatory">파라메터 타입</th>  
	</tr>
<%
	for(int i=1; i<=parmInfoList.size(); i++ ) {
		Parm_info parm = (Parm_info)parmInfoList.get(i-1); 
%>
	<tr>
		<td ><input type="text" id="parm_id<%=i%>" name="parm_id<%=i%>" size="130"   class="f_input" value="<%=parm.getParm_id()%>" readonly></td>
		<td  ><input type="text" id="parm_val<%=i%>" name="parm_val<%=i%>" size="130"   class="f_input" value="<%=parm.getParm_val()%>" readonly></td> 
		<td ><%=parm.getParm_desc()%></td>
		<td ><%=parm.getParm_tp_nm()%></td>
	</tr>
<%
	} 
%>
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
	      
		}

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>