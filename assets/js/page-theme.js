// JavaScript Document
define(['overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		var $overlayer = $.overlay({
			height: 120,
			content: words
		});
				
		$overlayer.trigger("overlay.dialog.popup", callback);
	}
	
	function init_setup(){
		var isSetuping = false;
		$(".action-setup").on("click", function(){
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
		}).on("setup.start", function(){
			$(this).find(".iconfont").addClass("sending");
			$(this).find(".icontext").text("安装进行中..");
		}).on("setup.success", function(){
			$(this).find(".iconfont").removeClass("sending");
			$(this).find(".icontext").text("安装成功");
			setTimeout(function(){
				window.location.reload();
			}, 2000);
		}).on("setup.fail", function(event, msg){
			popUpTips(msg);
			$(this).find(".iconfont").removeClass("sending");
			$(this).find(".icontext").text("安装");
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_setup();
			});
		}
	}
});