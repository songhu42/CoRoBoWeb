<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Srv_info"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Srv_infoService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Srv_infoService service = new Srv_infoService();  
	
	String listTitle = ""; 
	String faSrvNm = ComUtil.chUTFString(request.getParameter("faSrvNm"));  
	 
	listTitle = "서비스 정보 리스트"; 
	
	System.out.println(" faSrvNm:" + faSrvNm + " gCurPageNo:" + gCurPageNo ); 
	
	String whereOption = " WHERE 1=1 "; 
	if( !faSrvNm.equals("") ) whereOption += " AND (A.SRV_DETAIL LIKE '%" + faSrvNm + "%' OR C.SRV_NM LIKE '%" + faSrvNm + "%' OR C.SRV_DESC LIKE '%" + faSrvNm + "%' ) ";  
	System.out.println(whereOption); 
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Srv_info> list = service.selectList(whereOption, page_no, cnt_per_page);  
	int total_cnt =  service.count(whereOption);
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
													
													<td  width="10%" rowspan="1">
													서비스명(설명) 
													</td>
													<td  width="10%" rowspan="1">
													<input type="text" name="faSrvNm" id="faSrvNm" size="6" maxlength="10" class="f_input" value="<%=faSrvNm%>">
													</td>

													<td  width="20%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="20%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editSrvInfo.jsp');"/>
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
													<th>서비스 SEQ</th>
													<th>서비스 ID</th>
													<th>서비스명</th>
													<th>서비스 설명</th>
													<th>서비스 상세</th> 
													<th>등록일</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Srv_info info = (Srv_info)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openSrvInfoEdit('<%=info.getSrv_seq()%>');">
													<td><%=info.getSrv_seq()%></td>
													<td><%=info.getSrv_id()%></td>
													<td><%=info.getSrv_nm()%></td>
													<td><%=info.getSrv_desc()%></td>
													<td><%=info.getSrv_detail()%></td> 
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
			+ "&faSrvNm=" + $("#faSrvNm").val() ;  
	
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