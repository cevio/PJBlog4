// JavaScript Document

define(['overlay'], function(require, exports, module){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	var onDelete = function(){
		$(".action-delete").on("click", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
				$(this).text("正在删除..");
				$.getJSON(config.ajaxUrl.server.memDelete, {id: id}, function(xdata){
					$(this).data("status", false);
					if ( xdata && xdata.success ){
						$(_this).text("删除成功");
						setTimeout(function(){
							$(_this).parents("li:first").animate({
								opacity: 0
							}, "fast", function(){
								$(this).remove();
							});
						}, 500);
					}else{
						popUpTips(xdata.error);
					}
				});
			}
		});
	}
	
	exports.init = function(){
		onDelete();
	}
});