// JavaScript Document
define(function(require, exports, module){
	
	var overlay = function( node ){
		this.node = node;
	}
	
	overlay.prototype.deformationZoom = function( callback ){
		var width = $(this).outerWidth(),
			height = $(this).outerHeight(),
			_this = this;
			
		$(this).trigger("overlay.position", function(offset){
			var left = offset.left,
				top = offset.top;
				
			$(this).on("deformationZoom.popup", function(){
				$(this).css({
					width: $(window).width() + "px",
					height: $(window).height() + "px",
					top: "0px",
					left: "0px",
					opacity: 0
				});
				
				$(this).animate({
					width: width + "px",
					height: height + "px",
					left: left + "px",
					top: top + "px",
					opacity: 1
				}, "slow", callback);
			})
			
			.on("deformationZoom.drop", function(){
				$(this).empty().animate({
					width: $(window).width() + "px",
					height: $(window).height() + "px",
					top: "0px",
					left: "0px",
					opacity: 0
				}, 100, function(){ 
					$(this).trigger("masker.close");
					$(this).remove();	
				});
			});
			
			$(this).find(".close").on("click", function(){
				$(_this).trigger("deformationZoom.drop");
			});
			
			$(this).trigger("deformationZoom.popup");
		});
	}
	
	$.overlay = function(options){
		options = $.extend({
			mask: true,
			opacity: .5,
			background: "#777",
			content: '',
			effect: 'fadeIn',
			callback: null
		}, options || {});
		
		var $masker;
		
		if ( options.mask === true && $(".fixedMasker").size() === 0 ){
			$masker = $(document.createElement("div"));
			$masker.appendTo("body")
				   .addClass("fixedMasker")
				   .css("background", options.background)
				   .css("opacity", options.opacity);
		}
		
		var $overlayer = $(document.createElement("div"));
			$overlayer.appendTo("body").addClass("fixed").addClass("ui-wrapshadow").html(options.content);
			
		function getTL(){
			var left = ($(window).width() - $overlayer.outerWidth()) / 2;
			var top = ($(window).height() - $overlayer.outerHeight()) / 2;
			return {left:left, top:top};
		}
			
		function resize(){
			var offset = getTL();
			
			$overlayer.css({
				top : offset.top + "px",
				left : offset.left + "px"
			});
		}
			
		$(window).on("resize", resize);
		$overlayer.on("masker.close", function(){
			if ( options.mask === true ){
				$masker.remove();
			}
		}).on("overlay.position", function(event, callback){
			$.isFunction(callback) && callback.call($overlayer, getTL());
		});
		
		resize();

		var ect = new overlay($overlayer);
		
		if ( ect[options.effect] !== undefined ){
			ect[options.effect].call($overlayer, options.callback);
		}else{
			$overlayer.trigger("masker.close");
		}	
	}
	
	$.dialog = function( options ){
		options.content = '<div class="dialog fn-clear" style="width:250px;"><div class="title fn-clear"><div class="fn-left mtitle">提示</div><a href="javascript:;" class="fn-right close">关闭</a></div><div class="content">' + options.content + '</div><div class="bom"><input type="button" value="确定" class="button close" /></div></div>';
		$.overlay(options);
	}
	
	$.dialogSet = function( options ){
		options.content = '<div class="dialog fn-clear"><form action="' + options.action + '" method="post" style="margin:0; padding:0;"><div class="title fn-clear"><div class="fn-left mtitle">设置</div><a href="javascript:;" class="fn-right close">关闭</a></div><div class="content">' + options.content + '</div><div class="bom"><input type="submit" value="保存" class="button" /></div></form></div>';
		$.overlay(options);
	}
	
	$.updateBox = function(options){
		options.content = '<div class="ui-updatebox ui-wrapshadow">' + options.content + '</div>';
		$.overlay(options);
	}
	
	return overlay;
});