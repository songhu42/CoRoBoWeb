<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Srv_info"%>
<%@ page import="com.humanval.sipt.dao.Srv_mst"%>
<%@ page import="com.humanval.sipt.dao.Parm_info"%>
<%@ page import="com.humanval.sipt.service.Srv_infoService"%>
<%@ page import="com.humanval.sipt.service.Srv_mstService"%>
<%@ page import="com.humanval.sipt.service.Parm_infoService"%>
<%
	Srv_infoService service = new Srv_infoService(); 
	Srv_mstService mstService = new Srv_mstService(); 
	Srv_info info = new Srv_info(); 
	Parm_infoService parmService = new Parm_infoService(); 
	
	// request.setCharacterEncoding("utf-8");
	// response.setContentType("text/html;charset=utf-8");

	List<Com_code> srvTypeList = codeService.selectList("A02");  
	List<Com_code> parmTypeList = codeService.selectList("A03");  

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSrvSeq = ComUtil.chNull(request.getParameter("selSrvSeq"));

	System.out.println("action : " + saveAction + " srvTypeList : " + srvTypeList.size() + " selSrvSeq : " + selSrvSeq); 
	List<Parm_info> parmInfoList = new ArrayList<Parm_info>(); 
	
	// 신규 모드일 경우 SRV_MST에서 읽어와 선택할 수 있도록 한다. 
	List<Srv_mst> srvMstList = new ArrayList<Srv_mst>(); 
	if( saveAction.equals("") ) { 
		srvMstList = mstService.selectList(""); 
	}
	
	// N : New Save => Close Window & reload parent
	// U : Update Save => Edit Mode
	// D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(Long.parseLong(selSrvSeq)); 
		parmInfoList = parmService.selectList(" WHERE A.SRV_SEQ = " + selSrvSeq); 

	} else if( !saveAction.equals("") ) {
		long srv_seq = ComUtil.getLongNumber(request.getParameter("srv_seq"));
		long srv_id = ComUtil.getLongNumber(request.getParameter("srv_id"));
		String srv_detail = new String(ComUtil.chNull(request.getParameter("srv_detail")).getBytes("8859_1"), "UTF-8"); 
		String srv_call = ComUtil.chNull(request.getParameter("srv_call"));
		int srv_dur = ComUtil.getIntNumber(request.getParameter("srv_dur"));
		int pre_dur = ComUtil.getIntNumber(request.getParameter("pre_dur"));
		int aft_dur = ComUtil.getIntNumber(request.getParameter("aft_dur"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));

		info.setSrv_seq(srv_seq); 
		info.setSrv_id(srv_id); 
		info.setSrv_detail(srv_detail); 
		info.setSrv_call(srv_call); 
		info.setSrv_dur(srv_dur); 
		info.setPre_dur(pre_dur); 
		info.setAft_dur(aft_dur); 
		info.setSorts(sorts); 
		
		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			service.update(info); 
			int parm_cnt = service.getParmCount(srv_seq);  
			// parameter update ... 

			// parm update commands .. 
			for(int i=1; i<=parm_cnt; i++ ) {
				String parm_id = ComUtil.chNull(request.getParameter("parm_id"+i));
				String parm_val = new String(ComUtil.chNull(request.getParameter("parm_val"+i)).getBytes("8859_1"), "UTF-8");
				
				Parm_info parm = new Parm_info(); 
				parm.setSrv_seq(srv_seq); 
				parm.setParm_id(parm_id); 
				parm.setParm_val(parm_val);  

				System.out.println(" seq : " + srv_seq + " id : " +parm_id + " val : " + parm_val); 
				
				parmService.update(parm); 
			}
		} else if( saveAction.equals("N") ) {
			System.out.println("insert : " + srv_seq + ":" + srv_detail + ":" + srv_dur); 
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
		<link rel="stylesheet" href="assets/css/hsm.css?ver=5" /> 
<script >
</script>
	</head>
	<body class="is-preload popup">
			<section class="wrapper">
					<div class="popup">
						<section class="write">
							<div class="content">
								<h2>서비스 파라메터 등록</h2>
								
<form name="writeform" method="POST"  action="editSrvInfo.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSrvSeq" id="selSrvSeq" value="<%=selSrvSeq%>"> 


<div class="title_section"><i class="fa fa-home"></i>&nbsp;서비스 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="25%" />
		 <col width="25%" />
		 <col width="25%" />
		 <col width="25%" />
	  </colgroup>
	<tr>
		<th class="mandatory">서비스 ID</th>
		<td colspan="1">
		<%if( saveAction.equals("") ) { %>
			<select name="srv_id" id="srv_id" class="f_select" onchange="javascript:setSrvMstInfo();">
				<option value=""   >서비스를 선택하세요.</option>
		<%
			for(int i=0; i<srvMstList.size(); i++ ) {
				Srv_mst mst = (Srv_mst)srvMstList.get(i); 
				%>
				<option value="<%=mst.getSrv_id()%>"   ><%=mst.getSrv_nm()%></option>
			<%}%>		
			</select>
		<% } else { %>
		<input type="text" name="srv_id" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_id()%>" readonly>
		<% } %>
		</td>
		<th class="mandatory">서비스명</th>
		<td colspan="1"><input type="text" id="srv_nm" name="srv_nm" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_nm()%>" readonly></td>
	</tr>

	<tr>
		<th class="mandatory">서비스 설명</th>
		<td colspan="1"><input type="text" id="srv_desc" name="srv_desc" size="130"   class="f_input" value="<%=info.getSrv_desc()%>" readonly></td>
		<th class="mandatory">서비스 SEQ</th>
		<td colspan="1"><input type="text" id="srv_seq" name="srv_seq" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_seq()%>" readonly></td>
	</tr>

	<tr>
		<th class="mandatory">서비스상세설명</th>
		<td colspan="3"><input type="text" id="srv_detail" name="srv_detail" size="130"   class="f_input" value="<%=info.getSrv_detail()%>"></td>
	</tr>

	<tr>
		<th class="mandatory">서비스 호출명</th>
		<td colspan="1"><input type="text" id="srv_call" name="srv_call" size="130"   class="f_input" value="<%=info.getSrv_call()%>"></td>
		<th class="mandatory">서비스 실행시간(ms)</th>
		<td colspan="1"><input type="text" id="srv_dur"  name="srv_dur" size="30" maxlength="30" class="f_input" value="<%=info.getSrv_dur()%>" ></td>
	</tr>

	<tr>
		<th class="mandatory">실행이전 대기시간(ms)</th>
		<td colspan="1"><input type="text" name="pre_dur" size="30" maxlength="30" class="f_input" value="<%=info.getPre_dur()%>" ></td>
		<th class="mandatory">실행이후 대기시간(ms)</th>
		<td colspan="1"><input type="text" name="aft_dur" size="30" maxlength="30" class="f_input" value="<%=info.getAft_dur()%>" ></td>
	</tr>


</table>
<% if(!saveAction.equals("")) { %>
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
		<td  ><input type="text" id="parm_val<%=i%>" name="parm_val<%=i%>" size="130"   class="f_input" value="<%=parm.getParm_val()%>"></td> 
		<td ><%=parm.getParm_desc()%></td>
		<td ><%=parm.getParm_tp_nm()%></td>
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


function setSrvMstInfo() {
	var srv_id = $("#srv_id").val(); 
	console.log("srv_id : " + srv_id); 
	
	$.ajax({
	    url: 'rest/getSrvMst.jsp?srv_id=' + srv_id, 
	    type: 'GET',
	    dataType: 'json',
	    success: function(data) {
	    	console.log("data : " + data); 
	    	
	    	$("#srv_nm").val(data.srv_nm); 
	    	$("#srv_call").val(data.srv_nm); 
	    	$("#srv_desc").val(data.srv_desc); 
	    	$("#srv_detail").val(data.srv_desc); 
	    	$("#srv_tp").val(data.srv_tp); 
	    	$("#srv_dur").val("3000"); 
	    },
	    error: function(xhr, status, error) {
	        console.error('setSrvMstInfo 오류 발생:', error);
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
		if( form.srv_id.value == "" ) {
	      alert('서비스ID를 입력하세요!');
	      form.srv_id.focus();
	      return false;
	      
	   } else if( form.srv_detail.value == "") {
		      alert('서비스 상세설명을 입력하세요!');
		      form.srv_detail.focus();
		      return false;
		      
	   } else if( form.srv_dur.value == "") {
		      alert('서비스 실행시간을 입력하세요!');
		      form.srv_dur.focus();
		      return false;
		      
	   }

		form.saveAction.value = cmd; 
		form.submit();
	}
}


</script>


	</body>
</html>