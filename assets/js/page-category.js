// JavaScript Document
define(function(require, exports, module){
	
	function itemsHover(){
		$(".items")
			.on("mouseover", function(){
				$(this).addClass("current");
			})
			.on("mouseout", function(){
				$(this).removeClass("current");
			});
	}
	
	return {
		init: function(){
			$(function(){
				itemsHover();
			});
		}
	}
});