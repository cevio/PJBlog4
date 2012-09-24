<!--#include file="../config.asp" -->
<%
	http.async(function(req){
		var j = req.query.j, callbacks = {};
		
		callbacks.getcateinfo = function(){
			var id = req.query.id,
				dbo = require("DBO"),
				connecte = require("openDataBase");
				
			var cateName, cateInfo, cateOrder, cateRoot, cateCount, cateIcon, cateIsShow, cateOutLink, cateOutLinkText;
			
			if ( connecte === true ){
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_category Where id=" + id,
					callback: function(rs){
						cateName = rs("cate_name").value;
						cateInfo = rs("cate_info").value;
						cateOrder = rs("cate_order").value;
						cateRoot = rs("cate_root").value;
						cateCount = rs("cate_count").value;
						cateIcon = rs("cate_icon").value;
						cateIsShow = rs("cate_show").value;
						cateOutLink = rs("cate_outlink").value;
						cateOutLinkText = rs("cate_outlinktext").value
					}
				});
				
				return {
					success: true,
					data: {
						cateName: cateName,
						cateInfo: cateInfo,
						cateOrder: cateOrder,
						cateRoot: cateRoot,
						cateCount: cateCount,
						cateIcon: cateIcon,
						cateIsShow: cateIsShow,
						cateOutLink: cateOutLink,
						cateOutLinkText: cateOutLinkText
					}
				}
			}else{
				return {
					success: false,
					error: "打开数据库失败"
				}
			}
		};
		
		callbacks.addcates = function(){
			var cate_name = req.form.cateName,
				cate_info = req.form.cateInfo,
				cate_order = req.form.cateOrder,
				cate_root = req.form.cateRoot,
				cate_count = req.form.cateCount,
				cate_icon = req.form.cateIcon,
				cate_isshow = req.form.cateIsShow,
				cate_outlink = req.form.cateOutLink,
				cate_outlinktext = req.form.cateOutLinkText;
				
			var status = this.addCategory({
				cate_name: cate_name,
				cate_info: cate_info,
				cate_order: Number(cate_order) || 0,
				cate_root: Number(cate_root) || 0,
				cate_count: Number(cate_count) || 0,
				cate_icon: cate_icon,
				cate_show: cate_isshow === "1" ? true : false,
				cate_outlink: cate_outlink === "1" ? true : false,
				cate_outlinktext: cate_outlinktext
			});
			
			return {
				success: true,
				data: {
					id: status
				}
			}
		};
		
		callbacks.addCategory = function(options){
			var dbo = require("DBO"),
				connecte = require("openDataBase"),
				id = 0;
				
			if ( connecte === true ){
				dbo.add({
					data: options,
					table: "blog_category",
					conn: config.conn,
					callback: function(){
						id = this("id").value;
					}
				});
			}
			
			return id;
		};
		
		callbacks.updateCategory = function(id, options){
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				dbo.update({
					data: options,
					table: "blog_category",
					conn: config.conn,
					key: "id",
					keyValue: id
				});
				
				return true;
			}else{
				return false;
			}
		};
		
		callbacks.updatecate = function(){
			var id = req.form.id,
				cate_name = req.form.cateName,
				cate_info = req.form.cateInfo,
				cate_order = req.form.cateOrder,
				cate_root = req.form.cateRoot,
				cate_count = req.form.cateCount,
				cate_icon = req.form.cateIcon,
				cate_isshow = req.form.cateIsShow,
				cate_outlink = req.form.cateOutLink,
				cate_outlinktext = req.form.cateOutLinkText;
			
			var status = this.updateCategory(id, {
				cate_name: cate_name,
				cate_info: cate_info,
				cate_order: Number(cate_order) || 0,
				cate_root: Number(cate_root) || 0,
				cate_count: Number(cate_count) || 0,
				cate_icon: cate_icon,
				cate_show: cate_isshow === "1" ? true : false,
				cate_outlink: cate_outlink === "1" ? true : false,
				cate_outlinktext: cate_outlinktext
			});
			
			return { success: status, data: { id: id }, error: "数据库打开失败" }
				
		};
		
		callbacks.destorycates = function(){
			var id = req.query.id,
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				var len = String(config.conn.Execute("Select Count(*) From blog_category Where cate_root=" + id)(0));

				if ( len === "0" ){
					try{
						config.conn.Execute("Delete From blog_category Where id=" + id);
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
				
			}else{
				return {
					success: false,
					error: "数据库打开失败"
				}
			}
		}
		
		callbacks.iconlist = function(){
			return require.async("icon");
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