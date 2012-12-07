// JavaScript Document
define(['overlay'], function( require, exports, module ){
	var isMakingData = false;
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function checkAll(){
		$("#checkall").on("click", function(){
			var a = $(".cache input[type='checkbox']:checked").size(),
				b = $(".cache input[type='checkbox']").size();
			if ( a < b ){
				$(".cache input[type='checkbox']").attr("checked", true);
			}else{
				$(".cache input[type='checkbox']").attr("checked", false);
			}
		});
	}
	
	function clear(){
		$("#clear").on("click", function(){
			if ( isMakingData === true ){
				return;
			}
			
			isMakingData = true;
			
			var $checkElements = $(".cache input[type='checkbox']:checked");
			if ( $checkElements.size() > 0 ){
				clearItem($checkElements, 0, function(){
					$(".cache ul li").removeClass("active");
					popUpTips("全部清理完毕");
				});
			}
		});
	}
	
	function clearItem( $elements, i, callback ){
		if ( i === undefined ){ i = 0; }
		
		if ( i + 1 > $elements.size() ){
			$.isFunction(callback) && callback();
			isMakingData = false;
			return;
		}
		
		var $thisElement = $elements.eq(i),
			value = $thisElement.attr("value");
		
		$(".cache ul li").removeClass("active");
		var parent = $thisElement.parents("li:first").addClass("active");

		$.getJSON(config.ajaxUrl.server.system, {c: value}, function(params){
			if ( params.success ){
				parent.find("span").html("清理成功");
			}else{
				parent.find("span").html(params.error);
			}
			
			clearItem( $elements, i + 1, callback );
		});
	}
	
	return {
		init: function(){
			$(function(){
				checkAll();
				clear();
			});
		}
	}
});