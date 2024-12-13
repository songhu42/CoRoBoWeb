<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Class_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Class_mstService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat dayFormatter=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	NumberFormat numFormatter = NumberFormat.getNumberInstance();
			
	Class_mstService classService = new Class_mstService(); 
	List<Com_code> classTpList = codeService.selectList("A18");  
	List<Com_code> classStateList = codeService.selectList("A19");  
	String listTitle = ""; 
	String faUserNm = ComUtil.chNull(request.getParameter("faUserNm"));  
	String faClassState = ComUtil.chNull(request.getParameter("faClassState"));   
	 
	listTitle = "수업 리스트"; 
	
	System.out.println(" faUserNm:" + faUserNm + " gCurPageNo:" + gCurPageNo + " ADMIN_ID:" + userId ); 
	
	String whereOption = "WHERE A.ADMIN_ID='" + userId + "' "; 
	if( !faUserNm.equals("") ) whereOption += " AND GET_USER_NMS(A.USER_IDS) LIKE '%" + faUserNm + "%' ";  
	if( !faClassState.equals("") ) whereOption += " AND A.STATE = '" + faClassState + "' ";  

	System.out.println(whereOption); 
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Class_mst> list = classService.selectList(whereOption, page_no, cnt_per_page);  
	int total_cnt =  classService.count(whereOption);
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
													<select name="faClassState" id="faClassState" class="f_select"  >
													<option value="" selected>유형전체</option>
<%
	for(int i=0; i<classStateList.size(); i++ ) {
		Com_code code = (Com_code)classStateList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faClassState.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
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
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editClassMst.jsp');"/>
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
													<th>수업종류</th>
													<th>참여회원</th>
													<th>시작일자</th>
													<th>요일</th>
													<th>시작시간</th>
													<th>종료시간</th>
													<th>회당요금</th>
													<th>등록일</th>
												</tr>
											</thead>
											
										
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Class_mst info = (Class_mst)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openClassMstEdit('<%=info.getClass_id()%>');">
													<td><%=info.getClass_id()%></td>
													<td><%=info.getClass_tp_nm()%></td>
													<td><%=info.getUser_ids_nm()%></td>
													<td><%=dayFormatter.format(info.getStart_dt())%></td>
													<td><%=info.getClass_wds()%></td>
													<td><%=ComUtil.getTimeString(info.getStr_tm())%></td>
													<td><%=ComUtil.getTimeString(info.getEnd_tm())%></td>
													<td><%=numFormatter.format(info.getPrice())%></td>
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
	+ "&faUserNm=" + $("#faUserNm").val() + "&faClassState=" + $("#faClassState").val();  

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