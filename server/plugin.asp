<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	this.setup = function(){
		var folder = req.query.fo;
		if ( folder.length === 0 ){
			return {
				success: false,
				error: "未找到安装参数"
			}
		}else{
			var xml = require("XML"),
				fso = require("FSO"),
				date = require("DATE"),
				cache = require("cache");

			var xmlFile = "profile/plugins/" + folder + "/install.xml";
			if ( fso.exsit(xmlFile) ){
				var xmlConsole = xml.load(xmlFile);
				if ( xmlConsole !== null ){
					var pluginName = xml("pluginName", xmlConsole.root, xmlConsole.object);
					if ( pluginName.length > 0 ){
						pluginName = pluginName.text();
					}else{
						pluginName = "";
					}
					
					var pluginMark = xml("pluginMark", xmlConsole.root, xmlConsole.object);
					if ( pluginMark.length > 0 ){
						pluginMark = pluginMark.text();
					}else{
						pluginMark = "";
					}
					
					var pluginAuthor = xml("pluginAuthor", xmlConsole.root, xmlConsole.object);
					if ( pluginAuthor.length > 0 ){
						pluginAuthor = pluginAuthor.text();
					}else{
						pluginAuthor = "";
					}
					
					var pluginEmail = xml("pluginEmail", xmlConsole.root, xmlConsole.object);
					if ( pluginEmail.length > 0 ){
						pluginEmail = pluginEmail.text();
					}else{
						pluginEmail = "";
					}
					
					var pluginWebsite = xml("pluginWebsite", xmlConsole.root, xmlConsole.object);
					if ( pluginWebsite.length > 0 ){
						pluginWebsite = pluginWebsite.text();
					}else{
						pluginWebsite = "";
					}
					
					var pluginQQWeibo = xml("pluginQQWeibo", xmlConsole.root, xmlConsole.object);
					if ( pluginQQWeibo.length > 0 ){
						pluginQQWeibo = pluginQQWeibo.text();
					}else{
						pluginQQWeibo = "";
					}
					
					var pluginSinaWeibo = xml("pluginSinaWeibo", xmlConsole.root, xmlConsole.object);
					if ( pluginSinaWeibo.length > 0 ){
						pluginSinaWeibo = pluginSinaWeibo.text();
					}else{
						pluginSinaWeibo = "";
					}
					
					var pluginInfo = xml("pluginInfo", xmlConsole.root, xmlConsole.object);
					if ( pluginInfo.length > 0 ){
						pluginInfo = pluginInfo.html();
					}else{
						pluginInfo = "";
					}
					
					var pluginPublishDate = xml("pluginPublishDate", xmlConsole.root, xmlConsole.object);
					if ( pluginPublishDate.length > 0 ){
						pluginPublishDate = pluginPublishDate.text();
					}else{
						pluginPublishDate = "";
					}
					
					var pluginVersion = xml("pluginVersion", xmlConsole.root, xmlConsole.object);
					if ( pluginVersion.length > 0 ){
						pluginVersion = pluginVersion.text();
					}else{
						pluginVersion = "";
					}
					
					var pluginWebPage = xml("pluginWebPage", xmlConsole.root, xmlConsole.object);
					if ( pluginWebPage.length > 0 ){
						pluginWebPage = pluginWebPage.text();
					}else{
						pluginWebPage = "";
					}
					
					var canInsert = true;
					
					dbo.trave({
						conn: config.conn,
						sql: "Select * From blog_plugin Where pluginmark='" + pluginMark + "'",
						callback: function( rs ){
							if ( rs.Bof || rs.Eof ){
								canInsert = true;
							}else{
								canInsert = false;
							}
						}
					});
					
					if ( canInsert === true ){
						
						var id = 0,
							_date = date.format(pluginPublishDate, "y/m/d h:i:s");
						
						dbo.add({
							data: {
								pluginname: pluginName,
								pluginmark: pluginMark,
								pluginfolder: folder,
								pluginstatus: true,
								plugininfo: pluginInfo,
								pluginauthor: pluginAuthor,
								pluginemail: pluginEmail,
								pluginwebsite: pluginWebsite,
								pluginqqweibo: pluginQQWeibo,
								pluginsinaweibo: pluginSinaWeibo,
								pluginpublishdate: _date,
								pluginversion: pluginVersion,
								pluginwebpage: pluginWebPage
							},
							table: "blog_plugin",
							conn: config.conn,
							callback: function(){
								id = this("id").value;
							}
						});
						
						if ( id > 0 ){
						
							cache.build("plugin");
							
							var xmlConfigFile = "profile/plugins/" + folder + "/config.xml";
							
							if ( fso.exsit(xmlConfigFile) ){
								var xmlConfigConsole = xml.load(xmlConfigFile);
								if ( xmlConfigConsole !== null ){
									var elements = xml("key", xmlConfigConsole.root, xmlConfigConsole.object);
									
									elements.each(function(){
										var name = this.getAttribute("name"),
											value = this.getAttribute("value");
											
										dbo.add({
											data: { modekey: name, modevalue: value, modemark: id },
											table: "blog_moden",
											conn: config.conn
										});	
									});
									
									cache.build("moden", id);
								}
							}
							
							try{
								if ( fso.exsit("profile/plugins/" + folder + "/install.asp") ){
									require("pluginCustom", function( pluginCustom ){
										pluginCustom.themeFolder = String(config.conn.Execute("Select theme From blog_global Where id=1")(0));
										pluginCustom.styleFolder = String(config.conn.Execute("Select style From blog_global Where id=1")(0));
										pluginCustom.folder = folder;
										pluginCustom.mark = pluginMark;
										config.plugin = pluginCustom;
										var tmpParams = require("profile/plugins/" + folder + "/install");
										if ( tmpParams && tmpParams.init ){
											tmpParams.sap = sap;
											tmpParams.sap.mark = pluginMark;
											tmpParams.init();
										}
									});
								}
								
								return {
									success: true
								}
							}catch(e){
								return {
									success: false,
									error: e.message
								}
							}
						}else{
							return {
								success: false,
								error: "插入数据库失败"
							}
						}
					}else{
						return {
							success: false,
							error: "此插件已安装，请先卸载。"
						}
					}
					
				}else{
					return {
						success: false,
						error: "读取配置文件失败"
					}
				}
			}else{
				return {
					success: false,
					error: "未找到配置文件"
				}
			}
		}
	}
	
	this.setconfig = function(){
		var folder = "",
			id = req.query.id;
			
		if ( id.length === 0 ){
			id = 0;
		}else{
			id = Number(id);
		}
		
		if ( id > 0 ) {
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_plugin Where id=" + id,
				callback: function(rs){
					folder = rs("pluginfolder").value;
				}
			});
			
			if ( folder.length > 0 ){
				var xmltable = require("xmltable"),
					xmltableHTML = xmltable("profile/plugins/" + folder + "/config.xml", id);
					
				return {
					success: true,
					data: {
						html: xmltableHTML
					}
				}
			}else{
				return {
					success: false,
					error: "未找到插件"
				}
			}
		}else{
			return {
				success: false,
				error: "调用参数错误"
			}
		}
	}
	
	this.updateconfig = function(){
		var formEmtor = config.emtor(Request.Form),
			id = Number(http.form("id"));
		
		for ( var i = 0 ; i < formEmtor.length ; i++ ){
			if ( formEmtor[i] !== "id" ){
				var value = config.emtor(Request.Form(formEmtor[i]))[0];
				config.conn.Execute("Update blog_moden Set modevalue='" + value + "' Where modemark=" + id + " And modekey='" + formEmtor[i] + "'");
			}
		}
		
		var cache = require("cache");
			cache.build("moden", id);
		
		return {
			success: true
		}
	}
	
	this.pluginstop = function(){
		var id = req.query.id;
		if ( id.length === 0 ){
			id = 0;
		}else{
			id = Number(id);
		}
		
		if ( id > 0 ){
			dbo.update({
				conn: config.conn,
				table: "blog_plugin",
				key: "id",
				keyValue: id,
				data: {
					pluginstatus: false
				}
			});
			
			var cache = require("cache");
				cache.build("plugin");
			
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
	
	this.pluginactive = function(){
		var id = req.query.id;
		if ( id.length === 0 ){
			id = 0;
		}else{
			id = Number(id);
		}
		
		if ( id > 0 ){
			dbo.update({
				conn: config.conn,
				table: "blog_plugin",
				key: "id",
				keyValue: id,
				data: {
					pluginstatus: true
				}
			});
			
			var cache = require("cache");
				cache.build("plugin");
			
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
	
	this.pluginuninstall = function(){
		var id = req.query.id;
		if ( id.length === 0 ){
			id = 0;
		}else{
			id = Number(id);
		}
		
		if ( id > 0 ){
			var folder = String(config.conn.Execute("Select pluginfolder From blog_plugin Where id=" + id)(0)),
				mark = String(config.conn.Execute("Select pluginmark From blog_plugin Where id=" + id)(0));
			
			config.conn.Execute("Delete From blog_plugin Where id=" + id);
			config.conn.Execute("Delete From blog_moden Where modemark=" + id);
			
			var fso = require("FSO");
			if ( fso.exsit("profile/plugins/" + folder + "/uninstall.asp") ){
				require("pluginCustom", function( pluginCustom ){
					pluginCustom.themeFolder = String(config.conn.Execute("Select theme From blog_global Where id=1")(0));
					pluginCustom.styleFolder = String(config.conn.Execute("Select style From blog_global Where id=1")(0));
					pluginCustom.folder = folder;
					pluginCustom.mark = mark;
					config.plugin = pluginCustom;
					var tmpParams = require("profile/plugins/" + folder + "/uninstall");
					if ( tmpParams && tmpParams.init ){
						tmpParams.sap = sap;
						tmpParams.sap.mark = mark;
						tmpParams.init();
					}
				});
			}
			
			var cache = require("cache");
				cache.destory("plugin");
				cache.destory("moden", id);
			
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
	
	this.plugindestory = function(){
		var fo = req.query.fo;
		if ( fo.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}
		try{
			var fso = require("FSO");
			if ( fso.exsit("profile/plugins/" + fo, true) ){
				fso.destory("profile/plugins/" + fo, true);
			}
			return {
				success: true
			}
		}catch(e){
			return {
				success:false,
				error: e.message
			}
		}
	}
});
%>