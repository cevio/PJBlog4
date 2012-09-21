// JavaScript Document
define(['form'], function(require, exports, module){
	var tpl = require("tpl-category");
	
	function init_bindEvents(){
		
		// 向上滚动
		$("body").on("cate.scrollTop", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "-31px" }, "fast", callback);
		})
		// 向下滚动
		.on("cate.scrollBom", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "0px" }, "fast", callback);
		})
		
		// 编辑事件
		.on("cate.edit", ".items", function(event, id){
			var _this = this;
			$.getJSON(config.ajaxUrl.server.getCateInfo, { id: id }, function(jsons){
				if ( jsons && jsons.success ){
					$(".list").trigger("cate.abort", function(){
						$(_this).trigger("cate.scrollTop", function(){
							$(this).find(".editzone").html(tpl.editCategorySimple());
							$("body").append(tpl.editCategorySimpleInfo());
							
							var width = $(this).outerWidth(),
								offset = $(this).offset();
								
							$("#updateCategoryInfo").css({
								width: width + "px",
								top: (offset.top + 62) + "px",
								left : offset.left + "px"
							});
							
							$(_this).find("form").ajaxForm({
								dataType: "json",
								beforeSubmit: function(){
									var arr = ['cateOrder', 'cateRoot', 'cateCount', 'cateIcon', 'cateIsShow', 'cateOutLink'];
									
									for ( var i = 0 ; i < arr.length ; i++ ){
										$(_this).find("[name='" + arr[i] + "']").val($("#updateCategoryInfo").find("[name='t" + arr[i] + "']").val());
									}
									
								},
								success: function(datas){
									
								}
							});
							
						});
					});
				}else{
					alert(jsons.error);
				}
			});
		})
		
		// 撤销事件
		.on("cate.abort", ".list", function(event, callback){
			$("#updateCategoryInfo").remove();
			$(this).find(".editzone").empty();
			$(this).find(".scroll-wrap").css("margin-top", "0px");
			$.isFunction(callback) && callback();
		});
		
		$("body").on("click", "#updateCategoryInfo .updateCategoryInfoClose", function(){
			$("#updateCategoryInfo").remove();
			$(".list").find(".editzone").empty();
			$(".list .items").trigger("cate.scrollBom");
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_bindEvents();
				$("body").on("click", ".action-edit", function(){
					var id = $(this).attr("data-id"), parent = $(this).parents(".items:first");
					parent.trigger("cate.edit", id);
				});
			});
		}
	}
});