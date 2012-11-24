// JavaScript Document

define(['overlay'], function(require, exports, module){
	
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	var onDelete = function(){
		$(".action-delete").on("click", function(){
			var id = $(this).attr("data-id"),
				status = $(this).data("status"),
				_this = this;
				
			if ( !status ){
				$(this).data("status", true);
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
					$(this).data("status", false);
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
					$(this).data("status", false);
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
					$(this).data("status", false);
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
					$(this).data("status", false);
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
	
	exports.init = function(){
		onDelete();
		onForce();
		onUnForce();
		onToAdmin();
		onUnToAdmin();
	}
});