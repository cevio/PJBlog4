
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase"),
		types = http.get("t");

	if ( !types || types === "" || types.length === 0 ){
		types = "current";
	}
		
	if ( connecte === true ){
		
		var theme = { name: "", style: "", data: {} };
		
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function(rs){
				theme.name = rs("theme").value;
				theme.style = rs("style").value;
			}
		});
		
		var fso = require("FSO"),
			xml = require("XML"),
			xmlFile = "profile/themes/" + theme.name + "/install.xml";
		
%>
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">主题设置</div>
  <div class="fn-right ui-position-tools">
  	<a href="?p=theme" class="<%=( types == "current" ? "active" : "" )%>">当前主题</a> 
    <a href="?p=theme&t=list" class="<%=( types == "list" ? "active" : "" )%>">其他主题</a> 
    <a href="?p=theme&t=online" class="<%=( types == "online" ? "active" : "" )%>">在线主题</a>
  </div>
</div>
<div class="ui-context">
	<%
		if ( types === "list" ){
			(function(){
	%>
    	<div class="ui-wrapshadow uploadnewtheme">
        	<div class="info">上传主题包请注意：</div>
            <ul>
            	<li>1. 请尽量选择官方提供的主题包上传。</li>
                <li>2. 主题文件包格式为 *.pbd 格式，请不要上传非法文件。</li>
                <li>3. 更多主题包下载请前往官方支持平台。</li>
            </ul>
            <div class="uploadFile">
    		<input type="file" value="" id="uploadFile" />
            </div>
            <div class="info">请点击以上按钮选择本地主题包文件后点击以下按钮进行上传（可以批量上传）。</div>
            <div class="startupload"><a href="javascript:;" id="upload" class="button">上传新主题</a></div>
        </div>
    <%
				console.log('<ul class="theme-list">');
				var lists = fso.collect("profile/themes", true);
					for ( var listItem = 0 ; listItem < lists.length ; listItem++ ){
						var listFolder = lists[listItem],
							listInstallXMLFile = "profile/themes/" + listFolder + "/install.xml";
						
						if ( fso.exsit(listInstallXMLFile) && ( listFolder !== theme.name ) ){
							var xmlCustomLoader = xml.load(listInstallXMLFile);
							
							if ( xmlCustomLoader !== null ){
								var listXMLThemeName = xml("themeName", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeName.size() > 0 ){
										listXMLThemeName = listXMLThemeName.text();
									}else{
										listXMLThemeName = "";
									}
								
								var listXMLThemeInfo = xml("themeInfo", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeInfo.size() > 0 ){
										listXMLThemeInfo = listXMLThemeInfo.html();
									}else{
										listXMLThemeInfo = "";
									}
									
								var listXMLThemeVersion = xml("themeVersion", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeVersion.size() > 0 ){
										listXMLThemeVersion = listXMLThemeVersion.text();
									}else{
										listXMLThemeVersion = "";
									}
									
								var listXMLThemeAuthor = xml("themeAuthor", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeAuthor.size() > 0 ){
										listXMLThemeAuthor = listXMLThemeAuthor.text();
									}else{
										listXMLThemeAuthor = "";
									}
									
								var listXMLThemeMail = xml("themeEmail", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeMail.size() > 0 ){
										listXMLThemeMail = listXMLThemeMail.text();
									}else{
										listXMLThemeMail = "";
									}
								
								var listXMLThemePubDate = xml("themePublishDate", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemePubDate.size() > 0 ){
										listXMLThemePubDate = listXMLThemePubDate.text();
									}else{
										listXMLThemePubDate = "";
									}
									
								var listXMLThemeWebsite = xml("themeWebSite", xmlCustomLoader.root, xmlCustomLoader.object);
									if ( listXMLThemeWebsite.size() > 0 ){
										listXMLThemeWebsite = listXMLThemeWebsite.text();
									}else{
										listXMLThemeWebsite = "";
									}
									
		%>
        						<li class="fn-clear">
                                	<div class="theme-list-preview ui-wrapshadow fn-left"><img src="profile/themes/<%=listFolder%>/priview.jpg" /></div>
                                    <div class="theme-list-info ui-transition">
                                    	<div class="name"><%=listXMLThemeName%> <span>( <%=listXMLThemeVersion%> ) : { mark: <%=listFolder%> }</span></div>
                                        <div class="date">时间： <%=listXMLThemePubDate%></div>
                                        <div class="author">作者： <a href="mailto:<%=listXMLThemeMail%>"><%=listXMLThemeAuthor%></a> ( <a href="<%=listXMLThemeWebsite%>" target="_blank"><%=listXMLThemeWebsite%></a> ) </div>
                                        <div class="info fn-textoverhide">详细： <%=listXMLThemeInfo%></div>
                                        <div class="action">
                                        	<a href="javascript:;" class="fn-clear">分享</a> 
                                            <a href="javascript:;" class="fn-clear action-setup" data-id="<%=listFolder%>">安装</a> 
                                            <a href="javascript:;" class="fn-clear action-del" data-id="<%=listFolder%>">删除</a>
                                        </div>
                                    </div>
                                </li>
        <%
							}
						}
					}
					console.log('</ul>');
			})();
		}else if ( types === "online" ){
			console.log("即将开放在线主题模块");
		}else{
			(function(){
				if ( fso.exsit(xmlFile) ){
					var xmlLoader = xml.load(xmlFile);
					if ( xmlLoader !== null ){
						theme.data.themeName = xml("themeName", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeName.size() > 0 ){
							theme.data.themeName = theme.data.themeName.text();
						}else{
							theme.data.themeName = "";
						}
						
						theme.data.themeAuthor = xml("themeAuthor", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeAuthor.size() > 0 ){
							theme.data.themeAuthor = theme.data.themeAuthor.text();
						}else{
							theme.data.themeAuthor = "";
						}
						
						theme.data.themeWebSite = xml("themeWebSite", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeWebSite.size() > 0 ){
							theme.data.themeWebSite = theme.data.themeWebSite.text();
						}else{
							theme.data.themeWebSite = "";
						}
						
						theme.data.themeEmail = xml("themeEmail", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeEmail.size() > 0 ){
							theme.data.themeEmail = theme.data.themeEmail.text();
						}else{
							theme.data.themeEmail = "";
						}
						
						theme.data.themePublishDate = xml("themePublishDate", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themePublishDate.size() > 0 ){
							theme.data.themePublishDate = theme.data.themePublishDate.text();
						}else{
							theme.data.themePublishDate = "";
						}
						
						theme.data.themeVersion = xml("themeVersion", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeVersion.size() > 0 ){
							theme.data.themeVersion = theme.data.themeVersion.text();
						}else{
							theme.data.themeVersion = "";
						}
						
						theme.data.themeInfo = xml("themeInfo", xmlLoader.root, xmlLoader.object);
						if ( theme.data.themeInfo.size() > 0 ){
							theme.data.themeInfo = theme.data.themeInfo.html();
						}else{
							theme.data.themeInfo = "";
						}
	%>
    					<div class="currentTheme fn-clear">
                        	<div class="theme-preview ui-wrapshadow fn-left">
                        		<img src="profile/themes/<%=theme.name%>/priview.jpg" />
                            </div>
                            <div class="theme-info fn-left">
                            	<div class="name"><%=theme.data.themeName%> ( <%=theme.data.themeVersion%> )</div>
                                <div class="version"><span>相关：</span> 此主题由 <%=theme.data.themeAuthor%> 于 <%=theme.data.themePublishDate%> 制作版本 <%=theme.data.themeVersion%>。</div>
                                <div class="url"><span>网站：</span> <a href="<%=theme.data.themeWebSite%>" target="_blank"><%=theme.data.themeWebSite%></a></div>
                                <div class="infos"><span>详细：</span> <%=theme.data.themeInfo%></div>
                            </div>
                        </div>
                        
                        <div class="current-theme-style">
                        	<div class="title">此主题下可选的风格列表（ 当然风格已高亮显示。点击其他风格将被激活新风格。 ）</div>
                            <ul class="list fn-clear">
                            	<%
									var styles = fso.collect("profile/themes/" + theme.name + "/style", true);
									for ( var stylesItem = 0 ; stylesItem < styles.length ; stylesItem++ ){
										var _current = styles[stylesItem] === theme.style ? "current" : "";
								%>
								<li data-id="<%=styles[stylesItem]%>" class="ui-wrapshadow fn-left <%=_current%>"><img src="profile/themes/<%=theme.name%>/style/<%=styles[stylesItem]%>/priview.jpg" title="This style name is <%=styles[stylesItem]%>" /></li>
								<%
									}
								%>
                            </ul>
                        </div>
    <%
					}else{
						console.log("打开当前主题失败");
					}
				}else{
					console.log("未找到当前主题");
				}
			})();
		}
	%>
</div>
<%
	}else{
		console.log("数据库连接失败");
	}
%>