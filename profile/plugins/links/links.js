// JavaScript Document
define(function(require, exports, module){
	
	var link = require("article");
	
	function init_postlinkFormHTML(){
		var template = '<form action="'+pluginFolder+'/ajax.asp?j=post" id="postlink" method="post"><input type="hidden" value="post" name="j" />';
				
		if ( !config.isLogin() ){
			template += '<div class="text">网站：<input type="text" value="" name="linkname" /></div><div class="text">网址：<input type="text" value="" name="linkurl" /></div><div class="text">LOGO：<input type="text" value="" name="linkimage" /></div>';
		}
				
			template +=	'<div class="textarea"><textarea name="linkinfo"></textarea></div>'
				+	'<div class="submit"><input type="submit" value="提交" /> <input type="button" value="取消" class="close" /></div>'
            + 	'</form>';
		
		return template;
	}
	

	function init_postlink(){
		$("#postnewlink").on("click", function(){
			if ( link.isSendData === false ){
				link.isSendData = true;
				var offset = $(this).offset(),
					width = $(this).outerWidth(),
					height = $(this).outerHeight();
					
				var postFormDiv = document.createElement("div");
				$(postFormDiv).appendTo("body");
				$(postFormDiv).addClass("postlinkzone").html(init_postlinkFormHTML());
				$(postFormDiv).css("position", "absolute");
				
				var postFormDivWidth = $(postFormDiv).outerWidth(),
					postFormDivHeight = $(postFormDiv).outerHeight();
					
				$(postFormDiv).css({
					top: (offset.top + height) + "px",
					left: (offset.left + width - postFormDivWidth) + "px"
				});
				
				$(postFormDiv).on("post.close", function(){
					link.isSendData = false;
					$(this).remove();
				})
				.find(".close").on("click", function(){
					$(postFormDiv).trigger("post.close");
				});
				
				link.PostComment({
					formElement: $(postFormDiv).find("form"),
					beforeSubmit: function(){
						
					},
					success: function(jsons){
						link.isSendData = false;
						if ( jsons && jsons.success ){
							$(postFormDiv).trigger("post.close");
							if (aduit==true){alert('提交成功，请等待博主审核!');}
							window.location.reload();
						}else{
							alert(jsons.error);
						}
					},
					error: function(){
						link.isSendData = false;
						alert("发送出错");
					}
				});
			}
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_postlink();
			});
		}
	}
});