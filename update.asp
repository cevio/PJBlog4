<%
define(function( require, exports, module ){
	var dbo = require.async("DBO"),
		connect = require.async("openDataBase");
	
	if ( connect === true ){
		config.conn.Execute("alter table blog_global add totalarticles integer default 0");
		config.conn.Execute("alter table blog_global add totalcomments integer default 0");
		config.conn.Execute("alter table blog_article add log_comments integer default 0");
		var articlesCount = Number(String(config.conn.Execute("Select count(id) From blog_article")(0))),
			commentsCount = Number(String(config.conn.Execute("Select count(id) From blog_comment")(0)));
			
		dbo.update({
			conn: config.conn,
			table: "blog_global",
			key: "id",
			keyValue: "1",
			data: {
				totalarticles: articlesCount,
				totalcomments: commentsCount
			}
		});
		
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_article",
			callback: function(rs){
				var id = rs("id").value,
					counts = Number(String(config.conn.Execute("Select count(id) From blog_comment Where commentlogid=" + id)(0)));
				
				rs("log_comments") = counts;
				rs.Update();
			}
		});
	}
	
	CloseConnect();
});
%>