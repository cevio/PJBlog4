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
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	config.ajaxUrl.server.addNewCategory = "server/category.asp?j=addnewcategorybyname";
	config.ajaxUrl.server.updateCate = "server/category.asp?j=updatecate";
	config.ajaxUrl.server.setCateIcon = "server/category.asp?j=seticon";
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
	config.ajaxUrl.server.editorUpload = "server/upload.asp?immediate=1&uid=" + userid + "&hash=" + userhashkey;
	config.ajaxUrl.server.themeUpload = "server/pbdUpload.asp?j=theme&uid=" + userid + "&hash=" + userhashkey;
	config.ajaxUrl.server.pluginUpload = "server/pbdUpload.asp?j=plugin&uid=" + userid + "&hash=" + userhashkey;
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
			+						'<a href="javascript:;" class="fn-right close">取消</a>'
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