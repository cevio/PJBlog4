<!--#include file="../config.asp" -->
<%
	http.async(function(req){
		var j = req.query.j, callbacks = {};
		
		callbacks.getcateinfo = function(){
			var id = req.query.id;
			return {
				success: true,
				data: {
					id: id
				}
			}
		}
		
		callbacks.addcates = function(){
			var cate_name = req.form.cateName,
				cate_info = req.form.cateInfo;
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