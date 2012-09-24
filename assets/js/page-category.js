// JavaScript Document
define(['form', 'overlay'], function(require, exports, module){
	var tpl = require("tpl-category"),
		isAdding = false;
		
	function cantContinueToEditor(){
		popUpTips("请先完成编辑或者添加过程。");
	}
	
	function popUpTips( words, callback ){
		var $overlayer = $.overlay({
			content: words
		});
				
		$overlayer.trigger("overlay.dialog.popup", callback);
	}
	
	function editComplete(jsons){
		$(this).find(".view [data-id]").attr("data-id", jsons.data.id);
		$(this).find(".view .label .box span").text($(this).find("input[name='cateName']").val());
		$(this).find(".view .edit-info").text($(this).find("input[name='cateInfo']").val());
		$(".list").trigger("cate.abort");
	}
	
	function copyData(jsons){
		$(this).find("input[name='cateName']").val(jsons.data.cateName);
		$(this).find("input[name='cateInfo']").val(jsons.data.cateInfo);
		$(this).find("input[name='cateOrder']").val(jsons.data.cateOrder);
		$(this).find("input[name='cateRoot']").val(jsons.data.cateRoot);
		$(this).find("input[name='cateCount']").val(jsons.data.cateCount);
		$(this).find("input[name='cateIcon']").val(jsons.data.cateIcon);
		$(this).find(".updateCategoryInfo .chooseIconImg").attr("src", "profile/icons/" + jsons.data.cateIcon);
		$(this).find("input[name='cateIsShow'][value='" + (jsons.data.cateIsShow === true ? "1" : "0") + "']").attr("checked", true);
		$(this).find("input[name='cateOutLink'][value='" + (jsons.data.cateIsShow === true ? "1" : "0") + "']").attr("checked", true);
		$(this).find("input[name='cateOutLinkText']").val(jsons.data.cateOutLinkText);
	}
	
	function beforeSubmitCallback(){
		var canPost = true, 
			error = "";
		
		if ( this.find("input[name='cateName']").val().length === 0 ){
			canPost = false;
			error = "分类名不能为空。";
		}
		
		if ( this.find("input[name='cateInfo']").val().length === 0 ){
			canPost = false;
			error = "分类说明不能为空。";
		}
		
		if ( /^\d+$/.test(this.find("input[name='cateOrder']").val()) === false ){
			canPost = false;
			error = "分类排序必须为数字类型。";
		}
		
		if ( /^\d+$/.test(this.find("input[name='cateCount']").val()) === false ){
			canPost = false;
			error = "日志数必须为数字类型。";
		}else{
			if ( Number(this.find("input[name='cateCount']").val()) < 0 ){
				canPost = false;
				error = "日志数必须大于等于零。";
			}
		}
		
		if ( this.find("input[name='cateIcon']").val().length === 0 ){
			canPost = false;
			error = "请选择分类图标。";
		}
		
		if ( this.find("input[name='cateOutLink']") === "1" ){
			if ( this.find("input[name='cateOutLinkText']").val().length === 0 ){
				canPost = false;
				error = "外部链接地址不能为空。";
			}
		}
		
		return {
			success: canPost,
			error: error
		}
	}
	
	function init_bindEvents(){
		
		$("body")
		
		// 向上滚动
		.on("cate.scrollTop", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "-" + $(this).find(".view").outerHeight() + "px" }, "fast", callback);
		})
		
		// 向下滚动
		.on("cate.scrollBom", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "0px" }, "fast", callback);
		})
		
		// 编辑事件
		.on("cate.edit", ".items", function(event, id){
			if ( isAdding === false ){
				var _this = this;
				$.getJSON(config.ajaxUrl.server.getCateInfo, { id: id }, function(jsons){		
					if ( jsons && jsons.success ){
						$(".list").trigger("cate.abort", function(){
							isAdding = true;
							var height = $(_this).find(".editzone").html(tpl.editCategorySimple()).outerHeight();
								$(_this).css("height", height + "px");
								copyData.call(_this, jsons);
								$(_this).find("input[name='id']").val(id);
							
							$(_this).trigger("cate.scrollTop", function(){
								$(_this).addClass("actived");
								$(_this).find("form").ajaxForm({
									dataType: "json",
									beforeSubmit: function(){
										var h = beforeSubmitCallback.call($(_this).find("form"));
										if ( h.success === false ){
											popUpTips(h.error);
											return false;
										}
									},
									success: function(datas){
										if ( jsons && jsons.success ){
											editComplete.call(_this, datas);
										}else{
											popUpTips(jsons.error);
										}
									}
								});
							});
							
						});
						
					}else{
						popUpTips(jsons.error);
					}	
				});
			}else{
				cantContinueToEditor();
			}
		})
		
		// 撤销事件
		.on("cate.abort", ".list", function(event, callback){
			var obj = $(this).find(".actived"), dataidElement;
			if ( obj.size() > 0 ){
				obj.find(".scroll-wrap").animate({
					"margin-top" : "0px"
				}, "fast", function(){
					obj.animate({
						height: "31px"
					}, "fast", function(){
						obj.removeClass("actived").find(".editzone").empty();
						dataidElement = obj.find("[data-id]").eq(0);
						if ( Number(dataidElement.attr("data-id")) === 0 ){
							obj.remove();
						}
						isAdding = false;
						$.isFunction(callback) && callback();
					});
				});
			}else{
				dataidElement = obj.find("[data-id]").eq(0);
				if ( Number(dataidElement.attr("data-id")) === 0 ){
					obj.remove();
				}
				$.isFunction(callback) && callback();
			}
		})
		
		.on("click", ".updateCategoryInfo .updateCategoryInfoClose", function(){
			$(".list").trigger("cate.abort");
		})
		
		.on("click", ".action-add", function(){
			if ( isAdding === false ){
				var id = Number($(this).attr("data-id")) || 0,
					parent = null, 
					cls, 
					label, 
					_cls, 
					cb;
					
				if ( id === 0 ){
					parent = $(".list .items:last");
					cls = "one";
					_cls = "tpl-button-gray";
					cb = function(){
						this.find(".action-add").hide();
					};
				}else{
					parent = $(this).parents(".items:first");
					cls = "two";
					_cls = "tpl-button-green";
					cb = function(){
						this.find(".action-add").remove();
					};
				}
				
				$(".list").trigger("cate.abort", function(){
					isAdding = true;
					parent.after(tpl.addCategory());
					label = parent.next();
					label.addClass(cls).find(".view .label").addClass(_cls);
					label.find("input[name='cateRoot']").val(id);
					label.find("form").attr("action", config.ajaxUrl.server.addCate).ajaxForm({
						dataType: "json",
						beforeSubmit: function(){
							var h = beforeSubmitCallback.call(label.find("form"));
							if ( h.success === false ){
								popUpTips(h.error);
								return false;
							}
						},
						success: function(jsons){
							if ( jsons && jsons.success ){
								editComplete.call(label, jsons);
							}else{
								popUpTips(jsons.error);
							}
						}
					});
					$.isFunction(cb) && cb.call(label);
					label.css("height", label.find(".editzone").outerHeight() + "px");
					label.trigger("cate.scrollTop", function(){
						label.addClass("actived");
					});
				});
			}else{
				cantContinueToEditor();
			}
		})
		
		.on("click", ".chooseIcon", function(){
			var _this = this;
			$.getJSON(config.ajaxUrl.server.iconList, {}, function(arrays){
				if ( arrays.length > 0 ){
					var itemHTML = '';
					for ( var i = 0 ; i < arrays.length ; i++ ){
						itemHTML += tpl.iconTPL.items(arrays[i]);
					}
					$(_this).after(tpl.iconTPL.global(itemHTML));
					$(_this).parents(".items:first").css("height", $(_this).parents(".editzone:first").outerHeight() + "px");
				}
			});
		})
		
		.on("click", ".iconChooseItem", function(){
			var value = $(this).attr("data-value"),
				img = $(this).parents(".iconChooseArea:first").prev().prev(),
				input = img.prev();
			
			img.attr("src", "profile/icons/" + value);
			input.val(value);
		})
		
		.on("cate.destory", ".items", function(event, id){
			var _this = this;
			if ( isAdding === false ){
				$.getJSON(config.ajaxUrl.server.destoryCate, {id: id}, function( jsons ){
					if ( jsons && jsons.success ){
						$(_this).animate({
							height: "0px",
							opacity: "0"
						}, "fast", function(){
							$(_this).remove();
						});
					}else{
						popUpTips(jsons.error);
					}
				});
			}else{
				cantContinueToEditor();
			}
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
				})
				.on("click", ".action-del", function(){
					var id = $(this).attr("data-id");
						parent = $(this).parents(".items:first");
					
					parent.trigger("cate.destory", id);
				});
			});
		}
	}
});