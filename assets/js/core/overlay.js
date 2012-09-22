// JavaScript Document
define(function(require, exports, module){
	$.overlay = function(options){
		options = $.extend({
			mask: true,
			opacity: .5,
			background: "#000",
			content: '',
			effect: 'fadeIn',
			width: 500,
			height: 200
		}, options || {});
		
		if ( options.mask === true ){
			var $masker = $(document.createElement("div"));
			
				$masker.appendTo("body")
					   .addClass("fixedMasker")
					   .css("background", options.background)
					   .css("opacity", options.opacity);
		}
		
		var $overlayer = $(document.createElement("div"));
			$overlayer.appendTo("body").addClass("fixed").empty();
		
		var htmlElementWidth = options.width,
			htmlElementHeight = options.height,
			curLeft = ($(window).width() - htmlElementWidth) / 2,
			curTop = ($(window).height() - htmlElementHeight) / 2;
			
		$(window).on("resize", function(){
			var top, left;
			
			left = ($(window).width() - htmlElementWidth) / 2;
			top = ($(window).height() - htmlElementHeight) / 2;
			
			if ( animationing === false ){
				$overlayer.css({
					top : top + "px",
					left : left + "px"
				});
			}
		});
		
		$overlayer.on("overlay.popup", function(){
			
			var _this = this;
			
			$(this).css({
				width: $(window).width() + "px",
				height: $(window).height() + "px",
				top: "0px",
				left: "0px",
				opacity: 0
			});
			
			$(this).animate({
				width: htmlElementWidth + "px",
				height: htmlElementHeight + "px",
				left: curLeft + "px",
				top: curTop + "px",
				opacity: 1
			}, "slow", function(){ $(_this).html(options.content); });
			
		})
		
		.on("overlay.drop", function(){
			$(this).empty().animate({
				width: $(window).width() + "px",
				height: $(window).height() + "px",
				top: "0px",
				left: "0px",
				opacity: 0
			}, 100, function(){ $(this).remove(); if ( options.mask === true ){ $masker.remove(); } });
		});
		
		return $overlayer;
			
	}
});