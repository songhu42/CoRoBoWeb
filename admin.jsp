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

	String authString = " 'U' ";
	System.out.println("authLevel : " + authLevel); 
	
	
	if( authLevel.equals("O") ) authString = " 'U', 'O' ";
	else if( authLevel.equals("M") ) authString = " 'U', 'O', 'M' ";
	else if( authLevel.equals("S") ) authString = " 'U', 'O', 'M', 'S' ";
	
	String whereOption = " WHERE A.AUTH_LEVEL IN (" + authString + ") ";

	List<Admin_menu> menuList = menuService.selectList(whereOption);  
	Admin_menu curMenu = null; 
	String menuTitle = "CoRoBo 서비스 관리자"; 
	
	if( "".equals(gCurMenuId) ) {
		if( menuList.size() > 0 ) {
			curMenu = menuList.get(0); 
			gCurMenuId = curMenu.getMenu_id(); 
		}
	} else {
		curMenu = menuService.select(gCurMenuId); 
	}
	if( curMenu != null ) menuTitle = curMenu.getMenu_nm(); 
	
	// for checking user has auth this menu ..   
	whereOption += " AND A.MENU_ID = '" + gCurMenuId + "' ";
 	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>CoRoBo 서비스 관리</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="CoRoBo 서비스, ROS2, Python, Robot" />
		<link rel="shortcut icon" type="image/x-icon" href="./favicon.ico" />
		<link rel="icon" href="./favicon-152.png?v=1">


		<!-- <script src="assets/js/jquery.min.js"></script> --> 
		<script type="text/javascript" src="./flot/jquery.js"></script>
		<script type="text/javascript" src="./flot/jquery-ui.js"></script>
		
		<script src="assets/js/hsmutil.js?ver=5"></script> 
		<link rel="stylesheet" href="assets/css/common.css?ver=2" /> 
		<link rel="stylesheet" href="assets/css/main.css" /> 
		<link rel="stylesheet" href="assets/css/hsm.css?ver=6" /> 
		
<script type="text/javascript">

</script>
	</head>
	
	<body class="is-preload">
		<!-- Header -->
			<header id="header">
				<h3 class="menuTitle"><%=menuTitle%></h3>
				
				
				<!--모바일 메뉴-->
				<nav>
				<div class="m-header">
					<div class="m-hd">
						<button type="button" class="m-hd-hamburger js-hamburger-open"></button>
					</div>
				</div>
			
				<div class="m-gnb">
					<button type="button" class="m-hd-close js-hamburger-close"></button>
			
					<ol class="m-gnb-menu">
<%
for(int i=0; i<menuList.size(); i++ ) {
	Admin_menu menu = (Admin_menu)menuList.get(i); 
	
	boolean isSelected = false;  
	if( gCurMenuId.equals(menu.getMenu_id()) ) isSelected = true; 
	
	String titleStr = ""; 
	if( !isSelected ) titleStr = menu.getMenu_nm() + "</a>"; 
	else titleStr = "<font color='green'>" + menu.getMenu_nm() + "</font></a>";
	
	String linkStr = "";
	String parmStr = "gCurMenuId=" + menu.getMenu_id(); 
	if( menu.getOpen_area().equals("C") ) {
		linkStr = "<a href=\"javascript:goMenu('admin.jsp?" + parmStr + "');\">" + titleStr; 
	} else {
		linkStr = "<a href=\"javascript:openPopup('admin.jsp?" + parmStr + "');\">" + titleStr; 
	}
	
%>
				<li><%=linkStr%></li>
<%
}
%>					
						<%if (isLogined) {%>
						<li><a href="javascript:goLogout();">로그아웃</a></li>
						<%}%>
								
					</ol>
				</div>
				
				<div class="m-gnb-bg js-hamburger-close"></div>
				</nav>
			</header>
			
		<!-- Nav -->
			<nav id="menu">
				<ul class="links">
<%
for(int i=0; i<menuList.size(); i++ ) {
	Admin_menu menu = (Admin_menu)menuList.get(i); 
	
	boolean isSelected = false;  
	if( gCurMenuId.equals(menu.getMenu_id()) ) isSelected = true; 
	
	String titleStr = ""; 
	if( !isSelected ) titleStr = menu.getMenu_nm() + "</a>"; 
	else titleStr = "<font color='green'>" + menu.getMenu_nm() + "</font></a>";
	
	String linkStr = "";
	String parmStr = "gCurMenuId=" + menu.getMenu_id(); 
	if( menu.getOpen_area().equals("C") ) {
		linkStr = "<a href=\"javascript:goMenu('admin.jsp?" + parmStr + "');\">" + titleStr; 
	} else {
		linkStr = "<a href=\"javascript:openPopup('admin.jsp?" + parmStr + "');\">" + titleStr; 
	}
	
%>
				<li><%=linkStr%></li>
<%
}
%>
	<%
			if( isLogined ) { %>
			<li><a href="javascript:goLogout();">로그아웃</a></li>
	<% } %>
			
				</ul>
			</nav>


			<section class="wrapper wrapper-list">
				
					<div class="mainlay mainlayAdmin">
	
						<jsp:include page="leftAdmin.jsp" flush="false">
							<jsp:param name="gCurMenuId"  value="<%=gCurMenuId%>" />
						</jsp:include>
						
			<% if( curMenu != null ) {
					if( curMenu.getCont_type().equals("F")) {%>
						<jsp:include page="<%=curMenu.getContent()%>" flush="false">
							<jsp:param name="gCurMenuId"  value="<%=gCurMenuId%>" />
							<jsp:param name="gCurPageNo"  value="<%=gCurPageNo%>" />
						</jsp:include>
				<% } else if(curMenu.getCont_type().equals("C")) { %>
					<section class="list-wide">
						<div class="content">
						<%=curMenu.getContent()%>
						</div>
					</section>
				<% } else if(curMenu.getCont_type().equals("L")) { %>
					<section class="list-wide">
						<div class="content">
						<iframe width='100%' height='800px' src='<%=curMenu.getContent()%>'>이 브라우저는 iframe을 지원하지 않습니다.</iframe><br/>
						<a href="javascript:openPopup('<%=curMenu.getContent()%>');"><%=curMenu.getContent()%></a> 팝업으로열기.
						</div>
					</section>
				<% } %>
			<% } %>
						
					</div>
			
			</section>
			

<script>

(function($) {

	var isLog = $( "#isLogined" ).val();  

	if( isLog == "false" ) {
		window.location = "login.jsp"; 
	}

	/*햄버거 메뉴*/
    $(".js-hamburger-open").click(function () {
        $(".m-gnb").animate({"right": 0}, 500, "easeOutExpo");
        $(".m-gnb, .m-gnb-bg").show();
    });
    $(".js-hamburger-close").click(function () {
        $(".m-gnb").animate({"right": "-100%"}, 500, "easeOutExpo");
        $(".m-gnb, .m-gnb-bg").hide();
    });
    
    
})(jQuery);


</script>

	<%
	// check if user have auth for current menu.. 
	if( menuService.count(whereOption) == 0 ) {
		%>
		<script>
			alert("권한이 없는 메뉴입니다."); 
			history.back(); 
		</script>
		<%
	}
	%>
	
	</body>
</html>