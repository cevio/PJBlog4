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
	
	var animateName = "common";
	
	var animateContainer = {
		"common": {
			enter: function(element, callback){
				element.show();
				$.isFunction(callback) && callback();
			},
			leave: function(element, callback){
				element.hide();
				$.isFunction(callback) && callback();
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
				var div = document.createElement("div");
				$(div).appendTo("#metro-outer");
				$(div).addClass("metro-inner").html(html).hide();
				
				var selfElement = $(div), prevElement = selfElement.prev();
				
				setMetroUrlBar(30);
				require("assetss/pages/js/" + options.file, function( retData ){
					
					setMetroUrlBar(40);
					selfElement.on("page.ready", function(e, callback){
						retData.ready.call(this, callback);
					});
					selfElement.on("page.close", function(e, callback){
						retData.close.call(this, callback);
					});
					
					if ( retData.style && retData.style.length > 0) { $("#metro-wrapper").attr("class", "metro-" + retData.style); }
					
					animateContainer[animateName].leave(prevElement, function(){
						setMetroUrlBar(50);
						prevElement.trigger("page.close", function(){
							alert(1)
							animateContainer[animateName].enter(selfElement, function(){
								setMetroUrlBar(60);
								selfElement.trigger("page.ready", function(){
									setMetroUrlBar(100);
									setTimeout(function(){
										setMetroUrlBar(0);
										setMetroUrlBar(-1);
									}, 500);
								});
							})
						});
					});
					
				});
			});	
		}
	});
	
	exports.load = function( file ){
		require.async("assetss/pages/js/" + file, function( filefactory ){
			if ( filefactory.afterLoad ){ filefactory.afterLoad(); }
			$(function(){
				if ( filefactory.ready ){
					filefactory.ready();
				}
			});
			if ( filefactory.style ){
				$("#metro-wrapper").attr("class", "metro-" + filefactory.style);
			}
			$(".metro-innder").on("page.close", function(e, callback){
				filefactory.close.call(this, callback);
			}).on("page.ready", function(e, callback){
				filefactory.ready.call(this, callback);
			});
		});
	}
});