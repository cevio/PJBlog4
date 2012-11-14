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
			
		parent.css({
			"-webkit-transform": "translateX(-" + (i * params.width) + "px)",
			"-moz-transform": "translateX(-" + (i * params.width) + "px)",
		});
		container.removeClass("active");
			$(_this).addClass("active");
	});
	container.on("click", function(){
		$(this).trigger("guide.active");
	});
};

$(function(){
	initTabsWrapper();
	bindGuideEvent();
});