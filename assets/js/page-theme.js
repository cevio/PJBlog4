// JavaScript Document
define(['overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function init_setup(){
		var isSetuping = false;
		$(".action-setup")
			.on("click", function(){
				if ( isSetuping === false ){
					isSetuping = true;
					var folder = $(this).attr("data-id"),
						_this = this;
					if ( folder.length > 0 ){
						$(this).trigger("setup.start");
						$.getJSON(config.ajaxUrl.server.setupTheme, { id: folder }, function(jsons){
							isSetuping = false;
							if ( jsons && jsons.success ){
								$(_this).trigger("setup.success");
							}else{
								$(_this).trigger("setup.fail", jsons.error);
							}
						});
						
					}
				}
			})
			.on("setup.start", function(){
				$(this).addClass("activing").text("安装进行中..");
			})
			.on("setup.success", function(){
				$(this).removeClass("activing").text("安装成功");
				setTimeout(function(){
					if ( confirm("是否切换到当前主题页面？") ){
						window.location.href = "?p=theme";
					}
				}, 500);
			})
			.on("setup.fail", function(event, msg){
				$(this).removeClass("activing").text("安装");
			});
	}
	
	function init_themeStyleSet(){
		var setting = false;
		$(".current-theme-style .list li").on("click", function(){
			var _this = this;
			if ( setting === false ){
				setting = true;
				var id = $(this).attr("data-id");
				if ( id.length > 0 ){
					$.getJSON(config.ajaxUrl.server.setupThemeStyle, { id: id }, function(jsons){
						setting = false;
						if ( jsons && jsons.success ){
							$(".current-theme-style .list li").removeClass("current");
							$(_this).addClass("current");
						}else{
							popUpTips(jsons.error);
						}
					});
				}else{
					setting = false;
				}
			}
		});
	}
	
	function init_themeDelete(){
		var deling = false;
		$(".action-del").on("click", function(){
			if ( deling === false ){
				if ( confirm("确定删除？") ){
					deling = true;
					var id = $(this).attr("data-id"),
						_this = this;
						
					if ( id.length > 0 ){
						$(this).addClass("activing").text("正在删除..");
						$.getJSON(config.ajaxUrl.server.setupThemeDelete, { id: id }, function(jsons){
							deling = false;
							if ( jsons && jsons.success ){
								$(_this).removeClass("activing").text("删除成功");
								$(_this).parents("li:first").animate({
									opacity: 0
								}, "slow", function(){
									$(this).remove();
								});
							}else{
								//popUpTips(jsons.error);
								$(_this).removeClass("activing").text("删除");
							}
						});
					}else{
						deling = false;
					}
				}
			}
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_setup();
				init_themeStyleSet();
				init_themeDelete();
			});
		}
	}
});