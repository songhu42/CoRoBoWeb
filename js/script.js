/*햄버거 메뉴 ON 상태에서 PC사이즈로 돌아올시*/
/*
$(window).resize(function (){
  // width값을 가져오기
  var width_size = window.outerWidth;
	
  if (width_size > 1110) {
	$(".m-gnb, .m-gnb-bg").hide();
  }
});
*/

$(function(){
	/*스크롤바 위치에 따른 메뉴 고정*/
	$(window).scroll(function(){
		var scrPos = $(this).scrollTop();

		if ($(this).scrollTop() >= 500) {
			$(".aside-menu").addClass("active");
		} else {
			$(".aside-menu").removeClass("active");
		}
	});
	
	
	/*햄버거 메뉴*/
    $(".js-hamburger-open").click(function () {
        $(".m-gnb").animate({"right": 0}, 500, "easeOutExpo");
        $(".m-gnb, .m-gnb-bg").show();
    });
    $(".js-hamburger-close").click(function () {
        $(".m-gnb").animate({"right": "-100%"}, 500, "easeOutExpo");
        $(".m-gnb, .m-gnb-bg").hide();
    });
});