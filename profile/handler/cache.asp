<%
define(function(require, exports, module){
	var sap = require.async("sap");

	exports["global"] = function(){
		var arr = ["title", "website", "description", "theme", "style", "nickname", "webstatus", "articleprivewlength", "articleperpagecount", "webdescription", "webkeywords", "authoremail", "seotitle", "themename", "themeauthor", "themewebsite", "themeemail", "themeversion", "commentaduit", "commentperpagecount", "gravatarS", "gravatarR", "gravatarD", "binarywhitelist", "canregister", "totalarticles", "totalcomments", "commentdelaytimer", "commentvaildor", "commentmaxlength"];
		sap.proxy("cache.global.array", [arr]);
		return {
			sql: "Select " + arr.join(",") + " From blog_global Where id=1",
			callback: function( cacheData ){
				var rets = {
					title: cacheData[0][0],
					website: cacheData[0][1],
					description: cacheData[0][2],
					theme: cacheData[0][3],
					style: cacheData[0][4],
					nickname: cacheData[0][5],
					webstatus: cacheData[0][6],
					articleprivewlength: cacheData[0][7],
					articleperpagecount: cacheData[0][8],
					webdescription: cacheData[0][9],
					webkeywords: cacheData[0][10],
					authoremail: cacheData[0][11],
					seotitle: cacheData[0][12],
					themename: cacheData[0][13],
					themeauthor: cacheData[0][14],
					themewebsite: cacheData[0][15],
					themeemail: cacheData[0][16],
					themeversion: cacheData[0][17],
					commentaduit: cacheData[0][18],
					commentperpagecount: cacheData[0][19],
					gravatarS: cacheData[0][20],
					gravatarR: cacheData[0][21],
					gravatarD: cacheData[0][22],
					binarywhitelist: cacheData[0][23],
					canregister: cacheData[0][24],
					totalarticles: cacheData[0][25],
					totalcomments: cacheData[0][26],
					commentdelaytimer: cacheData[0][27],
					commentvaildor: cacheData[0][28],
					commentmaxlength: cacheData[0][29]
				};
				sap.proxy("cache.global.jsons", [rets]);
				return rets;
			}
		};
	}
	
	exports["category"] = function(){
		var arr = ["id", "cate_name", "cate_info", "cate_root", "cate_count", "cate_icon", "cate_outlink", "cate_outlinktext", "cate_order"];
		sap.proxy("cache.category.array", [arr]);
		return {
			sql: "Select " + arr.join(",") + " From blog_category Where cate_show=False",
			callback: function( cacheData ){
				var jsons = {},
					arrays = [],
					orders = {};

				for ( var i = 0 ; i < cacheData.length ; i++ ){
					var items = cacheData[i], id = items[0], cate_name = items[1], cate_info = items[2], 
						cate_root = items[3], cate_count = items[4], cate_icon = "profile/icons/" + items[5], 
						cate_outlink = items[6], cate_outlinktext = items[7], order = items[8];
						
					var js = { id: id, name: cate_name, info: cate_info, count: cate_count, icon: cate_icon, link: cate_outlink ? cate_outlinktext : "default.asp?c=" + id,
						order: order, root: cate_root };

					sap.proxy("cache.category.jsons", [js]);
					
					orders[js.id + ""] = js;
					
					if ( js.root === 0 ){
						if ( jsons[js.id + ""] === undefined ){
							jsons[js.id + ""] = js;
							jsons[js.id + ""].childrens = [];
						}else{
							var childrens = jsons[js.id + ""].childrens;
							jsons[js.id + ""] = js;
							jsons[js.id + ""].childrens = childrens;
						}
					}else{
						if ( jsons[js.root + ""] === undefined ){
							jsons[js.root + ""] = {
								childrens: []
							};
						}
						jsons[js.root + ""].childrens.push(js);
					}	
				}
				
				for ( var o in jsons ){ arrays.push(jsons[o]); }
				
				return {
					arrays: arrays.sort(function(a, b){
						return a.order - b.order;
					}),
					list: orders
				};
			}
		};
	}
	
	exports["tags"] = function(){
		var arr = ["id", "tagname", "tagcount"];
		sap.proxy("cache.tags.array", [arr]);
		return {
			sql: "Select " + arr.join(",") + " From blog_tags",
			callback: function( cacheData ){
				var tmpJSONS = {};
				for ( var i = 0 ; i < cacheData.length ; i++ ){
					var jsons = {
						id: cacheData[i][0],
						name: cacheData[i][1],
						count: cacheData[i][2]
					}
					sap.proxy("cache.tags.jsons", [jsons]);
					tmpJSONS[jsons.id + ""] = jsons;
				}
				return tmpJSONS;
			}
		};
	}
	
	exports["moden"] = function(id){
		return "Select modekey, modevalue From blog_moden Where modemark=" + id;
	}
	
	exports["plugin"] = function(){
		return "Select id, pluginname, pluginmark, pluginfolder, pluginstatus, plugininfo, pluginauthor, pluginemail, pluginwebsite, pluginqqweibo, pluginsinaweibo, pluginpublishdate, pluginversion, pluginwebpage From blog_plugin";
	}
	
	exports["user"] = function(id){
		var arr = ["photo", "nickName", "isposter", "oauth", "canlogin", "logindate", "loginip"];
		sap.proxy("cache.user.array", [arr]);
		return {
			sql: "Select " + arr.join(",") + " From blog_member Where id=" + id,
			callback: function(cacheData){
				sap.proxy("cache.tags.jsons", [cacheData]);
				return cacheData;
			}
		};
	}
	
	exports["attachments"] = function(){
		return "Select id, attachext, attachpath, attachsize From blog_attachments";
	}
});
%>