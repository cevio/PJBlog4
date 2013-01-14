// JavaScript Document
define(function(require,exports, module){
	
	function randoms(l){
		var Str = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 
			tmp = "";
			
		for( var i = 0 ; i < l ; i++ ) { 
			tmp += Str.charAt( Math.ceil(Math.random() * 100000000) % Str.length ); 
		}
		
		return tmp;
	}
	
	$.fn.upload = function(options, callback){
		var id = $(this).attr("id");
		
		if ( id === undefined ){
			$(this).attr("id", "id_" + randoms(10));
		}
		
		var _this = this;
			
		options = $.extend({
			auto: false, // if it can be auto that it must be setted true
			swf : selector("assets/js/lib/uploadify/uploadify.swf", false)
		}, options || {});
	
		// require the root module from web if it is not exsit
		require.async("assets/js/lib/uploadify/uploadify", function(){
			$.isFunction(callback) && callback.call(_this);
			$(_this).uploadify(options);
			//selectButton.uploadify("upload", "*");
		});
	}
	
});