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
	
	function init_postArticle(){
		$("#submit").on("click", function(){
			var content = $("textarea[name='log_content']").val();
				content = init_articleCut(content, articleCut || 300);
				content = init_autoCompleteHTMLCode(content);
				
			$("textarea[name='log_shortcontent']").val(content.replace(/\<textarea([\s\S]+?)\<\/textarea\>/ig, "&lt;textarea$1&lt;/textarea&gt;"));
			
			$("form").ajaxSubmit({
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
						var vals = $("input[name='log_category']").val();
						if ( $("form input[name='id']").val().length === 0 ) { 
							$("form").resetForm();
						}
						if ( vals.length > 0 ){
							$(".log-cate .log-cate-content .cate-name[data-id='" + vals + "']").trigger("click");
						}
					}else{
						tipPopUp(jsons.error);
					}
				}
			});
		});
	}
	
	function init_articleCut(text, n){
		var r = 0, 
			v = "",
			b = true,
			t = 0;
			
		for ( var i = 0 ; i < text.length ; i++ ){
			if ( r + 1 < n ){
				var value = text.charAt(i);
					v += value;
					
				switch ( value ){
					case "<":
						b = false;
						t = 1;
						break;
					case ">":
						b = true;
						t = 0;
						break;
					case "&":
						b = false;
						t = 2;
						break;
					case ";":
						if ( t === 2 ){
							b = true;
							r++;
							t = 0;
						}
						break;
					default:
						if ( b === true ){
							r++;
						}
				}
				
			}else{
				break;
			}
		}
		
		return v;
	}
	
	function init_autoCompleteHTMLCode(text, callback){
		var iframe = document.createElement("iframe");
			$(iframe).appendTo("body");
			iframe.contentWindow.document.open(); 
			iframe.contentWindow.document.writeln(text); 
			iframe.contentWindow.document.close();
			text = iframe.contentWindow.document.body.innerHTML;
			$(iframe).remove();
			if ( $.isFunction(callback) ){
				return callback(text);
			}else{
				return text;
			}
	}
	
	return {
		init: function(){
			init_choose_cates();
			$("textarea[name='log_content']").xheditor({
				skin: "nostyle"
			});
			init_postArticle();
		}
	}
});