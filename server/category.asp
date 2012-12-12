<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	this.getcateinfo = function(){
		var id = req.query.id,
			rets = {};
		
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_category Where id=" + id,
			callback: function(rs){
				rets.cateName = rs("cate_name").value;
				rets.cateInfo = rs("cate_info").value;
				if ( rets.cateInfo === null ){ rets.cateInfo = ""; }
				rets.cateOrder = rs("cate_order").value;
				if ( rets.cateOrder === null ){ rets.cateOrder = 99; }
				rets.cateRoot = rs("cate_root").value;
				rets.cateCount = rs("cate_count").value;
				if ( rets.cateCount === null ){ rets.cateCount = 0; }
				rets.cateIcon = rs("cate_icon").value;
				rets.cateIsShow = rs("cate_show").value;
				rets.cateOutLink = rs("cate_outlink").value;
				rets.cateOutLinkText = rs("cate_outlinktext").value;
				if ( rets.cateOutLinkText === null ){ rets.cateOutLinkText = ""; }
				rets.id = id;
				sap.proxy("system.category.info.begin", [rets, rs]);
			}
		});
		
		return {
			success: true,
			data: rets
		}
	}
	
	this.updatecate = function(){
		var rets = {},
			id = req.form.id;
			
			rets.cate_name = req.form.cateName;
			rets.cate_info = req.form.cateInfo;
			rets.cate_order = req.form.cateOrder;
			if ( !rets.cate_order || rets.cate_order.length === 0 ){
				rets.cate_order = 99;
			}
			rets.cate_root = req.form.cateRoot;
			if ( !rets.cate_root || rets.cate_root.length === 0 ){
				rets.cate_root = 0;
			}
			rets.cate_count = req.form.cateCount;
			if ( !rets.cate_count || rets.cate_count.length === 0 ){
				rets.cate_count = 0;
			}
			rets.cate_icon = req.form.cateIcon;
			rets.cate_show = req.form.cateIsShow;
			if ( rets.cate_show === "1" ){
				rets.cate_show = true;
			}else{
				rets.cate_show = false;
			}
			rets.cate_outlink = req.form.cateOutLink;
			if (rets.cate_outlink === "1"){
				rets.cate_outlink === 1;
			}else{
				rets.cate_outlink = 0;
			}
			rets.cate_outlinktext = req.form.cateOutLinkText;

		sap.proxy("system.category.update.begin", [rets, req]);
		
		dbo.update({
			data: rets,
			table: "blog_category",
			conn: config.conn,
			key: "id",
			keyValue: id
		});
		
		var cache = require.async("cache");	
			cache.build("category");

		return {
			success: true,
			data: {
				id: Number(id)
			}
		}
	}
	
	this.destorycates = function(){
		var id = req.query.id,
			len = String(config.conn.Execute("Select Count(*) From blog_category Where cate_root=" + id)(0));
			
		if ( len === "0" ){
			try{
				config.conn.Execute("Delete From blog_category Where id=" + id);
				
				var cache = require.async("cache");	
					cache.build("category");
				
				return {
					success: true
				}
			}catch(e){
				return {
					success: false,
					error: e.message
				}
			}
		}else{
			return {
				success: false,
				error: "存在二级分类，不能删除。"
			}
		}
	}
	
	this.iconlist = function(){
		return require.async("icon");
	}
	
	this.addnewcategorybyname = function(){
		var root = req.query.root,
			name = req.query.name,
			icon = req.query.icon,
			_id = 0;
			
		dbo.add({
			data: {
				cate_name: name,
				cate_root: Number(root),
				cate_icon: icon
			},
			table: "blog_category",
			conn: config.conn,
			callback: function(){
				_id = this("id").value;
			}
		});
		
		if ( _id > 0 ){
			var cache = require.async("cache");	
				cache.build("category");
				
			return {
				success: true,
				data: {
					id: _id
				}
			}
		}else{
			return {
				success: false,
				error: "新建分类失败"
			}
		}
	}
	
	this.seticon = function(){
		var id = req.query.id,
			icon = req.query.icon;
	
		dbo.update({
			conn: config.conn,
			table: "blog_category",
			data: {
				cate_icon: icon
			},
			key: "id",
			keyValue: id
		});
		
		var cache = require.async("cache");	
			cache.build("category");
		
		return {
			success: true
		}
	}
});
%>