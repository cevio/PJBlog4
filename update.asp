<%
define(function( require, exports, module ){
	var dbo = require.async("DBO"),
		connect = require.async("openDataBase");
	
	function getArticleComments(id){
		var counts = 0;
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_comment Where commentlogid=" + id,
			callback: function(rs){
				counts = rs.RecordCount;
			}
		});
		
		return counts;
	}
	
	function updateArticleComments(id, num){
		dbo.update({
			conn: config.conn,
			key: "id",
			keyValue: id,
			table: "blog_article",
			data: {
				log_comments: num
			}
		});
	}
	
	if ( connect === true ){
		var arr = [],
			arr2 = [];
			
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_article",
			callback: function(rs){
				arr.push(rs("id").value);
			}
		});
		
		for ( var i = 0 ; i < arr.length ; i++ ){
			arr2.push(getArticleComments(arr[i]));
		}
		
		for ( var j = 0 ; j < arr.length ; j++ ){
			updateArticleComments(arr[j], arr2[j]);
		}
	}
	
	CloseConnect();
});
%>