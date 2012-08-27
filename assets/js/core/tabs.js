define(["jQuery", "easing"], function(require, exports, module){
	
	var tabs = function(){
		this.triggerDom = null;
		this.contentDom = null;
		this.current = -1;
		this.timer = new Object();
		this.config = { event : "click", auto : false, delay : 5000, speed : "fast", currentClass : "current", effect : "none" }
	}
	
	$.tabs = function(name, factroy){ $.tabs[name] = factroy; }
	
	$.tabs("none", function(){
		this.init = function(triggerDom, contentDom){
			contentDom.hide();
		}
		this.process = function(sourceDom, targetDom, callback){
			sourceDom.hide();
			targetDom.show();
			callback();
		}
	});
	
	$.tabs("opacity", function(){
		this.init = function(triggerDom, contentDom){
			contentDom.hide().css("opacity", "0");
		}
		this.process = function(sourceDom, targetDom, callback, object){
			targetDom.show().animate({
				opacity : "1"
			}, object.config.speed, callback);
			sourceDom.css("opacity", "0").hide();
		}
	});
	
	$.tabs("verticalSlip", function(){
		this.init = function(triggerDom, contentDom){
			var dinner, douter, parent = contentDom.parent();
			
			if ( !parent.hasClass("tabs-verticalSlip-dinner") ){
				douter = document.createElement("div");
				dinner = document.createElement("div");
				$(douter).addClass("tabs-verticalSlip-douter").appendTo(parent);
				$(dinner).addClass("tabs-verticalSlip-dinner").appendTo(douter);
				contentDom.appendTo(dinner);
			}
		}
		this.process = function(sourceDom, targetDom, callback, object){
			var height = targetDom.outerHeight({padding:true});
			
			
			function getHeight(nodes){
				var _height = 0;
				nodes.each(function(){
					_height += $(this).outerHeight();
				});

				return _height;
			}
			
			targetDom.parent().parent().css({
				height : height + "px",
				overflow : "hidden"
			});
			
			targetDom.parent().animate({
				"margin-top" : "-" + ( getHeight(object.contentDom.slice(0, object.current)) ) + "px" 
			}, object.config.speed, callback);
		}
	});
	
	$.tabs("horizontalSlip", function(){
		this.init = function(triggerDom, contentDom){
			var dinner, douter, parent = contentDom.parent(), number = 0;
			
			if ( !parent.hasClass("tabs-horizontalSlip-dinner") ){
				contentDom.each(function(){
					var count = $(this).outerWidth();
					number += count;
					$(this).css("width", count + "px");
				});
				douter = document.createElement("div");
				dinner = document.createElement("div");
				$(douter).addClass("tabs-horizontalSlip-douter").appendTo(parent);
				$(dinner).addClass("tabs-horizontalSlip-dinner").appendTo(douter);
				contentDom.appendTo(dinner);
				$(dinner).css("width", number + "px").append('<div class="clear:both"></div>');
				contentDom.css({
					float : "left"
				});
			}
		}
		this.process = function(sourceDom, targetDom, callback, object){
			var height = targetDom.outerHeight(),
				width = targetDom.outerWidth();
				
			function getWidth(nodes){
				var _width = 0;
				nodes.each(function(){
					_width += $(this).outerWidth();
				});
				
				return _width;
			}
			
			targetDom.parent().parent().css({
				width : width + "px",
				height : height + "px",
				overflow : "hidden"
			});
			
			targetDom.parent().animate({
				"margin-left" : "-" + ( getWidth(object.contentDom.slice(0, object.current)) ) + "px" 
			}, object.config.speed, callback);
		}
	});

	$.tabs("window8flows", function(){
		this.init = function(triggerDom, contentDom){
			var douter, parent = contentDom.parent();
	
			if ( !parent.hasClass("tabs-window8flows-dinner") ){
				douter = document.createElement("div");
				$(douter).addClass("tabs-window8flows-douter").appendTo(parent);
				contentDom.appendTo(douter);
				contentDom.css({
					position : "absolute",
					top : "0px",
					left : "0px"
				}).each(function(i){
					$(this).attr("tabs-sort", i + "");
				});

				$(douter).css({
					overflow : "hidden",
					position : "relative",
				});
			}
		}
		this.process = function(sourceDom, targetDom, callback, object){
			var width = targetDom.outerWidth(),
				height = targetDom.outerHeight(),
				parent = targetDom.parent(),
				sourceSort = Number(sourceDom.attr("tabs-sort")) || -1,
				targetSort = Number(targetDom.attr("tabs-sort")),
				foter = targetSort > sourceSort ? "" : "-";

				parent.css({
					width : width + "px",
					height : height + "px"
				});

				targetDom.appendTo(parent);

				targetDom.css("left", foter + "30px").animate({
					left : "0px"
				}, object.config.speed, "easeOutCirc", callback);
		}
	});
	
	$.fn.tabs = function(options){
		
		if ( options === undefined ) { options = {}; }
		
		if ( typeof options === "object" ){
			options = $.extend({
				triggerDom : ".tabs-trigger",
				contentDom : ".tabs-content",
				event : "click",
				currentClass : "current",
				current : 0,
				auto : false,
				delay : 5000,
				speed : "fast",
				effect : "none"
			}, options);
		}
		
		this.each(function(){
			var tab = undefined,
				self = this,
				effect = null;
			
			if ( this.tabs === undefined ){ 
				tab = new tabs(); 
				tab.triggerDom = $(this).find(options.triggerDom + ":first").add($(this).find(options.triggerDom + ":first").siblings(options.triggerDom));
				tab.contentDom = $(this).find(options.contentDom + ":first").add($(this).find(options.contentDom + ":first").siblings(options.contentDom));
				
				if ( tab.contentDom.size() > 0 ){
					if ( tab.triggerDom.size() < tab.contentDom.size() ){
						(function(){
							var duce = tab.contentDom.size() - tab.triggerDom.size(),
								Arr = [];
							for ( var i = 0 ; i < duce ; i++ ){
								var mk = document.createElement("div");
								$(mk).appendTo(self);
								Arr.push(mk);
							}
							tab.triggerDom = $(Arr);
						})();
					}
				}else{
					return ;
				}
				
				self._tabs_ = tab; 
			}else{ 
				tab = self._tabs_;
				try{ tab.triggerDom.off(tab.config.event); } catch(e) {}
			}
	
			tab.config = $.extend(tab.config, options);
			
			if ( $.tabs[tab.config.effect] === undefined ){
				effect = new $.tabs["none"]();
			}else{
				effect = new $.tabs[tab.config.effect]();
			}
			
			effect.init.call(self, tab.triggerDom, tab.contentDom);
			
			if ( tab.config.event === "hover" ){ tab.config.event = "mouseover"; }
			
			if ( tab.config.auto === true ){
				tab.contentDom.on("mouseenter", function(){
					clearTimeout(tab.timer);
				}).on("mouseleave", function(){
					tab.timer = setTimeout(function(){
						tab.triggerDom.eq(tab.current + 1).trigger(tab.config.event);
					}, tab.config.delay);
				});	
			}
			
			tab.triggerDom.on(tab.config.event, function(e, json){
				
				if ( tab.config.auto === true ){
					clearTimeout(tab.timer);
				}
				
				var oldCurrent = tab.current, _this = this;
				tab.current = $.inArray(this, tab.triggerDom.toArray());
				
				var sourceDom, targetDom;
				if ( json === undefined ) { json = {} }
				
				if ( oldCurrent === -1 ){
					sourceDom = $();
					targetDom = tab.contentDom.eq(tab.current);
				}else{
					sourceDom = tab.contentDom.eq(oldCurrent);
					targetDom = tab.contentDom.eq(tab.current);
				}
				
				tab.triggerDom.removeClass(tab.config.currentClass);
				$(this).addClass(tab.config.currentClass);
				
				effect.process.call(_this, sourceDom, targetDom, function(){
					sourceDom.trigger("tabs.unactive");
					targetDom.trigger("tabs.active");
					if ( json.first === undefined ){ json.first = false; }
					if ( json.first === true ){ 
						$(self).trigger("tabs.onReady");
					}
					if ( tab.config.auto === true ){
						tab.timer = setTimeout(function(){
							tab.triggerDom.eq((tab.current + 1) % tab.contentDom.size()).trigger(tab.config.event);
						}, tab.config.delay);
					}
				}, tab);
				
			})
			.eq(
				tab.config.current < 0 ? 
					0 : ( 
							tab.config.current > (tab.contentDom.size() - 1) ? (tab.contentDom.size() - 1) : tab.config.current 
						)
			).trigger(tab.config.event, { first : true });
			
		});
		
		return this;
	}
});