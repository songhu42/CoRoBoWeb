<%@ page contentType = "text/html;charset=utf-8" %>
<%@ page import="com.humanval.sipt.service.Admin_mstService" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="com.humanval.sipt.util.Crypto" %>
<%@ page import="java.util.Date" %>
<%@ include file="initPage.jsp" %>
<%
	Admin_mstService service = new Admin_mstService(); 
	String selWeek = request.getParameter("selWeek"); 
	String curDate = ComUtil.getCurDt("yyyy-MM-dd"); 
	if(selWeek == null || selWeek.length() < 7){
		selWeek = ComUtil.getCurWeek(new Date()); 
	}
%>

<link href='fullcalendar-5.0.1/lib/main.css' rel='stylesheet' />
<script src='fullcalendar-5.0.1/lib/main.js'></script>
<script src="assets/js/hsmutil.js?ver=2"></script> 

<script>
function getTimeString(intTm) {
	var hh = ""; 
	var min = ""; 

	if ( intTm.length < 4 ) {
		hh = "0" + intTm.substring(0, 1); 
		min = intTm.substring(1); 
	} else {
		hh = intTm.substring(0, 2); 
		min = intTm.substring(2); 
	}
	
	return hh + ":" + min;

}

var isLoaded = false;
var calendar;

function goSearch() {
	var faValidYn = "";  
	if( $("#check_valid").prop("checked") ) faValidYn = "checked";  

	var params = "?gCurMenuId=<%=gCurMenuId%>&gCurPageNo=" + $("#gCurPageNo").val() 
	+ "&faUserNm=" + $("#faUserNm").val() + "&faClassState=" + $("#faClassState").val();  

	window.location = "admin.jsp" + params; 
}

function updateClassInfo(idKey, strTm, endTm) {
	if( !isLoaded ) return; 
	  $.ajax({
	        url: 'rest/updateClassInfo.jsp?admin_id=<%=userId%>&idKey=' + idKey + '&strTm=' + strTm + '&endTm=' + endTm, 
	        type: 'GET',
	        dataType: 'json',
	        success: function(data) {
	        	// id 변경해 줘야함.. 
	        	var event = calendar.getEventById( idKey ); 

	        	var classDay = strTm.substring(0, 10); 
	        	const ids = idKey.split("_");
	        	var newId = ids[0] + "_" + classDay + "_" + ids[2];

	        	var new_event = {
	        			id:newId, 
			        	start:event.start, 
			        	end:event.end, 
			        	title:event.title, 
			        	url:"javascript:openClassInfoEdit('" + newId + "');", 
			        	backgroundColor:event.backgroundColor, 
			        	startEditable:event.startEditable, 
			        	durationEditable:event.durationEditable, 

			        	editable:event.editable
	        	}; 

	        	event.remove(); 
	        	calendar.addEvent(new_event); 
	        	
	        	// calendar.render();
	        },
	        error: function(xhr, status, error) {
	            console.error('update class info 오류 발생:', error);
	        }
	    });    
}

function createCal(schedules) {

    var calendarEl = document.getElementById('calendar');
	
    calendar = new FullCalendar.Calendar(calendarEl, {
      height: '100%',
      contentHeight:'90%', 
      expandRows: true,
      slotMinTime: '13:00',
      slotMaxTime: '21:00',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
      },
      initialView: 'timeGridWeek',
      initialDate: '<%=curDate%>',
      navLinks: true, // can click day/week names to navigate views
      editable: true,
      selectable: true,
      nowIndicator: true,
      dayMaxEvents: true, // allow "more" link when too many events
      buttonText:{
    	  today:'오늘', 
    	  month:'월간', 
    	  week:'주간', 
    	  day:'일일', 
    	  list:'목록'
      }, 
      views: {
    	  timeGridWeek:{
    		  titleFormat:{
    			  year:'numeric', 
    			  month:'2-digit', 
    			  day:'2-digit'
    		  }
    	  }, 
    	  timeGridDay:{
			  titleFormat:{
				  year:'numeric', 
				  month:'2-digit', 
				  day:'2-digit'
			  }
		  }
      }, 
      eventDrop: function (info) {
          console.log(info.event.title + " was dropped on " + info.event.start.toISOString());
          console.log(info.event.id + "  " + info.event.end.toISOString());
			var idKey = info.event.id; 
			// 9시간 빼줘야.. 
			const offset = new Date().getTimezoneOffset() * 60000;
			var strTm = (new Date(info.event.start - offset)).toISOString();
			var endTm = (new Date(info.event.end - offset)).toISOString();
			
          if (!confirm("정말 수업일정을 변경하시겠습니까?")) {
              info.revert();
          } else {
        	// update CLASS_INFO
			updateClassInfo(idKey, strTm, endTm); 
          }
      },
      
      eventResize: function (info) {
          console.log(info.event.title + " was eventResize  " + info.event.start.toISOString());
          console.log(info.event.id + "  " + info.event.end.toISOString());
          info.event.start.to
			var idKey = info.event.id; 
			// var strTm = info.event.start.toISOString(); 
			// var endTm = info.event.end.toISOString(); 
			
			const offset = new Date().getTimezoneOffset() * 60000;
			var strTm = (new Date(info.event.start - offset)).toISOString();
			var endTm = (new Date(info.event.end - offset)).toISOString();
			
          if (!confirm("정말 수업일정을 변경하시겠습니까?")) {
              info.revert();
          } else {
        	// update CLASS_INFO
			updateClassInfo(idKey, strTm, endTm); 
          }
      },

      events:schedules
    });

    calendar.render();
}

  document.addEventListener('DOMContentLoaded', function() {
	    // get schedules for selected weeks 
	    var schedules = []; 
	    $.ajax({
	        url: 'rest/getSchedules.jsp?admin_id=<%=userId%>&selWeek=<%=selWeek%>', 
	        type: 'GET',
	        dataType: 'json',
	        success: function(data) {
	        	$.each(data, function(index, item) {
		        	var dict = {}; 
		        	var idKey = "" + item.class_id + "_" + item.class_dt + "_" + item.user_id; 
		        	console.log("key : " + idKey); 
		        	dict['id'] = idKey; 
		        	var startTm = item.class_dt.substring(0, 10) + "T" + getTimeString(item.str_tm) + ":00"; 
		        	var endTm = item.class_dt.substring(0, 10) + "T" + getTimeString(item.end_tm) + ":00"; 
		        	dict['start'] = startTm; 
		        	dict['end'] = endTm; 
		        	
		        	dict['title'] = item.user_nm + "(" + item.cur_times + "/" + item.tot_times + ")"; 
		        	dict['url'] = "javascript:openClassInfoEdit('" + idKey + "');";  
		        	
		        	if( item.is_done == 1 ) {
			        	// dict['editable'] = false; // 없어짐..  
			        	dict['startEditable'] = false; 
			        	dict['durationEditable'] = false; 
			        	dict['backgroundColor'] = 'gray'; 
			        	
		        	} else {
			        	dict['startEditable'] = true; 
			        	dict['durationEditable'] = true; 
		        	}
		        	schedules.push(dict); 

	            });
	        	
	        	createCal(schedules); 
	        	
	        	isLoaded = true; 
	        },
	        error: function(xhr, status, error) {
	            console.error('오류 발생:', error);
	        }
	    });    
	    
  });

</script>
<style>

/*
  html, body {
    overflow: hidden; /* don't do scrollbars */
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
    font-size: 14px;
  }
*/

  .fc-header-toolbar {
    /*
    the calendar will be butting up against the edges,
    but let's scoot in the header's buttons
    */
    padding-top: 1em;
    padding-left: 1em;
    padding-right: 1em;
  }

</style>

<section class="list-wide">
	<div class="content">
		<input type="hidden" id="isLogined" name="isLogined" value="<%=isLogined%>"/> 
		<input type="hidden" id="gCurPageNo" name="gCurPageNo" value="<%=gCurPageNo%>"/>  
	
		<div id='calendar-container'>
			<div id='calendar'></div>
		</div>
	</div>
</section>
