// JavaScript Document
define(['overlay'], function( require, exports, module ){
	
	function popUpTips( words, callback ){
		var $overlayer = $.overlay({
			content: words
		});
				
		$overlayer.trigger("overlay.dialog.popup", callback);
	}
	
	function init_EventBinds(){
		$("body").on("click", ".action-del", function(){
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
			
		});
	}
	
	return {
		init: function(){
			init_EventBinds();
		}
	}
});