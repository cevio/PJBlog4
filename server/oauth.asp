<!--#include file="../config.asp" -->
<%
	http.write(function(req){
		var type = req.query.type,
			code = req.query.code,
			ResponseText;
			
		function oAuth_qq(){
			var oAuth = require.async("OAUTH"),
				APPID = "100299901",
				APPKEY = "d6f6e47dae337b2c742e82b46735ea6d",
				WEBSITE = "http://lols.cc", 
				openText, info;
				
				tokenJSON = oAuth.qq.token(APPID, APPKEY, code, WEBSITE);
				
				if ( tokenJSON.success === true ){
					openText = oAuth.qq.openid(tokenJSON.data.access_token);
					
					if ( openText.success === true ){
						info = oAuth.qq.getInfo(tokenJSON.data.access_token, openText.data.openid, APPID);
						
						if ( info.success === true ){
							var dbo = require.async("DBO"),
								fn = require.async("fn"),
								sha1 = require.async("SHA1");
							
							dbo.select({
								conn : config.conn,
								sql : "Select * From blog_oauth_qq Where openid=" + openText.data.openid,
								callback : function(rs, conn){
									if ( rs.Bof || rs.Eof ){
										var rand = fn.randoms(10),
											_id = 0;
										dbo.add({
											data : {
												salt : rand,
												hashkey : sha1(tokenJSON.data.access_token + rand),
												isAdmin : false,
												adminPass : SHA1("admin888"),
												sex : 1,
												photo : info.data.figureurl,
												nickName : info.data.nickname,
												oauth : "qq"
											},
											table : "blog_member",
											conn : config.conn,
											callback : function(){
												_id = rs("id").value;
											}
										});
										
										dbo.add({
											data : {
												appid : APPID,
												appkey : APPKEY,
												openid : openText.data.openid,
												token : tokenJSON.data.access_token,
												nickname : info.data.nickname,
												figureurl : info.data.figureurl,
												figureurl_1 : info.data.figureurl_1,
												figureurl_2 : info.data.figureurl_2,
												gender : info.data.gender,
												vip : info.data.vip === "1",
												level : info.data.level,
												root : _id
											},
											table : "blog_oauth_qq",
											conn : config.conn
										});
									}else{
										var id = rs("root").value;
										dbo.update({
											conn : config.conn,
											data : {
												appid : APPID,
												appkey : APPKEY,
												openid : openText.data.openid,
												token : tokenJSON.data.access_token,
												nickname : info.data.nickname,
												figureurl : info.data.figureurl,
												figureurl_1 : info.data.figureurl_1,
												figureurl_2 : info.data.figureurl_2,
												gender : info.data.gender,
												vip : info.data.vip === "1",
												level : info.data.level
											},
											table : "blog_oauth_qq",
											key : "id",
											keyValue : id
										})
									}
								}
							})
						}else{
							return errorOut(info);
						}
						
					}else{
						return errorOut(openText);
					}
					
				}else{
					return errorOut(tokenJSON);
				}
		}
		
		function errorOut(err){
			return 'error <' + err.error + '>: ' + err.msg;
		}
			
		switch ( type ){
			case "qq" : ResponseText = oAuth_qq(); break;
			case "sina" : ResponseText = oAuth_sina(); break;
			default : ResponseText = custom();
		}
		
		return ResponseText;
	});
%>