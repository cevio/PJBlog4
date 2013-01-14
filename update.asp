<%
;define(function(){
	function RePairSQL(){
		var dbo = require("DBO"),
			connecte = require("openDataBase");
			if ( connecte === true ){
				config.conn.Execute("ALTER TABLE [blog_link] ADD linkout bit");
			}
	}

	RePairSQL();
});
%>