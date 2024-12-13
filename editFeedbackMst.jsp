<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Feedback_mst"%>
<%@ page import="com.humanval.sipt.service.Feedback_mstService"%>
<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
	
	Feedback_mstService service = new Feedback_mstService(); 
	Feedback_mst info = new Feedback_mst(); 
	
	// set default valid dt after 1 month. 
	Date curDate = new Date(); 
	info.setValid_dt(ComUtil.gapDay(curDate, 30)); 
	
	List<Com_code> gameTypeList = codeService.selectList("A13"); 

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSeqNo = ComUtil.chNull(request.getParameter("selSeqNo"));
	String contentStr = ""; 
	String is_delStr = ""; 
	System.out.println("action : " + saveAction + " selSeqNo : " + selSeqNo + " valid : " + info.getValid_dt()); 
	
	
	// N : New Save, U : Update Save, D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(ComUtil.getLongNumber(selSeqNo)); 
		contentStr = ComUtil.replaceAll(info.getContent(), "\\n", "\n"); 
		if( info.getDel_yn() == 1 ) is_delStr = "checked"; 
	} else if( !saveAction.equals("") ) {
		long seq_no = ComUtil.getLongNumber(request.getParameter("seq_no"));

		String title = new String(ComUtil.chNull(request.getParameter("title")).getBytes("8859_1"), "UTF-8");
		contentStr = new String(ComUtil.chNull(request.getParameter("content")).getBytes("8859_1"), "UTF-8");
		Date valid_dt = ComUtil.getDate(request.getParameter("valid_dt"));
		String game_type = ComUtil.chNull(request.getParameter("game_type"));

		String target = ComUtil.chNull(request.getParameter("target"));
		int cont_limit = ComUtil.getIntNumber(request.getParameter("cont_limit"));
		int heart_cnt = ComUtil.getIntNumber(request.getParameter("heart_cnt"));
		int damon_cnt = ComUtil.getIntNumber(request.getParameter("damon_cnt"));
		is_delStr = ComUtil.chNull(request.getParameter("is_delStr"));
		
		String content = ComUtil.replaceAll(contentStr, "\r\n", "\\n"); 
		content = ComUtil.replaceAll(content, "\n", "\\n"); 

		info.setSeq_no(seq_no); 
		info.setTitle(title); 
		info.setContent(content); 
		info.setValid_dt(valid_dt); 
		info.setGame_type(game_type); 
		info.setTarget(target); 
		info.setCont_limit(cont_limit); 
		info.setHeart_cnt(heart_cnt); 
		info.setDamon_cnt(damon_cnt); 
		info.setReg_id(1); 
		if( is_delStr.equals("") ) info.setDel_yn(0); 
		else info.setDel_yn(1); 

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
								<h2>피드백 등록</h2>
								
<form name="writeform" method="POST"  action="editFeedbackMst.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSeqNo" id="selSeqNo" value="<%=selSeqNo%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;메뉴 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="25%" />
		 <col width="10%" />
		 <col width="20%" />
		 <col width="10%" />
		 <col width="25%" />
	  </colgroup>

	<tr>
		<th class="mandatory">순번</th>
		<td colspan="1"><input type="text" name="seq_no" size="30" maxlength="30" class="f_input" value="<%=info.getSeq_no()%>" readonly ></td>
		<th class="mandatory">게임구분</th>
		<td colspan="3">
				<select name="game_type" id="game_type" class="f_select">
<%
	for(int i=0; i<gameTypeList.size(); i++ ) {
		Com_code code = (Com_code)gameTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getGame_type()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>
	</tr>
	<tr>
		<th class="mandatory">유효일자</th>
		<td colspan="1"><input type="text" name="valid_dt" size="10" maxlength="10" class="f_input" value="<%=formatter.format(info.getValid_dt())%>"></td>
		<td colspan="2">
			<input type="checkbox" name="is_del" value="1" id="is_del" <%=is_delStr%>  /> <label for="is_del">삭제여부</label>
			<input type="hidden" name="is_delStr" id="is_delStr" value="<%=is_delStr%>">
		</td>
		<th class="mandatory">최소글자수</th>
		<td colspan="1"><input type="text" name="cont_limit" size="30" maxlength="30" class="f_input" value="<%=info.getCont_limit()%>"  ></td>
	</tr>

	<tr>
		<th class="mandatory">피드백 제목</th>
		<td colspan="5"><input type="text" name="title" size="30" maxlength="30" class="f_input" value="<%=info.getTitle()%>"></td>
	</tr>

	<tr>
	<th class="mandatory">공지내용</th>
	<td colspan="5"><textarea name="content" cols="72" rows="10" class="f_textarea"><%=contentStr%></textarea></td>
	</tr>
	<tr>
		<th class="mandatory">타겟유저</th>
		<td colspan="1"><input type="text" name="target" size="30" maxlength="30" class="f_input" value="<%=info.getTarget()%>"  ></td>
		<th class="mandatory">보상하트</th>
		<td colspan="1"><input type="text" name="heart_cnt" size="30" maxlength="30" class="f_input" value="<%=info.getHeart_cnt()%>"  ></td>
		<th class="mandatory">보상다몬</th>
		<td colspan="1"><input type="text" name="damon_cnt" size="30" maxlength="30" class="f_input" value="<%=info.getDamon_cnt()%>"  ></td>
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
		if( form.title.value == "") {
			      alert('제목을 입력하세요!');
			      form.title.focus();
			      return false;
			      
		   } else if( form.content.value == "") {
			      alert('컨텐츠 내용을 입력하세요!');
			      form.content.focus();
			      return false;
		   }

		if( $("#is_del").prop("checked") ) $("#is_delStr").val("checked");  
		else $("#is_delStr").val("");  

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>