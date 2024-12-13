<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Feedback_res"%>
<%@ page import="com.humanval.sipt.dao.Feedback_sum"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.Feedback_resService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Feedback_resService service = new Feedback_resService(); 
	List<Com_code> resTypeList = codeService.selectList("A07"); 
	List<Com_code> resStList = codeService.selectList("A08"); 
	List<Com_code> userAgeList = codeService.selectList("A03"); 
	List<Com_code> gameTypeList = codeService.selectList("A13"); 
	List<Com_code> deviceTypeList = codeService.selectList("A14"); 
	
	String show_col1 = ""; 
	String show_col2 = ""; 
	String show_col3 = ""; 
	String show_col4 = ""; 
	String show_col5 = ""; 
	String show_col6 = ""; 
	
	String listTitle = ""; 
	String faResType = ComUtil.chNull(request.getParameter("faResType"));  
	String faResSt = ComUtil.chNull(request.getParameter("faResSt"), "0");  
	String faUserAge = ComUtil.chNull(request.getParameter("faUserAge"));  
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faDeviceType = ComUtil.chNull(request.getParameter("faDeviceType"));  
	String faUserId = ComUtil.chNull(request.getParameter("faUserId"));  
	String faStartDt = ComUtil.chNull(request.getParameter("faStartDt"));  
	String faEndDt = ComUtil.chNull(request.getParameter("faEndDt"));  
	String faShowCols = ComUtil.chNull(request.getParameter("faShowCols"));  
	
	if( faShowCols.equals("") ) faShowCols = "010010";  
	if( faShowCols.length() > 0 && faShowCols.substring(0,1).equals("1") ) show_col1 = "checked";  
	if( faShowCols.length() > 1 && faShowCols.substring(1,2).equals("1") ) show_col2 = "checked";  
	if( faShowCols.length() > 2 && faShowCols.substring(2,3).equals("1") ) show_col3 = "checked";  
	if( faShowCols.length() > 3 && faShowCols.substring(3,4).equals("1") ) show_col4 = "checked";  
	if( faShowCols.length() > 4 && faShowCols.substring(4,5).equals("1") ) show_col5 = "checked";  
	if( faShowCols.length() > 5 && faShowCols.substring(5,6).equals("1") ) show_col6 = "checked";  
	
	listTitle = "피드백 리스트"; 
	if( faStartDt.equals("") ) faStartDt = ComUtil.getDateString(ComUtil.gapDay(new Date(), -30)); 
	System.out.println(" faResSt:" + faResSt + " gCurPageNo:" + gCurPageNo ); 
	
	String whereOption = "WHERE A.RES_YN > 0  "; 
	if( !faResType.equals("") ) whereOption += " AND A.RES_TYPE = " + faResType + " ";  
	if( !faResSt.equals("A") ) whereOption += " AND A.RES_ST = " + faResSt + " ";  
	if( !faUserAge.equals("") ) whereOption += " AND C.USER_AGE = " + faUserAge + " ";  
	if( !faGameType.equals("") ) whereOption += " AND C.LOGIN_TYPE = '" + faGameType + "' ";  
	if( !faDeviceType.equals("") ) whereOption += " AND C.DEVICE_TOKEN = '" + faDeviceType + "' ";  
	if( !faUserId.equals("") ) whereOption += " AND A.USER_ID = " + faUserId + " ";  
	if( !faStartDt.equals("") ) whereOption += " AND A.REG_DT >= STR_TO_DATE('" + faStartDt + "','%Y-%m-%d') ";  
	if( !faEndDt.equals("") ) whereOption += " AND A.REG_DT <= STR_TO_DATE('" + faEndDt + "','%Y-%m-%d') ";  
	
	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 

	List<Feedback_res> list = service.selectList(whereOption, page_no, cnt_per_page);  
	
	int total_cnt =  service.count(whereOption);
	int page_cnt = 1 + total_cnt/cnt_per_page;
	

	String whereOption2 = "WHERE RES_YN > 0  "; 
	if( !faStartDt.equals("") ) whereOption2 += " AND REG_DT >= STR_TO_DATE('" + faStartDt + "','%Y-%m-%d') ";  
	if( !faEndDt.equals("") ) whereOption2 += " AND REG_DT <= STR_TO_DATE('" + faEndDt + "','%Y-%m-%d') ";  
	Feedback_sum sum = service.selectFeedbackSum(whereOption2); 
 	
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
													<select name="faResSt" id="faResSt" class="f_select"  >
													<option value="A" selected>상태전체</option>
<%
	for(int i=0; i<resStList.size(); i++ ) {
		Com_code code = (Com_code)resStList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faResSt.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td width="20%">
													<select name="faResType" id="faResType" class="f_select"  >
													<option value="" selected>유형전체</option>
<%
	for(int i=0; i<resTypeList.size(); i++ ) {
		Com_code code = (Com_code)resTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faResType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
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
													피드백일자
													</td>
													
													<td  width="40%" colspan="2">
													<input type="text" name="faStartDt" id="faStartDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faStartDt%>"> 
													&nbsp;&nbsp;~&nbsp;&nbsp; 
													<input type="text" name="faEndDt" id="faEndDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faEndDt%>">
													</td>
													
													
													<td  width="10%" colspan="2" rowspan="2">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

												</tr>
												<tr>
													<td colspan="4">
														<input type="checkbox" name="show_col1" value="1" id="show_col1" <%=show_col1%> class="f_input_check" /> <label for="show_col1">유저ID</label>
														<input type="checkbox" name="show_col2" value="1" id="show_col2" <%=show_col2%> class="f_input_check" /> <label for="show_col2">유저닉</label>
														<input type="checkbox" name="show_col3" value="1" id="show_col3" <%=show_col3%> class="f_input_check" /> <label for="show_col3">게임</label>
														<input type="checkbox" name="show_col4" value="1" id="show_col4" <%=show_col4%> class="f_input_check" /> <label for="show_col4">디바이스</label>
														<input type="checkbox" name="show_col5" value="1" id="show_col5" <%=show_col5%> class="f_input_check" /> <label for="show_col5">연령대</label>
														<input type="checkbox" name="show_col6" value="1" id="show_col6" <%=show_col6%> class="f_input_check" /> <label for="show_col6">구매액</label>

														<input type="hidden" name="faShowCols" id="faShowCols" value="<%=faShowCols%>">
													</td>
												</tr>
																							
											</tbody>
										</table>
									</div>		
												
								<!-- Table -->
									<h3><%=listTitle%></h3>
									<h4><b><font color=green>좋아요 : <%=sum.getLike_cnt()%>(<%=(100*sum.getLike_cnt()/sum.getTot_cnt()) %>%)</font> 
										게임성 : <%=sum.getGame_cnt()%>(<%=(100*sum.getGame_cnt()/sum.getTot_cnt()) %>%) 
										<font color=blue>학습 : <%=sum.getStudy_cnt()%>(<%=(100*sum.getStudy_cnt()/sum.getTot_cnt()) %>%) </font>
										하트/다몬 : <%=sum.getHeart_cnt()%>(<%=(100*sum.getHeart_cnt()/sum.getTot_cnt()) %>%) 
										<font color=violet>개선/건의 : <%=sum.getReq_cnt()%>(<%=(100*sum.getReq_cnt()/sum.getTot_cnt()) %>%) </font>
										<font color=red>오류 : <%=sum.getError_cnt()%>(<%=(100*sum.getError_cnt()/sum.getTot_cnt()) %>%) </font>
										기타 : <%=sum.getEtc_cnt()%>(<%=(100*sum.getEtc_cnt()/sum.getTot_cnt()) %>%) 
										총 <%=total_cnt%>개</b></h4>
									<div class="table-wrapper">
										<table >
											<thead>
												<tr>
												<th>등록일</th>
<%
	if( !show_col1.equals("") ) out.print("<th>ID</th>");  
	if( !show_col2.equals("") ) out.print("<th>유저닉</th>");  
	if( !show_col3.equals("") ) out.print("<th>게임</th>");  
	if( !show_col4.equals("") ) out.print("<th>장비</th>");  
	if( !show_col5.equals("") ) out.print("<th>연령</th>");  
	if( !show_col6.equals("") ) out.print("<th>구매</th>");  
%>
<th>내용</th>  
<th>분류</th>
<th>상태</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Feedback_res info = (Feedback_res)list.get(i); 
%>
												<tr class="select-tr" >
													<td width="140px"  onclick="javascript:openUserMst('<%=info.getUser_id()%>');"><%=formatter.format(info.getReg_dt())%>
													
													</td>

<%
	if( !show_col1.equals("") ) out.print("<td width='40px'>"+info.getUser_id()+"</td>");  
	if( !show_col2.equals("") ) out.print("<td width='100px'>"+info.getUser_nic()+"</td>");
	if( !show_col3.equals("") ) out.print("<td width='60px'>"+info.getLogin_type()+"</td>");
	if( !show_col4.equals("") ) out.print("<td width='60px'>"+info.getDevice_token()+"</td>");
	if( !show_col5.equals("") ) out.print("<td width='60px'>"+info.getUser_age_nm()+"</td>");
	if( !show_col6.equals("") ) out.print("<td width='60px'>"+info.getBuy_tot_amt()+"</td>");
	%>
	<td width='1000px' onclick="javascript:openFeedbackResEdit('<%=info.getSeq_no()%>', '<%=info.getUser_id()%>');"><%=info.getResult()%></td>
	
<td width='140px'>
				<select name="res_type<%=i%>" id="res_type<%=i%>" class="f_select_line">
<%
	for(int j=0; j<resTypeList.size(); j++ ) {
		Com_code code = (Com_code)resTypeList.get(j); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(code.getCode_id().equals(String.valueOf(info.getRes_type())))?" selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
		  		</select>

</td>
<td width='130px'>
				<select name="res_st<%=i%>" id="res_st<%=i%>" class="f_select_line" onchange="javascript:saveResTypeNow(<%=info.getSeq_no()%>, <%=info.getUser_id()%>, <%=i%>);" >
<%
	for(int j=0; j<resStList.size(); j++ ) {
		Com_code code = (Com_code)resStList.get(j); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(code.getCode_id().equals(String.valueOf(info.getRes_st())))?" selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
		  		</select>

</td>

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
	var faShowCols = "";  
	if( $("#show_col1").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col2").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col3").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col4").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col5").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	if( $("#show_col6").prop("checked") ) faShowCols = faShowCols + "1"; else faShowCols = faShowCols + "0";
	
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faResType=" + $("#faResType").val() + "&faResSt=" + $("#faResSt").val() + "&faUserAge=" + $("#faUserAge").val() 
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