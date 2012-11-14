var params = {
	width: 550,
	isWebkit: $.browser.webkit
};

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
			});
		}else{	
			parent.css({
				"-webkit-transform": "translateX(-" + (i * params.width) + "px)",
				"-moz-transform": "translateX(-" + (i * params.width) + "px)",
			});
			container.removeClass("active");
				$(_this).addClass("active");
		}
	});
};

function bindNextEvent(){
	$(".step-next").on("click", function(){
		var step = $(this).attr("data-step");
			
		if ( step ){
			step = Number(step);
			$(".guide .fn-right span").eq(step).trigger("guide.active");
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

$(function(){
	initTabsWrapper();
	bindGuideEvent();
	bindNextEvent();
	bindPrevEvent();
});