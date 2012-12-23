// JavaScript Document
define(['form'], function(require, exports, module){
	
	function slidebar(){
		$(".pannel li").on("click", function(){
			$(".pannel li").removeClass("active");
			$(this).addClass("active");
			var i = $.inArray(this, $(".pannel li").toArray());
			$(".wrap").animate({
				"margin-left": "-" + (i * 400) + "px"
			}, "fast");
		});
	}
	
	function ajaxFormBind(){
		var sending = false;
		$('form').ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( sending === false ){
					sending = true;
					$(".login-info").slideDown("fast");
				}else{
					return false;
				}
			},
			success: function( jsons ){
				sending = false;
				if ( jsons && jsons.success ){
					$('form').resetForm();
					$(".login-info").text('登入成功 即将为您跳转后台..');
					setTimeout(function(){
						window.location.reload();
					}, 1000);
				}else{
					$(".login-info").text(jsons.error);	
				}
			},
			error: function(){
				sending = false;
			}
		});
	}
	
	exports.init = function(){
		$(function(){
			ajaxFormBind();
			slidebar();
			$("input[name='username']").focus();
			$(".pannel li:first").trigger("click");
		});
	}
});