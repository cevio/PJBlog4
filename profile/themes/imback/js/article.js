// JavaScript Document
define(function(require, exports, module){
	
	var article = require("article");
	
	function init_postCommentFormHTML(){
		var template = '<form action="server/proxy/comment.asp?j=post" id="postcomment" method="post">'
            	+	'<input type="hidden" name="logid" value="' + postid + '" />'
            	+	'<input type="hidden" name="commid" value="0" />';
				
		if ( !config.isLogin() ){
			template += '<div class="text">昵称：<input type="text" value="" name="username" /></div><div class="text">邮箱：<input type="text" value="" name="usermail" /></div>';
		}
				
			template +=	'<div class="textarea"><textarea name="content"></textarea></div>'
				+	'<div class="submit"><input type="submit" value="提交" /> <input type="button" value="取消" class="close" /></div>'
            + 	'</form>';
		
		return template;
	}
	
	function init_replyFormHTML(id){
		var template = '<form action="server/proxy/comment.asp?j=post" id="postcomment" method="post">'
            	+	'<input type="hidden" name="logid" value="' + postid + '" />'
            	+	'<input type="hidden" name="commid" value="' + id + '" />';
		if ( !config.isLogin() ){
			template += '<div class="text">昵称：<input type="text" value="" name="username" /></div><div class="text">邮箱：<input type="text" value="" name="usermail" /></div>';
		}
			template +=	'<div class="textarea"><textarea name="content"></textarea></div>'
				+	'<div class="submit"><input type="submit" value="提交" /> <input type="button" value="取消" class="close" /></div>'
            + 	'</form>';
			
		return template;
	}
	
	function init_postcomment(){
		$("#postnewcomment").on("click", function(){
			if ( article.isSendData === false ){
				article.isSendData = true;
				var offset = $(this).offset(),
					width = $(this).outerWidth(),
					height = $(this).outerHeight();
					
				var postFormDiv = document.createElement("div");
				$(postFormDiv).appendTo("body");
				$(postFormDiv).addClass("postcommentzone").html(init_postCommentFormHTML());
				$(postFormDiv).css("position", "absolute");
				
				var postFormDivWidth = $(postFormDiv).outerWidth(),
					postFormDivHeight = $(postFormDiv).outerHeight();
					
				$(postFormDiv).css({
					top: (offset.top + height) + "px",
					left: (offset.left + width - postFormDivWidth) + "px"
				});
				
				$(postFormDiv).on("post.close", function(){
					article.isSendData = false;
					$(this).remove();
				})
				.find(".close").on("click", function(){
					$(postFormDiv).trigger("post.close");
				});
				
				article.PostComment({
					formElement: $(postFormDiv).find("form"),
					beforeSubmit: function(){
						
					},
					success: function(jsons){
						article.isSendData = false;
						if ( jsons && jsons.success ){
							$(postFormDiv).trigger("post.close");
							window.location.reload();
						}else{
							alert(jsons.error);
						}
					},
					error: function(){
						article.isSendData = false;
						alert("发送出错");
					}
				});
			}
		});
	}
	
	function init_reply(){
		$("body").on("click", '.postreply', function(){
			if ( article.isSendData === false ){
				article.isSendData = true;
				var id = $(this).data("id");
				if ( !$(this).next().hasClass("postreplyform") ){
					var div = document.createElement("div");
					$(this).after(div);
					$(div).addClass("postreplyform").html(init_replyFormHTML(id));
					
					$(div).on("post.close", function(){
						article.isSendData = false;
						$(this).remove();
					})
					.find(".close").on("click", function(){
						$(div).trigger("post.close");
					});
					
					article.PostComment({
						formElement: $(div).find("form"),
						beforeSubmit: function(){
							
						},
						success: function(){
							article.isSendData = false;
							$(div).trigger("post.close");
							window.location.reload();
						},
						error: function(){
							article.isSendData = false;
							alert("发送出错");
						}
					});
				}
			}
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_postcomment();
				init_reply();
				var width = 600;
				$("img").each(function(){
					if ( $(this).outerWidth() > width ){
						$(this).css("width", "600px");
					}
				});
			});
		}
	}
});