<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Feedback_mst"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Feedback_mstService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Feedback_mstService menuService = new Feedback_mstService(); 
	List<Com_code> gameTypeList = codeService.selectList("A13"); 
	
	String listTitle = ""; 
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faValidYn = ComUtil.chNull(request.getParameter("faValidYn"));  

	listTitle = "피드백 게시 리스트"; 
	
	String whereOption = "WHERE 1=1 "; 
	if( !faGameType.equals("") ) whereOption += " AND A.GAME_TYPE = '" + faGameType + "' ";  
	if( !faValidYn.equals("") ) whereOption += " AND A.DEL_YN = 0 ";  

	System.out.println(whereOption); 
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Feedback_mst> list = menuService.selectList(whereOption, page_no, cnt_per_page);  
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
													
													<td  width="20%" rowspan="1">
													<input type="checkbox" name="check_valid" value="1" id="check_valid" <%=faValidYn%>  /> <label for="check_valid">유효공지</label>
													</td>

													<td  width="15%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('editFeedbackMst.jsp');"/>
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
													<th>제목</th>
													<th>유효일</th>
													<th>게임</th>
													<th>타겟유저</th>
													<th>제한글자수</th>
													<th>보상하트</th>
													<th>보상다몬</th>
													<th>등록일</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Feedback_mst info = (Feedback_mst)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openFeedbackMstEdit('<%=info.getSeq_no()%>');">
													<td><%=info.getSeq_no()%></td>
													<td><%=info.getTitle()%></td>
													<td><%=formatter.format(info.getValid_dt())%></td>
													<td><%=info.getGame_type()%></td>
													<td><%=info.getTarget()%></td>
													<td><%=info.getCont_limit()%></td>
													<td><%=info.getHeart_cnt()%></td>
													<td><%=info.getDamon_cnt()%></td>
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
	  + "&faGameType=" + $("#faGameType").val() + "&faValidYn=" + faValidYn;  

	window.location = "admin.jsp" + params; 
}

(function($) {

	var isLog = $( "#isLogined" ).val();  

	if( isLog == "false" ) {
		window.location = "login.jsp"; 
	}

})(jQuery);


</script>
	</body>
</html>