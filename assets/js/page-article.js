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
			}
		});
	}
	
	return {
		init: function(){
			init_EventBinds();
		}
	}
});