<!--#include file="server/core/obay-min.asp" -->
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
	config.cacheAccess = "profile/cache"; // 缓存文件夹名
	
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
	
	// 逻辑模块映射
	map["fn"] = "server/fn";
	map["openDataBase"] = "server/dataBaseOperation";
	map["cache"] = "server/cache";
	map["member"] = "server/member";
	map["article"] = "server/article";
	map["comment"] = "server/comment";
	map["guestbook"] = "server/guestbook";
	map["theme"] = "server/theme";
	map["plugin"] = "server/plugin";
	
	map["status"] = "server/status";
	
	// handler处理模块映射
	masp["cacheHandle"] = "profile/handler/cache";
	
/*
 * 系统默认变量
 * 不允许修改和赋值
 * 改动可能引起系统异常
 */
 	config.conn = null;
	config.user = {
		login : false
	}
 
/*
 * 全局ASA文件加载
 * 如果修改过以上的config.appName属性，请删除网站根目录的global.asa文件
 * 之后系统将自动创建该文件
 */
 	asa();
%>