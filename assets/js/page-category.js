// JavaScript Document
define(['form'], function(require, exports, module){
	
	function init_tpl_cateEdition(jsons){
		
	}
	
	function init_bindEvents(){
		$("body").on("cate.scrollTop", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "-31px" }, "fast", callback);
		});
		
		$("body").on("cate.scrollBom", ".items", function(event, callback){
			$(this).find(".scroll-wrap").animate({ "margin-top": "0px" }, "fast", callback);
		});
		
		$("body").on("cate.edit", ".items", function(event, id){
			var _this = this;
			$.getJSON("?j=getid", { id: id }, function(jsons){
				if ( jsons && jsons.success ){
					$(_this).trigger("cate.scrollTop", function(){
						$(this).find(".editzone").html(init_tpl_cateEdition(jsons));
					});
				}else{
					// todo error layer.
				}
			});
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