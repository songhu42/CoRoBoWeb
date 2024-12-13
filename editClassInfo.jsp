<%@ page contentType = "text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/initPage.jsp" %>
<%@ page import="com.humanval.sipt.util.ComUtil" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.humanval.sipt.dao.Class_info"%>
<%@ page import="com.humanval.sipt.service.Class_infoService"%>
<%
	SimpleDateFormat dayFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	Class_infoService service = new Class_infoService(); 
	Class_info info = new Class_info(); 
	

	String saveAction = ComUtil.chNull(request.getParameter("saveAction")); 
	String selClassId = ComUtil.chNull(request.getParameter("selClassId"));
	String serverErrMsg = ""; 
	List<Com_code> msgTempList = codeService.selectList("A20");  
	
	System.out.println("action : " + saveAction + " selClassId : " + selClassId); 
	
	String readOnlyStr = ""; 
	// N : New Save, U : Update Save, D : Delete => Close Window & reload parent
	// E : Edit Mode setting .. 
	if( saveAction.equals("E") ) {
		String[] keys = selClassId.split("_"); 
		String class_dt = keys[1];  
		long class_id = ComUtil.getLongNumber(keys[0]); 
		long user_id = ComUtil.getLongNumber(keys[2]);  
		System.out.println("class_dt : " + class_dt ); 
				
		info = service.selectByString(class_dt, class_id, user_id);  
		System.out.println("class_dt : " + info.getClass_dt() + " class_id : " + info.getClass_id() + " user_id : " + info.getUser_id()); 
		
	} else if( !saveAction.equals("") ) {
		long class_id = ComUtil.getLongNumber(request.getParameter("class_id"));
		long user_id = ComUtil.getLongNumber(request.getParameter("user_id"));
		System.out.println("class_dt : " + request.getParameter("class_dt")); 
		
		Date class_dt = ComUtil.getDate(request.getParameter("class_dt")); 
		
		int str_tm = ComUtil.getIntNumber(request.getParameter("str_tm"));
		int end_tm = ComUtil.getIntNumber(request.getParameter("end_tm"));
		int is_done = ComUtil.getIntNumber(request.getParameter("is_done"));
		
		String content = new String(ComUtil.chNull(request.getParameter("content")).getBytes("8859_1"), "UTF-8");
		
		info.setClass_dt(class_dt); 
		info.setClass_id(class_id); 
		info.setAdmin_id(userId); 
		info.setUser_id(user_id); 
		info.setStr_tm(str_tm); 
		info.setEnd_tm(end_tm); 
		info.setIs_done(is_done); 
		info.setContent(content); 

		if( saveAction.equals("D") ) {
			service.delete(info); 
		} else if( saveAction.equals("U") ) {
			System.out.println("update class_dt : " + info.getClass_dt() + " class_id : " + info.getClass_id() + " user_id : " + info.getUser_id()); 

			service.update(info); 
		} else if( saveAction.equals("N") ) {
			service.insert(info); 
		}
		info.setReg_dt(new Date()); 
		
	} else {
		info.setClass_dt(ComUtil.getDate(ComUtil.getDateString(new Date())) ); 
		info.setClass_id(0); 
		info.setAdmin_id(userId); 
		info.setUser_id(0); 
		
		info.setUser_nm(""); 
		info.setStr_tm(900); 
		info.setEnd_tm(1000); 
		info.setIs_done(0); 

		info.setContent(""); 
		info.setCreate_dt(new Date()); 
		info.setReg_dt(new Date()); 
		
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
								<h2>수업상세정보 등록</h2>
								
<form name="writeform" method="POST"  action="editClassInfo.jsp"> 
<input type="hidden" name="saveAction" id="saveAction" value="<%=saveAction%>">
<input type="hidden" name="selClassId" id="selClassId" value="<%=selClassId%>">

<input type="hidden" name="admin_id" id="admin_id" value="<%=userId%>">

<div class="title_section"><i class="fa fa-home"></i>&nbsp;수업 정보</div>
	<table  class="table_form">
	<colgroup>
		 <col width="10%" />
		 <col width="20%" />
		 <col width="10%" />
		 <col width="20%" />
		 <col width="10%" />
		 <col width="30%" />
	  </colgroup>

	<tr>
		<th class="mandatory">ID</th>
		<td colspan="1">
			<select onchange="javascript:classChanged();" name="class_list" id="class_list" class="f_select">
			</select>
			<input type="hidden" name="class_id" id="class_id" size="30" maxlength="30" class="f_input" value="<%=info.getClass_id()%>" >
		</td>

		<th class="mandatory">수업일자</th>
		<td colspan="1">
<%		if( saveAction.equals("E") ) {  %>
			<input type="text" name="class_dt" id="class_dt" size="30" maxlength="30" class="f_input" value="<%=dayFormat.format(info.getClass_dt())%>" readonly >
<%		} else {  %>
			<input type="date" id="class_dt" name="class_dt" value="<%=dayFormat.format(info.getClass_dt())%>">
<%		}  %>
		</td>
		
		<th class="mandatory">회원</th>
		<td colspan="1">
			<input type="hidden" name="user_id" id="user_id" size="30" maxlength="30" class="f_input" value="<%=info.getUser_id()%>"  >
			<select onchange="javascript:userChanged();" name="user_list" id="user_list" class="f_select">
			</select>
		</td>

	</tr>

	<tr>
		<th class="mandatory">수업여부</th>
		<td colspan="1">
			<input type="hidden" name="is_done" id="is_done" size="30" maxlength="30" class="f_input" value="<%=info.getIs_done()%>"  >
			<%=info.getIs_done()==0?"수업예정":"수업종료"%>
		</td>

		<th class="mandatory">시작시간</th>
		<td colspan="1"><input type="text" name="str_tm" id="str_tm" size="30" maxlength="30" class="f_input" value="<%=info.getStr_tm()%>"></td>

		<th class="mandatory">종료시간</th>
		<td colspan="1"><input type="text" name="end_tm" id="end_tm" size="30" maxlength="30" class="f_input" value="<%=info.getEnd_tm()%>"></td>
	</tr>


	<tr>
		<th class="mandatory">참고사항</th>
		<td colspan="5">
			<textarea id="content" name="content" rows="8" cols="100"><%=info.getContent()%></textarea>
		</td>
	</tr>

	<tr>
		<th class="mandatory">메시지 선택</th>
		<td colspan="3">
				<select name="msg_tmp" id="msg_tmp" class="f_select" >
					<option value="">Select Tmplete</option>
<%
	for(int i=0; i<msgTempList.size(); i++ ) {
		Com_code code = (Com_code)msgTempList.get(i); 
%>
				  				<option value="<%=code.getCode_id()%>"  <%=(code.getCode_id().equals(info.getState()))?" selected ":"" %> ><%=code.getCode_nm()%></option>
<%}%>
		  		</select>
		</td>

		<th class="mandatory">전화번호</th>
		<td colspan="1"><input type="text" name="user_tel" id="user_tel" size="30" maxlength="30" class="f_input" value="<%=info.getUser_tel()%>"></td>

	</tr>
	<tr>
		<th class="mandatory">전송 메시지</th>
		<td colspan="5">
			<textarea id="sms_msg" name="sms_msg" rows="6" cols="100"></textarea>
		</td>
	</tr>


</table>

<div class="admin_button">
<% if( saveAction.equals("E") ) { %>
	<input type="button" class="small action" value="수정하기" onclick="check_form('U');"/>
	<input type="button" class="small action" value="삭제하기" onclick="check_form('D');"/>
<% } else { %>
	<input type="button" class="small action" value="등록하기" onclick="check_form('N');"/>
<% } %>

	<input type="button" class="small action" value="SMS 전송" onclick="javascript:send_sms_tmp();"/> 
	<input type="button" class="small action" value="닫기" onclick="javascript:window.close();"/> 
</div>

</form>
							</div>

						</section>
						<!-- end write -->
	</div>

</section>						
			
		
<script>
	function removeOptions(selectElement) {
	   var i, L = selectElement.options.length - 1;
	   for(i = L; i >= 0; i--) {
	      selectElement.remove(i);
	   }
	}

	function setClassList() {
		var class_id = $("#class_id").val(); 
				
        $.ajax({
            url: 'rest/getClassList.jsp?admin_id=<%=userId%>', 
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                var select = document.getElementById('class_list');
                if( select.options.length > 0 ) removeOptions(select); 
                
            	$.each(data, function(index, item) {
            		console.log("item : " + item.id + " : " + item.name); 
            		
                	const option = document.createElement('option');
                    option.value = item.id;
                    option.text = item.name;
                    if (class_id == item.id) {
                    	console.log("selected : " + item.id + " : " + item.name); 
                        option.selected = true;

                        setClassUsers(); 
                    }
                    select.appendChild(option);
                });
            	           	
            },
            error: function(xhr, status, error) {
                console.error('오류 발생:', error);
            }
        });
	}
	
	function setClassUsers() {
		
		var classStr = $("#class_id").val(); 
		console.log("setClassUsers class_id : " + classStr); 
		var class_id = parseInt(classStr);
		if( class_id < 1 ) {
			console.log("수업을 먼저 선택하세요."); 
			return; 
		}
		
        $.ajax({
            url: 'rest/getClassUsers.jsp?admin_id=<%=userId%>&class_id=' + classStr , 
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                var select = document.getElementById('user_list');
                if( select.options.length > 0 ) removeOptions(select); 

            	var user_id = $("#user_id").val(); 
            	$.each(data, function(index, item) {
            		console.log("setClassUsers user_id : " + item.id + " name : " + item.name); 
                    const option = document.createElement('option');
                    option.value = item.id;
                    option.text = item.name;
                    if (user_id == item.id) {
                    	console.log("selected : " + item.id + " : " + item.name); 
                        option.selected = true;
                    }
                    select.appendChild(option);
                });
            	
    	// select disabled.. 
        <%    	if( saveAction.equals("E") ) { %>
	            	$("#user_list").attr("disabled", true);
	            	$("#class_list").attr("disabled", true); 
        <%    	} %>           	
            },
            error: function(xhr, status, error) {
                console.error('오류 발생:', error);
            }
        });
	}
	
	function classChanged() {
		console.log("class changed.. "); 
		var select = document.getElementById('class_list');
		var selId = select.options[select.selectedIndex].value; 
		// $("#class_id").val($("#class_list option:selected").val()); 
		console.log("class id : " +selId); 
		 $("#class_id").val(selId); 
		setClassUsers(); 
	}
	
	function userChanged() {
		console.log("user changed.. "); 
		var select = document.getElementById('user_list');
		var selId = select.options[select.selectedIndex].value; 
		// $("#class_id").val($("#class_list option:selected").val()); 
		console.log("user id : " + selId); 
		 $("#user_id").val(selId); 
	}

	$(document).ready(function() {
    	setClassList();  
    	
    	console.log("is done : " + $("#is_done").val()); 
    	
    	if($("#is_done").val() == "1") {
    		$("#str_tm").attr("readonly", true);
    		$("#end_tm").attr("readonly", true);
    	}
    });

(function($) {
	
	// $("#datepicker").datepicker();
	
	<%
	if( saveAction.equals("G") || saveAction.equals("N") || saveAction.equals("D") || saveAction.equals("U") ) {
		if( saveAction.equals("N") || saveAction.equals("U") ) {
	%>
			alert("저장 되었습니다!"); 
	<%
		} else if( saveAction.equals("G") ) {
			if( serverErrMsg.equals("") ) {
	%>
			alert("수업이 생성 되었습니다!"); 
	<%
			} else {
			%>
				alert(serverErrMsg); 
			<%
				
			}
		}  else {
		%>
			alert("삭제 되었습니다!"); 
		<%
		}  
		%>

		window.opener.goSearch(); 
		window.close(); 
	<%
	}
	%>
	
})(jQuery);


function send_sms_tmp() {
	var msg_tmp = document.getElementById("msg_tmp");
	var msg_tmp_id = msg_tmp.value;
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url: 'rest/getSmsTmpl.jsp?admin_id=<%=userId%>&msg_tmp_id=' + msg_tmp_id + '&class_id=<%=info.getClass_id()%>&user_id=<%=info.getUser_id()%>&class_dt=<%=info.getClass_dt()%>' , 
        success:function(response){
        	var res = response.result;
        	console.log("sms result : " + res);
        	
        	$("#sms_msg").val(res); 
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
            console.log("Fail to connect to address server : " + textStatus + " Error : " + errorThrown);  
        }   
	});

}

function send_sms() {
	var msg = $("#sms_msg").val(); 
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:send_url + "/rest/sendReqSms.jsp?sender_tel=<%=telNo%>&msg=" + msg,
        success:function(response){
        	var res = response.result;
        	console.log("sms result : " + res); 
        	Alert("SMS 전송 성공!"); 
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
            console.log("Fail to connect to address server : " + textStatus + " Error : " + errorThrown);  
        }   
	});

}

function check_form(cmd) {
	var form = document.writeform; 
	
	if( cmd == "D" ) {
		if (confirm('정말 삭제 하시겠습니까?')) {
			form.saveAction.value = cmd; 
			form.submit();
       }
	} else { 
		if( form.class_id.value == "") {
			      alert('수업을 선택하세요!');
			      form.class_list.focus();
			      return false;
			      
		   } else if( form.user_id.value == "") {
			      alert('사용자를 선택하세요!');
			      form.user_list.focus();
			      return false;
		   } else if( form.str_tm.value == "") {
			      alert('시작시간을 입력하세요!');
			      form.str_tm.focus();
			      return false;
		   } else if( form.end_tm.value == "") {
			      alert('종료시간을 입력하세요!');
			      form.end_tm.focus();
			      return false;
		   } 

		form.saveAction.value = cmd; 
		form.submit();
	}
}

</script>


	</body>
</html>