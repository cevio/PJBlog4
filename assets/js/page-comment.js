// JavaScript Document
define(['form', 'overlay'], function(require, exports, module){
	
	var making = false;
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function reply(){
		$("body").on("click", ".ac-reply", function(){
			if ( making === true ){
				return;
			}
			making = true;
			var parentli = $(this).parents("li.comment-root:first"),
				id = parentli.attr("data-id"),
				logid = parentli.attr("data-logid");
				
			var html = 	'<form action="' + config.ajaxUrl.server.replyComment + '" method="post" style="margin:0;padding:0;">'
				+			'<input type="hidden" name="id" value="' + id + '" />'
				+			'<input type="hidden" name="logid" value="' + logid + '" />'
				+			'<div class="replyArea">'
				+				'<div class="reply-title">回复该评论</div>'
				+				'<div class="reply-content"><textarea name="content"></textarea></div>'
				+				'<div class="reply-submit"><input type="submit" value="保存" class="button" /> <input type="button" value="取消" class="button close" /> <span class="reply-info"></span></div>'
				+			'</div>'
				+		'</form>';
				
			var replyElement = document.createElement("div");
			$(this).parent().append(replyElement);
			var $replyElement = $(replyElement);
			$replyElement.addClass("replyBox").addClass("ui-wrapshadow").html(html);
			$replyElement.find("textarea").focus();
			var $form = $replyElement.find("form");
			$form.find(".close").on("click", function(){
				$replyElement.slideUp("fast", function(){
					$replyElement.remove();
					making = false;
				});
			});
			$form.ajaxForm({
				dataType: "json",
				beforeSubmit: function(){
					if ( $form.find("textarea").val().length === 0 ){
						popUpTips("请填写回复内容");
						return false;
					}
				},
				success: function( params ){
					if ( params.success ){
						var _htmls = '<li class="comment-li" data-id="' + params.data.id + '" data-logid="' + logid + '">'
						+				'<div class="comment-zone fn-clear">'
						+					'<div class="comment-photo fn-left">'
						+						'<div class="user-photo ui-wrapshadow"><img src="' + params.data.photo + '/30" /></div>'
						+					'</div>'
						+					'<div class="comment-context">'
						+						'<div class="comment-content">'
						+							'<div class="comment-name">' + params.data.name + ' 于 ' + params.data.date + '发表评论： [ ' + params.data.ip + ' ]</div>'
						+							'<div class="comment-word">' + $form.find("textarea").val() + '</div>'
						+							'<div class="comment-else">'
						+								'<a href="javascript:;" class="ac-reply">回复</a>'
						+								'<a href="javascript:;" class="ac-del">删除</a>'
						+								'<a href="javascript:;" class="ac-noaduit">取消</a>'
						+							'</div>'
						+						'</div>'
						+					'</div>'
						+				'</div>'
						+			'</li>';
						
						var thisul = parentli.find(".comment-children ul");
						
						if ( thisul.size() === 0 ){
							parentli.find(".comment-children").append('<ul class="comment-children-area"></ul>');
						}
						parentli.find(".comment-children ul").prepend(_htmls);
						var thisLi = parentli.find(".comment-children").find("li:first");
						$form.find(".close").trigger("click");
						thisLi.hide();
						thisLi.slideDown("fast");
					}else{
						popUpTips(params.error);
					}
				}
			})
		});
	}
	
	function destory(){
		$("body").on("click", ".ac-del", function(){
			if ( making === true ){
				return;
			}
			making = true;
			
			var parentli = $(this).parents("li:first"),
				id = parentli.attr("data-id"),
				logid = parentli.attr("data-logid"),
				_this = this;
				
			$(this).text("正在删除..");
				
			$.getJSON(config.ajaxUrl.server.delComment, {id: id, logid: logid}, function( params ){
				if ( params.success ){
					parentli.slideUp("fast", function(){
						$(this).remove();
						making = false;
					});
				}else{
					popUpTips(params.error);
					making = false;
					$(_this).text("删除");
				}
			});
		});
	}
	
	function passAduit(){
		$("body").on("click", ".ac-aduit", function(){
			if ( making === true ){
				return;
			}
			making = true;
			
			var parentli = $(this).parents("li:first"),
				id = parentli.attr("data-id"),
				logid = parentli.attr("data-logid"),
				_this = this;
				
			$(this).text("正在通过..");
			
			$.getJSON(config.ajaxUrl.server.passComment, {id: id, logid: logid}, function( params ){
				if ( params.success ){
					$(_this).text("通过成功");
					setTimeout(function(){
						$(_this).removeClass("ac-aduit").addClass("ac-noaduit").text("取消");
						making = false;
					}, 500);
				}else{
					popUpTips(params.error);
					making = false;
					$(_this).text("通过");
				}
			});
		});
	}
	
	function unPassAduit(){
		$("body").on("click", ".ac-noaduit", function(){
			if ( making === true ){
				return;
			}
			making = true;
			
			var parentli = $(this).parents("li:first"),
				id = parentli.attr("data-id"),
				logid = parentli.attr("data-logid"),
				_this = this;
				
			$(this).text("正在取消..");
			
			$.getJSON(config.ajaxUrl.server.unPassComment, {id: id, logid: logid}, function( params ){
				if ( params.success ){
					$(_this).text("取消成功");
					setTimeout(function(){
						$(_this).removeClass("ac-noaduit").addClass("ac-aduit").text("通过");
						making = false;
					}, 500);
				}else{
					popUpTips(params.error);
					making = false;
					$(_this).text("取消");
				}
			});
		});
	}
	
	return {
		init: function(){
			$(function(){
				reply();
				destory();
				passAduit();
				unPassAduit();
			});
		}
	}
});