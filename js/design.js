$(function(){
	
	//gnb
	//setLayout();
	
	//모바일메뉴
	$('.mobile_menu>ul>li>a').toggle(function(){
		$(this).siblings(".submenu").slideDown("fast");
		$(this).addClass("opened");
	},function(){
		$(this).siblings(".submenu").slideUp("fast");
		$(this).removeClass("opened");
	});
	
	//모바일메뉴 현재메뉴 오픈
	open_cur_m_menu();

	//모바일메뉴 출력
	$("a.open_m_menu").click(function(){
		$(".mobile_menu").animate({left:"0px"},300,"easeOutQuart");
		return false;
	});
	$("a.close_m_menu").click(function(){
		$(".mobile_menu").animate({left:"-250px"},300,"easeOutQuart");
		return false;
	});
	
	//input file 디자인
	$("input[type=file]").filestyle({ 
     image: "/img/jquery/btn_inputfile.gif",
     imageheight : 34,
     imagewidth : 80,
     width : 215
	});
	
	
	//rollOver
	$('a.rollOver').hover(function(){
		 $('img' ,this).attr('src', $('img',this).attr('src').replace(/^(.+)(\.[a-z]+)$/, "$1_on$2"));
	},function(){
		$('img' ,this).attr('src', $('img',this).attr('src').replace(/^(.+)_on(\.[a-z]+)$/, "$1$2"))
	});

});

//모바일메뉴 현재메뉴 오픈
function open_cur_m_menu(){
	var cur_m_menu = $('.mobile_menu>ul>li>a');
	var len_m_menu = cur_m_menu.length;
	for(var i=0; i<len_m_menu; i++){
		if($(cur_m_menu).eq(i).hasClass("selected")){
			$(cur_m_menu).eq(i).siblings(".submenu").show();
		}
	}
}


//input file 디자인
function designInputfile(){
	$("input[type=file]").filestyle({ 
     image: "/img/jquery/btn_inputfile.gif",
     imageheight : 34,
     imagewidth : 80,
     width : 215
	});
}


//팝업
var win= null;
function NewWindow(mypage,myname,w,h,scroll){
   var winl = (screen.width-w)/2;
   var wint = (screen.height-h)/2;
   var settings ='height='+h+',';
      settings +='width='+w+',';
      settings +='top='+wint+',';
      settings +='left='+winl+',';
      settings +='scrollbars='+scroll+',';
      settings +='resizable=yes';
   win=window.open(mypage,myname,settings);
   if(parseInt(navigator.appVersion) >= 4){win.window.focus();}
}