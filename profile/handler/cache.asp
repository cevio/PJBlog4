<%
define(function(require, exports, module){
	exports["global"] = function(){
		return {
			sql: "Select title, website, description, theme, style, nickname, webstatus, articleprivewlength, articleperpagecount, webdescription, webkeywords, authoremail, seotitle, themename, themeauthor, themewebsite, themeemail, themeversion, commentaduit, commentperpagecount, gravatarS, gravatarR, gravatarD, binarywhitelist, canregister From blog_global Where id=1",
			callback: function( cacheData ){
				return {
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
					canregister: cacheData[0][24]
				}
			}
		};
	}
	
	exports["category"] = function(){
		return {
			sql: "Select id, cate_name, cate_info, cate_root, cate_count, cate_icon, cate_outlink, cate_outlinktext, cate_order From blog_category Where cate_show=False",
			callback: function( cacheData ){
				var jsons = {},
					orders = {},
					arrays = [];
					
				for ( var i = 0 ; i < cacheData.length ; i++ ){
					var items = cacheData[i],
						id = items[0],
						cate_name = items[1],
						cate_info = items[2],
						cate_root = items[3],
						cate_count = items[4],
						cate_icon = "profile/icons/" + items[5],
						cate_outlink = items[6],
						cate_outlinktext = items[7],
						order = items[8];
					
					orders[id + ""] = {
						id: id,
						name: cate_name,
						info: cate_info,
						count: cate_count, 
						icon: cate_icon,
						link: cate_outlink ? cate_outlinktext : "default.asp?c=" + id,
						order: order
					};
					
					if ( cate_root === 0 ){
						if ( jsons[id + ""] === undefined ){
							jsons[id + ""] = {
								id: id,
								name: cate_name,
								info: cate_info,
								count: cate_count, 
								icon: cate_icon,
								link: cate_outlink ? cate_outlinktext : "default.asp?c=" + id,
								order: order,
								childrens: []
							};
						}else{
							jsons[id + ""].id = id;
							jsons[id + ""].name = cate_name;
							jsons[id + ""].info = cate_info;
							jsons[id + ""].count = cate_count;
							jsons[id + ""].icon = cate_icon;
							jsons[id + ""].order = order;
							jsons[id + ""].link = cate_outlink ? cate_outlinktext : "default.asp?c=" + id;
							if ( jsons[id + ""].childrens === undefined ){
								jsons[id + ""].childrens = [];
							}
						}
					}else{
						if ( jsons[cate_root + ""] === undefined ){
							jsons[cate_root + ""] = {
								childrens: []
							};
						}
						
						jsons[cate_root + ""].childrens.push({
							id: id,
							name: cate_name,
							info: cate_info,
							count: cate_count, 
							icon: cate_icon,
							link: cate_outlink ? cate_outlinktext : "default.asp?c=" + id,
							order: order
						});
					}	
				}
				
				for ( var o in jsons ){
					arrays.push(jsons[o]);
				}
				
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
		return {
			sql: "Select id, tagname, tagcount From blog_tags",
			callback: function( cacheData ){
				var tmpJSONS = {};
				for ( var i = 0 ; i < cacheData.length ; i++ ){
					tmpJSONS[cacheData[i][0] + ""] = {
						id: cacheData[i][0],
						name: cacheData[i][1],
						count: cacheData[i][2]
					}
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
		return "Select photo, nickName, isposter, oauth, canlogin, logindate, loginip From blog_member Where id=" + id;
	}
	
	exports["attachments"] = function(){
		return "Select id, attachext, attachpath, attachsize From blog_attachments";
	}
});
%>