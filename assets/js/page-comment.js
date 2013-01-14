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
				logid = parentli.attr("data-logid"),
				self = $(this).attr("data-id"),
				_this = this;
				
			var html = 	'<form action="' + config.ajaxUrl.server.replyComment + '" method="post" style="margin:0;padding:0;">'
				+			'<input type="hidden" name="id" value="' + id + '" />'
				+			'<input type="hidden" name="logid" value="' + logid + '" />'
				+			'<input type="hidden" name="self" value="' + self + '" />'
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
						var status = $(".pedit").data("status");
						var _htmls = '<li class="comment-li" data-id="' + params.data.id + '" data-logid="' + logid + '">'
						+				'<div class="comment-zone fn-clear">'
						+					'<span class="p-checked fn-left ' + (status ? "p-show": "") + '"><input type="checkbox" value="' + params.data.id + '" name="ids" /></span>'
						+					'<div class="comment-photo fn-left">'
						+						'<div class="user-photo ui-wrapshadow"><img src="' + params.data.photo + '" /></div>'
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
						thisLi.slideDown("fast", function(){
							parentli.find(".comment-zone:first .comment-context .ac-aduit").removeClass("ac-aduit").addClass("ac-noaduit").text("取消");
							$(_this).parent().find(".ac-aduit").removeClass("ac-aduit").addClass("ac-noaduit").text("取消");
						});
					}else{
						popUpTips(params.error);
					}
				}
			})
		});
	}
	
	function destory(){
		$("body").on("click", ".ac-del", function(event, callback){
			if ( making === true ){
				return;
			}
			
			function doDel(){
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
							$.isFunction(callback) && callback();
						});
					}else{
						popUpTips(params.error);
						making = false;
						$(_this).text("删除");
					}
				});
			}
			
			if ( callback ){
				doDel.call(this)
			}else{
				if ( confirm("确定删除这条评论？") ){
					doDel.call(this);
				}
			}
		});
	}
	
	function passAduit(){
		$("body").on("click", ".ac-aduit", function(event, callback){
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
						$.isFunction(callback) && callback();
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
		$("body").on("click", ".ac-noaduit", function(event, callback){
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
						$.isFunction(callback) && callback();
					}, 500);
				}else{
					popUpTips(params.error);
					making = false;
					$(_this).text("取消");
				}
			});
		});
	}
	
	function openCheckbox(){
		$(".pedit").on("click", function(){
			var status = $(this).data("status");
			if ( status ){
				$(".p-checked").removeClass("p-show");
				$(this).data("status", false);
				closePeditList();
			}else{
				$(".p-checked").addClass("p-show");
				$(this).data("status", true);
				openPeditList.call(this);
			}
		});
	}
	
	function openPeditList(){
		var div = document.createElement("div");
		$(div).appendTo("body");
		var $div = $(div);
		
		$div
			.addClass("peditlist")
			.addClass("ui-wrapshadow")
			.html('<a href="javascript:;" id="pdel">批量删除</a><a href="javascript:;" id="paduit">批量通过</a><a href="javascript:;" id="punaduit">批量取消通过</a>');
		
		var offsets = $(this).offset();
		var height = $(this).outerHeight();
		$div.css({
			top: (offsets.top + height + 8) + "px",
			left: (offsets.left + $(this).outerWidth() - $div.outerWidth()) + "px"
		});
	}
	
	function closePeditList(){
		$(".peditlist").slideUp("fast", function(){
			$(this).remove();
		});
	}
	
	function closeStatusBox(word){
		$("#postingbox").html(word);
		var _this = this;
		setTimeout(function(){
			$(_this).find(".close").trigger("click");
		}, 2000);
	}
	
	function pAction(elements, types, str){
		$("body").on("click", elements, function(){
			var status = $(".pedit").data("status");
			if ( status ){
				var ids = [],
					$elements = $(".p-checked").find("input[name='ids']"),
					pocks = [];
					
				$elements.each(function(){
					if ( $(this).attr("checked") ){
						pocks.push(this);
					}
				});

				if ( pocks.length > 0 ){
					$.loading({
						effect: "deformationZoom", 
						word: '正在发送数据..',
						callback: function(){
							var _this = this;
							if ( confirm("确定这么做？") ){
								pedit(pocks, types, 0, function(){
									closeStatusBox.call(_this, str);
								});
							}else{
								closeStatusBox.call(_this, "正在取消...");
							}
						}
					});
				}
			}
		});
	}
	
	function pedit(arr, type, i, callback){
		if ( i === undefined ){ i = 0; }
		if ( arr[i] !== undefined ){
			var k = $(arr[i]).parent().next().next().find(type);
			if ( k.size() > 0 ){
				k.trigger("click", function(){
					pedit(arr, type, i + 1, callback);
				});
			}else{
				pedit(arr, type, i + 1, callback);
			}
		}else{
			$.isFunction(callback) && callback();
		}
	}
	
	return {
		init: function(){
			$(function(){
				reply();
				destory();
				passAduit();
				unPassAduit();
				openCheckbox();
				pAction("#pdel", ".ac-del", "全部删除完毕");
				pAction("#paduit", ".ac-aduit", "全部通过完毕");
				pAction("#punaduit", ".ac-noaduit", "全部取消完毕");
			});
		}
	}
});