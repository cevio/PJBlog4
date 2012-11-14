// JavaScript Document
// set default params for sizzle
define(["assets/js/core/jQuery"], function(){

	// map modules
	config.map("upload", "assets/js/upload");
	config.map("form", "assets/js/core/form");
	config.map("tpl-category", "assets/js/tpl/tpl-category");
	config.map("overlay", "assets/js/core/overlay");
	config.map("editor", "assets/js/lib/xheditor/editor");
	config.map("tabs", "assets/js/core/tabs");
	config.map("easing", "assets/js/core/jQuery.easing.1.3");
	config.map("article", "assets/js/article");
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	config.ajaxUrl.server.updateCate = "server/category.asp?j=updatecate";
	config.ajaxUrl.server.addCate = "server/category.asp?j=addcates";
	config.ajaxUrl.server.destoryCate = "server/category.asp?j=destorycates";
	config.ajaxUrl.server.iconList = "server/category.asp?j=iconlist";
	config.ajaxUrl.server.delArticles = "server/article.asp?j=delarticle";
	config.ajaxUrl.server.setupPlugin = "server/plugin.asp?j=setup";
	config.ajaxUrl.server.configSetPlugin = "server/plugin.asp?j=setconfig";
	config.ajaxUrl.server.updateConfig = "server/plugin.asp?j=updateconfig";
	config.ajaxUrl.server.pluginStop = "server/plugin.asp?j=pluginstop";
	config.ajaxUrl.server.pluginActive = "server/plugin.asp?j=pluginactive";
	config.ajaxUrl.server.pluginUnInstall = "server/plugin.asp?j=pluginuninstall";
	config.ajaxUrl.server.setupTheme = "server/theme.asp?j=setup";
	config.ajaxUrl.server.setupThemeStyle = "server/theme.asp?j=setupstyle";
	config.ajaxUrl.server.setupThemeDelete = "server/theme.asp?j=themedelete";
	config.ajaxUrl.server.editorUpload = "server/upload.asp?immediate=1";
	
	
	function cookie(key, value, options) {
        // key and at least value given, set cookie...
        if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
            options = $.extend({}, options);
    
            if (value === null || value === undefined) {
                options.expires = -1;
            }
    
            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setDate(t.getDate() + days);
				options.expires = t;
            }
    
            value = String(value);
    
            return (document.cookie = [
                encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }
    
        // key and possibly options given, get cookie...
        options = value || {};
        var decode = options.raw ? function(s) { return s; } : decodeURIComponent;
    
        var pairs = document.cookie.split('; ');
        for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
            if (decode(pair[0]) === key) return decode(pair[1] || ''); // IE saves cookies with empty string as "c; ", e.g. without "=" as opposed to EOMB, thus pair[1] may be undefined
        }
        return null;
    };
	
	config.isLogin = function(){
		var loginKey = cookie(config.cookie + "_login");
		if ( loginKey && loginKey === "true" ){
			return true;
		}else{
			return false;
		}
	}

	$("body")
	
	// 全局绑定事件之跳转全局设置页面
	.on("click", ".sdk-globalconfigure", function(){
		window.location.href = "?p=globalConfigure";
	});
	
	return {
		status : true,
		load : function( args ){
			require.async(args, function( customs ){
				if ( customs.init !== undefined ){
					customs.init();
				}
			});
		}
	};
});