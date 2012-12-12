<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	this.setup = function(){
		var folder = req.query.id;
		if ( folder.length === 0 ){
			return {
				success: false,
				error: "安装参数错误"
			}
		}else{
			var fso = require("FSO"),
				xml = require("XML"),
				styleName,
				xmlFile = "profile/themes/" + folder + "/install.xml";
				
			if ( fso.exsit("profile/themes/" + folder + "/install.xml") ){
				if ( fso.exsit("profile/themes/" + folder + "/style", true) ){
					var folderList = fso.collect("profile/themes/" + folder + "/style", true);
					if ( folderList.length > 0 ){
						styleName = folderList[0];
						var xmlLoader = xml.load(xmlFile);
						if ( xmlLoader === null ){
							return {
								success: false,
								error: "打开配置文件出错"
							}
						}else{
							var themeName = xml("themeName", xmlLoader.root, xmlLoader.object);
							if ( themeName.size() > 0 ){
								themeName = themeName.text();
							}else{
								themeName = "";
							}
							
							var themeAuthor = xml("themeAuthor", xmlLoader.root, xmlLoader.object);
							if ( themeAuthor.size() > 0 ){
								themeAuthor = themeAuthor.text();
							}else{
								themeAuthor = "";
							}
							
							var themeWebSite = xml("themeWebSite", xmlLoader.root, xmlLoader.object);
							if ( themeWebSite.size() > 0 ){
								themeWebSite = themeWebSite.text();
							}else{
								themeWebSite = "";
							}
							
							var themeEmail = xml("themeEmail", xmlLoader.root, xmlLoader.object);
							if ( themeEmail.size() > 0 ){
								themeEmail = themeEmail.text();
							}else{
								themeEmail = "";
							}
							
							var themeVersion = xml("themeVersion", xmlLoader.root, xmlLoader.object);
							if ( themeVersion.size() > 0 ){
								themeVersion = themeVersion.text();
							}else{
								themeVersion = "";
							}
							
							dbo.update({
								conn: config.conn,
								table: "blog_global",
								key: "id",
								keyValue: "1",
								data: {
									theme: folder,
									style: styleName,
									themename: themeName,
									themeauthor: themeAuthor,
									themewebsite: themeWebSite,
									themeemail: themeEmail,
									themeversion: themeVersion
								}
							});
							
							if ( fso.exsit("profile/themes/" + folder + "/install.asp") ){
								require("profile/themes/" + folder + "/install.asp");
							}
							
							var cache = require("cache");
								cache.build("global");
							
							return {
								success: true
							}
						}
					}else{
						return {
							success: false,
							error: "风格不存在"
						}
					}
				}else{
					return {
						success: false,
						error: "风格文件夹不存在"
					}
				}
			}else{
				return {
					success: false,
					error: "主题不存在"
				}
			}
		}
	}
	
	this.setupstyle = function(){
		var id = req.query.id;
		
		if ( id.length > 0 ){
			dbo.update({
				conn: config.conn,
				table: "blog_global",
				key: "id",
				keyValue: "1",
				data: {
					style: id
				}
			});
			var cache = require("cache");
				cache.build("global");
			
			return {
				success: true
			}
		}else{
			return {
				success: false,
				error: "参数错误"
			}
		}
	}
	
	this.themedelete = function(){
		var id = req.query.id;
		
		if ( id.length > 0 ){
			var fso = require("FSO");
			fso.destory("profile/themes/" + id, true);
			return {
				success: true
			}
		}else{
			return {
				success: false,
				error: "参数错误"
			}
		}
	}
});
%>