<!--#include file="config.asp" -->
<%
	var fso = require("FSO"),
		dbo = require("DBO"),
		connect = require("openDataBase");
	
	function RePairPreview(folder){
		var root = "profile/" + folder;
		var contains = fso.collect(root, true, function(name){
			return root + "/" + name;
		});
		if ( contains && contains.length > 0 ){
			for ( var i = 0 ; i < contains.length ; i++ ){
				var fo = contains[i] + "/priview.jpg";
				if ( fso.exsit(fo) ){
					fso.rename(fo, "preview.jpg");
				}
			}
		}
	}
	
	function RePairGlobal(){
		if ( connect === true ){
			var ArticleCounts = Number(String(config.conn.Execute("Select count(id) From blog_article")(0))),
				CommentCounts = Number(String(config.conn.Execute("Select count(id) From blog_comment")(0)));
				
			config.conn.Execute("Update blog_global Set totalarticles=" + ArticleCounts + ", totalcomments=" + CommentCounts + " Where id=1");
		}
	}
	
	function SQLEXCUTE(){
		if ( connect === true ){
			config.conn.Execute("alter table blog_member add website varchar(255)");
			config.conn.Execute("Update blog_member Set website=''");
			//config.conn.Execute("alter table blog_global add commentcanpostmail bit default 0");
		}
	}
	
	RePairGlobal();
	RePairPreview("themes");
	RePairPreview("plugins");
%>