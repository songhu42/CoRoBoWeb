<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Buy_history"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Buy_historyService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	DecimalFormat decimalFormat = new DecimalFormat("#,##0");

	Buy_historyService service = new Buy_historyService(); 
	List<Com_code> userAgeList = codeService.selectList("A03"); // 나이대  
	List<Com_code> gameTypeList = codeService.selectList("A13"); 
	List<Com_code> deviceTypeList = codeService.selectList("A14"); 
	List<Com_code> buyTypeList = codeService.selectList("A16"); // Consumable or Non Consumable.. 
		
	String show_col1 = ""; 
	String show_col2 = ""; 
	String show_col3 = ""; 
	String show_col4 = ""; 
	String show_col5 = ""; 
	
	String listTitle = ""; 
	String faBuyType = ComUtil.chNull(request.getParameter("faBuyType"));  
	String faUserAge = ComUtil.chNull(request.getParameter("faUserAge"));  
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faDeviceType = ComUtil.chNull(request.getParameter("faDeviceType"));  
	String faUserId = ComUtil.chNull(request.getParameter("faUserId"));  
	String faStartDt = ComUtil.chNull(request.getParameter("faStartDt"));  
	String faEndDt = ComUtil.chNull(request.getParameter("faEndDt"));  
	String faShowCols = ComUtil.chNull(request.getParameter("faShowCols"));  
	
	if( faShowCols.equals("") ) faShowCols = "01010";  
	if( faShowCols.length() > 0 && faShowCols.substring(0,1).equals("1") ) show_col1 = "checked";  
	if( faShowCols.length() > 1 && faShowCols.substring(1,2).equals("1") ) show_col2 = "checked";  
	if( faShowCols.length() > 2 && faShowCols.substring(2,3).equals("1") ) show_col3 = "checked";  
	if( faShowCols.length() > 3 && faShowCols.substring(3,4).equals("1") ) show_col4 = "checked";  
	if( faShowCols.length() > 4 && faShowCols.substring(4,5).equals("1") ) show_col5 = "checked";  

	listTitle = "인앱구매 리스트"; 
	if( faStartDt.equals("") ) faStartDt = ComUtil.getDateString(ComUtil.gapDay(new Date(), -7)); 
	
	faStartDt = faStartDt.replaceAll("-", ""); 
	faEndDt = faEndDt.replaceAll("-", "");
	
	String whereOption = "WHERE 1=1  "; 
	if( faBuyType.equals("C") ) whereOption += " AND A.ITEM_ID IN ('item102', 'item302', 'item502') ";
	else if( faBuyType.equals("N") ) whereOption += " AND A.ITEM_ID NOT IN ('item102', 'item302', 'item502') ";
	if( !faUserAge.equals("") ) whereOption += " AND C.USER_AGE = " + faUserAge + " ";  
	if( !faGameType.equals("") ) whereOption += " AND C.LOGIN_TYPE = '" + faGameType + "' ";  
	if( !faDeviceType.equals("") ) whereOption += " AND C.DEVICE_TOKEN = '" + faDeviceType + "' ";  
	if( !faUserId.equals("") ) whereOption += " AND A.USER_ID = " + faUserId + " ";  
	if( !faStartDt.equals("") ) whereOption += " AND DATE_FORMAT(A.REG_DT, '%Y%m%d') >= '" + faStartDt + "' ";  
	if( !faEndDt.equals("") ) whereOption += " AND DATE_FORMAT(A.REG_DT, '%Y%m%d') <= '" + faEndDt + "' ";  
	 
			
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Buy_history> list = service.selectList(whereOption, page_no, cnt_per_page);  
	
	int total_cnt =  service.count(whereOption);
	int page_cnt = 1 + total_cnt/cnt_per_page;
 	
	int totalPrice = 0; 
	Buy_history sum = service.selectSum(whereOption); 
	
%>
<section class="list-wide">
							<div class="content">
								<input type="hidden" id="isLogined" name="isLogined" value="<%=isLogined%>"/> 
								<input type="hidden" id="gCurPageNo" name="gCurPageNo" value="<%=gCurPageNo%>"/>  

									<div class="table-search">
										<table >
											<tbody>
												<tr>
													<td width="20%">
													<select name="faBuyType" id="faBuyType" class="f_select"  >
													<option value="A" selected>상태전체</option>
<%
	for(int i=0; i<buyTypeList.size(); i++ ) {
		Com_code code = (Com_code)buyTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faBuyType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td width="20%">
													<select name="faDeviceType" id="faDeviceType" class="f_select"  >
													<option value="" selected>디바이스전체</option>
<%
	for(int i=0; i<deviceTypeList.size(); i++ ) {
		Com_code code = (Com_code)deviceTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faDeviceType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td width="20%">
													<select name="faGameType" id="faGameType" class="f_select"  >
													<option value="" selected>게임전체</option>
<%
	for(int i=0; i<gameTypeList.size(); i++ ) {
		Com_code code = (Com_code)gameTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faGameType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td  width="10%" rowspan="1">
													아이디
													</td>
													
													<td  width="10%" rowspan="1">
													<input type="text" name="faUserId" id="faUserId" size="6" maxlength="10" class="f_input" value="<%=faUserId%>">
													</td>
												</tr>
												
												<tr>
													<td width="20%">
													<select name="faUserAge" id="faUserAge" class="f_select"  >
													<option value="" selected>연령전체</option>
<%
	for(int i=0; i<userAgeList.size(); i++ ) {
		Com_code code = (Com_code)userAgeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faUserAge.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													
													<td  width="20%" rowspan="1">
													구매일자
													</td>
													
													<td  width="40%" colspan="2">
													<input type="text" name="faStartDt" id="faStartDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faStartDt%>"> 
													&nbsp;&nbsp;~&nbsp;&nbsp; 
													<input type="text" name="faEndDt" id="faEndDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faEndDt%>">
													</td>
													
													
													<td  width="10%" rowspan="2">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

												</tr>
												<tr>
													<td colspan="4">
														<input type="checkbox" name="show_col1" value="1" id="show_col1" <%=show_col1%> class="f_input_check" /> <label for="show_col1">유저ID</label>
														<input type="checkbox" name="show_col2" value="1" id="show_col2" <%=show_col2%> class="f_input_check" /> <label for="show_col2">아이템</label>
														<input type="checkbox" name="show_col3" value="1" id="show_col3" <%=show_col3%> class="f_input_check" /> <label for="show_col3">게임</label>
														<input type="checkbox" name="show_col4" value="1" id="show_col4" <%=show_col4%> class="f_input_check" /> <label for="show_col4">디바이스</label>
														<input type="checkbox" name="show_col5" value="1" id="show_col5" <%=show_col5%> class="f_input_check" /> <label for="show_col5">영수증</label>

														<input type="hidden" name="faShowCols" id="faShowCols" value="<%=faShowCols%>">
													</td>
												</tr>

											</tbody>
										</table>
									</div>		
												
								<!-- Table -->
									<h3><%=listTitle%></h3>
									<h4><b><font color=blue> - 총 구매수 : <%=decimalFormat.format(sum.getBuy_cnt())%>&nbsp;&nbsp; - 총 구매금액 : <%=decimalFormat.format(sum.getBuy_tot_amt())%>원&nbsp;&nbsp;</font> </b></h4>
									<div class="table-wrapper">
										<table >
											<thead>
												<tr>
												<th>구매일</th>
												<th>유저닉</th>
<%
	if( !show_col1.equals("") ) out.print("<th>ID</th>");  
	if( !show_col2.equals("") ) out.print("<th>아이템</th>");  
%>
												<th>금액</th>
<% 
	if( !show_col3.equals("") ) out.print("<th>게임</th>");  
	if( !show_col4.equals("") ) out.print("<th>디바이스</th>");  
	if( !show_col5.equals("") ) out.print("<th>영수증</th>");  
%>
												<th>연령</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Buy_history info = (Buy_history)list.get(i); 
		totalPrice += info.getItem_price(); 
%>
												<tr class="select-tr" >
													<td width="140px"><%=formatter.format(info.getReg_dt())%></td>
													<td width="120px"  onclick="javascript:openUserMst('<%=info.getUser_id()%>');" ><%=info.getUser_nic()%></td>
<%
	if( !show_col1.equals("") ) out.print("<td width='80px'>"+info.getUser_id()+"</td>");  
	if( !show_col2.equals("") ) out.print("<td width='100px'>"+info.getItem_id()+"</td>");
%>
													<td width="80px"><%=info.getItem_price()%></td>
<%
	if( !show_col3.equals("") ) out.print("<td width='70px'>"+info.getLogin_type()+"</td>");
	if( !show_col4.equals("") ) out.print("<td width='70px'>"+info.getDevice_token()+"</td>");
	if( !show_col5.equals("") ) out.print("<td width='180px'>"+info.getReceipt_id()+"</td>");
%>
													<td width="60px"><%=info.getUser_age_nm()%></td>
												</tr>
<%
	} 
%>
												<tr class="select-tr" >
													<td colspan="1"></td>
													<td colspan="2">전체 구매금액</td>
													<td colspan="2"><%=totalPrice%></td>
												</tr>

											</tbody>
											<tfoot>
												<tr>
													<td colspan="6">
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
	var faShowCols = "";  
	if( $("#show_col1").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col2").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col3").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col4").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col5").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";

	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faBuyType=" + $("#faBuyType").val() + "&faUserAge=" + $("#faUserAge").val() 
	+ "&faGameType=" + $("#faGameType").val() + "&faDeviceType=" + $("#faDeviceType").val() + "&faUserId=" + $("#faUserId").val() 
	+ "&faStartDt=" + $("#faStartDt").val() + "&faEndDt=" + $("#faEndDt").val() + "&faShowCols=" + faShowCols; 
	
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