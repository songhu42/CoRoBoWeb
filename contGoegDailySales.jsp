<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.DailySales"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.service.DailySalesService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	DecimalFormat numFormat = new DecimalFormat("#,###,###");

	DailySalesService service = new DailySalesService(); 
	List<Com_code> gameTypeList = codeService.selectList("A13"); 
	List<Com_code> deviceTypeList = codeService.selectList("A14"); 
	
	String listTitle = ""; 
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faDeviceType = ComUtil.chNull(request.getParameter("faDeviceType"));  
	String faStartDt = ComUtil.chNull(request.getParameter("faStartDt"));  
	
	if( faStartDt.equals("") ) faStartDt = ComUtil.getDateString(ComUtil.gapDay(new Date(), -30)); 
	listTitle = "일별 매출현황"; 
	
	System.out.println(" faStartDt:" + faStartDt + " faGameType:" + faGameType ); 
	
	// make sumup if necessary.. 
	String curDate = ComUtil.getDateString(new Date(), ""); 
	service.sumupDailySales(curDate, true); 
	
	String whereOption = "WHERE DATE >= " + faStartDt.replaceAll("-", ""); 
	if( !faGameType.equals("") ) whereOption += " AND GAME_TYPE = '" + faGameType + "' ";  
	if( !faDeviceType.equals("") ) whereOption += " AND DEVICE_TYPE = '" + faDeviceType + "' ";  
	
	List<DailySales> list = service.selectListDesc(whereOption);  	
%>
<section class="list-wide">
							<div class="content">
								<input type="hidden" id="isLogined" name="isLogined" value="<%=isLogined%>"/> 
								<input type="hidden" id="gCurPageNo" name="gCurPageNo" value="1"/>  

									<div class="table-search">
										<table >
											<tbody>
												<tr>
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
													
													<td  width="15%" >
													시작일
													</td>
													
													<td  width="15%" >
													<input type="text" name="faStartDt" id="faStartDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faStartDt%>"> 
													</td>
													
													
													<td  width="20%" rowspan="2">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

												</tr>
																							
											</tbody>
										</table>
									</div>		
												
								<!-- Table -->
									<h3><%=listTitle%></h3>
									<h4><b></b></h4>
									<div class="table-wrapper">
										<table >
											<thead>
												<tr>
												<th>일자</th>
												<th>가입자수</th>  
												<th>구매수</th>
												<th>구매액</th>
												<th>광고수</th>
												<th>게임유저</th>  
												<th>총게임수</th>
												<th>공유전체</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	int newUserSum = 0; 
	int buyCntSum = 0; 
	long buyAmtSum = 0; 
	int advCntSum = 0; 
	int gameUserSum = 0; 
	int gameCntSum = 0; 
	int shareTotSum = 0; 
	
	int curDayWeek = ComUtil.getDayOfWeek(new Date()); 

	for(int i=0; i<list.size(); i++ ) {
		DailySales info = (DailySales)list.get(i);

		if( i > 0 && info.getWeekday() == curDayWeek ) {
			
	%>
				<tr class="select-tr sumup" >
					<td>주간합계</td>
					<td><%=numFormat.format(newUserSum)%></td>
					<td><%=numFormat.format(buyCntSum)%></td>
					<td><%=numFormat.format(buyAmtSum)%></td>
					<td><%=numFormat.format(advCntSum)%></td>
					<td><%=numFormat.format(gameUserSum)%></td>
					<td><%=numFormat.format(gameCntSum)%></td>
					<td><%=numFormat.format(shareTotSum)%></td>
				</tr>
	<%
			newUserSum = 0; 
			buyCntSum = 0; 
			buyAmtSum = 0; 
			advCntSum = 0; 
			gameUserSum = 0; 
			gameCntSum = 0; 
			shareTotSum = 0; 
		}		
%>
			<tr class="select-tr" >
				<td><%=info.getMon()%>월 <%=info.getDay()%>일</td>
				<td><%=numFormat.format(info.getNew_user())%></td>
				<td onclick="javascript:openInApp('<%=info.getDate()%>');"><%=numFormat.format(info.getBuy_cnt())%></td>
				<td onclick="javascript:openInApp('<%=info.getDate()%>');"><%=numFormat.format(info.getBuy_amt())%></td>
				<td><%=numFormat.format(info.getAdv_cnt())%></td>
				<td><%=numFormat.format(info.getGame_user())%></td>
				<td><%=numFormat.format(info.getGame_cnt())%></td>
				<td><%=numFormat.format(info.getShare_tot())%></td>
			</tr>
<%
	newUserSum += info.getNew_user(); 
	buyCntSum += info.getBuy_cnt(); 
	buyAmtSum += info.getBuy_amt(); 
	advCntSum += info.getAdv_cnt(); 
	gameUserSum += info.getGame_user(); 
	gameCntSum += info.getGame_cnt(); 
	shareTotSum += info.getShare_tot(); 

	} 
%>

											</tbody>
											<tfoot>

											</tfoot>
										</table>
									</div>
							</div>
						</section>
						
						
<script>

function cmdSearch() {
	goSearch(); 
}

function goSearch() {
	
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faGameType=" + $("#faGameType").val() + "&faDeviceType=" + $("#faDeviceType").val()  
	+ "&faStartDt=" + $("#faStartDt").val(); 
	
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