<!--#include file="server/core/obay.asp" -->
<!--#include file="profile/handler/config.asp" -->
<%
/* 
 * version V4.0 ( 2012-08-10 )
 * http://sizzle.cc http://pjhome.net
 * 全局设置
 * 可以通过这里的设置对全局网站有关功能开启和关闭以及数据库路径的修改。
 * 具体参见各项说明。
 */
	config.debug = false; // 是否开启DEBUG模式
	config.useApp = true; // 是否使用APP
	config.cacheAccess = "profile/caches"; // 缓存文件夹名
	config.platform = "http://platform.pjhome.net";
	config.version = "4.0.0.388";
	
/*
 * 网站模块映射
 * 调用模块时候注意模块返回变量。
 * 在调用前请先确定模块的稳定性和存在性。
 * 建议使用官方推荐模块
 */
 
 	// 通用模块映射
 	map["DBO"] = "server/core/dbo";
	map["FSO"] = "server/core/fso";
	map["STREAM"] = "server/core/stream";
	map["XML"] = "server/core/xml";
	map["XMLHTTP"] = "server/core/xmlhttp";
	map["WINHTTP"] = "server/core/winhttp";
	map["UPLOAD"] = "server/core/upload";
	map["COOKIE"] = "server/core/cookie";
	map["DATE"] = "server/core/date";
	map["MD5"] = "server/core/md5";
	map["SHA1"] = "server/core/sha1";
	map["PACKAGE"] = "server/core/package";
	map["SPKPACKAGE"] = "server/core/spkPackage";
	map["SQL"] = "server/core/sql";
	
	// 逻辑模块映射
	map["fn"] = "server/fn";
	map["gra"] = "server/gravatar";
	map["openDataBase"] = "server/dataBaseOperation";
	map["cache"] = "server/cache";
	map["icon"] = "server/getIcons";
	map["tags"] = "server/tags";
	map["xmltable"] = "server/xmltable";
	map["pluginCustom"] = "server/pluginCustom";
	map["sap"] = "server/SystemActionProxy";
	map["member"] = "server/member";
	map["article"] = "server/article";
	map["comment"] = "server/comment";
	map["guestbook"] = "server/guestbook";
	map["theme"] = "server/theme";
	map["plugin"] = "server/plugin";
	map["status"] = "server/status";
	
	// handler处理模块映射
	map["cacheHandle"] = "profile/handler/cache";
	
	// 缓存模块
	map["cache_global"] = "server/module/global";
	map["cache_category"] = "server/module/category";
	map["cache_article"] = "server/module/article";
	map["cache_article_detail"] = "server/module/article-detail";
	map["cache_comment"] = "server/module/comment";
	
	http.service = function( callback, isposter ){
		http.async(function(req){
			try{
				require("status")();
				var j = req.query.j, callbacks = {};
				if ( config.user.admin === true || ( (isposter === true) && (config.user.poster === true) ) ){
					var dbo = require("DBO"),
						connecte = require("openDataBase"),
						sap = require("sap");
								
					if ( connecte === true ){
						callback.call(callbacks, req, dbo, sap);
						if ( callbacks[j] !== undefined ){
							return callbacks[j]();
						}else{
							return {
								success: false,
								error: "未找到对应处理模块"
							}
						}
					}else{
						return {
							success: false,
							error: "数据库连接失败"
						}
					}
				}else{
					return {
						success: false,
						error: "非法权限操作"
					}
				}
			}catch(e){
				return {
					success: false,
					error: e.message
				}
			}
		});
		CloseConnect();
	}
	
/*
 * 系统默认变量
 * 不允许修改和赋值
 * 改动可能引起系统异常
 */
 	config.conn = null;
	config.user = {
		login: false,
		id: 0
	}
	
	config.page = { assets: {}, server: {} };
 
/*
 * 全局ASA文件加载
 * 如果修改过以上的config.appName属性，请删除网站根目录的global.asa文件
 * 之后系统将自动创建该文件
 */
 	asa();

/*
 * 数据库关闭
 * 尝试关闭数据库方法。一般写在系统结束末尾。
 * 请谨慎使用此方法。
 */	
	function CloseConnect(){
		try{
			config.conn.Close();
			config.conn = null;
		}catch(error){
			console.push(error.message);
		}
	}
	
	function ConsoleClose( word ){
		CloseConnect();
		console.end(word);
	}
	
	function ConsoleDisAble( word ){
		CloseConnect();
		console.log(word);
	}

/*
 * 数据源缓存
 * 打开某一数据源，通过缓存
 * 适用于模板制作。
 */
 	function LoadCacheModule( ModuleName, ModuleCallback ){
		var ModuleCacheDatas = require(ModuleName);
		if ( typeof ModuleCallback === "function" ){
			ModuleCallback( ModuleCacheDatas );
		}
	}
	
	function LoadPluginsCacheModule( ModuleName, ModuleCallback ){
		if ( config.pluginModen === undefined ){
			config.pluginModen = require("pluginCustom");
		}
		var ModuleCacheDatas = config.pluginModen.loadPlugin( ModuleName );
		if ( ModuleCacheDatas !== null ){
			if ( typeof ModuleCallback === "function" ){
				ModuleCallback( ModuleCacheDatas );
			}else{
				return ModuleCacheDatas;
			}
		}
	}
	
	var pageCustomParams = {
		tempCaches: {},
		tempParams: {},
		tempModules: {}
	};
%>