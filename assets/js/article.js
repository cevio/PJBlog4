// JavaScript Document
define(['form'], function(require, exports, module){	
	exports.isSendData = false;
	
	exports.PostComment = function(options){
		var $form = $(options.formElement);
		
		$form.ajaxForm({
			dataType: "json",
			beforeSubmit: options.beforeSubmit,
			success: options.success,
			error: options.error
		});
	}
});