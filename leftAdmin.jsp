<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.dao.Com_code"%>
<%@ page import="com.humanval.sipt.dao.Admin_menu"%>
<%@ page import="com.humanval.sipt.util.ComUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.humanval.sipt.service.Com_codeService"%>
<%@ page import="com.humanval.sipt.service.Admin_menuService"%>

<%
	String authString = " 'U' ";
	if( authLevel.equals("O") ) authString = " 'U', 'O' ";
	else if( authLevel.equals("M") ) authString = " 'U', 'O', 'M' ";
	else if( authLevel.equals("S") ) authString = " 'U', 'O', 'M', 'S' ";
	
	String whereOption = " WHERE A.AUTH_LEVEL IN (" + authString + ") ";

	Admin_menuService menuService = new Admin_menuService(); 
	List<Admin_menu> list = menuService.selectList(whereOption);  
%>
	<section>
		<div class="content"> 
		<br/><br/>
			<blockquote>
<%
String groupName = ""; 

for(int i=0; i<list.size(); i++ ) {
	Admin_menu menu = (Admin_menu)list.get(i); 
	if( !groupName.equals(menu.getGrp_nm()) ) {
		groupName = menu.getGrp_nm(); 
%>
			<header>
				<h3><a href="#" class="icon fas fa-cog"><span class="label">Icon</span></a><strong>&nbsp;<%=menu.getGrp_nm() %></strong></h3>
			</header>
<% 
	}
	
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
				<p class="menu_p"><strong>&nbsp;<%=linkStr%></strong>	</p>
<%
}
%>
			</blockquote>
		</div>
	</section>