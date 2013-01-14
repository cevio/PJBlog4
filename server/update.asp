<!--#include file="../config.asp" -->
<%
	http.service(function(req, dbo, sap){
		this.package = function(){
			var xmlhttp = require("XMLHTTP"),
				stream = require("STREAM"),
				fso = require("FSO"),
				packname = req.query.packname;
				
			if ( !fso.exsit("profile/store", true) ){
				fso.create("profile/store");
			}
			
			try{
				if ( !fso.exsit("profile/store/" + packname) ){
					var binData = xmlhttp.ajax({ method: "GET", url: config.platform + "/store/versions/" + packname });
					if ( binData === null ){
						return {
							success: false,
							error: "获取远程资源失败"
						}
					}else{
						stream.save(binData, "profile/store/" + packname, true);
						return {
							success: true
						}
					}
				}else{
					return {
						success: true
					}
				}
			}catch(e){
				return {
					success: false,
					error: e.message
				}	
			}
		}
		
		this.unpack = function(){
			var spk = require("SPKPACKAGE"),
				fso = require("FSO"),
				packname = req.query.packname;
			
			try{
				var spkInstall = new spk("profile/store/" + packname, config.base);
				spkInstall.install();
				if ( fso.exsit("update.asp") ){
					require.async("update.asp");
					fso.destory("update.asp");
				}
				fso.destory("profile/store/" + packname);
				return {
					success: true
				}
			}catch(e){
				return {
					success: false,
					error: e.message
				}
			}
		}
		
		this.cache = function(){
			try{
				Application.Lock();
				Application.StaticObjects(config.appName).RemoveAll();
				Application.UnLock();
				var fso = require("FSO");
				fso.destorys(config.cacheAccess);
				fso.destorys(config.cacheAccess, true);
				return {
					success: true
				}
			}catch(e){
				return {
					success: false,
					error: e.message
				}
			}
			return {
				success: true
			}
		}
	});
%>