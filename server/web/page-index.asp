<div class="ui-position fn-clear">
    <div class="fn-left ui-position-title">后台首页</div>
    <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context fn-clear">
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase"),
		sap = require("sap"),
		GRA = require("gra");
		
	if ( connecte === true ){
	
	function getUserInfo(id){
		var userData = {};
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_member Where id=" + id,
			callback: function(rs){
				userData.photo = rs("photo").value;
				userData.nickName = rs("nickName").value;
				userData.oauth = rs("oauth").value;
			}
		});
		return userData
	}
%>
	<div class="comment fn-right">
    	<ul class="lists">
       	<%
			dbo.trave({
				conn: config.conn,
				sql: "Select top 10 * From blog_comment Order By commentpostdate DESC",
				callback: function(){
					this.each(function(){
						var user = this("commentuserid").value,
							userData = {};
						
						if ( user > 0 ){
							userData = getUserInfo(user);
							var userPhotos = {};
							sap.proxy("system.member.list.photo", [userPhotos, userData.oauth, userData.photo]);
							userData.photo = userPhotos[userData.oauth];
						}else{
							userData.photo = GRA(this("commentusermail").value);
							userData.nickName = this("commentusername").value;
							if ( user === -1 ){
								userData.photo = config.user.photo;
								userData.nickName = config.user.name;
							}
						}
		%>
        	<li class="items fn-clear">
            	<div class="photo fn-right ui-wrapshadow"><img src="<%=userData.photo%>" /></div>
                <div class="infos fn-left ui-wrapshadow">
                	<div class="infocotent">
                        <div class="name"><%=userData.nickName%></div>
                        <div class="word"><%=this("commentcontent").value%></div>
                        <div class="action fn-clear"><a href="javascript:;" class="action-reply fn-left">回复</a><a href="javascript:;" class="action-del fn-right">删除</a></div>
                    </div>
                </div>
            </li>
        <%
					});
				}
			});
		%>
        </ul>
    </div>
    <div class="context">
<!--    	<div class="nav-titles fn-clear ui-wrapshadow">
            <div class="fn-left">活跃用户</div>
            <div class="fn-right"><a href="?p=member">详细</a></div>
        </div>-->
    	<div class="member">
        	<ul class="fn-clear">
           	<%
				dbo.trave({
					conn: config.conn,
					sql: "Select top 5 * From blog_member Order By logindate DESC",
					callback: function(){
						this.each(function(){
							var oauth = this("oauth").value,
								photoCons = {};
							
							sap.proxy("system.member.list.photo", [photoCons, oauth, this("photo").value]);
			%>
            	<li class="fn-left">
                	<div class="photo ui-wrapshadow"><img src="<%=photoCons[oauth]%>" /></div>
                    <div class="name fn-textoverhide"><%=this("nickname").value%></div>
                </li>
            <%
						});
					}
				})
			%>
            </ul>
        </div>
        
        <div class="nav-titles fn-clear ui-wrapshadow">
            <div class="fn-left">
            	<div class="tabs fn-clear">
                	<a href="javascript:;" class="fn-left">官方信息</a>
                    <a href="javascript:;" class="fn-left">主题信息</a>
                    <a href="javascript:;" class="fn-left">插件信息</a>
                </div>
            </div>
            <div class="fn-right"><a href="<%=config.platform%>" target="_blank">详细</a></div>
        </div>
        <div class="plant-infos">
        	<div class="plant-infos-item" id="n1"></div>
            <div class="plant-infos-item" id="n2"></div>
            <div class="plant-infos-item" id="n3"></div>
        </div>
    </div>
<%
	}else{
		console.log("连接数据库失败");
	}
%>
</div>