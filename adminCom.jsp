<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	Com_codeService codeService = new Com_codeService(); 
	
	String group_id = ComUtil.chNull(request.getParameter("group_id"));
	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 

	System.out.println("action : " + saveAction); 
	
	// 전부 지우고 다시하는 경우가 있어서 하드 코딩함.. 
	String group_nm = ""; 
	if( group_id.equals("A01") ) group_nm = "요양원분류"; 
	else if( group_id.equals("A02") ) group_nm = "매매분류";
	else if( group_id.equals("A03") ) group_nm = "구분";
	else if( group_id.equals("A04") ) group_nm = "컨설팅분류";

	// N : New Code Save
	// U : Update All Data
	// D : Delete by delete_code 
	
	if( saveAction.equals("D") ) {
		Com_code code = new Com_code(); 
		code.setGroup_id(group_id); 

		String delete_id = ComUtil.chNull(request.getParameter("delete_id"));
		code.setCode_id(delete_id); 

		codeService.delete(code);
		
	} else if( saveAction.equals("U") ) {
		List<Com_code> preList = codeService.selectList(group_id); 
		for(int i=0; i<preList.size(); i++ ) {
			Com_code code = (Com_code)preList.get(i); 

			String code_id = ComUtil.chNull(request.getParameter("code_id"+i));
			String code_nm = ComUtil.chNull(request.getParameter("code_nm"+i));
			int sorts = ComUtil.getIntNumber(request.getParameter("sorts"+i));
			
			code.setCode_id(code_id); 
			code.setCode_nm(code_nm); 
			code.setSorts(sorts); 
			
			codeService.update(code);
		}
		
	} else if( saveAction.equals("N") ) {
		Com_code code = new Com_code(); 
		code.setGroup_id(group_id); 
		code.setGroup_nm(group_nm); 
		String code_id = ComUtil.chNull(request.getParameter("code_id"));
		String code_nm = ComUtil.chNull(request.getParameter("code_nm"));
		int sorts = ComUtil.getIntNumber(request.getParameter("sorts"));
		
		
		code.setCode_id(code_id); 
		code.setCode_nm(code_nm); 
		code.setSorts(sorts); 

		codeService.insert(code); 
		
	}
	
	List<Com_code> comList = codeService.selectList(group_id); 

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
		<script src="assets/js/hsmutil.js?ver=2""></script> 
			
		<link rel="stylesheet" href="assets/css/main.css" /> 
		<link rel="stylesheet" href="assets/css/hsm.css?ver=2" /> 
<script >
</script>
	</head>
	<body class="is-preload popup">
			<section class="wrapper">
					<div class="popup adminPop">
						<section class="write">
							<div class="content">
								<h2><%=group_nm%> 관리</h2>
								
<form name="writeform" method="POST"  action="adminCom.jsp">				
<input type="hidden" name="group_id"  id="group_id" value="<%=group_id%>">
<input type="hidden" name="saveAction" id="saveAction" value="">
<input type="hidden" name="delete_id" id="delete_id" value="">

	<table  class="table_form">
		<colgroup>
			 <col width="20%" />
			 <col width="40%" />
			 <col width="20%" />
			 <col width="20%" />
		  </colgroup>

		<tr>
		<th>코드</th>
		<th><%=group_nm%> 명</th>
		<th>순번</th>
		<th>추가/삭제</th>
		</tr>
<%
	String max_code = ""; 
	int max_sorts = 0;  
	for(int i=0; i<comList.size(); i++ ) {
		Com_code code = (Com_code)comList.get(i); 
		max_code = code.getCode_id(); 
		if( max_sorts < code.getSorts() ) max_sorts = code.getSorts(); 
%>
		<tr>
		<td ><input type="text" name="code_id<%=i %>" id="code_id<%=i %>"  class="f_input" value="<%=code.getCode_id()%>"></td>
		<td ><input type="text" name="code_nm<%=i %>"  id="code_nm<%=i %>"  class="f_input" value="<%=code.getCode_nm()%>"></td>
		<td ><input type="text" name="sorts<%=i %>"  id="sorts<%=i %>"  class="f_input" value="<%=code.getSorts()%>"></td>
		<td ><input type="button" class="small action" value="삭제" onclick="delete_com('<%=code.getCode_id()%>');"/></td>
		</tr>
<%
	}
	if( max_code.equals("") ) max_code = "A01"; 
	else {
		int max_ind = Integer.parseInt(max_code.substring(1)) + 1; 
		if( max_ind > 9 ) max_code = "A" + max_ind; 
		else max_code = "A0" + max_ind; 
	}
%>
		<tr>
		<td ><input type="text" name="code_id" id="code_id"  class="f_input" value="<%=max_code%>"></td>
		<td ><input type="text" name="code_nm"  id="code_nm"  class="f_input" value=""></td>
		<td ><input type="text" name="sorts"  id="sorts"  class="f_input" value="<%=(max_sorts+1)%>"></td>
		<td ><input type="button" class="small action" value="추가" onclick="check_form('N');"/></td>
		</tr>
	</table>


<div class="admin_button">
	<input type="button" class="small action" value="저장하기" onclick="check_form('U');"/>
	<input type="button" class="small action" value="닫기" onclick="javascript:window.close();"/> 
</div>

</form>
							</div>

						</section>
						<!-- end write -->
	</div>

</section>						
			
		
<script>

function check_form(cmd) {
	var form = document.writeform; 
	if( form.code_nm.value == "" && cmd == "N") {
		alert("추가하실 항목명을 입력하세요."); 
		form.code_nm.focus(); 
		return false; 
	} else {
		form.saveAction.value = cmd; 
		form.submit();
	}

}


function delete_com(id) {
	var form = document.writeform; 
	
	if (confirm('정말 삭제 하시겠습니까?')) {
		form.saveAction.value = "D"; 
		form.delete_id.value = id; 
		form.submit();
      }

}

</script>


	</body>
</html>