// JavaScript Document
define(['overlay'],function(require, exports, module){
	exports.init = function(){
		$.dialog({
			content: '1111<span class="close">close</span>',
			effect: "deformationZoom"
		});
	}
});