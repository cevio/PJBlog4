// JavaScript Document
define(['form', 'cookie'], function(require, exports, module){
	function ajaxFormBind(){
		$('form').ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				$(".infoText").empty();
				$(".submitImageBtn").addClass("loading");
				if ( $("input[name='username']").val().length === 0 ){
					tips("用户名不能为空");
					return false;
				}
				if ( $("input[name='password']").val().length === 0 ){
					tips("密码不能为空");
					return false;
				}
				$(".password .submitImageBtn, .password .passwordTextBox").attr("disabled", true);
			},
			success: function( jsons ){
				if ( jsons && jsons.success ){
					tips("验证成功", function(){
						$.cookie(config.cookie + "_login_username", $("input[name='username']").val(), {
							expires: new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000)
						});
						setTimeout(function(){
							window.location.reload();
						}, 500);
					});
				}else{
					$(".password .submitImageBtn, .password .passwordTextBox").attr("disabled", false);
					tips(jsons.error);	
				}
			},
			error: function(){
				$(".password .submitImageBtn, .password .passwordTextBox").attr("disabled", false);
				tips("网络错误");
			}
		});
	}
	
	function tips(word, callback){
		$(".username .name").animate({
			"margin-top" : "4px"
		}, "slow", function(){
			$(".infoText").text(word).fadeIn("fast", function(){
				$(".submitImageBtn").removeClass("loading");
				$.isFunction(callback) && callback();
			});
		});
	}
	
	function initBoxStatus(){
		$(".login-box").show().css({
			"top": (($(window).height() - 100) / 2) + "px",
			"left": (($(window).width() - 200) / 2) + "px"
		});
	}
	
	function userName(){
		var username = $.cookie(config.cookie + "_login_username");
		if ( username && username.length > 0 ){
			$("input[name='username']").val(username);
		}
	}
	
	exports.init = function(){
		$(function(){
			$(window).on("resize", initBoxStatus).trigger("resize");
			$("input[name='username']").focus();
			userName();
			ajaxFormBind();
		});
	}
});