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
	config.map("tips", "assets/js/lib/tips/tips");
	config.map("update", "assets/js/update");
	config.map("date", "assets/js/core/date");
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	config.ajaxUrl.server.addNewCategory = "server/category.asp?j=addnewcategorybyname";
	config.ajaxUrl.server.updateCate = "server/category.asp?j=updatecate";
	config.ajaxUrl.server.setCateIcon = "server/category.asp?j=seticon";
	config.ajaxUrl.server.destoryCate = "server/category.asp?j=destorycates";
	config.ajaxUrl.server.iconList = "server/category.asp?j=iconlist";
	config.ajaxUrl.server.delArticles = "server/article.asp?j=delarticle";
	config.ajaxUrl.server.topArticles = "server/article.asp?j=toparticle";
	config.ajaxUrl.server.unTopArticles = "server/article.asp?j=untoparticle";
	config.ajaxUrl.server.setupPlugin = "server/plugin.asp?j=setup";
	config.ajaxUrl.server.configSetPlugin = "server/plugin.asp?j=setconfig";
	config.ajaxUrl.server.updateConfig = "server/plugin.asp?j=updateconfig";
	config.ajaxUrl.server.pluginStop = "server/plugin.asp?j=pluginstop";
	config.ajaxUrl.server.pluginActive = "server/plugin.asp?j=pluginactive";
	config.ajaxUrl.server.pluginUnInstall = "server/plugin.asp?j=pluginuninstall";
	config.ajaxUrl.server.pluginDestory = "server/plugin.asp?j=plugindestory";
	config.ajaxUrl.server.setupTheme = "server/theme.asp?j=setup";
	config.ajaxUrl.server.setupThemeStyle = "server/theme.asp?j=setupstyle";
	config.ajaxUrl.server.setupThemeDelete = "server/theme.asp?j=themedelete";
	config.ajaxUrl.server.memDelete = "server/member.asp?j=mdelete";
	config.ajaxUrl.server.memForce = "server/member.asp?j=mforce";
	config.ajaxUrl.server.memUnForce = "server/member.asp?j=munforce";
	config.ajaxUrl.server.memToAdmin = "server/member.asp?j=toadmin";
	config.ajaxUrl.server.memUnToAdmin = "server/member.asp?j=untoadmin";
	config.ajaxUrl.server.replyComment = "server/comment.asp?j=reply";
	config.ajaxUrl.server.delComment = "server/comment.asp?j=destory";
	config.ajaxUrl.server.passComment = "server/comment.asp?j=pass";
	config.ajaxUrl.server.unPassComment = "server/comment.asp?j=unpass";
	config.ajaxUrl.server.password = "server/configure.asp?j=password";
	config.ajaxUrl.server.system = "server/system.asp?j=clean";
	config.ajaxUrl.server.package = "server/update.asp?j=package";
	config.ajaxUrl.server.unpack = "server/update.asp?j=unpack";
	config.ajaxUrl.server.cache = "server/update.asp?j=cache";
	
	try{
		config.ajaxUrl.server.editorUpload = "server/upload.asp?immediate=1&uid=" + userid + "&hash=" + userhashkey + "&oauth=" + useroauth;
		config.ajaxUrl.server.themeUpload = "server/pbdUpload.asp?j=theme&uid=" + userid + "&hash=" + userhashkey + "&oauth=" + useroauth;
		config.ajaxUrl.server.pluginUpload = "server/pbdUpload.asp?j=plugin&uid=" + userid + "&hash=" + userhashkey + "&oauth=" + useroauth;
	}catch(e){}
	
	(function ($, document, undefined) {
		var pluses = /\+/g;
		function raw(s) { return s; }
		function decoded(s) { return decodeURIComponent(s.replace(pluses, ' ')); }
	
		var iConfigs = $.cookie = function (key, value, options) {
			if (value !== undefined) {
				options = $.extend({}, iConfigs.defaults, options);
	
				if (value === null) { options.expires = -1; }
	
				if (typeof options.expires === 'number') {
					var days = options.expires, t = options.expires = new Date();
					t.setDate(t.getDate() + days);
				}
	
				value = iConfigs.json ? JSON.stringify(value) : String(value);
	
				return (document.cookie = [
					encodeURIComponent(key), '=', iConfigs.raw ? value : encodeURIComponent(value),
					options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
					options.path    ? '; path=' + options.path : '',
					options.domain  ? '; domain=' + options.domain : '',
					options.secure  ? '; secure' : ''
				].join(''));
			}
	
			// read
			var decode = iConfigs.raw ? raw : decoded;
			var cookies = document.cookie.split('; ');
			for (var i = 0, l = cookies.length; i < l; i++) {
				var parts = cookies[i].split('=');
				if (decode(parts.shift()) === key) {
					var cookie = decode(parts.join('='));
					return iConfigs.json ? JSON.parse(cookie) : cookie;
				}
			}
	
			return null;
		};
	
		iConfigs.defaults = {};
	
		$.removeCookie = function (key, options) {
			if ($.cookie(key) !== null) {
				$.cookie(key, null, options);
				return true;
			}
			return false;
		};
	
	})(jQuery, document);
	
	config.isLogin = function(){
		try{
			var loginKey = $.cookie(config.cookie + "_user").split("&"),
				loginParams = {},
				logined = false;
				
			for ( var i = 0 ; i < loginKey.length ; i++ ){
				loginParams[loginKey[i].split("=")[0]] = loginKey[i].split("=")[1];
			}
			if ( loginParams.id !== undefined ){
				if ( !isNaN(loginParams.id) ){
					loginParams.id = Number(loginParams.id);
					if ( (loginParams.id > 0) || (loginParams.id === -1) ){
						if ( loginParams.oauth && loginParams.oauth.length > 0 ){
							if ( loginParams.hashkey && loginParams.hashkey.length > 0 ){
								logined = true;
							}
						}
					}
				}
			}
			
			return logined;
		}catch(e){
			return false;
		}
	}
	
	$(".modify-password").on("click", function(){
		require.async(['form', 'overlay'], function(){
			
			var options = {
				effect: "deformationZoom",
				callback: function(){
					var _this = this;
					$(this).find("form").ajaxForm({
						dataType: "json",
						beforeSubmit: function(){
							if ( $(_this).find("input[name='oldpass']").val().length === 0 ){
								$(_this).find(".passinfo").text("请填写旧密码");
								return false;
							}
							if ( $(_this).find("input[name='newpass']").val().length === 0 ){
								$(_this).find(".passinfo").text("请填写新密码");
								return false;
							}
							if ( $(_this).find("input[name='repass']").val().length === 0 ){
								$(_this).find(".passinfo").text("请重复填写新密码");
								return false;
							}
						},
						success: function(params){
							if ( params.success ){
								$(_this).find(".passinfo").text("修改密码成功");
								setTimeout(function(){
									$(_this).find(".close:first").trigger("click");
								}, 500);
							}else{
								$(_this).find(".passinfo").text(params.error);	
							}
						}
					})
				}
			}
			
			options.content = '<div class="dialog fn-clear" style="width:300px;"><form action="' + config.ajaxUrl.server.password + '" method="post" style="margin:0;padding:0;">'
			+					'<div class="title fn-clear">'
			+						'<div class="fn-left mtitle">修改密码</div>'
//			+						'<a href="javascript:;" class="fn-right close">取消</a>'
			+					'</div>'
			+					'<div class="content">'
			+						'<div class="oldpass">旧密码：<input type="password" name="oldpass" value="" placeholder="旧密码" /></div>'
			+						'<div class="newpass">新密码：<input type="password" name="newpass" value="" placeholder="新密码" /></div>'
			+						'<div class="repeatepass">重复密码：<input type="password" name="repass"value="" placeholder="重复密码" /></div>'
			+					'</div>'
			+					'<div class="bom"><input type="submit" value="提交" class="button" /><input type="button" value="取消" class="button close" /><span class="passinfo"></span></div></form></div>';
			
			$.overlay(options);
		});
	});
	
	return {
		status: true,
		load: function( args ){
			require.async(args, function( customs ){
				if ( customs.init !== undefined ){
					customs.init();
				}
			});
		} 
	};
});