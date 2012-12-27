<%
define(function( require, exports, module ){
	var cache = require.async("cache"),
		proxyCustom = require.async("pluginCustom"),
		fns = require.async("fn"),
		GRA = require.async("gra"),
		global = cache.load("global"),
		getUserPhoto = fns.getUserInfo;
	
	exports.datas = function(){
		var dbo = require.async("DBO"),
			connect = require.async("openDataBase"),
			date = require.async("DATE"),
			retDatas = [];
		
		if ( connect === true ){
			var configures = proxyCustom.configCache(this.id),
				tops = configures.top,
				dates = configures.date;
				
			if ( isNaN(tops) ){tops = 10;}
			tops = Number(tops);

			dbo.trave({
				conn: config.conn,
				sql: "Select top " + tops + " * From blog_article Order By log_posttime DESC",
				callback: function(rs){
					this.each(function(){
						retDatas.push({
							id: this("id").value,
							title: this("log_title").value,
							user: getUserPhoto(this("log_uid").value),
							date: date.format(this("log_posttime").value, dates),
							views: this("log_views").value,
							cover: this("log_cover").value,
							url: "article.asp?id=" + this("id").value
						});
					});
				}
			});
		}
		
		return retDatas;
	}
});
%>