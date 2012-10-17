// JavaScript Document
define(['tabs', 'overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		var $overlayer = $.overlay({
			content: words
		});
				
		$overlayer.trigger("overlay.dialog.popup", callback);
	}
	
	function init_setup(){
		var setuping = false;
		
		$(".action-setup").on("click", function(){
			if ( setuping === false ){
				setuping = true;
				$(this).html('<span class="iconfont">&#409;</span> <span class="icontext">安装进行中..</span>').find(".iconfont").addClass("sending");
				var folder = $(this).attr("data-fo"), _this = this;
				
				$.getJSON(config.ajaxUrl.server.setupPlugin, {fo: folder}, function( jsons ){
					setuping = false;
					if ( jsons.success ){
						$(_this).removeClass("sending").html('<span class="iconfont">&#379;</span> <span class="icontext">安装成功</span>');
						$(_this).off("click");
					}else{
						$(_this).removeClass("sending").html('<span class="iconfont">&#409;</span> <span class="icontext">安装</span>');
						popUpTips(jsons.error);
					}
				});
			}else{
				popUpTips("正在安装中，请等待安装完毕！");
			}
		});
	}
	
	return {
		init: function(){
			$(function(){
				$(".tabs").tabs({
					triggerDom : ".tabs-trigger",
					contentDom : ".tabs-content",
					event : "click",
					currentClass : "current",
					current : 0,
					effect : "horizontalSlip"
				});
				init_setup();
			});	
		}
	}
});