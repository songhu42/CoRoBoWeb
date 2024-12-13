<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Word_sync_his"%>
<%@ page import="com.humanval.sipt.service.Word_sync_hisService"%>
<%@ page import="com.humanval.sipt.dao.Sync_data_info"%>
<%@ page import="com.humanval.sipt.service.Sync_data_infoService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Word_sync_hisService service = new Word_sync_hisService(); 
	
	String listTitle = ""; 
	String faContents = ComUtil.chNull(request.getParameter("faContents"));  
	String faEng = ComUtil.chNull(request.getParameter("faEng"));  
	String faKor = ComUtil.chNull(request.getParameter("faKor"));  
	String faExeYn = ComUtil.chNull(request.getParameter("faExeYn"), "0");  
	String faCmd = ComUtil.chNull(request.getParameter("faCmd"), "");  
	
	if( faContents.contains("Sync") ) listTitle = "단어 업데이트 리스트"; 
	else listTitle = "동의어 업데이트 리스트"; 
	
	if( faCmd.equals("EXE") ) {
		Sync_data_infoService dataService = new Sync_data_infoService();
		int maxVer = dataService.getNextDbVer(); 

		List<Word_sync_his> hisList = service.selectList("WHERE A.EXE_YN = 0 ORDER BY A.SEQ_NO");  
		for( int i=0; i<hisList.size(); i++ ) {
			Word_sync_his his = hisList.get(i); 
			String sql_str = his.getSql_str(); 
			
			Sync_data_info data = new Sync_data_info(); 
			data.setDb_ver(maxVer); 
			data.setSeq_no(i+1); 
			data.setDb_type(1); // goeg.db - user data (WORD_MST.. )
			data.setSql_str(sql_str); 
			System.out.println("seq : " + data.getSeq_no() + " sql_str : " + data.getSql_str());
			
			// 1. insert to SYNC_DATA_INFO 
			dataService.insert(data);
			
			// 2. history status update .. 
			his.setDb_ver(maxVer); 
			his.setExe_yn(1);
			service.update(his); 
		}
	}
	
	String whereOption = "WHERE 1=1  "; 
	if( !faEng.equals("") ) whereOption += " AND A.SQL_STR LIKE '%" + faEng + "%' ";  
	if( !faKor.equals("") ) whereOption += " AND A.SQL_STR LIKE '%" + faKor + "%' ";  
	whereOption += " AND A.EXE_YN = " + faExeYn + " ";  
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Word_sync_his> list = service.selectList(whereOption, page_no, cnt_per_page);  
	
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
													<td  width="10%" rowspan="1">영어</td>
													<td  width="10%" rowspan="1">
													<input type="text" name="faEng" id="faEng" size="10" maxlength="20" class="f_input" value="<%=faEng%>">
													</td>
													<td  width="10%" rowspan="1">한국어</td>
													<td  width="10%" rowspan="1">
													<input type="text" name="faKor" id="faKor" size="10" maxlength="20" class="f_input" value="<%=faKor%>">
													</td>
													<td width="15%">
													<select name="faExeYn" id="faExeYn" class="f_select"  >
													<option value="0" selected>미적용</option>
													<option value="1" <%=(faExeYn.equals("1")) ? " selected ":"" %>>적용</option>
													</select></td>
													
													<td  width="10%" colspan="1" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>
													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="신규" onclick="javascript:openPopup('<%=faContents%>');"/>
													</td>
													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="실행" onclick="javascript:cmdExecute();"/>
													</td>

												</tr>
											</tbody>
										</table>
									</div>		
												
								<!-- Table -->
									<h3><%=listTitle%></h3>

									<div class="table-wrapper">
										<table >
											<thead>
												<tr>
												<th>등록일</th>
												<th>NO</th>  
												<th>SQL String</th>
												<th>상태</th>
												<th>VER</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Word_sync_his info = (Word_sync_his)list.get(i); 
%>
												<tr class="select-tr" >
													<td width="140px"  ><%=formatter.format(info.getReg_dt())%></td>
													<td width="40px"  ><%=info.getSeq_no()%></td>
													<td width="1000px"  ><%=info.getSql_str()%></td>
													<td width="50px"  ><%=info.getExe_yn()%></td>
													<td width="60px"  ><%=info.getDb_ver()%></td>
												</tr>
<%
	} 
%>

											</tbody>
											<tfoot>
												<tr>
													<td colspan="5">
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
	+ "&faEng=" + $("#faEng").val() + "&faKor=" + $("#faKor").val() 
	+ "&faExeYn=" + $("#faExeYn").val(); 
	
	window.location = "admin.jsp" + params; 
}

function cmdExecute() {
	
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faEng=" + $("#faEng").val() + "&faKor=" + $("#faKor").val() 
	+ "&faExeYn=" + $("#faExeYn").val() + "&faCmd=EXE"; 
	
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