var params = {
	width: 550,
	isWebkit: $.browser.webkit,
	cangonext: true
};

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

function initTabsWrapper(){
	var parent = $(".outer"),
		selfs = $(".inner");
		
	parent.css( "width", (selfs.size() * params.width) + "px" );
}

function bindGuideEvent(){
	var container = $(".guide .fn-right span");
	container.on("guide.active", function(){
		var i = $.inArray(this, container.toArray()),
			parent = $(".outer"),
			_this = this;
			
		if ( $.browser.msie ){
			parent.animate({
				"margin-left": "-" + (i * params.width) + "px"
			}, "fast", function(){
				container.removeClass("active");
				$(_this).addClass("active");
				$(_this).trigger("module.ready");
			});
		}else{
			parent.off(transEndEventName);
			parent.addClass("metro-animate-complete-class").on(transEndEventName, function(event){
				if ( 
					$(event.target).hasClass("metro-animate-complete-class") && 
					(event.originalEvent.propertyName === cssTransformVendor + "transform")
				){
					$(_this).trigger("module.ready");	
				}
			});
			parent.css(cssVendor + "transform", "translateX(-" + (i * params.width) + "px)");
			container.removeClass("active");
				$(_this).addClass("active");
		}
	});
};

function bindNextEvent(){
	$(".step-next").on("click", function(){
		if ( params.cangonext === true ){
			var step = $(this).attr("data-step");
				
			if ( step ){
				step = Number(step);
				$(".guide .fn-right span").eq(step).trigger("guide.active");
			}
		}
	});
}

function bindPrevEvent(){
	$(".step-prev").on("click", function(){
		var step = $(this).attr("data-step");
		if ( step ){
			step = Number(step);
			$(".guide .fn-right span").eq(step).trigger("guide.active");
		}
	});
}

function bindSetupAction(){
	$("#setup").on("module.ready", function(){
		params.cangonext = false;
		var postData = {
			folder: $("input[name='folder']").val(),
			openid: $("input[name='openid']").val(),
			openkey: $("input[name='openkey']").val()
		};
		$.getJSON("setup/setup.asp", postData, function( callers ){
			if ( callers.success === true ){
				params.cangonext = true;
				$(".setuping").append('<div class="info">安装成功，点击下一步完成安装。</div>');
			}else{
				alert(callers.error);
			}
		});
	});
}

$(function(){
	initTabsWrapper();
	bindGuideEvent();
	bindNextEvent();
	bindPrevEvent();
	bindSetupAction();
});