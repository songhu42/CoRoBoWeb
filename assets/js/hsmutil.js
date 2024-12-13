/*
 * check value is integer or not 
 */
function isInt(value) {
    var er = /^-?[0-9]+$/;
    return er.test(value);
}

/*
 * check value is phone number or not 
 */
function isPhoneNumber(value) {
    var er = /^-?[0-9\\-]+$/;
    return er.test(value);
}
function isPhoneNumber10(value) {
	if( value.length < 10 ) return false; 
	
    var er = /^-?[0-9\\-]+$/;
    return er.test(value);
}

function goLogin() {
	window.open("admin.jsp", '_blank');
}
function goLogout() {
	window.location = "logout.jsp"; 
}


function openWrite(div) {
	var smsParam = ""; 
	if( div == 2 ) smsParam = "&isSMS=N"; 
	if( $('.list-wide').is(":visible") ) openPopup("/write.jsp?mobile_yn=N"+smsParam);
	else openPopup("/write.jsp?mobile_yn=Y"+smsParam);
}
function openMsnMstEdit(msn_id) {
	var url = "editMsnMst.jsp?selMsnId=" + msn_id + "&saveAction=E"; 
	openPopup(url); 
}
function openSrvMstEdit(srv_id) {
	var url = "editSrvMst.jsp?selSrvId=" + srv_id + "&saveAction=E"; 
	openPopup(url); 
}
function openSrvInfoEdit(srv_seq) {
	var url = "editSrvInfo.jsp?selSrvSeq=" + srv_seq + "&saveAction=E"; 
	openPopup(url); 
}
function openMsnSrvEdit(msn_seq) {
	var url = "editMsnSrv.jsp?selMsnSeq=" + msn_seq + "&saveAction=E"; 
	openPopup(url); 
}


function openAdminMenuEdit(menu_id) {
	var url = "editAdminMenu.jsp?selMenuId=" + menu_id + "&saveAction=E"; 
	openPopup(url); 
}
function openBoardAnnEdit(seq_no) {
	var url = "editBoardAnn.jsp?selSeqNo=" + seq_no + "&saveAction=E"; 
	openPopup(url); 
}
function openUserMstEdit(user_id) {
	var url = "editUserMst.jsp?selUserId=" + user_id + "&saveAction=E"; 
	openPopup(url); 
}
function openFeedbackMstEdit(seq_no) {
	var url = "editFeedbackMst.jsp?selSeqNo=" + seq_no + "&saveAction=E"; 
	openPopup(url); 
}

function openUserMst(user_id) {
	var url = "viewUserMst.jsp?selUserId=" + user_id + "&saveAction=E"; 
	openPopup(url); 
}

function openClassMstEdit(class_id) {
	var url = "editClassMst.jsp?selClassId=" + class_id + "&saveAction=E"; 
	openPopup(url); 
}

function openClassInfoEdit(class_id) {
	var url = "editClassInfo.jsp?selClassId=" + class_id + "&saveAction=E"; 
	openPopup(url); 
}


function openInApp(cur_dt) {
	var url = "admin.jsp?gCurMenuId=AM_402&faStartDt=" + cur_dt + "&faEndDt=" + cur_dt; 
	openPopup(url); 
}

function openFeedbackResEdit(seq_no, user_id) {
	var url = "editFeedbackRes.jsp?selSeqNo=" + seq_no + "&selUserId=" + user_id + "&saveAction=E"; 
	openPopup(url); 
}

function openPopup( _url ) {
	var w = screen.width; 
	var h = screen.height;
	var maxw = 940; 
	
	if( w > maxw ) {
		w = maxw; 
		h = maxw;
		if( h > screen.height ) h = screen.height;
	}

	var left = (screen.width/2)-(w/2); 
	var top = (screen.height/2)-(h/2); 
	
	window.open(_url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
	
}


function goMenu( _url ) {
	window.location.href = _url; 
}

function openSmallPopup(_url) {
	var w = 400;
	var h = 400; 
	var left = (screen.width/2)-(w/2); 
	var top = (screen.height/2)-(h/2); 
	window.open(_url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);	
}

function saveResTypeNow(seq_no, user_id, ind) {
	var curHost = "http://" + window.location.host; 
	
	var typeNm = "#res_type"+ind;
	var stNm = "#res_st"+ind;

	var res_type = $(typeNm).val(); 
	var res_st = $(stNm).val(); 
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:curHost + "/hsm/saveResTypeNow.jsp?seq_no=" + seq_no + "&user_id=" + user_id + "&res_type=" + res_type + "&res_st=" + res_st,
        success:function(response){
        	
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
       	    console.log("saveResTypeNow Error : " + errorThrown);  
        }
	});
}


function topbar_sel(ind, area_id) {
	var element = $("#topbar_btn" + ind);

	if( element.hasClass("selected") ) {
		element.removeClass("selected");
		$("#fAreaType").val("");
	} else {
		element.addClass("selected");
		$("#fAreaType").val(area_id);
		
		sessionStorage.setItem('fSidoType', ""); 
		sessionStorage.setItem('fGugunType', ""); 
		$("#select_sido").val(""); 
		$("#select_gugun").val(""); 
		$("#select_sido_m").val(""); 
		$("#select_gugun_m").val(""); 
	}
	
	cmdSearch(); 
}

function topbar_div(ind, area_id) {
	var element = $("#topdiv_btn" + ind);

	if( element.hasClass("selected") ) {
		element.removeClass("selected");
		$("#fDivType").val("");
	} else {
		element.addClass("selected");
		$("#fDivType").val(area_id);
		sessionStorage.setItem('fYoType', ""); 
		$("#f_yo_type").val("");  
		$("#f_yo_type_m").val("");  
	}
	
	cmdSearch(); 
}

function rotateBanners(elem) {
	for( var i=1; i<=3; i++) {
		var curClass = "bg"+i; 
		var nextClass = "bg" + (i%3 + 1); 
		
		if( $(elem).hasClass(curClass) ) {
			$(elem).removeClass(curClass);
			$(elem).addClass(nextClass).fadeIn(200);
			
			$("#headtitle"+i).hide(); 
			$("#headtitle"+(i%3 + 1)).show(); 

			$("#headmsg"+i).hide(); 
			$("#headmsg"+(i%3 + 1)).show(); 
			
			break; 
		}
	}
}

function startRotator(elem) {
	$("#headtitle2").hide(); 
	$("#headtitle3").hide(); 
	$("#headmsg2").hide(); 
	$("#headmsg3").hide(); 
	
	setInterval("rotateBanners('"+elem+"')", 5000);
}


function alertBox(txt, callbackMethod, jsonData){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            if(callbackMethod){
                callbackMethod(jsonData);
            }
        }
    });
}
 
function alertBoxFocus(txt, obj){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            obj.focus();
        }
    });
}
 
    
function confirmBox(txt, callbackMethod, jsonData){
    modal({
        type: 'confirm',
        title: '알림',
        text: txt,
        callback: function(result) {
            if(result){
                callbackMethod(jsonData);
            }
        }
    });
}
 
function promptBox(txt, callbackMethod, jsonData){
    modal({
        type: 'prompt',
        title: 'Prompt',
        text: txt,
        callback: function(result) {
            if(result){
                callbackMethod(jsonData);
            }
        }
    });
}
 
function successBox(txt){
    modal({
        type: 'success',
        title: 'Success',
        text: txt
    });
}
 
function warningBox(txt){
    modal({
        type: 'warning',
        title: 'Warning',
        text: txt,
        center: false
    });
}
 
function infoBox(txt){
    modal({
        type: 'info',
        title: 'Info',
        text: txt,
        autoclose: true
    });
}
 
function errorBox(txt){
    modal({
        type: 'error',
        title: 'Error',
        text: txt
    });
}
 
function invertedBox(txt){
    modal({
        type: 'inverted',
        title: 'Inverted',
        text: txt
    });
}
 
function primaryBox(txt){
    modal({
        type: 'primary',
        title: 'Primary',
        text: txt
    });
}

