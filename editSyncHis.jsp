<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Word_sync_his"%>
<%@ page import="com.humanval.sipt.service.Word_sync_hisService"%>
<%@ page import="com.humanval.sipt.dao.Word_mst"%>
<%@ page import="com.humanval.sipt.service.Word_mstService"%>
<%@ page import="com.humanval.sipt.dao.Word_sel"%>
<%@ page import="com.humanval.sipt.service.Word_selService"%>
<%@ page import="com.humanval.sipt.service.Sync_data_infoService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
	
	Word_sync_hisService service = new Word_sync_hisService(); 
	Word_mstService mstService = new Word_mstService(); 
	Word_selService selService = new Word_selService(); 
	Word_sync_his info = new Word_sync_his(); 
	Word_mst mst = new Word_mst(); 
	List<Word_mst> mstList = new ArrayList<Word_mst>(); 
	List<Word_sel> selList = new ArrayList<Word_sel>(); 
	
	// set default valid dt after 1 month. 
	Date curDate = new Date(); 
	
	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSeqNo = ComUtil.chNull(request.getParameter("selSeqNo"));
	String faWordId = ComUtil.chNull(request.getParameter("faWordId"));
	String setEng = ComUtil.chNull(request.getParameter("setEng")); 
	String setKor = new String(ComUtil.chNull(request.getParameter("setKor")).getBytes("8859_1"), "UTF-8");

	int cntSel = 0; 
	// '' : Word Select Mode,  E : Word Edit Mode setting,  N : New SQL His Save 
	if( saveAction.equals("E") ) {
		mst = mstService.select(faWordId); 
		setEng = mst.getEng(); 
		setKor = mst.getKor(); 
		
		selList = selService.selectList("WHERE WORD_ID = '" + faWordId + "' ORDER BY SEQ_NO"); 
		cntSel = selList.size(); 
	} if( saveAction.equals("") ) {
		String whereOption = " WHERE 1=1 "; 
		if( !faWordId.equals("") ) whereOption += " AND A.WORD_ID = '" + faWordId + "' "; 
		if( !setEng.equals("") ) whereOption += " AND A.ENG LIKE '%" + setEng + "%' "; 
		if( !setKor.equals("") ) whereOption += " AND A.KOR LIKE '%" + setKor + "%' "; 

		if( !whereOption.equals(" WHERE 1=1 ") ) mstList = mstService.selectList(whereOption); 

	} else if( saveAction.equals("N") ) {
		Sync_data_infoService dataService = new Sync_data_infoService();
		
		String sql_str = ""; 
		
		String kor = ""; 
		
		cntSel = ComUtil.getIntNumber(request.getParameter("cntSel")); 
		for( int i=0; i<cntSel; i++ ) {
			String sel_sql = ""; 
			String sel_kor = new String(ComUtil.chNull(request.getParameter("sel_kor"+i)).getBytes("8859_1"), "UTF-8");
			String sel_seq = ComUtil.chNull(request.getParameter("sel_seq"+i)); 
			String sel_type = ComUtil.chNull(request.getParameter("sel_type"+i)); 
			String sel_div = ComUtil.chNull(request.getParameter("sel_div"+i)); 

			if( sel_div.equals("D") ) {
				sel_sql = "DELETE FROM WORD_SEL WHERE WORD_ID = '" + faWordId + "' AND SEQ_NO = " + sel_seq + ";"; 
			} else if( sel_div.equals("U") ) {
				sel_sql = "UPDATE WORD_SEL SET ENG = '" + setEng + "', KOR = '" + sel_kor + "' WHERE WORD_ID = '" + faWordId + "' AND SEQ_NO = " + sel_seq + ";"; 

				if( !kor.equals("") ) kor += ", "; 
				kor += sel_kor; 
			} else if( sel_div.equals("I") ) {
				sel_sql = "INSERT INTO WORD_SEL(WORD_ID, SEQ_NO, ENG, KOR, TYPE) VALUES('" + faWordId + "', " + sel_seq + ", '" + setEng + "', '" + sel_kor + "', '" + sel_type + "');"; 

				if( !kor.equals("") ) kor += ", "; 
				kor += sel_kor; 
			} else {
				if( !kor.equals("") ) kor += ", "; 
				kor += sel_kor; 
			}
			
			if( !sel_div.equals("") ) {
				dataService.runQuery(sel_sql); 
				
				info = new Word_sync_his(); 
				info.setExe_yn(0); 
				info.setSql_str(sel_sql);
				service.insert(info); 
			}
		}
		
		sql_str = "UPDATE WORD_MST SET ENG = '" + setEng + "', KOR = '" + kor + "' WHERE WORD_ID = '" + faWordId + "';"; 
		dataService.runQuery(sql_str); 
		
		info = new Word_sync_his(); 
		info.setExe_yn(0); 
		info.setSql_str(sql_str);
		service.insert(info); 
		
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
								<h2>단어 업데이트 가등록</h2>
								
<form name="writeform" method="POST"  action="editSyncHis.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSeqNo" id="selSeqNo" value="<%=selSeqNo%>">
<input type="hidden" name="cntSel" id="cntSel" value="<%=cntSel%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;단어 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="20%" />
		 <col width="30%" />
		 <col width="20%" />
		 <col width="30%" />
	  </colgroup>

	<tr>
		<th class="mandatory">Word ID</th>
		<td colspan="1"><input type="text" name="faWordId" id="faWordId" size="10" maxlength="10" class="f_input" value="<%=faWordId%>"  ></td>

		<th class="mandatory">영어</th>
		<td colspan="1"><input type="text" name="setEng" id="setEng" size="20" maxlength="30" class="f_input" value="<%=setEng%>"></td>
	</tr>

	<tr>
		<th class="mandatory">한글</th>
		<td colspan="2"><input type="text" name="setKor" id="setKor" size="20" maxlength="30" class="f_input" value="<%=setKor%>"  ></td>
		<td colspan="1"><input type="button" class="small action" value="검색" onclick="inquiry();"/></td>
	</tr>

<% if( !saveAction.equals("E") ) { %>
	<tr>
		<th>Word ID</th>
		<th>영어</th>
		<th colspan="2">한글</th>
	</tr>

<%
	for(int i=0; i<mstList.size(); i++ ) {
		Word_mst data = (Word_mst)mstList.get(i); 
%>
		<tr class="select-tr" onclick="selectWord('<%=data.getWord_id()%>');">
			<td><%=data.getWord_id()%></td>
			<td><%=data.getEng()%></td>
			<td colspan="2"><%=data.getKor()%></td>
		</tr>
<%
	} 
 } %>

	<tr>
		<th>순번</th>
		<th>한글</th>
		<th>품사</th>
		<th>Mode</th>
	</tr>
	
<%
	for(int i=0; i<selList.size(); i++ ) {
		Word_sel sel = (Word_sel)selList.get(i); 
%>
		<tr class="select-tr" >
			<td><input type="text" name="sel_seq<%=i%>" id="sel_seq<%=i%>" size="5" maxlength="30" class="f_input" value="<%=sel.getSeq_no()%>"  ></td>
			<td><input type="text" name="sel_kor<%=i%>" id="sel_kor<%=i%>" size="20" maxlength="30" class="f_input" value="<%=sel.getKor()%>"  onchange="setDiv('<%=i%>');"></td>
			<td><input type="text" name="sel_type<%=i%>" id="sel_type<%=i%>" size="5" maxlength="30" class="f_input" value="<%=sel.getType()%>"  ></td>
			<td><input type="text" name="sel_div<%=i%>" id="sel_div<%=i%>" size="5" maxlength="30" class="f_input" value=""  ></td>
		</tr>
<%
	} 
%>
		<tr class="select-tr" >
			<td><input type="text" name="sel_seq<%=cntSel%>" id="sel_seq<%=cntSel%>" size="5" maxlength="30" class="f_input" value=""  ></td>
			<td><input type="text" name="sel_kor<%=cntSel%>" id="sel_kor<%=cntSel%>" size="20" maxlength="30" class="f_input" value=""  ></td>
			<td><input type="text" name="sel_type<%=cntSel%>" id="sel_type<%=cntSel%>" size="5" maxlength="30" class="f_input" value=""  ></td>
			<td><input type="text" name="sel_div<%=cntSel%>" id="sel_div<%=cntSel%>" size="5" maxlength="30" class="f_input" value="I"  ></td>
		</tr>
</table>

<div class="admin_button">
<% if( saveAction.equals("E") ) { %>
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
		if( saveAction.equals("N")  ) {
	%>
			alert("저장 되었습니다!"); 

		window.opener.goSearch(); 
		window.close(); 
	<%
	}
	%>
	
})(jQuery);

function check_form(cmd) {
	var form = document.writeform; 
	
	if( cmd == "N" ) {
		var cntSel = $( "#cntSel" ).val();  
		for( var i=0; i<cntSel; i++ ) {
			var sel_seq = $( "#sel_seq"+i ).val();  
			var sel_kor = $( "#sel_kor"+i ).val();  
			var sel_div = $( "#sel_div"+i ).val();  
			var sel_type = $( "#sel_type"+i ).val();  
			
			if( sel_div == "U" ) {
				if( sel_kor == "" ) {
					alert(sel_seq + "번의 수정할 뜻을 입력하세요."); 
					$( "#sel_kor"+i ).focus();  
					return; 
				}
				if( sel_type == "" ) {
					alert(sel_seq + "번의 수정할 품사를 입력하세요."); 
					$( "#sel_type"+i ).focus();  
					return; 
				}
			}
			
		}
		
		// add selCnt if new line is not empty .. 
		 
		if( $( "#sel_seq"+cntSel).val() > 0 ) {
			$( "#cntSel" ).val((Number(cntSel)+1));

			if( $( "#sel_kor"+cntSel).val() == "" ) {
				alert("추가할 뜻의 이름을 입력하세요."); 
				 $( "#sel_kor"+cntSel).focus(); 
				return; 
			}
			if( $( "#sel_type"+cntSel).val() == "" ) {
				alert("추가할 뜻의 품사를 입력하세요."); 
				$( "#sel_type"+cntSel).focus() 
				return; 
			}
		}
		
		form.saveAction.value = cmd; 
		form.submit();
	}
}

function setDiv(ind) {
	var form = document.writeform; 
	var sel_kor = $( "#sel_kor"+ind ).val();  
	var sel_div = $( "#sel_div"+ind );

	if( sel_kor == "" ) sel_div.val("D"); 
	else sel_div.val("U"); 
}

function selectWord(word_id) {
	var form = document.writeform; 
	form.saveAction.value = "E"; 
	form.faWordId.value = word_id; 
	form.submit();
}

function inquiry() {
	var form = document.writeform; 
	form.saveAction.value = ""; 
	form.submit();
}

</script>


	</body>
</html>