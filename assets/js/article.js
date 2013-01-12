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
	
	exports.checkForm = function(){
		var post = {
			success: true,
			error: ""
		};
		
		if ( $("input[name='username']").size() > 0 ){
			if ( $("input[name='username']").val().length === 0 ){
				post.success = false;
				post.error = "用户名不能为空";
			}
		}
		
		if ( $("input[name='usermail']").size() > 0 ){
			if ( $("input[name='usermail']").val().length === 0 ){
				post.success = false;
				post.error = "邮箱不能为空";
			}
		}
		
		if ( post.success === true ){
			$.cookie(
				config.cookie + "_comment_username", 
				$("input[name='username']").val(), 
				{
					expires: new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000)
				}
			);
			$.cookie(
				config.cookie + "_comment_usermail", 
				$("input[name='usermail']").val(),
				{
					expires: new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000)
				}
			);
			$.cookie(
				config.cookie + "_comment_website", 
				$("input[name='website']").val(),
				{
					expires: new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000)
				}
			);
		}
		
		return post;
	}
	
	exports.insertForm = function(){
		try{
			var username = $.cookie(config.cookie + "_comment_username"),
				usermail = $.cookie(config.cookie + "_comment_usermail"),
				website = $.cookie(config.cookie + "_comment_website");
			
			if ( username && (username.length > 0) && (!config.isLogin()) ){
				$("input[name='username']").val(username);
				$("input[name='usermail']").val(usermail);
				$("input[name='website']").val(website);
			}
		}catch(e){
			
		}
	}
	
	$(function(){
		exports.insertForm();
	});
});