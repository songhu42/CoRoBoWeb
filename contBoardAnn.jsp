<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Board_ann"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Board_annService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Board_annService menuService = new Board_annService(); 
	List<Com_code> annTypeList = codeService.selectList("A12"); 
	List<Com_code> gameTypeList = codeService.selectList("A13"); 
	
	String listTitle = ""; 
	String faAnnType = ComUtil.chNull(request.getParameter("faAnnType"));  
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faUserId = ComUtil.chNull(request.getParameter("faUserId"));  
	String faValidYn = ComUtil.chNull(request.getParameter("faValidYn"));  
	 
	listTitle = "공지사항 리스트"; 
	
	System.out.println(" faAnnType:" + faAnnType + " gCurPageNo:" + gCurPageNo ); 
	
	String whereOption = "WHERE 1=1 "; 
	if( !faAnnType.equals("") ) whereOption += " AND A.ANN_TYPE = '" + faAnnType + "' ";  
	if( !faGameType.equals("") ) whereOption += " AND A.GAME_TYPE = '" + faGameType + "' ";  
	if( !faUserId.equals("") ) whereOption += " AND A.USER_ID = " + faUserId + " ";  
	if( !faValidYn.equals("") ) whereOption += " AND A.VALID_DT > NOW() ";  

	System.out.println(whereOption); 
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Board_ann> list = menuService.selectList(whereOption, page_no, cnt_per_page);  
	int total_cnt =  menuService.count(whereOption);
	int page_cnt = 1 + total_cnt/cnt_per_page; 

 	
%>

<section class="list-wide">
							<div class="content">
								<input type="hidden" id="isLogined" name="isLogined" value="<%=isLogined%>"/> 
								<input type="hidden" id="gCurPageNo" name="gCurPageNo" value="<%=gCurPageNo%>"/>  

									<div class="table-search">
										<table >
											<tbody>
												<tr>
													<td width="17%">
													<select name="faAnnType" id="faAnnType" class="f_select"  >
													<option value="" selected>유형전체</option>
<%
	for(int i=0; i<annTypeList.size(); i++ ) {
		Com_code code = (Com_code)annTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faAnnType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													<td width="18%">
													<select name="faGameType" id="faGameType" class="f_select"  >
													<option value="" selected>게임전체</option>
<%
	for(int i=0; i<gameTypeList.size(); i++ ) {
		Com_code code = (Com_code)gameTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=("faGameType".equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td  width="10%" rowspan="1">
													아이디
													</td>
													<td  width="10%" rowspan="1">
													<input type="text" name="faUserId" id="faUserId" size="6" maxlength="10" class="f_input" value="<%=faUserId%>">
													</td>
													<td  width="20%" rowspan="1">
													<input type="checkbox" name="check_valid" value="1" id="check_valid" <%=faValidYn%>  /> <label for="check_valid">유효공지</label>
													</td>

													<td  width="15%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editBoardAnn.jsp');"/>
													</td>
												</tr>
																							
											</tbody>
										</table>
									</div>		
												
								<!-- Table -->
									<h3><%=listTitle%></h3>
									<h4> 총 <%=total_cnt%>개</h4>
									<div class="table-wrapper">
										<table >
											<thead>
												<tr>
													<th>순번</th>
													<th>종류</th>
													<th>제목</th>
													<th>유효일</th>
													<th>게임</th>
													<th>유저ID</th>
													<th>등록일</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Board_ann info = (Board_ann)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openBoardAnnEdit('<%=info.getSeq_no()%>');">
													<td><%=info.getSeq_no()%></td>
													<td><%=info.getAnn_type_nm()%></td>
													<td><%=info.getTitle()%></td>
													<td><%=formatter.format(info.getValid_dt())%></td>
													<td><%=info.getGame_type()%></td>
													<td><%=info.getUser_id()%></td>
													<td><%=formatter.format(info.getReg_dt())%></td>  
												</tr>
<%
	} 
%>

											</tbody>
											<tfoot>
												<tr>
													<td colspan="9">
<%
	int firstPage = Math.max(1, page_no-3);
	int lastPage = Math.min(page_cnt, page_no + 3); 
	if( firstPage > 1 ) {	
%>													
													<a href='javascript:goPage(<%=page_no-4%>);' class='pre'><img src="./img/arrow_left.png"  /></a>
<%
	}
%>													
<%
	for( int i=firstPage; i<=lastPage; i++ ) {
		if( i == page_no ) {
%>													
													<strong><%=i%></strong>
<%
		} else {
%>
													<a href='javascript:goPage(<%=i%>);'><%=i%></a>
<%
		}
	}
%>													
<%
	if( page_cnt > page_no + 3 ) {
%>													

													<a href='javascript:goPage(<%=page_no+4%>);' class='next'><img src="./img/arrow_right.png"/></a>
<%
	}
%>													
													
													</td> 
												</tr>
											</tfoot>
										</table>
									</div>
							</div>
						</section>
						
						
<script>
function goPage(page) {
	$("#gCurPageNo").val(page); 
	goSearch(); 
}

function cmdSearch() {
	$("#gCurPageNo").val(1); 
	goSearch(); 
}

function goSearch() {
	var faValidYn = "";  
	if( $("#check_valid").prop("checked") ) faValidYn = "checked";  

	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faAnnType=" + $("#faAnnType").val() + "&faGameType=" + $("#faGameType").val() + "&faUserId=" + $("#faUserId").val() + "&faValidYn=" + faValidYn;  

	window.location = "admin.jsp" + params; 
}

(function($) {

	var isLog = $( "#isLogined" ).val();  

	if( isLog == "false" ) {
		window.location = "login.jsp"; 
	}

	// sessionStorage recovery.. 
	//var faReqSt = sessionStorage.getItem('faReqSt'); 
	//if( faReqSt != null && faReqSt != "" ) {
	//	$("#f_req_st").val(faReqSt); 
	//}
})(jQuery);


</script>
	</body>
</html>