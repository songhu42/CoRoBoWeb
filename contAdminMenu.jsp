<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Admin_menu"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Admin_menuService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Admin_menuService menuService = new Admin_menuService(); 
	List<Admin_menu> menuGrpList = menuService.selectGroupList("");  
	
	String listTitle = ""; 
	String faGrpNm = ComUtil.chUTFString(request.getParameter("faGrpNm"));  
	 
	listTitle = "어드민 메뉴 리스트"; 
	
	System.out.println(" faGrpNm:" + faGrpNm + " gCurPageNo:" + gCurPageNo ); 
	
	String whereOption = "WHERE 1=1 "; 
	if( !faGrpNm.equals("") ) whereOption += " AND A.GRP_NM LIKE '%" + faGrpNm + "%' ";  

	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Admin_menu> list = menuService.selectList(whereOption, page_no, cnt_per_page);  
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
													<td width="60%">
													<select name="faGrpNm" id="faGrpNm" class="f_select"  >
													<option value="" selected>전체그룹</option>
<%
	for(int i=0; i<menuGrpList.size(); i++ ) {
		Admin_menu code = (Admin_menu)menuGrpList.get(i); 
%>
				  				<option value="<%=code.getGrp_nm()%>" <%=(faGrpNm.equals(code.getGrp_nm())) ? " selected ":"" %>><%=code.getGrp_nm()%></option>
<%}%>
													</select></td>

													<td  width="20%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="20%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editAdminMenu.jsp');"/>
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
													<th>그룹</th>
													<th>메뉴ID</th>
													<th>메뉴명</th>
													<th>컨텐츠구분</th>
													<th>사용권한</th>
													<th>장소구분</th>
													<th>등록일</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Admin_menu info = (Admin_menu)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openAdminMenuEdit('<%=info.getMenu_id()%>');">
													<td><%=info.getGrp_nm()%></td>
													<td><%=info.getMenu_id()%></td>
													<td><%=info.getMenu_nm()%></td>
													<td><%=info.getCont_type_nm()%></td>
													<td><%=info.getAuth_level_nm()%></td>
													<td><%=info.getOpen_area_nm()%></td>
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
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
			+ "&faGrpNm=" + $("#faGrpNm").val() ;  
	
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