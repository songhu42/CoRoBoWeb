<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Msn_mst"%>
<%@ page import="com.humanval.sipt.dao.Msn_srv"%>
<%@ page import="com.humanval.sipt.dao.Srv_info"%>
<%@ page import="com.humanval.sipt.service.Msn_mstService"%>
<%@ page import="com.humanval.sipt.service.Msn_srvService"%>
<%@ page import="com.humanval.sipt.service.Srv_infoService"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>

<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	Msn_mstService mstService = new Msn_mstService();  
	Srv_infoService srvService = new Srv_infoService();  
	Msn_srvService service = new Msn_srvService();  

	String listTitle = ""; 
	String faMsnId = ComUtil.chUTFString(request.getParameter("faMsnId"));  
	String faSrvSeq = ComUtil.chUTFString(request.getParameter("faSrvSeq"));  
	String listCmd = ComUtil.chUTFString(request.getParameter("listCmd"));  
	
	long msn_id = 0; 
	long srv_seq = 0; 
	if( !faMsnId.equals("") ) msn_id = Long.parseLong(faMsnId); 
	if( !faSrvSeq.equals("") ) srv_seq = Long.parseLong(faSrvSeq); 

	listTitle = "미션 서비스 리스트"; 
	
	System.out.println(" faMsnId:" + faMsnId + " listCmd:" + listCmd ); 
	
	// 미션-서비스 추가 처리 .. 
	if( listCmd.equals("ADD") ) {
		Srv_info srv_info = srvService.select(srv_seq); 
		int sorts = service.count(" WHERE A.MSN_ID = " + faMsnId); 
		System.out.println(" srv_seq:" + srv_seq + " sorts:" + sorts ); 
		Msn_srv msn_srv = new Msn_srv(); 
		msn_srv.setMsn_id(msn_id);
		msn_srv.setSrv_seq(srv_seq);
		msn_srv.setSrv_id(srv_info.getSrv_id()); 
		msn_srv.setSorts(sorts+1); 
		
		service.insert(msn_srv); 
	} else if( listCmd.equals("COPY") ) {
		Msn_mst info = new Msn_mst(); 
		info.setMsn_id(msn_id); 
		
		System.out.println(" Mission copy :" + msn_id ); 
		mstService.msnCopy(info); 
	} else if( listCmd.equals("EXC") ) {
		Msn_mst info = new Msn_mst(); 
		info.setMsn_id(msn_id); 
		
		System.out.println(" Mission Execute :" + msn_id ); 
		mstService.execute(info); 
	}
	
	String whereOption = "WHERE 1=1 "; 

	int page_no = 1;
	int cnt_per_page = 15; 
 
	if( !gCurPageNo.equals("") ) page_no = Integer.parseInt(gCurPageNo); 
	
	List<Msn_mst> mstList = mstService.selectList("");  
	List<Srv_info> srvList = srvService.selectList("");  
	
	List<Msn_srv> list = new ArrayList<Msn_srv>(); 
	int total_cnt =  0;
	int page_cnt = 10; 
	
	if( !faMsnId.equals("") ) {
		whereOption += " AND A.MSN_ID = " + faMsnId + " ";  
		list = service.selectList(whereOption, page_no, cnt_per_page);  
		total_cnt =  service.count(whereOption);
		page_cnt = 1 + total_cnt/cnt_per_page; 
	}
	
%>

<section class="list-wide">
							<div class="content">
								<input type="hidden" id="isLogined" name="isLogined" value="<%=isLogined%>"/> 
								<input type="hidden" id="gCurPageNo" name="gCurPageNo" value="<%=gCurPageNo%>"/> 
								<input type="hidden" id="listCmd" name="listCmd" value=""/> 

									<div class="table-search">
										<table >
											<tbody>
												<tr>
													<td  width="10%" rowspan="1">
													미션명 
													</td>
													<td  width="30%" rowspan="1">
			<select name="faMsnId" id="faMsnId" class="f_select" onchange="javascript:cmdSearch();">
				<option value=""   >미션을 선택하세요.</option>
			<%
			for(int i=0; i<mstList.size(); i++ ) {
				Msn_mst mst = (Msn_mst)mstList.get(i); 
				%>
				<option value="<%=mst.getMsn_id()%>" <%=(msn_id == mst.getMsn_id())?" selected ":"" %> ><%=mst.getMsn_desc()%></option>
			<%}%>		
			</select>
													
													</td>

													<td  width="10%" rowspan="1">
													<input type="button" class="full" value="검색" onclick="javascript:cmdSearch();"/>
													</td>

													<td  width="24%" rowspan="1">
			<select name="faSrvSeq" id="faSrvSeq" class="f_select" >
				<option value=""  >추가할 서비스를 선택하세요.</option>
			<%
			for(int i=0; i<srvList.size(); i++ ) {
				Srv_info srv = (Srv_info)srvList.get(i); 
				%>
				<option value="<%=srv.getSrv_seq()%>"  <%=(srv_seq == srv.getSrv_seq())?" selected ":"" %>  ><%=srv.getSrv_detail()%></option>
			<%}%>		
			</select>
													</td>
													<td  width="8%" rowspan="1">
													<input type="button" class="full" value="서비스 추가" onclick="javascript:cmdAdd();"/>
													</td>
													<td  width="8%" rowspan="1">
													<input type="button" class="full" value="미션 복사" onclick="javascript:cmdCopy();"/>
													</td>
													<td  width="8%" rowspan="1">
													<input type="button" class="full" value="미션 실행" onclick="javascript:cmdExc();"/>
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
													<th>미션ID</th>
													<th>미션명</th> 
													<th>서비스명</th>
													<th>서비스설명</th>
													<th>순번</th>
													<th>등록일</th>
												</tr>
											</thead>
											
											
											<tbody>
<%
	for(int i=0; i<list.size(); i++ ) {
		Msn_srv info = (Msn_srv)list.get(i); 
%>
												<tr class="select-tr" onclick="javascript:openMsnSrvEdit('<%=info.getMsn_seq()%>');">
													<td><%=info.getMsn_id()%></td>
													<td><%=info.getMsn_nm()%></td>
													<td><%=info.getSrv_call()%></td>
													<td><%=info.getSrv_detail()%></td>
													<td><%=info.getSorts()%></td>
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

function cmdAdd() {
	if( $("#faSrvSeq").val() == "" ) {
		alert("추가할 서비스를 선택하세요!"); 
	} else {
		$("#listCmd").val("ADD"); 
		cmdSearch()
	}
}
function cmdExc() {
	if( $("#faMsnId").val() == "" ) {
		alert("실행할 미션을 선택하세요!"); 
	} else {
		$("#listCmd").val("EXC"); 
		cmdSearch()
	}
}
function cmdCopy() {
	if( $("#faMsnId").val() == "" ) {
		alert("복사할 미션을 선택하세요!"); 
	} else {
		$("#listCmd").val("COPY"); 
		cmdSearch()
	}
}

function goSearch() {
	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
			+ "&faMsnId=" + $("#faMsnId").val() + "&faSrvSeq=" + $("#faSrvSeq").val() + "&listCmd=" + $("#listCmd").val() ;  
	
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