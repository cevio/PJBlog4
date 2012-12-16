<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	var fns = require("fn");

	this.add = function(){
		var rets = {}, id = 0;
			
		rets.log_title = req.form.log_title,
		rets.log_category = req.form.log_category,
		rets.log_content = req.form.log_content,
		rets.log_tags = this.addTags(req.form.log_tags).join(""),
		rets.log_shortcontent = req.form.log_shortcontent,
		rets.log_cover = req.form.log_cover;
			
		if ( rets.log_title.length === 0 ){
			return {
				success: false,
				error: "标题不能为空"
			}
		}
		
		if ( rets.log_category.length === 0 ){
			return {
				success: false,
				error: "亲，您还没有选择分类呢。"
			}
		}
		
		if ( rets.log_content.length === 0 ){
			return {
				success: false,
				error: "亲，您不打算写日志内容吗？"
			}
		}
		
		var date = require("DATE"),
			time = date.format(new Date(), "y/m/d h:i:s");
			
		rets.log_posttime = time;
		rets.log_updatetime = time;
		rets.log_views = 0;
		rets.log_uid = config.user.id;
			
		var tmp_remove_html = fns.removeHTML(rets.log_content);

		if ( rets.log_shortcontent.length === 0 ){
			rets.log_shortcontent = this.shortCutContent(tmp_remove_html);
			if ( rets.log_shortcontent.success ){
				rets.log_shortcontent = rets.log_shortcontent.data.html;
			}else{
				return {
					success: false,
					error: "处理日志预览出错"
				}
			}
		}
		
		sap.proxy("system.article.add.begin", [rets, req]);
		
		dbo.add({
			data: rets,
			table: "blog_article",
			conn: config.conn,
			callback: function(){
				id = this("id").value;
			}
		});
		
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_category Where id=" + rets.log_category,
			callback: function( rs ){
				rs("cate_count") = rs("cate_count").value + 1;
				rs.Update();
			}
		});
		
		if ( id > 0 ){
			var cache = require.async("cache");
				cache.build("category");
				
			return {
				success: true,
				data: {
					id: id
				}
			}
		}else{
			return {
				success: false,
				error: "添加数据失败"
			}
		}
	}
	
	this.shortCutContent = function(html){
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function(rs){
				html = fns.cutStr(html, rs("articleprivewlength").value, true);
			}
		});
		
		return {
			success: true,
			data: {
				html : html
			}
		}
	}
	
	this.update = function(){
		var rets = {}
			id = req.form.id,
			log_oldCategory = req.form.log_oldCategory;			
		
		rets.log_title = req.form.log_title;
		rets.log_category = req.form.log_category;
		rets.log_content = req.form.log_content;
		rets.log_tags = this.updateTags(id, req.form.log_tags).join("");
		rets.log_shortcontent = req.form.log_shortcontent;
		rets.log_cover = req.form.log_cover;
			
		if ( rets.log_title.length === 0 ){
			return {
				success: false,
				error: "标题不能为空"
			}
		}
		
		if ( rets.log_category.length === 0 ){
			return {
				success: false,
				error: "亲，您还没有选择分类呢。"
			}
		}
		
		if ( rets.log_content.length === 0 ){
			return {
				success: false,
				error: "亲，您不打算写日志内容吗？"
			}
		}
		
		var date = require("DATE"),
			time = date.format(new Date(), "y/m/d h:i:s");
		
		rets.log_updatetime = time;
			
		var tmp_remove_html = fns.removeHTML(rets.log_content);
		
		if ( rets.log_shortcontent.length === 0 ){	
			rets.log_shortcontent = this.shortCutContent(tmp_remove_html);
			if ( rets.log_shortcontent.success ){
				rets.log_shortcontent = rets.log_shortcontent.data.html;
			}else{
				return {
					success: false,
					error: "处理日志预览出错"
				}
			}
		}
		
		sap.proxy("system.article.update.begin", [rets, req]);
		
		dbo.update({
			data: rets,
			table: "blog_article",
			conn: config.conn,
			key: "id",
			keyValue: id
		});
		
		return {
			success: true,
			data: {
				id: id
			}
		}
	}
	
	this.addTags = function( tags ){
		var mtags = require("tags"),
			arrays = mtags.formatTags(tags),
			idArrays = [];
			
		for ( var i = 0 ; i < arrays.length ; i++ ){
			var ret = mtags.addTags(arrays[i]);
			if ( ret.success === true ){
				idArrays.push( "{" + ret.data.id + "}" );
			}
		}
		
		return idArrays;
	}
		
	this.updateTags = function(id, tags){
		var mtags = require("tags"),
			arrays = mtags.formatTags(tags),
			idArrays = [],
			removeFn = mtags.removeTagsByID(id);

		if ( removeFn.success === true ){
			for ( var i = 0 ; i < arrays.length ; i++ ){
				var ret = mtags.addTags(arrays[i]);
				if ( ret.success === true ){
					idArrays.push( "{" + ret.data.id + "}" );
				}
			}
		}else{
			console.push(removeFn.error);
		}

		return idArrays;
	}
	
	this.delarticle = function(){
		var id = req.query.id;
		if ( id.length > 0 ){
			try{
				var cateid = 0;				
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_article Where id=" + id,
					type: 3,
					callback: function(rs){
						cateid = rs("log_category").value;
						rs.Delete();
					}
				});
				
				dbo.trave({
					type: 3,
					conn: config.conn,
					sql: "Select * From blog_category Where id=" + cateid,
					callback: function( rs ){
						rs("cate_count") = rs("cate_count").value - 1;
						rs.Update();
					}
				});
				
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
				error: "参数错误"
			}
		}
	}
}, true);
%>