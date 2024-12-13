var access_token; 

function authSido(sel_obj, callback) {

	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:"https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?consumer_key=bb9771a73c53434f8df9&consumer_secret=7fb0bcca8e3e43739faa",
        success:function(response){
        	access_token = response.result.accessToken;
        	console.log("access token : " + access_token); 
        	callback(sel_obj);
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
            alert("Fail to connect to address server : " + textStatus); 
            console.log("Error : " + errorThrown);  
        }   
	});

}


function authGugun(gugun_str, callback, sido) {

	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:"https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?consumer_key=bb9771a73c53434f8df9&consumer_secret=7fb0bcca8e3e43739faa",
        success:function(response){
        	access_token = response.result.accessToken;
        	console.log("access token : " + access_token); 
        	callback(gugun_str, sido);
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
            alert("Fail to connect to address server : " + textStatus); 
            console.log("Error : " + errorThrown);  
        }   
	});

}

var retry = false; 
function getSidoData(sido_sel) {

	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:"https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=" + access_token + "",
        success:function(response){
        	retry = false; 
        	fillSidoArray(sido_sel, response); 
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
        	if( retry ) {
                alert("Fail to connect to address server : " + textStatus); 
                console.log("getSidoData Error : " + errorThrown);  
                retry = false; 
        	} else {
            	retry = true; 
            	authSido(sido_sel, getSidoData); 
                // alert("Fail to connect to address server : " + textStatus); 
                console.log("getSidoData Error : " + errorThrown);  
        	}
        }
	});

}

function fillSidoArray(sido_sel, response) {
	sessionStorage.setItem('select_sido_data', JSON.stringify(response));
	
	var sido_obj = $(sido_sel); 
	console.log("getSidoData success : " + sido_obj.get(0).outerHTML);  
	sido_obj.empty(); 

	sido_obj.append('<option value="" selected="selected">시도를 선택하세요. </option>');

	$.each(response.result, function(i, item) {
		sido_obj.append($('<option>',{ value: item.cd, text: item.addr_name }));
	});        	
	
}

function getGugunData(gugun_str, sido) {
	var gugun_sel = $(gugun_str); 
	
	if( sido == "" ) {
		gugun_sel.empty(); 
    	gugun_sel.append('<option value="" selected="selected">구군을 선택하세요. </option>');
		return; 
	}
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:"https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json?accessToken=" + access_token + "&cd=" + sido,
        success:function(response){
        	retry = false; 
        	console.log("access : " + access_token + " sido : " + sido); 
        	fillGugunArray(gugun_str, response);  
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
        	if( retry ) {
        		retry = false; 
                alert("Fail to connect to address server : " + textStatus); 
                console.log("getGugunData Error : " + errorThrown);  
        	} else {
        		retry = true; 
            	authGugun(gugun_str, getGugunData, sido); 
                // alert("Fail to connect to address server : " + textStatus); 
                console.log("getSidoData Error : " + errorThrown);  

        	}
        }
	});
}



function fillGugunArray(gugun_sel, response) {

	if( gugun_sel != "#add_gugun" ) sessionStorage.setItem('select_gugun_data', JSON.stringify(response));
	
	var gugun_obj = $(gugun_sel); 
	gugun_obj.empty(); 

	gugun_obj.append('<option value="" selected="selected">구군을 선택하세요. </option>');

	$.each(response.result, function(i, item) {
		gugun_obj.append($('<option>', { value: item.cd, text: item.addr_name })); 
	});        	
	
}


/*
 * get gugun data from web server .. 
 */
function getGugunDataServer(gugun_str, sido) {
	var gugun_sel = $(gugun_str); 
	var curHost = "http://" + window.location.host; 
		
	if( sido == "" ) {
		gugun_sel.empty(); 
    	gugun_sel.append('<option value="" selected="selected">구군을 선택하세요. </option>');
		return; 
	}
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:curHost + "/rest/getGugunData.jsp?sido=" + sido,
        success:function(response){
        	console.log(" sido : " + sido); 
        	fillGugunArray(gugun_str, response);  
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
       	    console.log("getSidoData Error : " + errorThrown);  
        }
	});
}



/*
 * get full_type data from web server .. 
 */
function getFullTypeServer(full_type_str, yo_type) {
	var full_type_sel = $(full_type_str); 
	var curHost = "http://" + window.location.host; 
	
	if( yo_type == "" ) {
		full_type_sel.empty(); 
		full_type_sel.append('<option value="" selected="selected">구분을 선택하세요. </option>');
		return; 
	}
	
	$.ajax({
        headers:{ 
           "Accept":"application/json", 
           "Content-type":"application/x-www-form-urlencoded" 
        },   
        url:curHost + "/rest/getFullTypeData.jsp?yo_type=" + yo_type,
        success:function(response){
        	fillFullTypeArray(full_type_str, response);  
        }, 
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
       	    console.log("getFullTypeServer Error : " + errorThrown);  
        }
	});
}


function fillFullTypeArray(full_type_str, response) {
	var full_type_obj = $(full_type_str); 
	full_type_obj.empty(); 

	full_type_obj.append('<option value="" selected="selected">구분을 선택하세요. </option>');

	$.each(response.result, function(i, item) {
		full_type_obj.append($('<option>', { value: item.cd, text: item.name })); 
	});        	
	
}
	 
