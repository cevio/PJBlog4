
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase"),
		types = http.get("t");

	if ( !types || types === "" || types.length === 0 ){
		types = "setuped";
	}
		
	if ( connecte === true ){
		var fso = require("FSO"),
			xml = require("XML"),
			pluginRootFiles = fso.collect("profile/plugins", true),
			pluginMarkArray = [],
			date = require("DATE");
			
		function checkPluginMark(mark){
			var status = false;
			for ( var j = 0 ; j < pluginMarkArray.length ; j++ ){
				if ( pluginMarkArray[j] === mark ){
					status = true;
					break;
				}
			}
			return status;
		}
%>

<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">插件管理</div>
  <div class="fn-right ui-position-tools">
  	<a href="?p=plugin" class="<%=( types == "setuped" ? "active" : "" )%>">已安装插件</a> 
    <a href="?p=plugin&t=list" class="<%=( types == "list" ? "active" : "" )%>">未安装插件</a> 
    <a href="?p=plugin&t=online" class="<%=( types == "online" ? "active" : "" )%>">在线插件</a>
  </div>
</div>
<div class="ui-context">
<%
	if ( types === "list" ){
		(function(){
%>
		<ul class="setuped-list">
        	<%
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_plugin Order By pluginstatus Desc",
					callback: function( rs ){
						if ( rs.Bof || rs.Eof ){}else{
							this.each(function(){
								pluginMarkArray.push(this("pluginmark").value);
							});
						}
					}
				});
			
				var hasFiles = 0;
				if ( pluginRootFiles.length > 0 ){
					(function(files){
						for ( var i = 0 ; i < files.length ; i++ ){
							var xmlFile = "profile/plugins/" + files[i] + "/install.xml";
							
							if ( fso.exsit(xmlFile) ){
								var xmlConsole = xml.load(xmlFile);
								if ( xmlConsole !== null ){
									
									var pluginName = xml("pluginName", xmlConsole.root, xmlConsole.object);
									if ( pluginName.length > 0 ){
										pluginName = pluginName.text();
									}else{
										pluginName = "";
									}
									
									var pluginMark = xml("pluginMark", xmlConsole.root, xmlConsole.object);
									if ( pluginMark.length > 0 ){
										pluginMark = pluginMark.text();
									}else{
										pluginMark = "";
									}
									
									var pluginAuthor = xml("pluginAuthor", xmlConsole.root, xmlConsole.object);
									if ( pluginAuthor.length > 0 ){
										pluginAuthor = pluginAuthor.text();
									}else{
										pluginAuthor = "";
									}
									
									var pluginEmail = xml("pluginEmail", xmlConsole.root, xmlConsole.object);
									if ( pluginEmail.length > 0 ){
										pluginEmail = pluginEmail.text();
									}else{
										pluginEmail = "";
									}
									
									var pluginWebsite = xml("pluginWebsite", xmlConsole.root, xmlConsole.object);
									if ( pluginWebsite.length > 0 ){
										pluginWebsite = pluginWebsite.text();
									}else{
										pluginWebsite = "";
									}
									
									var pluginQQWeibo = xml("pluginQQWeibo", xmlConsole.root, xmlConsole.object);
									if ( pluginQQWeibo.length > 0 ){
										pluginQQWeibo = pluginQQWeibo.text();
									}else{
										pluginQQWeibo = "";
									}
									
									var pluginSinaWeibo = xml("pluginSinaWeibo", xmlConsole.root, xmlConsole.object);
									if ( pluginSinaWeibo.length > 0 ){
										pluginSinaWeibo = pluginSinaWeibo.text();
									}else{
										pluginSinaWeibo = "";
									}
									
									var pluginInfo = xml("pluginInfo", xmlConsole.root, xmlConsole.object);
									if ( pluginInfo.length > 0 ){
										pluginInfo = pluginInfo.html();
									}else{
										pluginInfo = "";
									}
									
									var pluginPublishDate = xml("pluginPublishDate", xmlConsole.root, xmlConsole.object);
									if ( pluginPublishDate.length > 0 ){
										pluginPublishDate = pluginPublishDate.text();
									}else{
										pluginPublishDate = "";
									}
									
									var pluginVersion = xml("pluginVersion", xmlConsole.root, xmlConsole.object);
									if ( pluginVersion.length > 0 ){
										pluginVersion = pluginVersion.text();
									}else{
										pluginVersion = "";
									}
						if ( checkPluginMark(pluginMark) === false ){
							hasFiles++;
			%>
						<li class="fn-clear">
							<div class="pic fn-left ui-wrapshadow"><img src="profile/plugins/<%=files[i]%>/priview.jpg" onerror="this.src='assets/img/thumb.jpg'" /></div>
							<div class="info ui-transition">
								<div class="titles"><%=pluginName%></div>
								<div class="msg fn-textoverhide" title="<%=pluginInfo%>">详细：<%=pluginInfo%></div>
								<div class="author">此插件由 <%=pluginAuthor%> 于 <%=pluginPublishDate%> 发布版本 <%=pluginVersion%></div>
								<div class="tools">
                                	<a href="javascript:;" class="action-setup" data-fo="<%=files[i]%>">安装</a> 
                                    <a href="javascript:;" class="action-del" data-fo="<%=files[i]%>">删除</a>
                                </div>
							</div>
						</li>
			<%
						}
								}
							}
						}
					})(pluginRootFiles);
					if ( hasFiles === 0 ){
						console.log("未找到未安装的插件");
					}
				}else{
					console.log("未找到未安装的插件");
				}
			%>
        </ul>
<%
		})();
	}else if ( types === "online" ){
		console.log("即将开放在线插件安装功能");
	}else{
		(function(){
%>
		<ul class="setuped-list">
        	<%
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_plugin Order By pluginstatus Desc",
					callback: function( rs ){
						if ( rs.Bof || rs.Eof ){
							console.log("没有已安装的插件");
						}else{
							this.each(function(){
								pluginMarkArray.push(this("pluginmark").value);
			%>
            <li class="fn-clear">
                <div class="pic fn-left ui-wrapshadow"><img src="profile/plugins/<%=this("pluginfolder").value%>/priview.jpg" onerror="this.src='assets/img/thumb.jpg'" /></div>
                <div class="info ui-transition">
                    <div class="titles"><%=this("pluginname").value%></div>
                    <div class="msg fn-textoverhide" title="<%=this("plugininfo").value%>">详细：<%=this("plugininfo").value%></div>
                    <div class="author">此插件由 <%=this("pluginauthor").value%> 于 <%=date.format(this("pluginpublishdate").value, "y-m-d h:i:s")%> 发布版本 <%=this("pluginversion").value%></div>
                    <div class="tools">
                        <%
                            if ( fso.exsit("profile/plugins/" + this("pluginfolder").value + "/config.xml") ){
                        %>
                        <a href="javascript:;" class="action-set fn-clear" data-id="<%=this("id").value%>">设置</a>
                        <%
                            }
                            if ( this("pluginstatus").value === true ){
                        %>
                        <a href="javascript:;" class="action-stop fn-clear" data-id="<%=this("id").value%>">停用</a>
                        <%
                            }else{
                        %>
                        <a href="javascript:;" class="action-active fn-clear" data-id="<%=this("id").value%>">启用</a>
                        <%
                            }
                        %>
                        <a href="javascript:;" class="action-uninstall fn-clear" data-id="<%=this("id").value%>">卸载</a> 
                        <%
                            if ( fso.exsit("profile/plugins/" + this("pluginfolder").value + "/configure.asp") ){
                        %>
                        <a href="?p=plugin-configure&id=<%=this("id").value%>" class="action-use fn-clear" data-id="<%=this("id").value%>">高级应用</a> 
                        <%}%>
                    </div>
                </div>
            </li>
			<%
                            });
                        }
                    }
                });
            %>
        </ul>
<%
		})();
	}
%>
</div>
<%
	}else{
		console.log("数据库连接失败");
	}
%>