// JavaScript Document
define(['tabs', 'overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function init_setup(){
		var setuping = false;
		
		$(".action-setup").on("click", function(){
			if ( setuping === false ){
				setuping = true;
				$(this).addClass("activing").text('安装进行中..');
				var folder = $(this).attr("data-fo"), 
					_this = this;
				
				$.getJSON(config.ajaxUrl.server.setupPlugin, {fo: folder}, function( jsons ){
					setuping = false;
					if ( jsons.success ){
						$(_this).removeClass("activing").text('安装成功');
						$(_this).off("click");
						if ( confirm("是否需要切换到已安装插件页面？") ){
							setTimeout(function(){ 
								window.location.href = "?p=plugin";
							}, 500);
						}
					}else{
						$(_this).removeClass("activing").text('安装');
						popUpTips(jsons.error);
					}
				});
			}
		});
	}
	
	function init_configSetting(){
		$(".action-set").on("click", function(){
			var id = $(this).attr("data-id");
			$.getJSON(config.ajaxUrl.server.configSetPlugin, {id: id}, function(jsons){
				if ( jsons.success ){
					$.dialogSet({
						content: jsons.data.html,
						action: config.ajaxUrl.server.updateConfig,
						effect: "deformationZoom",
						callback: function(){
							var _this = this;
								$(this).find("table").css("width", "100%");
								$(this).trigger("overlay.mid");
								$(this).find("form").append('<input type="hidden" name="id" value="' + id + '" />');
								require.async(['form'], function(){
									var formDataSending = false;
									$(_this).find("form").ajaxForm({
										dataType: "json",
										beforeSubmit: function(){
											if ( formDataSending === true ){
												return false;
											}
										},
										success: function(datas){
											formDataSending = false;
											if ( datas.success ){
												$(_this).find(".content").text("保存成功，1秒关闭。");
												setTimeout(function(){
													$(_this).find(".close").trigger("click");
												}, 1000);
											}else{
												popUpTips(datas.error);
											}
										},
										error: function(){
											formDataSending = false;
										}
									})
								});
						}
					});
				}else{
					popUpTips(jsons.error);
				}
			});
		});
	}
	
	function init_pluginStop(){
		$("body").on("click", ".action-stop", function(){
			var id = $(this).attr("data-id"),
				_this = this;
				
				$(this).addClass("activing").text("正在停用..");
				
			$.getJSON(config.ajaxUrl.server.pluginStop, {id: id}, function(jsons){
				if ( jsons.success ){
					$(_this).removeClass("activing").text("插件已成功停用");
					
					setTimeout(function(){
						$(_this).removeClass("action-stop")
								.addClass("action-active")
								.text("启用");
					}, 500);
				}else{
					$(_this).removeClass("activing").text("停用");
					popUpTips(jsons.error);
				}
			});
		});
	}
	
	function init_pluginActive(){
		$("body").on("click", ".action-active", function(){
			var id = $(this).attr("data-id"),
				_this = this;
				
				$(this).addClass("activing").text("正在启用..");
				
			$.getJSON(config.ajaxUrl.server.pluginActive, {id: id}, function(jsons){
				if ( jsons.success ){
					$(_this).removeClass("activing").text("插件已成功启用");
					
					setTimeout(function(){
						$(_this).removeClass("action-active")
								.addClass("action-stop")
								.text("停用");
					}, 500);
				}else{
					$(_this).removeClass("activing").text("启用");
					popUpTips(jsons.error);
				}
			});
		});
	}
	
	function init_unInstall(){
		$(".action-uninstall").on("click", function(){
			var id = $(this).attr("data-id"),
				_this = this;
				
				$(this).addClass("activing").text("正在卸载..");
				
			$.getJSON(config.ajaxUrl.server.pluginUnInstall, {id: id}, function(jsons){
				if ( jsons.success ){
					$(_this).removeClass("activing").text("已卸载");
					$(_this).off("click");
					setTimeout(function(){ 
						$(_this).parents("li:first").animate({
							opacity: 0
						}, "fast", function(){
							$(this).remove();
						});
					}, 1000);
				}else{
					$(this).removeClass("activing").text("卸载");
					popUpTips(jsons.error);
				}
			});
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_setup();
				init_configSetting();
				init_pluginStop();
				init_pluginActive();
				init_unInstall();
			});	
		}
	}
});