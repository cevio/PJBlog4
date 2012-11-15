// JavaScript Document
define(function(require, exports, module){
	exports.ready = function(callback){
		console.log("ready ok");
		$.isFunction(callback) && callback();
	}
	
	exports.close = function(callback){
		console.log("close ok");
		$.isFunction(callback) && callback();
	}
	
	exports.style = "white";
});