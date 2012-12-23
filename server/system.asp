<!--#include file="../config.asp" -->
<%
	http.service(function(req, dbo){
		
		var clear = {},
			cache = require("cache");
			
		clear.global = function(){
			cache.destory("global");
		}
		
		clear.user = function(){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_member",
				callback: function(){
					this.each(function(){
						cache.destory("user", this("id").value);
					});
				}
			});
		}
		
		clear.category = function(){
			cache.destory("category");
		}
		
		clear.plugins = function(){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_plugin",
				callback: function(){
					this.each(function(){
						cache.destory("moden", this("id").value);
					});
				}
			});
			cache.destory("plugin");
		}
		
		clear.tags = function(){
			cache.destory("tags");
		}
		
		clear.attments = function(){
			cache.destory("attachments");
		}
		
		this.clean = function(){
			var c = req.query.c;
			if ( clear[c] !== undefined ){
				clear[c]();
				return {
					success: true
				}
			}else{
				return {
					success: false,
					error: "没有找到需要清理的缓存模块"
				}
			}
		}
	});
%>