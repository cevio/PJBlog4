// JavaScript Document

define(['overlay', 'form'], function(require, exports, module){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	var onDelete = function(){
		$("body").on("click", ".action-delete", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
				if ( confirm("确定要删除该用户？") ){
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
							$(_this).text("删除");
						}
					});
				}else{
					$(this).data("status", false);
				}
			}
		});
	}
	
	var onForce = function(){
		$("body").on("click", ".action-force", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
			if ( !status ){
				$(this).data("status", true);
				$(this).text("正在禁止..");
				$.getJSON(config.ajaxUrl.server.memForce, {id: id}, function(xdata){
					$(_this).data("status", false);
					if ( xdata && xdata.success ){
						$(_this).text("禁止成功");
						setTimeout(function(){
							$(_this).text("恢复").removeClass("action-force").addClass("action-unforce");
						}, 500);
					}else{
						popUpTips(xdata.error);
						$(_this).text("禁止");
					}
				});
			}
		});
	}
	
	var onUnForce = function(){
		$("body").on("click", ".action-unforce", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
				$(this).text("正在恢复..");
				$.getJSON(config.ajaxUrl.server.memUnForce, {id: id}, function(xdata){
					$(_this).data("status", false);
					if ( xdata && xdata.success ){
						$(_this).text("恢复成功");
						setTimeout(function(){
							$(_this).text("禁止").removeClass("action-unforce").addClass("action-force");
						}, 500);
					}else{
						popUpTips(xdata.error);
						$(_this).text("恢复");
					}
				});
			}
		});
	}
	
	var onToAdmin = function(){
		$("body").on("click", ".action-up", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
				$(this).text("正在提升..");
				$.getJSON(config.ajaxUrl.server.memToAdmin, {id: id}, function(xdata){
					$(_this).data("status", false);
					if ( xdata && xdata.success ){
						$(_this).text("提升成功");
						setTimeout(function(){
							$(_this).text("降阶").removeClass("action-up").addClass("action-down");
						}, 500);
					}else{
						popUpTips(xdata.error);
						$(_this).text("提升");
					}
				});
			}
		});
	}
	
	var onUnToAdmin = function(){
		$("body").on("click", ".action-down", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
				$(this).text("正在降阶..");
				$.getJSON(config.ajaxUrl.server.memUnToAdmin, {id: id}, function(xdata){
					$(_this).data("status", false);
					if ( xdata && xdata.success ){
						$(_this).text("降阶成功");
						setTimeout(function(){
							$(_this).text("提升").removeClass("action-down").addClass("action-up");
						}, 500);
					}else{
						popUpTips(xdata.error);
						$(_this).text("降阶");
					}
				});
			}
		});
	}
	
	var searchBind = function(){
		var sending = false;
		$("#search").ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( sending === true ){
					return false;
				}
				var vals = $("input[name='keyword']").val();
				if ( vals.length === 0 ){
					return false;
				}
			},
			success: function( params ){
				sending = false;
				if ( params.success ){
					
					(function(){
						var userList = params.data;
						
						if ( userList.length > 0 ){
							var htmls = "";
							for ( var i = 0 ; i < userList.length ; i++ ){
								var t = userList[i];
								htmls += 	'<li class="fn-left userlist">'
								+				'<div class="list clafn-clear">'
								+					'<div class="photo ui-wrapshadow fn-left"><img src="' + (t.photo + '/50') + '" /></div>'
								+					'<div class="info fn-left">'
								+						'<div class="name">' + t.nickname + '</div>'
								+						'<div class="action">'
								+							'<a href="javascript:;" class="action-delete" data-id="' + t.id + '" title="删除后无法恢复，请慎重。">删除</a> '
								+							(t.canlogin === true ? '<a href="javascript:;" class="action-force" data-id="' + t.id + '" title="对该用户的登入权限进行限制">禁止</a> ' : '<a href="javascript:;" class="action-unforce" data-id="' + t.id + '" title="对该用户的登入权限进行限制">恢复</a> ')
								+							(t.isadmin === true ? '<a href="javascript:;" class="action-down" data-id="' + t.id + '" title="对该用户进行权限上的提升或者降阶，可以进入后台或者还原为普通用户。">降阶</a> ' : '<a href="javascript:;" class="action-up" data-id="' + t.id + '" title="对该用户进行权限上的提升或者降阶，可以进入后台或者还原为普通用户。">提升</a> ')
								+						'</div>'
								+					'</div>'
								+				'</div>'
								+			'</li>';
							}
							$(".userlist").html(htmls);
						}else{
							$(".userlist").text("没有找到用户");
						}
					})();
					
				}else{
					popUpTips(params.error);
				}
			}
		})
	}
	
	exports.init = function(){
		onDelete();
		onForce();
		onUnForce();
		onToAdmin();
		onUnToAdmin();
		searchBind();
	}
});