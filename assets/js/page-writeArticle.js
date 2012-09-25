// JavaScript Document
define(['editor'], function(require, exports, module){
	
	function init_choose_cates(){
		var $cates = $(".log-cate .log-cate-content .cate-name"),
			vals = $("input[name='log_category']").val();

		$cates.on("click", function(){
			$cates.removeClass("cate-choosed");
			$(this).addClass("cate-choosed");
			$("input[name='log_category']").val($(this).attr("data-id"));
		});
		
		if ( vals.length > 0 ){
			$(".log-cate .log-cate-content .cate-name[data-id='" + vals + "']").trigger("click");
		}
	}
	
	return {
		init: function(){
			init_choose_cates();
			$("textarea").xheditor({
				skin: "nostyle"
			});
		}
	}
});