// JavaScript Document
define(['form'], function(require, exports, module){
	
	function ajaxFormBind(){
		var sending = false;
		$('form').ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( sending === false ){
					sending = true;
					getSendingTip();
				}else{
					return false;
				}
			},
			success: function( jsons ){
				sending = false;
				if ( jsons && jsons.success ){
					getSuccess();
					$('form').resetForm();
				}else{
					getError(jsons.error);	
				}
			}
		});
	}
	
	function getCustomTip(){
		$(".word-tip").html('<span class="iconfont">&#226;</span> 请输入密码后登入【第一次登入密码为"admin888"，请登入后修改！】');
	}
	
	function getSendingTip(){
		$(".word-tip").html('<span class="iconfont">&#316;</span> 正在验证密码，请稍后！');
	}
	
	function getSuccess(){
		$(".word-tip").html('<span class="iconfont green">&#126;</span> 验证密码成功，3秒后跳转，或者<a href="control.asp">点击这里跳转</a>');
		setTimeout(function(){
			window.location.reload();
		}, 1000);
	}
	
	function getError(error){
		$(".word-tip").html('<span class="iconfont red">&#223;</span> ' + error);
	}
	
	exports.init = function(){
		$(function(){
			ajaxFormBind();
			$("input[name='password']").focus();
		});
	}
});