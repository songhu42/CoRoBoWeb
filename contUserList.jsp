<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	User_mstService userService = new User_mstService(); 
	List<Com_code> userGradeList = codeService.selectList("A16");  
	String listTitle = ""; 
	String faUserNm = ComUtil.chNull(request.getParameter("faUserNm"));  
	String faUserGrade = ComUtil.chNull(request.getParameter("faUserGrade"));   
	 
	listTitle = "사용자 리스트"; 
	
	System.out.println(" faUserNm:" + faUserNm + " gCurPageNo:" + gCurPageNo + " ADMIN_ID:" + userId ); 
	
	String whereOption = "WHERE C.ADMIN_ID='" + userId + "' "; 
	if( !faUserNm.equals("") ) whereOption += " AND C.USER_NM LIKE '%" + faUserNm + "%' ";  
	if( !faUserGrade.equals("") ) whereOption += " AND C.USER_GRADE = '" + faUserGrade + "' ";  

	System.out.println(whereOption); 
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<User_mst> list = userService.selectList(whereOption, page_no, cnt_per_page);  
	int total_cnt =  userService.count(whereOption);
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
													<select name="faUserGrade" id="faUserGrade" class="f_select"  >
													<option value="" selected>유형전체</option>
<%
	for(int i=0; i<userGradeList.size(); i++ ) {
		Com_code code = (Com_code)userGradeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faUserGrade.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td  width="10%" rowspan="1">
													사용자명
													</td>
													<td  width="10%" rowspan="1">
													<input type="text" name="faUserNm" id="faUserNm" size="6" maxlength="10" class="f_input" value="<%=faUserNm%>">
													</td>

													<td  width="15%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editUserMst.jsp');"/>
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
													<th>ID</th>
													<th>성명</th>
													<th>닉네임</th>
													<th>전화번호</th>
													<th>회원등급</th>
													<th>회원상태</th>
													<th>등록일</th>
												</tr>
											</thead>
											
										
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		User_mst info = (User_mst)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openUserMstEdit('<%=info.getUser_id()%>');">
													<td><%=info.getUser_id()%></td>
													<td><%=info.getUser_nm()%></td>
													<td><%=info.getUser_nic()%></td>
													<td><%=info.getTel_no()%></td>
													<td><%=info.getUser_grade_nm()%></td>
													<td><%=info.getState_nm()%></td>
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
	+ "&faUserNm=" + $("#faUserNm").val() + "&faUserGrade=" + $("#faUserGrade").val();  

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