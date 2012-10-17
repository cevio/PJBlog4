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
	
	function init_configSetting(){
		$(".action-set").on("click", function(){
			var id = $(this).attr("data-id");
			$.getJSON(config.ajaxUrl.server.configSetPlugin, {id: id}, function(jsons){
				if ( jsons.success ){
					var $overlayer = $.overlay({
							content: jsons.data.html,
							action: config.ajaxUrl.server.updateConfig
						});
								
						$overlayer.trigger("overlay.set.popup", function(){
							var _this = this;
							$(this).find("table").addClass("table").css("width", "100%");
							$(this).trigger("overlay.mid");
							$(this).find("form").append('<input type="hidden" name="id" value="' + id + '" />');
							require.async(['form'], function(){
								$(_this).find("form").ajaxForm({
									dataType: "json",
									success: function(datas){
										if ( datas.success ){
											$(_this).find(".content").text("保存成功，1秒关闭。");
											setTimeout(function(){
												$(_this).find(".close").trigger("click");
											}, 1000);
										}else{
											alert(datas.error);
										}
									}
								})
							});
						});
				}else{
					popUpTips(jsons.error);
				}
			});
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
				init_configSetting();
			});	
		}
	}
});