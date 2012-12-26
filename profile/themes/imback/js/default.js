// JavaScript Document
define(function(){
	$(function(){
		var width = 600;
		$("img").each(function(){
			if ( $(this).outerWidth() > width ){
				$(this).css("width", "600px");
			}
		});
	});
});