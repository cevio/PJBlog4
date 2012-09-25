<!--#include file="../config.asp" -->
<%
	http.async(function(req){
		var j = req.query.j, callbacks = {};
		
		callbacks.add = function(){
			var log_title = req.form.log_title,
				log_category = req.form.log_category,
				log_content = req.form.log_content,
				log_tags = req.form.log_tags;
				
			if ( log_title.length === 0 ){
				return {
					success: false,
					error: "标题不能为空"
				}
			}
			
			if ( log_category.length === 0 ){
				return {
					success: false,
					error: "亲，您还没有选择分类呢。"
				}
			}
			
			if ( log_content.length === 0 ){
				return {
					success: false,
					error: "亲，您不打算写日志内容吗？"
				}
			}
			
			var date = require("DATE"),
				time = date.format(new Date(), "y/m/d h:i:s");
				
			var status = this.addArticle({
				log_title: log_title,
				log_category: log_category,
				log_content: log_content,
				log_tags: log_tags,
				log_views: 0,
				log_posttime: time,
				log_updatetime: time
			});
			
			return {
				success: true,
				data: {
					id: status
				}
			}
		}
		
		callbacks.addArticle = function(options){
			var dbo = require("DBO"),
				connecte = require("openDataBase"),
				id = 0;
				
			if ( connecte === true ){
				dbo.add({
					data: options,
					table: "blog_article",
					conn: config.conn,
					callback: function(){
						id = this("id").value;
					}
				});
			}
			
			return id;
		}
		
		if ( Session("admin") === true ){
			if ( callbacks[j] !== undefined ){
				return callbacks[j]();
			}else{
				return {
					success: false,
					error: "未找到对应处理模块"
				}
			}
		}else{
			return {
				success: false,
				error: "非法权限操作"
			}
		}
	});
%>