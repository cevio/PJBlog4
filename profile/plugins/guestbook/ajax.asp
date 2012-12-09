<!--#include file="../../../config.asp" -->
<%
var checksub_email=function(str){
	if (!str||str==""){return false;}
	if (!str.match(/^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/)){
	return false;
	}
	else{
	return true;
	}
}
var getunamebyid=function(id){
	var dbo = require("DBO"),
	connecte = require("openDataBase"),uname='';
	id=Number(id);
	if ( connecte === true ){
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_member WHERE id="+id,
			callback:function(){
				this.each(function(){
					uname=this("nickName").value!=""?this("nickName").value:"";
				})
			}
		});
		return uname;
	}else{
		return '';
	}
};
	http.async(function(req){
		var j = req.form.j, callbacks = {};

		var id = req.form.id;
		id = Number(id);
		if (id<0){
			return {
				success: false,
				error: "参数错误"
			}
		}

		require("status");
		var username='',userid=0,email=req.form.email?(checksub_email(req.form.email)?req.form.email:""):"",website=req.form.website?req.form.website:"";
		var content=req.form.content?req.form.content:'';
		if ( config.user.login === true ){
			username=getunamebyid(config.user.id);
			if (username!=""){
				userid=config.user.id;
			}
		}
		else{
			username="访客"+req.form.username;
			userid=0;
		}
		
		callbacks.post = function(){
			/*可加入判断*/
			if (!content||content.length<5){
				return {
					success: false,
					error: "留言内容不能短于5个字符"
				}
			}
			if (content.length>500){
				return {
					success: false,
					error: "你想长篇大论啊"
				}
			}
			var fn=require("fn"),
				dbo = require("DBO"),
				connecte = require("openDataBase");
				content=fn.removeHTML(content);
			if ( connecte === true ){
				var date = require("DATE"),
				time = date.format(new Date(), "y/m/d h:i:s");
				dbo.add({
					conn: config.conn,
					table:"blog_guestbook",
					data:{
						"bookusername":fn.SQLStr(username),
						"bookusermail":fn.SQLStr(email),
						"bookwebsite":fn.SQLStr(website),
						"bookuserid":userid,
						"bookcontent":fn.SQLStr(http.form("content")),
						"bookroot":id,
						"bookposttime":time,
						"bookpostip":fn.getIP()
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