// JavaScript Document
define(['assetss/common/js/sysmo/jQuery'], function( require, exports, module ){
	
	config.map("upload", "assets/js/upload");
	config.map("form", "assets/js/core/form");
	config.map("tpl-category", "assets/js/tpl/tpl-category");
	config.map("overlay", "assets/js/core/overlay");
	config.map("editor", "assets/js/lib/xheditor/editor");
	config.map("tabs", "assets/js/core/tabs");
	config.map("easing", "assets/js/core/jQuery.easing.1.3");
	config.map("article", "assets/js/article");
	
	function cookie(key, value, options) {
        // key and at least value given, set cookie...
        if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
            options = $.extend({}, options);
    
            if (value === null || value === undefined) {
                options.expires = -1;
            }
    
            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setDate(t.getDate() + days);
				options.expires = t;
            }
    
            value = String(value);
    
            return (document.cookie = [
                encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }
    
        // key and possibly options given, get cookie...
        options = value || {};
        var decode = options.raw ? function(s) { return s; } : decodeURIComponent;
    
        var pairs = document.cookie.split('; ');
        for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
            if (decode(pair[0]) === key) return decode(pair[1] || ''); // IE saves cookies with empty string as "c; ", e.g. without "=" as opposed to EOMB, thus pair[1] may be undefined
        }
        return null;
    };
	
	var dummyStyle = document.createElement('div').style,
		vendor = (function () {
			var vendors = 'webkitT,MozT,msT,OT,t'.split(','),
				t,
				i = 0,
				l = vendors.length;
	
			for ( ; i < l; i++ ) {
				t = vendors[i] + 'ransform';
				if ( t in dummyStyle ) {
					return vendors[i].substr(0, vendors[i].length - 1);
				}
			}
	
			return false;
		})(),
		cssVendor = vendor ? '-' + vendor.toLowerCase() + '-' : '',
		cssTransformVendor,
		transEndEventName = (function () {
			if ( vendor === false ) return false;
	
			var transitionEnd = {
				''			: ['transitionend', ''],
				'webkit'	: ['webkitTransitionEnd', '-webkit-'],
				'Moz'		: ['transitionend', ''],
				'O'			: ['oTransitionEnd', '-o-'],
				'ms'		: ['MSTransitionEnd', '-ms-']
			};
				
			cssTransformVendor = transitionEnd[vendor][1];
			
			return transitionEnd[vendor][0];
		})();
	
	var animateName = cookie(config.cookie + "_animatename") || "common";
	
	var animateContainer = {
		"common": {
			// 进入动画
			enter: function(element, callback){
				var tricWin = $(window).outerWidth() / 4 * 3;
				element.show().removeData("transEnd");
				element.css("-" + vendor + "-transform", "rotate(720deg) scale(.5) translate(" + (tricWin * 2) + "px)");
				 
				setTimeout(function(){
					element.data("transEnd", {
						cls: "metro-inner-enter",
						proName: cssTransformVendor + "transform",
						callback: function(){
							$(this).data("transEnd", {
								cls: "metro-inner-enter-show",
								proName: cssTransformVendor + "transform",
								callback: function(){
									$(this).removeClass("metro-inner-enter").removeClass("metro-inner-enter-show");
									$.isFunction(callback) && callback();
								}
							});
							$(this).addClass("metro-inner-enter-show")
								.css("-" + vendor + "-transform", "rotate(0deg) scale(1) translate(0px)");
						}
					});
					element.addClass("metro-inner-enter")
						.css("-" + vendor + "-transform", "rotate(720deg) scale(.5) translate(0px)");
				}, 1);
			},
			
			// 退出动画
			leave: function(element, callback){
				var tricWin = $(window).outerWidth() / 4 * 3;
				element.data("transEnd", {
					cls: "metro-inner-close",
					proName: cssTransformVendor + "transform",
					callback: function(){
						$(this).data("transEnd", {
							cls: "metro-inner-close-hide",
							proName: cssTransformVendor + "transform",
							callback: function(){
								$(this).remove();
								$.isFunction(callback) && callback();
							}
						});
						$(this).addClass("metro-inner-close-hide")
							.css("-" + vendor + "-transform", "rotate(720deg) scale(.5) translate(-" + (tricWin * 2) + "px)");
					}
				});
				element.addClass("metro-inner-close")
					.css("-" + vendor + "-transform", "rotate(720deg) scale(.5) translate(0px)");
			},
			
			// 初始化
			init: function(){
				$("body").addClass("metro-animate-rotate");
				$("body").on(transEndEventName, ".metro-inner", function(event){
					var tmpData = $(this).data("transEnd");
					if ( tmpData ){
						var protytypeName = event.originalEvent.propertyName;
						if ( $(event.target).hasClass(tmpData.cls) && protytypeName === tmpData.proName ){
							tmpData.callback.call(this);
						}
					}
				});
			}
		}
	}

	function setMetroUrlBar(z){
		if ( z === -1 ){
			$(".metro-url-loadbar").hide();
		}else{
			$(".metro-url-loadbar").show();
			$(".metro-url-loadbar .bar").css("width", z + "%");
		}
	}
	
	function setStyle(prevElement, selfElement, style, file){
		if ( prevElement !== null && prevElement.size() > 0 ){
			if ( prevElement.data("custom").style ) 
				$("#metro-wrapper").removeClass("metro-" + prevElement.data("custom").style);
				$("body").removeClass(prevElement.data("custom").style);
		} 
		if ( selfElement !== null && selfElement.size() > 0 ) {
			selfElement.data("custom", {style: style});
			selfElement.addClass("metro-" + style);
			selfElement.addClass("metro-page-" + file);
			$("body").addClass(style);
		}
	}
	
	$(window).on("page.open", function(event, options){
		var url = "controls.asp", 
			urlJSON = {};	
		if ( options.args ){
			urlJSON = options.args;
		}	
		if ( options.file ){
			urlJSON.files = options.file;
			url += "?" + $.param(urlJSON);
			setMetroUrlBar(10);
			$.post(url, { method: "ajax"}, function(html){
				setMetroUrlBar(20);
				
				// 加载到body中
				var div = document.createElement("div");
				$(div).appendTo("#metro-outer");
				$(div).addClass("metro-inner").html(html).hide();
				
				// 当前对象与前一对象
				var selfElement = $(div), 
					prevElement = selfElement.prev();
				
				setMetroUrlBar(30);
				
				// 加载JS
				require("assetss/pages/js/" + options.file, function( retData ){
					
					setMetroUrlBar(60);
					
					// 绑定JS中事件
					selfElement.on("page.ready", function(){
						retData.ready.call(this);
					}).on("page.close", function(){
						retData.close.call(this);
					});
					
					if ( retData.style && retData.style.length > 0 ) {
						setStyle(prevElement, selfElement, retData.style, options.file);
					}

					if ( prevElement.size() > 0 ){
						prevElement.trigger("page.close");
						animateContainer[animateName].leave(prevElement, function(){
							
							setMetroUrlBar(90);
							
							animateContainer[animateName].enter(selfElement, function(){
								setMetroUrlBar(100);
								setTimeout(function(){
									setMetroUrlBar(-1);
									
									$(selfElement).trigger("page.ready");
								}, 2000);
							});
						});
					}else{	
						animateContainer[animateName].enter(selfElement, function(){
							
							setMetroUrlBar(100);
							
							setTimeout(function(){
								setMetroUrlBar(-1);
								
								$(selfElement).trigger("page.ready");
							}, 2000);
						});
					}
				});
			});	
		}
	});
	
	animateContainer[animateName].init();
	
	exports.load = function( file ){
		require(["assetss/pages/js/" + file], function( rets ){
			var selfElement = $(".metro-inner:first");
			setStyle(null, selfElement, rets.style, file);
			selfElement.on("page.ready", rets.ready).on("page.close", rets.close);
			$(function(){
				selfElement.trigger("page.ready");
			});
		});
	}
});