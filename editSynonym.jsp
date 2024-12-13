<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Word_sync_his"%>
<%@ page import="com.humanval.sipt.service.Word_sync_hisService"%>
<%@ page import="com.humanval.sipt.dao.Word_synonym"%>
<%@ page import="com.humanval.sipt.service.Word_synonymService"%>
<%@ page import="com.humanval.sipt.service.Sync_data_infoService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
	
	Word_sync_hisService service = new Word_sync_hisService(); 
	Word_synonymService mstService = new Word_synonymService(); 

	Word_sync_his info = new Word_sync_his(); 
	Word_synonym mst = new Word_synonym(); 
	List<Word_synonym> mstList = new ArrayList<Word_synonym>(); 
	
	// set default valid dt after 1 month. 
	Date curDate = new Date(); 
	
	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selSeqNo = ComUtil.chNull(request.getParameter("selSeqNo"));
	int faSeqNo = ComUtil.getIntNumber(request.getParameter("faSeqNo"));

	String setKor = new String(ComUtil.chNull(request.getParameter("setKor")).getBytes("8859_1"), "UTF-8");

	String whereOption = " WHERE 1=1 "; 
	if( faSeqNo > 0 ) whereOption += " AND A.SEQ_NO = " + faSeqNo + " "; 
	if( !setKor.equals("") ) whereOption += " AND ( A.KOR1 LIKE '%" + setKor + "%' OR A.KOR2 LIKE '%" + setKor + "%' OR A.KOR3 LIKE '%" + setKor + "%' OR A.KOR4 LIKE '%" + setKor 
			+ "%' OR A.KOR5 LIKE '%" + setKor + "%' OR A.KOR6 LIKE '%" + setKor+ "%' OR A.KOR7 LIKE '%" + setKor + "%' ) "; 

	if( !whereOption.equals(" WHERE 1=1 ") ) mstList = mstService.selectList(whereOption); 

	if( saveAction.equals("N") ) {
		Sync_data_infoService dataService = new Sync_data_infoService();
		
		String sql_str = ""; 
		
		String seq_no = ComUtil.chNull(request.getParameter("seq_no"));
		String kor1 = new String(ComUtil.chNull(request.getParameter("kor1")).getBytes("8859_1"), "UTF-8");
		String kor2 = new String(ComUtil.chNull(request.getParameter("kor2")).getBytes("8859_1"), "UTF-8");
		String kor3 = new String(ComUtil.chNull(request.getParameter("kor3")).getBytes("8859_1"), "UTF-8");
		String kor4 = new String(ComUtil.chNull(request.getParameter("kor4")).getBytes("8859_1"), "UTF-8");
		String kor5 = new String(ComUtil.chNull(request.getParameter("kor5")).getBytes("8859_1"), "UTF-8");
		String kor6 = new String(ComUtil.chNull(request.getParameter("kor6")).getBytes("8859_1"), "UTF-8");
		String kor7 = new String(ComUtil.chNull(request.getParameter("kor7")).getBytes("8859_1"), "UTF-8");
		String sel_div = ComUtil.chNull(request.getParameter("sel_div"));

		if( sel_div.equals("D") ) {
			sql_str = "DELETE FROM WORD_SYNONYM WHERE SEQ_NO = " + seq_no + ";"; 
		} else if( sel_div.equals("U") ) {
			sql_str = "UPDATE WORD_SYNONYM SET KOR1 = '" + kor1 + "', KOR2 = '" + kor2 + "', KOR3 = '" + kor3 + "', KOR4 = '" + kor4 + "', KOR5 = '" + kor5 + "', KOR6 = '" + kor6 + "', KOR7 = '" + kor7 
					+ "' WHERE SEQ_NO = " + seq_no + ";"; 
		} else if( sel_div.equals("I") ) {
			int next_seq = mstService.getNextSeq();
			sql_str = "INSERT INTO WORD_SYNONYM(SEQ_NO, KOR1, KOR2, KOR3, KOR4, KOR5, KOR6, KOR7) VALUES(" + next_seq + ", '"+ kor1 + "', '" + kor2 + "', '" + kor3 + "', '" + kor4 + "', '" + kor5 + "', '" + kor6 + "', '" + kor7 + "');"; 
		} 
		
		if( !sel_div.equals("") ) {
			dataService.runQuery(sql_str); 
			
			info = new Word_sync_his(); 
			info.setExe_yn(0); 
			info.setSql_str(sql_str);
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
								<h2>동의어 업데이트 가등록</h2>
								
<form name="writeform" method="POST"  action="editSynonym.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selSeqNo" id="selSeqNo" value="<%=selSeqNo%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;동의어 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
		 <col width="10%" />
	  </colgroup>

	<tr>
		<td colspan="2"><input type="text" name="faSeqNo" id="faSeqNo" size="10" maxlength="10" class="f_input" value="<%=faSeqNo%>"  ></td>
		<td colspan="3"><input type="text" name="setKor" id="setKor" size="10" maxlength="30" class="f_input" value="<%=setKor%>"  ></td>
		<td colspan="4"><input type="button" class="small action" value="검색" onclick="inquiry();"/></td>
	</tr>

	<tr>
		<th>SEQ</th>
		<th>kor1</th>
		<th>kor2</th>
		<th>kor3</th>
		<th>kor4</th>
		<th>kor5</th>
		<th>kor6</th>
		<th>kor7</th>
		<th>Mode</th>
	</tr>

<%
	for(int i=0; i<mstList.size(); i++ ) {
		Word_synonym data = (Word_synonym)mstList.get(i); 
%>
		<tr class="select-tr" onclick="selectWord('<%=i%>');">
			<td><input type="text" name="seq_no<%=i%>" id="seq_no<%=i%>" size="5" maxlength="30" class="f_input" value="<%=data.getSeq_no()%>" readonly ></td>
			<td><input type="text" name="kor1_<%=i%>" id="kor1_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor1()%>" readonly ></td>
			<td><input type="text" name="kor2_<%=i%>" id="kor2_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor2()%>" readonly ></td>
			<td><input type="text" name="kor3_<%=i%>" id="kor3_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor3()%>" readonly ></td>
			<td><input type="text" name="kor4_<%=i%>" id="kor4_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor4()%>" readonly ></td>
			<td><input type="text" name="kor5_<%=i%>" id="kor5_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor5()%>" readonly ></td>
			<td><input type="text" name="kor6_<%=i%>" id="kor6_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor6()%>" readonly ></td>
			<td><input type="text" name="kor7_<%=i%>" id="kor7_<%=i%>" size="10" maxlength="30" class="f_input" value="<%=data.getKor7()%>" readonly ></td>
			<td></td>
		</tr>
<%
 } %>

		<tr class="select-tr" >
			<td><input type="text" name="seq_no" id="seq_no" size="5" maxlength="30" class="f_input" value="" readonly ></td>
			<td><input type="text" name="kor1" id="kor1" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor2" id="kor2" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor3" id="kor3" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor4" id="kor4" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor5" id="kor5" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor6" id="kor6" size="10" maxlength="30" class="f_input" value="" ></td>
			<td><input type="text" name="kor7" id="kor7" size="10" maxlength="30" class="f_input" value="" ></td>

			<td><input type="text" name="sel_div" id="sel_div" size="5" maxlength="30" class="f_input" value="I"  ></td>

		</tr>
</table>

<div class="admin_button">
	<input type="button" class="small action" value="등록하기" onclick="check_form('N');"/>
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
	<%
	}
	%>
	
})(jQuery);

function check_form(cmd) {
	var form = document.writeform; 
	
	if( cmd == "N" ) {
		var seq_no = $( "#seq_no" ).val();  
		var sel_div = $( "#sel_div" ).val();  

		if( $( "#kor1" ).val() == "" ) {
			alert("동의어를 입력하세요."); 
			$( "#kor1" ).focus();  
			return; 
		}
		if( $( "#kor2" ).val() == "" ) {
			alert("동의어를 입력하세요."); 
			$( "#kor2" ).focus();  
			return; 
		}
				
		
		form.saveAction.value = cmd; 
		form.submit();
	}
}

function selectWord(ind) {
	$( "#seq_no" ).val($( "#seq_no"+ind ).val()); 
	$( "#kor1" ).val($( "#kor1_"+ind ).val());  
	$( "#kor2" ).val($( "#kor2_"+ind ).val());  
	$( "#kor3" ).val($( "#kor3_"+ind ).val());  
	$( "#kor4" ).val($( "#kor4_"+ind ).val());  
	$( "#kor5" ).val($( "#kor5_"+ind ).val());  
	$( "#kor6" ).val($( "#kor6_"+ind ).val());  
	$( "#kor7" ).val($( "#kor7_"+ind ).val());  
	$( "#sel_div" ).val("U");  
}

function inquiry() {
	var form = document.writeform; 
	form.saveAction.value = ""; 
	form.submit();
}

</script>


	</body>
</html>