// JavaScript Document
define(['overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function init_EventBinds(){
		$("body").on("click", ".action-del", function(){
			if ( confirm("确定要删除该日志？") ){
				var id = Number($(this).attr("data-id")),
					_this = this;
					
				if ( id > 0 ){
					$.getJSON(config.ajaxUrl.server.delArticles, { id: id }, function( jsons ){
						if ( jsons && jsons.success ){
							$(_this).parents("tr:first").animate({
								opacity: 0
							}, "slow", function(){
								$(this).remove();
							});
						}else{
							popUpTips(jsons.error);
						}
					});
				}else{
					popUpTips("参数错误");
				}
			}
		});
		
		$("body").on("click", ".action-top", function(){
			var id = Number($(this).attr("data-id")),
				_this = this,
				status = $(this).data("sening");
			
			if ( id > 0 ){
				if ( !status ){
					$(this).data("sening", true);
					$(this).text("...");
					$.getJSON(config.ajaxUrl.server.topArticles, { id: id }, function( jsons ){
						if ( jsons && jsons.success ){
							$(_this).text("成功");
							setTimeout(function(){
								$(_this)
									.text("取消")
									.removeClass("action-top")
									.addClass("action-untop")
									.data("sening", false);
							}, 500);
						}else{
							popUpTips(jsons.error);
						}
					});
				}
			}else{
				popUpTips("参数错误");
			}
		});
		
		$("body").on("click", ".action-untop", function(){
			var id = Number($(this).attr("data-id")),
				_this = this,
				status = $(this).data("sening");
			
			if ( id > 0 ){
				if ( !status ){
					$(this).data("sening", true);
					$(this).text("...");
					$.getJSON(config.ajaxUrl.server.unTopArticles, { id: id }, function( jsons ){
						if ( jsons && jsons.success ){
							$(_this).text("成功");
							setTimeout(function(){
								$(_this)
									.text("置顶")
									.removeClass("action-untop")
									.addClass("action-top")
									.data("sening", false);
							}, 500);
						}else{
							popUpTips(jsons.error);
						}
					});
				}
			}else{
				popUpTips("参数错误");
			}
		});
	}
	
	return {
		init: function(){
			init_EventBinds();
		}
	}
});