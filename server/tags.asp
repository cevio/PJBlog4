<%
define(function(require, exports, module){
	exports.formatTags = function( tags ){
		if ( tags.length === 0 ){ return []; }
		
		tags = tags.replace(/^\s+/, "")
					.replace(/\s+$/, "")
					.replace(/\s+/g, ",");
					
		return tags.split(",")
	}
	
	exports.addTags = function( tag ){
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			id = 0, 
			count = 0;
		
		if ( connecte === true ){
			if ( tag.length > 0 ){
				dbo.trave({
					type: 3,
					conn: config.conn,
					sql: "Select * From blog_tags Where tagname='" + tag + "'",
					callback: function(rs){
						if ( rs.Bof || rs.Eof ){
							rs.AddNew();
							id = rs("id").value;
							rs("tagname") = tag;
							rs("tagcount") = 1;
							rs.Update();
						}else{
							id = rs("id").value;
							count = rs("tagcount").value;
							rs("tagcount") = count + 1;
							rs.Update();
						}
					}
				});
				
				var cache = require.async("cache");
					cache.build("tags");
				
				return {
					success: true,
					data: {
						id: id
					}
				}
			}else{
				return {
					success: false,
					error: "tag is empty"
				}
			}
		}else{
			return {
				success: false,
				error: "打开数据库失败"
			}
		}
	}
	
	exports.reFormatTags = function( tags ){
		return tags.replace(/^\{/, "")
							.replace(/\}$/, "")
							.split("}{");
	}
	
	exports.readTagFromCache = function( id ){
		var cache = require.async("cache"),
			tagsDatas = cache.load("tags");
		
		return tagsDatas[id + ""];
	}
	
	exports.readTag = function( id ){
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			tagName = "";
			
		if ( connecte === true ){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_tags Where id=" + id,
				callback: function(rs){
					tagName = rs("tagname").value;
				}
			});
			
			return {
				success: true,
				data: {
					name: tagName
				}
			}
		}else{
			return {
				success: false,
				error: "打开数据库失败"
			}
		}
	}
	
	exports.removeTagsByID = function(id){
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			oldTags,
			_this = this;
			
		if ( connecte === true ){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_article Where id=" + id,
				callback: function(rs){
					oldTags = _this.reFormatTags( rs("log_tags").value );
					
					for ( var i = 0 ; i < oldTags.length ; i++ ){
						dbo.trave({
							type: 3, 
							conn: config.conn,
							sql: "Select * From blog_tags Where id=" + oldTags[i],
							callback: function(rs){
								var count = rs("tagcount").value;
								
								if ( count < 2 ){
									rs.Delete();
								}else{
									rs("tagcount") = count - 1;
									rs.Update();
								}
							}
						})
					}
				}
			});
			
			return {
				success: true
			};
		}else{
			return {
				success: false,
				error: "打开数据库失败"
			};
			
		}
	}
});
%>