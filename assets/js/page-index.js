// JavaScript Document
define(['overlay'],function(require, exports, module){
	
	var pickHTML = {
		"n1": function(params){
			return JSON.stringify(params);
		},
		"n2": function(params){
			return JSON.stringify(params);
		},
		"n3": function(params){
			return JSON.stringify(params);
		}
	}
	
	function bindTabs(){
		$(".tabs a").on("click", function(){
			var i = $.inArray(this, $(".tabs a").toArray());
			$(".tabs a").removeClass("active");
			$(this).addClass("active");
			$(".plant-infos .plant-infos-item").hide();
			$(".plant-infos .plant-infos-item").eq(i).show();
		});
		$(".tabs a").eq(0).trigger("click");
	}

	function getNews(callback){
		require.async(config.platform + "/proxy/news.js", function( params ){
			console.log(params);
			if ( params ){
				var s = [1, 2, 3],
					d,
					html = { n1: "", n2: "", n3: "" };
					
				for ( var j = 0 ; j < s.length ; j++ ){
					var t = "n" + s[j],
						m = params[t];
						
					for ( i = 0 ; i < m.length ; i++ ){
						d = m[i];
						var k = pickHTML[t];
						if ( !k ){
							console.log(t);
						}
						html[t] += k(d);
					}
					$("#" + t).html(html[t]);
				}
				$.isFunction(callback) && callback();
			}
		});	
	}
	
	exports.init = function(){
		getNews(bindTabs);
	}
});