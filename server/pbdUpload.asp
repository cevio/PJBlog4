<!--#include file="../config.asp" -->
<%
try{
	require(["UPLOAD", "SHA1", "SPKPACKAGE", "FSO"], function(upload, SHA1, spkPackage, fso){
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			hash = http.get("hash"),
			oauth = http.get("oauth"),
			j = http.get("j"),
			isLogin = false,
			isAdmin = false;
			
		function consoleJSON(jsons){
			console.log(JSON.stringify(jsons));
		}
		
		function randoms(n){
			var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
				res = "";
				
			for(var i = 0; i < n ; i ++) {
				var id = Math.ceil(Math.random() * (chars.length - 1));
				res += chars[id];
			}
				
			return res;
		}
		
		if ( j.length === 0 ){
			consoleJSON({
				err: "参数错误",
				msg: "server error"
			});
			return;
		}
			
		if ( connecte === true ){
			(require("status"))("-1", hash, "system");
		
			isLogin = config.user.login;
			isAdmin = config.user.poster;
			
			if ( isLogin === true && isAdmin === true ){
				var folder = "";
				
				if ( j === "theme" ){
					folder = "profile/themes";
				}else if ( j === "plugin" ){
					folder = "profile/plugins";
				}else{
					consoleJSON({
						err: "参数错误",
						msg: "server error"
					});
					return;
				}
				
				var route = upload({ saveTo : folder, allowExt : ["pbd"] });
				
				if ( route.Filedata !== undefined ){
					route = {
						success: true,
						data: {
							src: route.Filedata.savePath,
							file: route.Filedata.filename,
							ext: route.Filedata.fileExt,
							size: route.Filedata.fileSize
						}
					}	
				}
				
				if ( route.success ){
					var path = folder + "/" + randoms(20);
					fso.create(path);
					var spkInstall = new spkPackage( route.data.src, path );
					spkInstall.install();
					
					fso.destory(route.data.src);
					
					consoleJSON({
						err: "",
						msg: "上传成功"
					});
				}else{
					consoleJSON({
						err: route.error,
						msg: "server error"
					});	
				}
			}else{
				consoleJSON({
					err: "没有权限",
					msg: "server error"
				});
			}
		}else{
			consoleJSON({
				err: "打开数据库失败",
				msg: "server error"
			});
		}
	});
	CloseConnect();
}catch(e){
	CloseConnect();
	consoleJSON({
		err: e.message,
		msg: "server error"
	});
}
%>