define(function( require, exports, module ){
	// 兼容代码
	var dummyStyle = document.createElement('div').style,
		vendor = (function () {
			var vendors = 'webkitT,MozT,msT,OT,t'.split(','),
				t,
				i = 0,
				l = vendors.length;
	
			for ( ; i < l; i++ ) {
				t = vendors[i] + 'ransform';
				if ( t in dummyStyle ) {
					return vendors[i].substr(0, vendors[i].length - 1);
				}
			}
	
			return false;
		})(),
		cssVendor = vendor ? '-' + vendor.toLowerCase() + '-' : '',
		cssTransformVendor,
		transEndEventName = (function () {
			if ( vendor === false ) return false;
	
			var transitionEnd = {
				''			: ['transitionend', ''],
				'webkit'	: ['webkitTransitionEnd', '-webkit-'],
				'Moz'		: ['transitionend', ''],
				'O'			: ['oTransitionEnd', '-o-'],
				'ms'		: ['MSTransitionEnd', '-ms-']
			};
				
			cssTransformVendor = transitionEnd[vendor][1];
			
			return transitionEnd[vendor][0];
		})();

	var randoms = function(n){
		var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
			res = "";

		for(var i = 0; i < n ; i ++) {
			var id = Math.ceil(Math.random() * (chars.length - 1));
			res += chars[id];
		}

		return res;
	}

	$.fn.transend = function( options, callback ){
		if ( options.css === undefined ){
			options = {
				css: options
			}
		};

		var jsons = {}, regList = ["transform", "transform-origin"];
		for ( var c in options.css ){
			if ( regList.indexOf(c) === -1 ){
				jsons[c] = options.css[c];
			}else{
				jsons["-" + vendor + "-" + c] = options.css[c];
			}
		}

		if ( options.proname === undefined ){
			options.proname = cssTransformVendor + "transform";
		};

		var t = {};
		if ( $.isFunction(callback) ){
			t.complete = callback;
		}else{
			t = callback;
		}

		try{
			this.off(transEndEventName);
		}catch(e){};

		this.on(transEndEventName, function(event){
			var tmpData = $(this).data("tansend");
			if ( tmpData ){
				var protytypeName = event.originalEvent.propertyName;
				if ( $(event.target).hasClass(tmpData.cls) && protytypeName === tmpData.proName ){
					$(this).removeClass(tmpData.cls);
					$.isFunction(tmpData.callback) && tmpData.callback.call(this);
				}
			}
		})

		this.each(function(){
			var cls = randoms(20),
				element = $(this);

			if ( $.isFunction(t.beforeStart) ){
				t.beforeStart.call(this);
			}

			element
					.data("tansend", { cls: cls, proName: options.proname, callback: t.complete })
					.addClass(cls)
					.css(jsons);
		});
	}

	$.fn.clearTransend = function(){
		this.off(transEndEventName);
		this.removeData(tansend);
	}
});