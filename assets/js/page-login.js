// JavaScript Document
define(['form'], function(require, exports, module){
	
	function ajaxFormBind(){
		$('form').ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				alert("sending..");
				return false;
			},
			success: function( jsons ){
				if ( jsons && jsons.success ){
					
				}else{
					
				}
			}
		});
	}
	
	exports.init = function(){
		$(function(){
			ajaxFormBind();
		});
	}
});