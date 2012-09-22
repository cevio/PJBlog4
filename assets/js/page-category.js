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
						
						var height = $(_this).find(".editzone").html(tpl.editCategorySimple()).outerHeight();
							$(_this).css("height", height + "px");
							
						$(_this).find("input[name='cateName']").val(jsons.data.cateName);
						$(_this).find("input[name='cateInfo']").val(jsons.data.cateInfo);
						$(_this).find("input[name='cateOrder']").val(jsons.data.cateOrder);
						$(_this).find("input[name='cateRoot']").val(jsons.data.cateRoot);
						$(_this).find("input[name='cateCount']").val(jsons.data.cateCount);
						$(_this).find("input[name='cateIcon']").val(jsons.data.cateIcon);
						$(_this).find("input[name='cateIsShow'][value='" + (jsons.data.cateIsShow === true ? "1" : "0") + "']").attr("checked", true);
						$(_this).find("input[name='cateOutLink'][value='" + (jsons.data.cateIsShow === true ? "1" : "0") + "']").attr("checked", true);
						$(_this).find("input[name='id']").val(id);
						
						$(_this).trigger("cate.scrollTop", function(){
							$(_this).addClass("actived");
							$(_this).find("form").ajaxForm({
								dataType: "json",
								beforeSubmit: function(){},
								success: function(datas){
									if ( jsons && jsons.success ){
										$(_this).find(".view .label .box span").text($(_this).find("input[name='cateName']").val());
										$(_this).find(".view .edit-info").text($(_this).find("input[name='cateInfo']").val());
										$(".list").trigger("cate.abort");
									}else{
										alert(jsons.error);
									}
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
			var obj = $(this).find(".actived");
			if ( obj.size() > 0 ){
				obj.find(".scroll-wrap").animate({
					"margin-top" : "0px"
				}, "fast", function(){
					obj.animate({
						height: "31px"
					}, "fast", function(){
						obj.removeClass("actived").find(".editzone").empty();
						$.isFunction(callback) && callback();
					});
				});
			}else{
				$.isFunction(callback) && callback();
			}
		})
		
		.on("click", ".updateCategoryInfo .updateCategoryInfoClose", function(){
			$(".list").trigger("cate.abort");
		})
		
		.on("click", ".action-add", function(){
			var id = Number($(this).attr("data-id")) || 0,
				parent = null, 
				cls, 
				label, 
				_cls, 
				cb, 
				km;
				
			if ( id === 0 ){
				parent = $(".list .items:last");
				cls = "one";
				_cls = "tpl-button-gray";
				cb = function(){
					this.find(".action-add").hide();
				};
				km = "infoOne";
			}else{
				parent = $(this).parents(".items:first");
				cls = "two";
				_cls = "tpl-button-green";
				cb = function(){
					this.find(".action-add").remove();
				};
				km = "infoTwo";
			}
			
			$(".list").trigger("cate.abort", function(){
				parent.after(tpl.addCategory());
				label = parent.next();
				label.addClass(cls).find(".view .label").addClass(_cls);
				label.find("input[name='cateRoot']").val(id);
				label.find("form").attr("action", config.ajaxUrl.server.addCate).ajaxForm({
					dataType: "json",
					beforeSubmit: function(){},
					success: function(jsons){
						if ( jsons && jsons.success ){
							label.find(".view [data-id]").attr("data-id", jsons.data.id);
							label.find(".view .label .box span").text(label.find("input[name='cateName']").val());
							label.find(".view .edit-info").text(label.find("input[name='cateInfo']").val());
							$(".list").trigger("cate.abort");
						}else{
							alert(jsons.error);
						}
					}
				});
				$.isFunction(cb) && cb.call(label);
				label.css("height", label.find(".editzone").outerHeight() + "px");
				label.trigger("cate.scrollTop", function(){
					label.addClass("actived");
				});
			});
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_bindEvents();
				$("body").on("click", ".action-edit", function(){
					var id = $(this).attr("data-id"), 
						parent = $(this).parents(".items:first");
						
					parent.trigger("cate.edit", id);
				});
			});
		}
	}
});