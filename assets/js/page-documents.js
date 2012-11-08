// JavaScript Document
define(['tabs'], function(){
	
	function init_documentsListTabs(){
		$(".documents-list").tabs({
			triggerDom : ".documents-list-header a",
			contentDom : ".documents-list-content .documents-list-content-items",
			effect: "opacity"
		});
	}
	
	function init_documentsItemsListTabs(){
		$(".ItemTabs").tabs({
			triggerDom : ".ItemTabs-list a",
			contentDom : ".ItemTabs-content .ItemTabs-content-items",
			effect: "verticalSlip"
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_documentsListTabs();
				init_documentsItemsListTabs();
			});
		}
	}
});