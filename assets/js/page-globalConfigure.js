// JavaScript Document
define(['form', 'overlay'], function( require, exports, module ){
	
	function tipPopUp( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function init_submit(){
		var sending = false;
		$("#postSetForm").ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( sending === false ){
					sending = true;
				}else{
					return false;
				}
			},
			success: function(jsons){
				sending = false;
				if ( jsons && jsons.success ){
					tipPopUp("保存设置成功！");
				}else{
					tipPopUp(jsons.error || "服务端错误");
				}
			},
			error: function(){
				sending = false;
			}
		});
	}
	
	return {
		init: function(){
			$(function(){
				init_submit();
			});
		}
	}
});