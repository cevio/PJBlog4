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
			
			$overlayer.css({
				top : top + "px",
				left : left + "px"
			});
		});
		
		$overlayer
		.on("overlay.deformationzoom.popup", function(event, callback){
			
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
			}, "slow", function(){ 
				$(_this).html(options.content);
				$.isFunction(callback) && callback.call(this);
			});
			
		})
		
		.on("overlay.deformationzoom.drop", function(event, callback){
			$(this).empty().animate({
				width: $(window).width() + "px",
				height: $(window).height() + "px",
				top: "0px",
				left: "0px",
				opacity: 0
			}, 100, function(){ 
				$(this).remove(); 
				if ( options.mask === true ){ $masker.remove(); } 
				$.isFunction(callback) && callback.call(this);
			});
		})
		
		.on("overlay.dialog.popup", function(event, callback){
			options.content = '<div class="dialog"><div class="title fn-clear"><div class="fn-left mtitle">提示</div><a href="javascript:;" class="fn-right close"><span class="iconfont">&#223;</span></a></div><div class="content">' + options.content + '</div><div class="bom"><input type="button" value="确定" class="tpl-button-blue close" /></div></div>';
			$(this).trigger("overlay.deformationzoom.popup", function(){
				var _this = this;
				$(this).find(".close").on("click", function(){
					$(_this).trigger("overlay.deformationzoom.drop");
				});
				$.isFunction(callback) && callback.call(this);
			});
		});
		
		return $overlayer;
			
	}
});