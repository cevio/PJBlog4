<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_category = cache.load("category"),
		arrays = {};
	
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
		
		if ( cate_root === 0 ){
			if ( arrays[id + ""] === undefined ){
				arrays[id + ""] = {
					cate_name: cate_name,
					cate_info: cate_info,
					cate_count: cate_count, 
					cate_icon: cate_icon,
					cate_outlink: cate_outlink,
					cate_outlinktext: cate_outlinktext,
					childrens: {}
				};
			}else{
				arrays[id + ""].cate_name = cate_name;
				arrays[id + ""].cate_info = cate_info;
				arrays[id + ""].cate_count = cate_count;
				arrays[id + ""].cate_icon = cate_icon;
				arrays[id + ""].cate_outlink = cate_outlink;
				arrays[id + ""].cate_outlinktext = cate_outlinktext;
				if ( arrays[id + ""].childrens === undefined ){
					arrays[id + ""].childrens = {};
				}
			}
		}else{
			if ( arrays[cate_root + ""] === undefined ){
				arrays[cate_root + ""] = {
					childrens: {}
				};
			}
			
			if ( arrays[cate_root + ""].childrens[id + ""] === undefined ){
				arrays[cate_root + ""].childrens[id + ""] = {};
			}
			
			arrays[cate_root + ""].childrens[id + ""].cate_name = cate_name;
			arrays[cate_root + ""].childrens[id + ""].cate_info = cate_info;
			arrays[cate_root + ""].childrens[id + ""].cate_count = cate_count;
			arrays[cate_root + ""].childrens[id + ""].cate_icon = cate_icon;
			arrays[cate_root + ""].childrens[id + ""].cate_outlink = cate_outlink;
			arrays[cate_root + ""].childrens[id + ""].cate_outlinktext = cate_outlinktext;
		}	
		
	}
	
	return arrays;
});
%>