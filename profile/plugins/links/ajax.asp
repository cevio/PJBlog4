<!--#include file="../../../config.asp" -->
<%
	http.async(function(req){
		var j = req.form.j, callbacks = {};

		var id = req.form.id;
		id = Number(id);
		if (id<1){
			return {
				success: false,
				error: "参数错误"
			}
		}

		require("status");
		var linkname=req.form.linkname?req.form.linkname:'',linkinfo=req.form.linkinfo?req.form.linkinfo:'',linkurl=req.form.linkurl?req.form.linkurl:'',linkimage=req.form.linkurl?req.form.linkurl:'',linkimage=req.form.linkurl?req.form.linkurl:'';
		callbacks.post = function(){
			/*可加入判断*/
			if (linkinfo.length>100){
				return {
					success: false,
					error: "网站简介不用那么多字吧"
				}
			}
			var fn=require("fn"),
				dbo = require("DBO"),
				connecte = require("openDataBase");
				linkinfo=fn.removeHTML(linkinfo);
			if ( connecte === true ){
				var date = require("DATE"),
				time = date.format(new Date(), "y/m/d h:i:s");
				dbo.add({
					conn: config.conn,
					table:"blog_link",
					data:{
						"linkname":fn.SQLStr(linkname),
						"linkinfo":fn.SQLStr(linkinfo),
						"linkurl":fn.SQLStr(linkurl),
						"linkimage":fn.SQLStr(linkimage),
						"linkroot":0,
						"linkaduit":false
					}
				});
				return {
					success: true
				}
			}else{
				return {
					success: false,
					error: "数据库连接失败"
				}
			}
		}

		if ( callbacks[j] !== undefined ){
			return callbacks[j]();
		}else{
			return {
				success: false,
				error: "未找到对应处理模块"
			}
		}
	});
	CloseConnect();
%>