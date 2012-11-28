<!--#include file="asp/obay.asp" -->
<%
http.async(function(req){
	try{
		var dataParams = {
			folder: req.query.folder,
			openid: req.query.openid,
			openkey: req.query.openkey
		},
			randoms = function(n){
				var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
					res = "";
					
				for(var i = 0; i < n ; i ++) {
					var id = Math.ceil(Math.random() * (chars.length - 1));
					res += chars[id];
				}
					
				return res;
			};
		
		if ( dataParams.folder.length > 0 && dataParams.openid.length > 0 && dataParams.openkey.length > 0 ){
			return (function(params){
				var fso = require("setup/asp/fso"),
					spk = require("setup/asp/spkPackage"),
					stream = require("setup/asp/stream"),
					spkInstall,
					rand_AppName = randoms(10),
					rand_CacheFileName = randoms(10),
					rand_Cookie = randoms(10);
				
				fso.create(params.folder, true);
				spkInstall = new spk("setup/package.pbd", params.folder);
				spkInstall.install();
				
				var percentFn = "%",
					systemConfigureText = '<' + percentFn + 'config.base="' + params.folder + '";config.appName="' + rand_AppName + '";config.cacheFileNamePixer="' + rand_CacheFileName + '";config.access="profile/PBlog4/PJBlog4.asp";config.cookie="' + rand_Cookie + '";' + percentFn + '>', 
					assetsConfigureText = 'config("debug", false);config("base", "' + params.folder + '");config.cookie = "' + rand_Cookie + '";';
				
				stream.save(systemConfigureText, params.folder + "/profile/handler/config.asp");
				stream.save(assetsConfigureText, params.folder + "/profile/handler/configure.js");
				
				var dbo = new ActiveXObject(config.nameSpace.conn),
					access = selector.lock(params.folder + "/profile/PBlog4/PJBlog4.asp"),
					status = false;
					
				try{
					dbo.open("provider=Microsoft.jet.oledb.4.0;data source=" + access);
					status = true;
				}catch(e){
					try{
						dbo.open("driver={microsoft access driver (*.mdb)};dbq=" + access);
						status = true;
					}catch(e){}
				}
				
				if ( status === true ){
					var rs = new ActiveXObject(config.nameSpace.record);
						rs.Open("Select * Form blog_global Where id=1", conn, 3, 3);
						rs("qq_appid") = params.openid;
						rs("qq_appkey") = params.openkey;
						rs.Update();
						rs.Close();
						
					return { success: true };
				}else{
					return {
						success: false,
						error: "数据库打开失败"
					}
				}
				
			})(dataParams);	
		}else{
			return {
				success: false,
				error: "请将所有必填项填写完整"
			}
		}
	}catch(e){
		
	}
});
%>