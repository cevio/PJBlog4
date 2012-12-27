<%
define(function( require, exports, module ){
	var proxyCustom = require.async("pluginCustom"),
		fns = require.async("fn"),
		getUserPhoto = fns.getUserInfo,
		cache = require.async("cache"),
		cache_global = cache.load("global");
	
	exports.datas = function(){
		var dbo = require.async("DBO"),
			connect = require.async("openDataBase"),
			date = require.async("DATE"),
			retDatas = [];
		
		if ( connect === true ){
			var configures = proxyCustom.configCache(this.id),
				tops = configures.top,
				dates = configures.date,
				len = configures.len;
				
			if ( isNaN(tops) ){tops = 10;}
			tops = Number(tops);
			if ( isNaN(len) ){len = 0;}
			len = Number(len);
			if ( len < 0 ){ len = 0; }
			
			var sql = "";
			
			if ( cache_global.commentaduit === true ){
				sql = "Select top " + tops + " * From blog_comment Where commentaudit=true Order By commentpostdate DESC";
			}else{
				sql = "Select top " + tops + " * From blog_comment Order By commentpostdate DESC";
			}

			dbo.trave({
				conn: config.conn,
				sql: sql,
				callback: function(rs){
					this.each(function(){
						retDatas.push({
							id: this("id").value,
							content: len === 0 ? this("commentcontent").value : fns.cutStr(this("commentcontent").value, len, true),
							date: this("commentpostdate").value,
							user: getUserPhoto(this("commentuserid").value, this("commentusername").value, this("commentusermail").value),
							website: this("commentwebsite").value,
							url: "article.asp?id=" + this("commentlogid").value + "#comment_" + this("commentid").value
						});
					});
				}
			});
		}
		
		return retDatas;
	}
});
%>