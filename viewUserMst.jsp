<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.User_mst"%>
<%@ page import="com.humanval.sipt.service.User_mstService"%>
<%
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd hh:mm");
	
	User_mstService service = new User_mstService(); 
	User_mst info = new User_mst(); 
	
	// set default valid dt after 1 month. 
	Date curDate = new Date(); 
	
	String saveAction = ComUtil.chNull(request.getParameter("saveAction"));  
	String selUserId = ComUtil.chNull(request.getParameter("selUserId"));
	
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		info = service.select(ComUtil.getLongNumber(selUserId)); 
	}
	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>CoRoBo 서비스 관리</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="휴먼밸, 영단어신, 바이오범프, 철학, 채식" />

		<script src="assets/js/jquery.min.js"></script>
		<script src="assets/js/jquery.modal.js"></script>
		<script src="assets/js/sido.js"></script> 
		<script src="assets/js/hsmutil.js?ver=2"></script> 
			
		<link rel="stylesheet" href="assets/css/main.css" /> 
		<link rel="stylesheet" href="assets/css/jquery.modal.css" /> 
		<link rel="stylesheet" href="assets/css/hsm.css?ver=2" /> 
<script >
</script>
	</head>
	<body class="is-preload popup">
			<section class="wrapper">
					<div class="popup">
						<section class="write">
							<div class="content">
								<h2>사용자 정보 보기</h2>
								
<form name="writeform" method="POST"  action="editFeedbackRes.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selUserId" id="selUserId" value="<%=selUserId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;사용자 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="23%" />
		 <col width="10%" />
		 <col width="23%" />
		 <col width="10%" />
		 <col width="23%" />
	  </colgroup>

	<tr>
		<th class="mandatory">아이디</th>
		<td colspan="1"><input type="text" name="user_id" size="20" maxlength="30" class="f_input" value="<%=info.getUser_id()%>" readonly ></td>

		
		<th class="mandatory">게임</th>
		<td colspan="1"><input type="text" name="game_type" size="20" maxlength="30" class="f_input" value="<%=info.getLogin_type()%>" readonly ></td>

		<th class="mandatory">디바이스</th>
		<td colspan="1"><%=info.getDevice_token()%></td>

	</tr>
	<tr>
		<th class="mandatory">앱버전/디바이스</th>
		<td colspan="5"><%=info.getApp_ver()%></td>
	</tr>

	<tr>
		<th class="mandatory">유저닉</th>
		<td colspan="1"><%=info.getUser_nic()%></td>
		
		<th class="mandatory">스테이지</th>
		<td colspan="1"><%=info.getStage()%></td>

		<th class="mandatory">유저 레벨</th>
		<td colspan="1"><%=info.getUser_lvl()%></td>
	</tr>

	<tr>
		<th class="mandatory">등록일</th>
		<td colspan="1"><%=formatter.format(info.getJoin_dt())%></td>

		<th class="mandatory">구매액</th>
		<td colspan="1"><%=info.getBuy_tot_amt()%></td>
		
		<th class="mandatory">연령</th>
		<td colspan="1"><%=info.getUser_age_nm()%></td>
	</tr>

	<tr>
		<th class="mandatory">맥스하트</th>
		<td colspan="1"><%=ComUtil.getIntFormat(info.getMax_heart_cnt())%></td>

		<th class="mandatory">하트</th>
		<td colspan="1"><%=ComUtil.getIntFormat(info.getHeart_cnt())%></td>
		
		<th class="mandatory">추천인</th>
		<td colspan="1"><%=info.getInvitor_id()%></td>
	</tr>


	<tr>
		<th class="mandatory">다몬</th>
		<td colspan="1"><%=ComUtil.getLongFormat(info.getUser_gold())%></td>

		<th class="mandatory">경험치</th>
		<td colspan="1"><%=ComUtil.getLongFormat(info.getUser_exp())%></td>
		
		<th class="mandatory">착용장비</th>
		<td colspan="1"><%=info.getWp_item()%></td>
	</tr>

	<tr>
		<th class="mandatory">총게임수</th>
		<td colspan="1"><%=ComUtil.getIntFormat(info.getTot_game_cnt())%></td>

		<th class="mandatory">오늘게임수</th>
		<td colspan="1"><%=ComUtil.getIntFormat(info.getCur_game_cnt())%></td>
		
		<th class="mandatory">출석이벤트</th>
		<td colspan="1"><%=info.getEvent_days()%></td>
	</tr>

</table>

<div class="admin_button">
	<input type="button" class="small action" value="닫기" onclick="javascript:window.close();"/> 
</div>

</form>
							</div>

						</section>
						<!-- end write -->
	</div>

</section>						

	</body>
</html>