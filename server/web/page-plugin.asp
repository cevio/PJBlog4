
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
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

<div class="tpl-space fn-clear">
    <div class="plugin-zone">
        <h3><span class="iconfont">&#367;</span> 插件管理</h3>
        <div class="tabs">
            <div class="tabs-navs fn-clear"> <a href="javascript:;" class="fn-left tabs-trigger">已安装插件</a> <a href="javascript:;" class="fn-left tabs-trigger">未安装插件</a> <a href="javascript:;" class="fn-left tabs-trigger">在线插件</a> <div class="fn-right"><input type="text" value="" name="onlinePluginName" placeholder="搜索在线插件.." style="width:150px;" /></div> </div>
            <div class="tabs-contents">
                <div class="tabs-content-items tabs-content">
                    <ul class="tabs-content-items-area">
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
                                	<div class="pic"><img src="profile/plugins/<%=this("pluginfolder").value%>/priview.jpg" onerror="this.src='assets/images/plugin.jpg'" /></div>
                                    <div class="info">
                                    	<div class="titles"><%=this("pluginname").value%></div>
                                        <div class="msg"><%=this("plugininfo").value%></div>
                                        <div class="author"><span class="iconfont">&#359;</span> 此插件由 <%=this("pluginauthor").value%> 于 <%=date.format(this("pluginpublishdate").value, "y-m-d h:i:s")%> 发布版本 <%=this("pluginversion").value%></div>
                                        <div class="tools">
                                        	<a href="javascript:;" class="action-set fn-clear" data-id="<%=this("id").value%>">
                                            	<span class="iconfont">&#355;</span> <span class="icontext">设置</span>
                                            </a>
                                            <%
												if ( this("pluginstatus").value === true ){
											%>
                                        	<a href="javascript:;" class="action-stop fn-clear" data-id="<%=this("id").value%>">
                                            	<span class="iconfont">&#419;</span> <span class="icontext">停用</span>
                                            </a>
                                            <%
												}else{
											%>
                                            <a href="javascript:;" class="action-active fn-clear" data-id="<%=this("id").value%>">
                                            	<span class="iconfont">&#265;</span> <span class="icontext">启用</span>
                                            </a>
                                            <%
												}
											%>
                                        	<a href="javascript:;" class="action-uninstall fn-clear" data-id="<%=this("id").value%>">
                                            	<span class="iconfont">&#350;</span> <span class="icontext">卸载</span>
                                            </a> 
                                            <a href="javascript:;" class="action-use fn-clear" data-id="<%=this("id").value%>">
                                            	<span class="iconfont">&#361;</span> <span class="icontext">高级应用</span>
                                            </a> 
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
                </div>
                <div class="tabs-content-items tabs-content">
                    <ul class="tabs-content-items-area">
                    <%
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
                                	<div class="pic"><img src="profile/plugins/<%=files[i]%>/priview.jpg" onerror="this.src='assets/images/plugin.jpg'" /></div>
                                    <div class="info">
                                    	<div class="titles"><%=pluginName%></div>
                                        <div class="msg"><%=pluginInfo%></div>
                                        <div class="author"><span class="iconfont">&#359;</span> 此插件由 <%=pluginAuthor%> 于 <%=pluginPublishDate%> 发布版本 <%=pluginVersion%></div>
                                        <div class="tools"><a href="javascript:;" class="action-setup fn-clear" data-fo="<%=files[i]%>"><span class="iconfont">&#409;</span> <span class="icontext">安装</span></a> <a href="javascript:;" class="action-del fn-clear" data-fo="<%=files[i]%>"><span class="iconfont">&#356;</span> <span class="icontext">删除</span></a></div>
                                    </div>
                                </li>
                    <%
								}
										}
									}
								}
							})(pluginRootFiles);
							if ( hasFiles === 0 ){
								console.log('<li class="fn-clear">未找到未安装的插件</li>');
							}
						}else{
							console.log('<li class="fn-clear">未找到未安装的插件</li>');
						}
					%>
                    </ul>
                </div>
                <div class="tabs-content-items tabs-content">
                    <ul class="tabs-content-items-area">
                    3
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<%
	}else{
		console.log('<div class="tpl-space fn-clear"><div class="plugin-zone">数据库连接失败</div></div>');
	}
%>