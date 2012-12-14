<%
define(function(require, exports, module){
	var cookie = require.async("COOKIE"),
		SHA1 = require.async("SHA1"),
		GRA = require.async("gra"),
		clearStatus = function(){
			config.user.id = 0;
			config.user.login = false;
			config.user.hashkey = "";
			config.user.name = "";
			config.user.photo = "_blank";
			config.user.admin = false;
			config.user.poster = false;
		}
		status = function(id, hashkey){
			var _id = unescape(cookie.get(config.cookie + "_user", "id")),
				_hashkey = cookie.get(config.cookie + "_user", "hashkey"),
				_oauth = cookie.get(config.cookie + "_user", "oauth");
				
			if ( id === undefined ){
				id = _id;
				hashkey = _hashkey;
			}

			var dbo = require("DBO"),
				connecte = require("openDataBase"),
				sql = _oauth === "system" ? "Select * From blog_global Where id=1": "Select * From blog_member Where id=" + id;
	
			if ( connecte === true ){
				dbo.trave({
					conn: config.conn,
					sql: sql,
					callback: function(rs){
						if ( rs("hashkey").value === hashkey ){
							if ( _oauth !== "system" ){
								if ( rs("canlogin").value !== true ){
									clearStatus();
									return;
								}
							}
							config.user.id = _oauth === "system" ? -1 : rs("id").value;
							config.user.login = true;
							config.user.hashkey = hashkey;
							config.user.name = rs("nickname").value;
							config.user.photo = _oauth === "system" ? GRA(rs("authoremail").value) : rs("photo").value;
							config.user.admin = _oauth === "system" ? true : false;
							config.user.poster = _oauth === "system" ? true : rs("isposter").value;
						}else{
							clearStatus();
						}
					}
				});
			}
		}
	
	return status;
});
%>