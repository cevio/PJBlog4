<!--#include file="server/core/obay.asp" -->
<%
/* 
 * version V4.0 ( 2012-08-10 )
 * http://sizzle.cc http://pjhome.net
 * 全局设置
 * 可以通过这里的设置对全局网站有关功能开启和关闭以及数据库路径的修改。
 * 具体参见各项说明。
 */
	config.debug = true; // 是否开启DEBUG模式
	config.base = "/"; // obay 基址
	config.useApp = true; // 是否使用APP
	config.appName = "PJBlog4"; // APP 统一名称
	config.access = "profile/PBlog4/PJBlog4.asp"; // 数据库路径
	config.cookie = "PJBlog4"; // cookie 名称
	config.cacheAccess = "profile/caches"; // 缓存文件夹名
	config.platform = "http://platform.pjhome.net";
	
/*
 * 配置debug调用模块智能选择函数
 */
 	function debugMode( exps ){ return config.debug ? exps : exps + "-min"; }
	
/*
 * 网站模块映射
 * 调用模块时候注意模块返回变量。
 * 在调用前请先确定模块的稳定性和存在性。
 * 建议使用官方推荐模块
 */
 
 	// 通用模块映射
 	map["DBO"] = debugMode("server/core/dbo");
	map["FSO"] = debugMode("server/core/fso");
	map["STREAM"] = debugMode("server/core/stream");
	map["XML"] = debugMode("server/core/xml");
	map["XMLHTTP"] = debugMode("server/core/xmlhttp");
	map["WINHTTP"] = debugMode("server/core/winhttp");
	map["UPLOAD"] = debugMode("server/core/upload");
	map["COOKIE"] = debugMode("server/core/cookie");
	map["DATE"] = debugMode("server/core/date");
	map["MD5"] = debugMode("server/core/md5");
	map["SHA1"] = debugMode("server/core/sha1");
	map["PACKAGE"] = debugMode("server/core/package");
	map["SPKPACKAGE"] = debugMode("server/core/spkPckage");
	
	// 逻辑模块映射
	map["fn"] = "server/fn";
	map["openDataBase"] = "server/dataBaseOperation";
	map["cache"] = "server/cache";
	map["icon"] = "server/getIcons";
	map["tags"] = "server/tags";
	map["xmltable"] = "server/xmltable";
	map["pluginCustom"] = "server/pluginCustom";
	
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
	
/*
 * 系统默认变量
 * 不允许修改和赋值
 * 改动可能引起系统异常
 */
 	config.conn = null;
	config.user = {
		login : false
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
			if ( config.conn !== null ){
				config.conn.Close();
				config.conn = null;
			}
		}catch(error){
			console.push(error.message);
		}
	}

/*
 * 数据源缓存
 * 打开某一数据源，通过缓存
 * 适用于模板制作。
 */
 	function LoadCacheModule( ModuleName, ModuleCallback ){
		var ModuleCacheDatas = require(ModuleName);
		if ( typeof ModuleCallback === "function" ){
			ModuleCallback(ModuleCacheDatas);
		}
	}
%>