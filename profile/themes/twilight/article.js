// JavaScript Document
define(['form'], function( require, exports, module ){
	
	var isSending = false;
	
	function init_postComments(){
		var $form = $("#postcomment");
		
		$form.ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( isSending === true ){
					return false;
				}
				
				if ($form.find("textarea[name='content']").val().length === 0){
					alert("请填写内容");
					return false;
				}
				
				isSending = true;
			},
			success: function(datas){
				isSending = false;
				if ( datas && datas.success ){
					alert("ok")
				}else{
					alert(datas.error);
				}
			},
			error: function(s){
				isSending = false;
				alert(s.error());
			}
		});
		
	}
	
	return {
		init: function(){
			$(function(){
				init_postComments();
			});
		}
	}
});