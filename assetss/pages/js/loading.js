// JavaScript Document
define(function( require, exports, module ){
	
	var loadTree = [
		{ name: "Form Ajax Submit Plugin", url: "form" },
		{ name: "Upload Ajax Plugin", url: "upload" },
		{ name: "Overlay Plugin", url: "overlay" },
		{ name: "Tabs Plugin", url: "tabs" },
		{ name: "Jquery Easing Plugin", url: "easing" }
	];
	
	function loadDepinessTree( i, callback ){
		if ( loadTree[i] ){
			require.async( loadTree[i].url, function(){
				setTimeout(function(){
					loadHandle(i, callback);
				}, 500);
			});
		}else{
			$.isFunction(callback) && callback();
		}
	}
	
	function loadHandle(i, callback){
		var pec = ((i + 1) / loadTree.length * 100) + "%";
		$(".metro-init-progress .progress .bar").css({
			width: pec
		});
		$(".metro-init-progress .metro-init-progress-list .left").html('<span>loading: </span>' + loadTree[i].name + " ...");
		$(".metro-init-progress .metro-init-progress-list .right").text(pec);
		loadDepinessTree( i + 1, callback );
	}
	
	exports.ready = function(){
		loadDepinessTree(0, function(){
			$(window).trigger("page.open", {
				file: "welcome"
			});
		});
	}
	
	exports.close = function(){
		
	}
	
	exports.style = "green";
});