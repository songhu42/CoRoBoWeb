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
	List<Com_code> graphTypeList = codeService.selectList("A15"); 
	
	String listTitle = ""; 
	String faGameType = ComUtil.chNull(request.getParameter("faGameType"));  
	String faDeviceType = ComUtil.chNull(request.getParameter("faDeviceType"));  
	String faGraphType = ComUtil.chNull(request.getParameter("faGraphType"));  
	String faStartDt = ComUtil.chNull(request.getParameter("faStartDt"));  
	
	if( faGraphType.equals("") ) faGraphType = "M"; 
	if( faStartDt.equals("") ) faStartDt = ComUtil.getDateString(ComUtil.gapDay(new Date(), -30)); 
	listTitle = "일별 매출현황"; 
	
	System.out.println(" faStartDt:" + faStartDt + " faGameType:" + faGameType ); 
	String startDt = ComUtil.getDateStringWest(ComUtil.getDate(faStartDt)); 
	
	// make sumup if necessary.. 
	String curDate = ComUtil.getDateString(new Date(), ""); 
	service.sumupDailySales(curDate, true); 
	
	String whereOption = "WHERE DATE >= " + faStartDt.replaceAll("-", ""); 
	if( !faGameType.equals("") ) whereOption += " AND GAME_TYPE = '" + faGameType + "' ";  
	if( !faDeviceType.equals("") ) whereOption += " AND DEVICE_TYPE = '" + faDeviceType + "' ";  

	List<DailySales> list = service.selectList(whereOption);  
	
	int showCount = 5; 
	
	if( faGraphType.equals("M") ) showCount=4; 
	else if( faGraphType.equals("H") ) showCount=2; 

	StringBuffer[] sb = new StringBuffer[showCount]; 
	for( int j=0; j<showCount; j++ ) sb[j] = new StringBuffer(); 
	
	if( faGraphType.equals("L") ) {
		sb[0].append("\"buy_cnt\": { \"label\":\"구매수\", \"data\":[");
		sb[1].append("\"share_fb\": { \"label\":\"페북공유\", \"data\":[");
		sb[2].append("\"share_cacao\": { \"label\":\"카톡공유\", \"data\":[");
		sb[3].append("\"share_story\": { \"label\":\"카스공유\", \"data\":[");
		sb[4].append("\"feedback_cnt\": { \"label\":\"피드백\", \"data\":[");

	} else if( faGraphType.equals("M") ) {
		sb[0].append("\"new_user\": { \"label\":\"신규유저\", \"data\":["); 
		sb[1].append("\"adv_cnt\": { \"label\":\"광고수\", \"data\":["); 
		sb[2].append("\"game_user\": { \"label\":\"게임유저\", \"data\":["); 
		sb[3].append("\"share_tot\": { \"label\":\"공유전체\", \"data\":[");

	} else if( faGraphType.equals("H") ) {
		sb[0].append("\"buy_amt\": { \"label\":\"구매액\", \"data\":[");
		sb[1].append("\"game_cnt\": { \"label\":\"게임수\", \"data\":[");
	}
	
	for( int i=0; i<list.size(); i++ ) {
		DailySales sales = (DailySales)list.get(i); 
		if( i > 0 ) {
			for( int j=0; j<showCount; j++ ) sb[j].append(","); 
		}
		int day = sales.getYear()*10000 + sales.getMon() *100 + sales.getDay(); 
		// String day = "\"" + sales.getMon() + "/" + sales.getDay() + "/" + sales.getYear() + "\"";

		if( faGraphType.equals("L") ) {
			sb[0].append("[" + day + "," + sales.getBuy_cnt() + "]" ); 
			sb[1].append("[" + day + "," + sales.getShare_fb() + "]" ); 
			sb[2].append("[" + day + "," + sales.getShare_cacao() + "]" ); 
			sb[3].append("[" + day + "," + sales.getShare_story() + "]" ); 
			sb[4].append("[" + day + "," + sales.getFeedback_cnt() + "]" ); 

		} else if( faGraphType.equals("M") ) {
			sb[0].append("[" + day + "," + sales.getNew_user() + "]" ); 
			sb[1].append("[" + day + "," + sales.getAdv_cnt() + "]" ); 
			sb[2].append("[" + day + "," + sales.getGame_user() + "]" ); 
			sb[3].append("[" + day + "," + sales.getShare_tot() + "]" ); 

		} else if( faGraphType.equals("H") ) {
			sb[0].append("[" + day + "," + sales.getBuy_amt() + "]" ); 
			sb[1].append("[" + day + "," + sales.getGame_cnt() + "]" ); 
		}
			
	}
	for( int j=0; j<showCount; j++ ) sb[j].append("]}");
	
	StringBuffer sbSet = new StringBuffer();
	sbSet.append("{");
	sbSet.append(sb[0].toString()); 
	for( int j=1; j<showCount; j++ ) sbSet.append("," + sb[j].toString()); 
	sbSet.append("}"); 
	
	
%>
	<link href="./assets/css/flot.css" rel="stylesheet" type="text/css">
	<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="./flot/excanvas.min.js"></script><![endif]-->
	<script type="text/javascript" src="./flot/jquery.flot.js"></script>
	<script type="text/javascript">

	function addDays(date, days) {
		  var result = new Date(date);
		  result.setDate(result.getDate() + days);
		  return result;
	}
	
	function convertDate(d) {
		var startDt = <%=startDt%>;
		var curYear = Math.floor(d/10000);
		var md = d%10000; 
		var curMon = Math.floor(md/100); 
		var curDay = md%100; 
		var date1 = new Date(startDt);
		var date2 = new Date("" + curMon + "/" + curDay + "/" + curYear);
		var timeDiff = Math.abs(date2.getTime() - date1.getTime());
		var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
		return diffDays + 1; 
	}

	function inverseDate(gap) {
		var startDt = <%=startDt%>;

		var date1 = new Date(startDt);
		var date2 = addDays(date1, gap-1); 
		
		return date2.getFullYear() * 10000 + date2.getMonth()*100 + date2.getDate();
		
	}
	
	$(function() {
	
		var datasets = JSON.parse('<%=sbSet.toString()%>'); 

		// hard-code color indices to prevent them from shifting as countries are turned on/off
		var i = 0;
		$.each(datasets, function(key, val) {
			val.color = i;
			++i;
		});

		// insert checkboxes 
		var choiceContainer = $("#choices");
		$.each(datasets, function(key, val) {
			choiceContainer.append("<br/><input type='checkbox' name='" + key +
				"' checked='checked' id='id" + key + "'></input>" +
				"<label for='id" + key + "'>"
				+ val.label + "</label>");
		});

		choiceContainer.find("input").click(plotAccordingToChoices);

		var plot; 
		
		function plotAccordingToChoices() {

			var data = [];
			choiceContainer.find("input:checked").each(function () {
				var key = $(this).attr("name");
				if (key && datasets[key]) {
					data.push(datasets[key]);
				}
			});

			if (data.length > 0) {
				plot = $.plot("#placeholder", data, {
					series: {
						lines: {
							show: true
						},
						points: {
							show: true
						}
					},
					grid: {
						hoverable: true,
						clickable: true
					},
					yaxis: {
						min: 0
					},
					xaxis: {
						tickDecimals: 0 
						, transform: convertDate
						, inverseTransform:inverseDate
						// , mode:"time"
					}
				});
			}
		}
		
		plotAccordingToChoices();

	
		$("#tooltip").hide();
		
		$("#placeholder").bind("plothover", function (event, pos, item) {
			if (item) {
				var x = item.datapoint[0].toFixed(0),
					y = item.datapoint[1].toFixed(0);
	
				$("#tooltip").html(item.series.label + " : " + y + " /" + x)
					.css({top: item.pageY-54, left: item.pageX+20})
					.fadeIn(200);
			} else {
				$("#tooltip").hide();
			}
		});
		
		$("#placeholder").bind("plotclick", function (event, pos, item) {
			if (item) {
				plot.highlight(item.series, item.datapoint);
			} else {
				plot.unhighlight();
			}
		});
	});

	</script>
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
													<td width="15%">
													<select name="faGraphType" id="faGraphType" class="f_select"  >
<%
	for(int i=0; i<graphTypeList.size(); i++ ) {
		Com_code code = (Com_code)graphTypeList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>" <%=(faGraphType.equals(code.getCode_id())) ? " selected ":"" %>><%=code.getCode_nm()%></option>
<%}%>
													</select></td>
													
													<td  width="10%" >
													시작일
													</td>
													
													<td  width="10%" >
													<input type="text" name="faStartDt" id="faStartDt" size="20" maxlength="20" style="width:100px;" class="f_input_date" value="<%=faStartDt%>"> 
													</td>
													
													
													<td  width="15%" rowspan="2">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

												</tr>
																							
											</tbody>
										</table>
									</div>
											
		<div class="demo-container">
			<div id="placeholder" class="demo-placeholder" style="float:left; "></div>
			<p id="choices" style="float:right; width:135px;"></p>
			<div id="tooltip"></div>
		</div>												

							</div>
						</section>
						
						
<script>

function cmdSearch() {
	goSearch(); 
}

function goSearch() {
	
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faGameType=" + $("#faGameType").val() + "&faDeviceType=" + $("#faDeviceType").val() + "&faGraphType=" + $("#faGraphType").val()  
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