<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Srv_mst"%>
<%@ page import="com.humanval.sipt.dao.Parm_mst"%>
<%@ page import="com.humanval.sipt.service.Srv_mstService"%>
<%@ page import="com.humanval.sipt.service.Parm_mstService"%>
<%
	Srv_mstService service = new Srv_mstService(); 
	Srv_mst info = new Srv_mst(); 
	Parm_mstService parmService = new Parm_mstService(); 
	
	// request.setCharacterEncoding("utf-8");
	// response.setContentType("text/html;charset=utf-8");

	List<Com_code> srvTypeList = codeService.selectList("A02");  
	List<Com_code> parmTypeList = codeService.selectList("A03");  

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSrvId = ComUtil.chNull(request.getParameter("selSrvId"));

	System.out.println("action : " + saveAction + " srvTypeList : " + srvTypeList.size() + " selSrvId : " + selSrvId); 
	List<Parm_mst> parmMstList = new ArrayList<Parm_mst>();  

	
	// N : New Save => Close Window & reload parent
	// U : Update Save => Edit Mode
	// D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(Long.parseLong(selSrvId)); 
		parmMstList = parmService.selectList(" WHERE A.SRV_ID = " + selSrvId); 

	} else if( !saveAction.equals("") ) {
		long srv_id = ComUtil.getLongNumber(request.getParameter("srv_id"));
		String srv_nm = new String(ComUtil.chNull(request.getParameter("srv_nm")).getBytes("8859_1"), "UTF-8");
		String srv_desc = new String(ComUtil.chNull(request.getParameter("srv_desc")).getBytes("8859_1"), "UTF-8");
		int robo_cnt = ComUtil.getIntNumber(request.getParameter("robo_cnt"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));

		String srv_tp = ComUtil.chNull(request.getParameter("srv_tp"));

		info.setSrv_id(srv_id); 
		info.setSrv_nm(srv_nm); 
		info.setSrv_desc(srv_desc); 
		info.setSrv_tp(srv_tp); 
		info.setSorts(sorts); 
		
		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			service.update(info);  
		} else if( saveAction.equals("N") ) {
			service.insert(info); 
		}  
		
		// parm update commands .. 
		if( saveAction.length() > 1 ) {
			String parm_id = ComUtil.chNull(request.getParameter("parm_id"));
			String parm_desc = new String(ComUtil.chNull(request.getParameter("parm_desc")).getBytes("8859_1"), "UTF-8");
			String parm_tp = ComUtil.chNull(request.getParameter("parm_tp"));
			String def_val = ComUtil.chNull(request.getParameter("def_val"));
			
			Parm_mst parm = new Parm_mst(); 
			parm.setSrv_id(srv_id); 
			parm.setParm_id(parm_id); 
			parm.setParm_desc(parm_desc); 
			parm.setParm_tp(parm_tp); 
			parm.setDef_val(def_val); 
			
			if( saveAction.equals("PI") ) {
				parmService.insert(parm); 
			} else if( saveAction.equals("PU") ) {
				parmService.update(parm); 
			} else if( saveAction.equals("PD") ) {
				parmService.delete(parm); 
			}

			parmMstList = parmService.selectList(" WHERE A.SRV_ID = " + srv_id); 
			saveAction = "E"; 
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
		<link rel="stylesheet" href="assets/css/hsm.css?ver=5" /> 
<script >
</script>
	</head>
	<body class="is-preload popup">
			<section class="wrapper">
					<div class="popup">
						<section class="write">
							<div class="content">
								<h2>어드민 메뉴 등록</h2>
								
<form name="writeform" method="POST"  action="editSrvMst.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSrvId" id="selSrvId" value="<%=selSrvId%>">

<input type="hidden" name="parm_id" id="parm_id" value="">
<input type="hidden" name="parm_desc" id="parm_desc" value="">
<input type="hidden" name="parm_tp" id="parm_tp" value="">
<input type="hidden" name="def_val" id="def_val" value="">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;서비스 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="15%" />
		 <col width="35%" />
		 <col width="15%" />
		 <col width="35%" />
	  </colgroup>

	<tr>
		<th class="mandatory">서비스ID</th>
		<td colspan="1"><input type="text" name="srv_id" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_id()%>" readonly></td>
		<th class="mandatory">서비스명</th>
		<td colspan="1"><input type="text" name="srv_nm" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_nm()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">서비스설명</th>
		<td colspan="3"><input type="text" name="srv_desc" size="130"   class="f_input" value="<%=info.getSrv_desc()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">서비스구분</th>
		<td colspan="1">
				<select name="srv_tp" id="srv_tp" class="f_select">
<%
	for(int i=0; i<srvTypeList.size(); i++ ) {
		Com_code code = (Com_code)srvTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getSrv_tp()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		<th class="mandatory">순서</th>
		<td colspan="1"><input type="text" name="sorts" size="10" maxlength="10" class="f_input" value="<%=info.getSorts()%>"></td>
	</tr>



</table>
<% if( !selSrvId.equals("") && !selSrvId.equals("0")) { %>
<div class="title_section"><i class="fa fa-home"></i>&nbsp;파라메터 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="20%" />
		 <col width="20%" />
		 <col width="20%" /> 
		 <col width="20%" />
		 <col width="20%" />
	  </colgroup>

	<tr>
		<th class="mandatory">파라메터 ID</th>
		<th class="mandatory">파라메터 설명</th>
		<th class="mandatory">파라메터 타입</th>
		<th class="mandatory">디폴트 값</th>
		<th class="mandatory">파라메터 수정</th>
	</tr>
	<tr>
		<td ><input type="text" id="parm_id0" name="parm_id0" size="130"   class="f_input" value=""></td>
		<td ><input type="text" id="parm_desc0" name="parm_desc0" size="130"   class="f_input" value=""></td>
		<td >
			<select name="parm_tp0" id="parm_tp0" class="f_select">
<%
	for(int i=0; i<parmTypeList.size(); i++ ) {
		Com_code code = (Com_code)parmTypeList.get(i); 
%>
				<option value="<%=code.getCode_id()%>" ><%=code.getCode_nm()%></option>
<%}%>
		  	</select>
		</td>
		<td ><input type="text" id="def_val0" name="def_val0" size="130"   class="f_input" value=""></td>
		<td  style="text-align: center;" ><input type="button" class="parm_button small action" value="추가" onclick="check_parm_form('PI', 0);"/></td>
	</tr>
<%
	for(int i=1; i<=parmMstList.size(); i++ ) {
		Parm_mst parm = (Parm_mst)parmMstList.get(i-1); 
%>
	<tr>
		<td ><input type="text" id="parm_id<%=i%>" name="parm_id<%=i%>" size="130"   class="f_input" value="<%=parm.getParm_id()%>" readonly></td>
		<td ><input type="text" id="parm_desc<%=i%>" name="parm_desc<%=i%>" size="130"   class="f_input" value="<%=parm.getParm_desc()%>"></td>
		<td >
			<select name="parm_tp<%=i%>" id="parm_tp<%=i%>" class="f_select">
<%
	for(int j=0; j<parmTypeList.size(); j++ ) {
		Com_code code = (Com_code)parmTypeList.get(j); 
%>
				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(parm.getParm_tp()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  	</select>

		</td>
		<td  ><input type="text" id="def_val<%=i%>" name="def_val<%=i%>" size="130"   class="f_input" value="<%=parm.getDef_val()%>"></td>
		<td style="text-align: center;"  ><input type="button" class="parm_button small action" value="수정" onclick="check_parm_form('PU', <%=i%>);"/> 
		&nbsp;
		<input type="button" class="parm_button small action" value="삭제" onclick="check_parm_form('PD', <%=i%>);"/></td>
	</tr>
<%
	} 
%>
</table>
<% } %>

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
		if( saveAction.equals("X") ) alert_msg = "서비스이 실행 되었습니다!"; 
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
		if( form.srv_id.value == "" ) {
	      alert('서비스ID를 입력하세요!');
	      form.srv_id.focus();
	      return false;
	      
	   } else if( form.srv_nm.value == "") {
		      alert('서비스명을 입력하세요!');
		      form.srv_nm.focus();
		      return false;
		      
	   } else if( form.srv_desc.value == "") {
		      alert('서비스설명을 입력하세요!');
		      form.srv_desc.focus();
		      return false;
		      
	   }

		form.saveAction.value = cmd; 
		form.submit();
	}
}


function check_parm_form(cmd, ind) {
	var form = document.writeform; 
	
	var parm_id = document.getElementById("parm_id"+ind); 
	var parm_desc = document.getElementById("parm_desc"+ind); 
	var parm_tp = document.getElementById("parm_tp"+ind); 
	var def_val = document.getElementById("def_val"+ind); 

	form.parm_id.value = parm_id.value; 
	form.parm_desc.value = parm_desc.value; 
	form.parm_tp.value = parm_tp.value; 
	form.def_val.value = def_val.value; 

	if( cmd == "PD" ) {
		if (confirm('정말 삭제 하시겠습니까?')) {
			form.saveAction.value = cmd; 
			form.submit();
       }
	} else { 
		if( parm_id.value == "" ) {
	      alert('파라메터ID를 입력하세요!');
	      parm_id.focus();
	      return false;
	      
	   } else if( parm_desc.value == "") {
		      alert('파라메터명을 입력하세요!');
		      form.srv_nm.focus();
		      return false;
		      
	   } 

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>