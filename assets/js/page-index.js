// JavaScript Document
define(['overlay', 'form'],function(require, exports, module){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	var pickHTML = {
		"n1": function(params){
			return "等待平台完成，推送最新PJBlog4信息。";
		},
		"n2": function(params){
			return "等待平台完成，推送最新PJBlog4主题。";
		},
		"n3": function(params){
			return "等待平台完成，推送最新PJBlog4插件。";
		}
	}
	
	function bindTabs(){
		$(".tabs a").on("click", function(){
			var i = $.inArray(this, $(".tabs a").toArray());
			$(".tabs a").removeClass("active");
			$(this).addClass("active");
			$(".plant-infos .plant-infos-item").hide();
			$(".plant-infos .plant-infos-item").eq(i).show();
		});
		$(".tabs a").eq(0).trigger("click");
	}

	function getNews(callback){
		require.async(config.platform + "/proxy/news.js", function( params ){
			console.log(params);
			if ( params ){
				var s = [1, 2, 3],
					d,
					html = { n1: "", n2: "", n3: "" };
					
				for ( var j = 0 ; j < s.length ; j++ ){
					var t = "n" + s[j],
						m = params[t];
						
					for ( i = 0 ; i < m.length ; i++ ){
						d = m[i];
						var k = pickHTML[t];
						if ( !k ){
							console.log(t);
						}
						html[t] += k(d);
					}
					$("#" + t).html(html[t]);
				}
				$.isFunction(callback) && callback();
			}
		});	
	}
	
	function ajaxReply(){
		$("body").on("click", ".action-reply", function(){
			var root = $(this).attr("data-root"),
				logid = $(this).attr("data-logid"),
				replybox = $(this).parent().next();
				
			if ( !isNaN(root) && !isNaN(logid) ){
				var html = '<div class="fn-clear">'
				+			'<div class="fn-left imgs"><img src="' + userphoto + '" /></div>'
				+			'<div class="masker">'
				+				'<div class="replyarea">'
				+					'<form action="' + config.ajaxUrl.server.replyComment + '" method="post" style="margin:0px; padding: 0px;">'
				+						'<input type="hidden" name="id" value="' + root + '" /><input type="hidden" value="' + logid + '" name="logid" />'
				+						'<div class="replycontent"><textarea name="content" placeholder="填写回复内容"></textarea></div>'
				+						'<div class="replyaction"><input type="submit" value="保存" class="button" /> <input type="button" value="取消" class="button closereply"></div>'
				+					'</form>'
				+				'</div>'
				+			'<div>'
				+			'</div>';
				replybox.html(html);
				replybox.slideDown("fast", function(){
					replybox.find("form").ajaxForm({
						dataType: "json",
						beforeSubmit: function(){
							if ( replybox.find("textarea[name='content']").val().length === 0 ){
								popUpTips("请填写回复内容");
								return false;
							}
						},
						success: function( params ){
							if ( params && params.success ){
								var chtml = '<li class="items fn-clear" style="display: none;">'
								+				'<div class="photo fn-right ui-wrapshadow"><img src="' + params.data.photo + '" /></div>'
								+				'<div class="infos fn-left ui-wrapshadow">'
								+					'<div class="infocotent">'
								+						'<div class="name">' + params.data.name + '</div>'
								+						'<div class="word">' + replybox.find("textarea[name='content']").val() + '</div>'
								+						'<div class="action fn-clear"><a href="javascript:;" class="action-del fn-left" data-id="' + params.data.id + '" data-logid="' + params.data.logid + '">删除</a><a href="javascript:;" class="action-reply fn-right" data-logid="' + params.data.logid + '" data-root="' + params.data.root + '">回复</a></div>'
								+						'<div class="replybox"></div>'
								+					'</div>'
								+				'</div>'
								+			'</li>';
								
								replybox.parents("ul:first").prepend(chtml);
								replybox.parents("ul:first").find("li:first").slideDown("fast");
								replybox.find(".closereply").trigger("click");
							}else{
								popUpTips(params.error);
							}
						},
						error: function(){
							popUpTips("网路出错");
						}
					});
				});
				replybox.find(".closereply").on("click", function(){
					replybox.slideUp("fast", function(){
						replybox.empty();
					});
				});
			}
		});
	}
	
	function commentDestory(){
		$("body").on("click", ".action-del", function(){
			if ( confirm("确定删除？") ){
				var id = $(this).attr("data-id"),
					logid = $(this).attr("data-logid"),
					_this = this;
				
				if ( !isNaN(id) && !isNaN(logid) ){
					$.getJSON(config.ajaxUrl.server.delComment, {id: id, logid: logid}, function(params){
						if ( params && params.success ){
							$(_this).parents("li:first").animate({
								height: "0px",
								opacity: 0
							}, "slow", function(){
								$(this).remove();
							});
						}else{
							popUpTips(params.error);
						}
					});
				}
			}
		});
	}
	
	exports.init = function(){
		getNews(bindTabs);
		ajaxReply();
		commentDestory();
	}
});