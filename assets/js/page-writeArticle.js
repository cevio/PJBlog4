// JavaScript Document
define(['editor', 'form', 'overlay'], function(require, exports, module){
	
	var sending = false;
	
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
	
	function tipPopUp( words, callback ){
		var $overlayer = $.overlay({
			content: words
		});
				
		$overlayer.trigger("overlay.dialog.popup", callback);
	}
	
	return {
		init: function(){
			init_choose_cates();
			$("textarea").xheditor({
				skin: "nostyle"
			});
			$("form").ajaxForm({
				dataType: "json",
				beforeSubmit: function(){
					if ( sending === false ){
						if ( $("input[name='log_title']").val().length === 0 ){
							tipPopUp("亲，您还没有填写标题呢！");
							return false;
						}
						
						if ( $("input[name='log_category']").val().length === 0 ){
							tipPopUp("亲，您还没有选择分类呢！");
							return false;
						}
						
						if ( $("textarea[name='log_content']").val().length === 0 ){
							tipPopUp("亲，您不打算写日志了吗？");
							return false;
						}
						
						sending = true;
					}else{
						tipPopUp("亲，请不要重复提交好吗？");
						return false;
					}
				},
				success: function(jsons){
					sending = false;
					if ( jsons && jsons.success ){
						tipPopUp("保存日志成功了。");
						$("form").resetForm();
						var vals = $("input[name='log_category']").val();
						if ( vals.length > 0 ){
							$(".log-cate .log-cate-content .cate-name[data-id='" + vals + "']").trigger("click");
						}
					}else{
						tipPopUp(jsons.error);
					}
				}
			})
		}
	}
});