<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_category = cache.load("category"),
		arrays = {},
		ids = [],
		trees = [];
	
	for ( var i = 0 ; i < sys_cache_category.length ; i++ ){
		var items = sys_cache_category[i];
		
		var id = items[0],
			cate_name = items[1],
			cate_info = items[2],
			cate_root = items[3],
			cate_count = items[4],
			cate_icon = items[5],
			cate_outlink = items[6],
			cate_outlinktext = items[7];
			
		ids.push(id);
		
		if ( cate_root === 0 ){
			if ( arrays[id + ""] === undefined ){
				arrays[id + ""] = {
					id: id,
					name: cate_name,
					info: cate_info,
					count: cate_count, 
					icon: cate_icon,
					link: cate_outlink ? cate_outlinktext : "default.asp?c=" + id,
					childrens: []
				};
			}else{
				arrays[id + ""].id = id;
				arrays[id + ""].name = cate_name;
				arrays[id + ""].info = cate_info;
				arrays[id + ""].count = cate_count;
				arrays[id + ""].icon = cate_icon;
				arrays[id + ""].link = cate_outlink ? cate_outlinktext : "default.asp?c=" + id;
				if ( arrays[id + ""].childrens === undefined ){
					arrays[id + ""].childrens = [];
				}
			}
		}else{
			if ( arrays[cate_root + ""] === undefined ){
				arrays[cate_root + ""] = {
					childrens: []
				};
			}
			
			arrays[cate_root + ""].childrens.push({
				id: id,
				name: cate_name,
				info: cate_info,
				count: cate_count, 
				icon: cate_icon,
				cate_outlink: cate_outlink ? cate_outlinktext : "default.asp?c=" + id
			});
		}	
	}
	
	for ( var j = 0 ; j < ids.length ; j++ ){
		if ( arrays[ids[j] + ""] !== undefined ){
			trees.push(arrays[ids[j] + ""]);
		}
	}
	
	pageCustomParams.categorys = trees;
	
	return trees;
});
%>