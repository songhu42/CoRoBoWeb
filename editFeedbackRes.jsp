<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Feedback_res"%>
<%@ page import="com.humanval.sipt.service.Feedback_resService"%>
<%@ page import="com.humanval.sipt.dao.Board_ann"%>
<%@ page import="com.humanval.sipt.service.Board_annService"%>
<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd hh:mm");
	
	Feedback_resService service = new Feedback_resService(); 
	Feedback_res info = new Feedback_res(); 
	
	// set default valid dt after 1 month. 
	Date curDate = new Date(); 
	
	List<Com_code> resTypeList = codeService.selectList("A07"); 
	List<Com_code> resStList = codeService.selectList("A08"); 

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSeqNo = ComUtil.chNull(request.getParameter("selSeqNo"));
	String selUserId = ComUtil.chNull(request.getParameter("selUserId"));
	String contentStr = ""; 	// 피드백 마스터 내용 
	String resultStr = ""; 	// 피드백 내용 
	String resultContentStr = ""; 	// 개인별 피드백 응답 공지 내용 
	
	
	System.out.println("action : " + saveAction + " selSeqNo : " + selSeqNo + " selUserId : " + selUserId); 
	
	
	// N : New Save, U : Update Save, D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(ComUtil.getLongNumber(selSeqNo), ComUtil.getLongNumber(selUserId)); 
		contentStr = ComUtil.replaceAll(info.getContent(), "\\n", "\n"); 
		resultStr = ComUtil.replaceAll(info.getResult(), "\\n", "\n"); 
		resultContentStr = ComUtil.replaceAll(info.getResult_content(), "\\n", "\n"); 
		if( resultContentStr.equals("") ) resultContentStr = "안녕하세요? 휴먼밸입니다. \n\n많은 애용 부탁드립니다. \n감사합니다."; 
	} else if( !saveAction.equals("") ) {
		long seq_no = ComUtil.getLongNumber(request.getParameter("seq_no"));

		String title = new String(ComUtil.chNull(request.getParameter("title")).getBytes("8859_1"), "UTF-8");
		resultStr = new String(ComUtil.chNull(request.getParameter("result")).getBytes("8859_1"), "UTF-8");

		long user_id = ComUtil.getLongNumber(selUserId); 
		int res_st = ComUtil.getIntNumber(request.getParameter("res_st"));
		String game_type = ComUtil.chNull(request.getParameter("game_type"));
		int res_type = ComUtil.getIntNumber(request.getParameter("res_type"));
		long res_seq = ComUtil.getLongNumber(request.getParameter("res_seq"));
		
		String result = ComUtil.replaceAll(resultStr, "\n", "\\n"); 
		
		resultContentStr = new String(ComUtil.chNull(request.getParameter("result_content")).getBytes("8859_1"), "UTF-8");
		String result_content = ComUtil.replaceAll(resultContentStr, "\r\n", "\\n");
		result_content = ComUtil.replaceAll(result_content, "\r\n", "\\n");
		
		info.setSeq_no(seq_no); 
		info.setUser_id(ComUtil.getLongNumber(selUserId)); 
		info.setRes_type(res_type); 
		info.setRes_seq(res_seq); 
		
		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			if( res_st == 0 ) info.setRes_st(1); 
			service.update(info); 
			
		} else if( saveAction.equals("N") ) {
			info.setRes_st(2);
			
			if( result_content.length() > 5 && user_id > 0  ) {
				Board_annService annService = new Board_annService(); 
				Board_ann ann = new Board_ann(); 
				
				String resTitle = "피드백 답변 안내"; 
				if( result.length() > 5 && result.substring(0,4).equals("단어오류") ) resTitle = "단어오류 제보 처리 결과"; 
				
				ann.setTitle(resTitle); 
				ann.setContent(result_content); 
				ann.setValid_dt(ComUtil.gapDay(curDate, 30)); // 한달후.. 
				ann.setGame_type(game_type); 
				ann.setAnn_type("P"); 
				ann.setUser_id(user_id); 
				ann.setReg_id(1); 
				ann.setIs_popup(1); 
				
				annService.insert(ann); 
				
				long last_seq_no = annService.getLastSeqNo(); 
				info.setRes_st(3); 
				info.setRes_seq(last_seq_no); 
			}
			
			service.update(info); 

		} 
		
		if(!saveAction.equals("D") ) {
			info = service.select(ComUtil.getLongNumber(selSeqNo), ComUtil.getLongNumber(selUserId)); 
			contentStr = ComUtil.replaceAll(info.getContent(), "\\n", "\n"); 
			resultStr = ComUtil.replaceAll(info.getResult(), "\\n", "\n"); 

		}
		
	}
	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>휴먼밸 서비스</title>
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
								<h2>피드백 처리 등록</h2>
								
<form name="writeform" method="POST"  action="editFeedbackRes.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSeqNo" id="selSeqNo" value="<%=selSeqNo%>">
<input type="hidden" name="selUserId" id="selUserId" value="<%=selUserId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;피드백 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="23%" />
		 <col width="10%" />
		 <col width="23%" />
		 <col width="10%" />
		 <col width="23%" />
	  </colgroup>

	<tr>
		<th class="mandatory">순번</th>
		<td colspan="1"><input type="text" name="seq_no" size="20" maxlength="30" class="f_input" value="<%=info.getSeq_no()%>" readonly ></td>

		
		<th class="mandatory">게임</th>
		<td colspan="1"><input type="text" name="game_type" size="20" maxlength="30" class="f_input" value="<%=info.getLogin_type()%>" readonly ></td>

		<th class="mandatory">디바이스</th>
		<td colspan="1"><%=info.getDevice_token()%></td>

	</tr>
	<tr>
		<th class="mandatory">앱버전/디바이스</th>
		<td colspan="5"><%=info.getApp_ver()%></td>
	</tr>

	<tr>
		<th class="mandatory">유저ID</th>
		<td colspan="1"><%=info.getUser_id()%></td>

		<th class="mandatory">유저닉</th>
		<td colspan="1"><%=info.getUser_nic()%></td>
		
		<th class="mandatory">스테이지</th>
		<td colspan="1"><%=info.getStage()%></td>
	</tr>

	<tr>
		<th class="mandatory">등록일</th>
		<td colspan="1"><%=formatter.format(info.getReg_dt())%></td>

		<th class="mandatory">구매액</th>
		<td colspan="1"><%=info.getBuy_tot_amt()%></td>
		
		<th class="mandatory">연령</th>
		<td colspan="1"><%=info.getUser_age_nm()%></td>
	</tr>

	<tr>
		<th class="mandatory">요청제목</th>
		<td colspan="3"><%=info.getTitle()%></td>

		<th class="mandatory">종료일자</th>
		<td colspan="1"><%=formatter.format(info.getValid_dt())%></td>
	</tr>

	<tr>
	<th class="mandatory">피드백 내용</th>
	<td colspan="5"><textarea name="result" cols="72" rows="6" class="f_textarea" readonly ><%=resultStr%></textarea></td>
	</tr>

	<tr>
		<th class="mandatory">피드백종류</th>
		<td colspan="1">
				<select name="res_type" id="res_type" class="f_select">
<%
	for(int i=0; i<resTypeList.size(); i++ ) {
		Com_code code = (Com_code)resTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(code.getCode_id().equals(String.valueOf(info.getRes_type())))?" selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
		
		<th class="mandatory">처리상태</th>
		<td colspan="1">
				<select name="res_st" id="res_st" class="f_select">
<%
	for(int i=0; i<resStList.size(); i++ ) {
		Com_code code = (Com_code)resStList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(String.valueOf(info.getRes_st())))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>		
		<th class="mandatory">순번</th>
		<td colspan="1"><input type="text" name="res_seq" size="20" maxlength="30" class="f_input" value="<%=info.getRes_seq()%>" readonly ></td>
		
	</tr>

	<tr>
	<th class="mandatory">개인별 피드백</th>
	<td colspan="5"><textarea name="result_content" cols="72" rows="5" class="f_textarea"><%=resultContentStr%></textarea></td>
	</tr>


</table>

<div class="admin_button">
<% if( saveAction.equals("E") ) { %>
	<input type="button" id="update_btn" class="small action" value="수정하기" onclick="check_form('U');"/>
	<input type="button" id="delete_btn"  class="small action" value="삭제하기" onclick="check_form('D');"/>
	<input type="button" id="complete_btn"  class="small action" value="완료하기" onclick="check_form('N');"/>
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
			window.opener.goSearch(); 
	<%
		}  else {
		%>
			alert("삭제 되었습니다!"); 
			window.opener.goSearch(); 
			window.close(); 
		<%
		}  
		%>

	<%
	}
	%>
	
})(jQuery);



function check_form(cmd) {
	var form = document.writeform; 
	
	$("#update_btn").prop("disabled", true);
	$("#complete_btn").prop("disabled", true);

	if( cmd == "D" ) {
		if (confirm('정말 삭제 하시겠습니까?')) {
			form.saveAction.value = cmd; 
			form.submit();
       }
	} else { 
		if( form.title.value == "") {
			      alert('제목을 입력하세요!');
			      form.title.focus();
				  	$("#update_btn").prop("disabled", false);
					$("#complete_btn").prop("disabled", false);
			      return false;
			      
		   } else if( form.result.value == "") {
			      alert('컨텐츠 내용을 입력하세요!');
			      form.result.focus();
				  	$("#update_btn").prop("disabled", false);
					$("#complete_btn").prop("disabled", false);
			      return false;
		   }

		if( $("#is_popup").prop("checked") ) $("#is_popupStr").val("checked");  
		else $("#is_popupStr").val("");  

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>