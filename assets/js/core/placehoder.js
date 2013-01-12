// JavaScript Document
define(function( require, exports, module ){
	$.fn.placeHolder = function(){
		this.each(function(){
			try{
				var placeHoderWord = $(this).attr("placeholder"),
					parent,
					_this = this;
					
				if ( $(this).parent().css("position").toLowerCase() !== "relative" ){
					var element = $(this).wrap('<span style="position: relative; display: inline-block;"></span>');
					parent = $(this).parent();
				}else{
					parent = $(this).parent();
				}
				
				parent.append('<label style="position: absolute; top: 0px; left: 0px;">' + placeHoderWord + '</label>');
				var label = parent.find("label"),
					padding = $(this).css("padding-left");
				
				var width = $(this).outerWidth(),
					height = $(this).height(),
					_height = $(this).outerHeight();
					
				label.css({
					width: width + "px",
					height: height === 0 ? "20px" : _height + "px",
					"line-height": height === 0 ? "20px" : _height + "px",
					color: "#999",
					cursor:"text"
				});
				
				if ( padding.length > 0 ){
					label.css("padding-left", padding);
				}
				
				label.on("focus click", function(){
					$(_this).focus();
				});
				
				$(this).on("keyup blur", function(){
					if ( $(this).val().length > 0 ){
						label.hide();
					}else{
						label.show();
					}
				});
			}catch(e){}
		});
		return this;
	}
	
	$.placeHoder = function(){
		if ( !history.pushState ){
			$("*[placeholder]").placeHolder();
		}
	}
	
	$(function(){
		$.placeHoder();
	});
});