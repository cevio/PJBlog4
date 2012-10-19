
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
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

<div class="tpl-space fn-clear">
    <div class="theme-zone">
    	<h3><span class="iconfont">&#367;</span> 当前主题</h3>
        <%
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
        <div class="theme-current fn-clear">
        	<div class="theme-priview fn-left">
            	<img src="profile/themes/<%=theme.name%>/priview.jpg" />
            </div>
            <div class="theme-info fn-left">
            	<div class="theme-title"><%=theme.data.themeName%> ( <%=theme.data.themeVersion%> )</div>
                <div class="theme-user"><span class="iconfont">&#359;</span> 此主题由 <%=theme.data.themeAuthor%> 于 <%=theme.data.themePublishDate%> 制作版本 <%=theme.data.themeVersion%>。</div>
                <div class="theme-info-items"><span>网站：</span> <a href="<%=theme.data.themeWebSite%>" target="_blank"><%=theme.data.themeWebSite%></a></div>
                <div class="theme-info-items theme-action"><a href="" target="_blank"><span class="iconfont">&#47;</span> 分享</a> <a href=""><span class="iconfont">&#119;</span> 文档</a></div>
            </div>
            <div class="theme-message fn-left"><span class="strong">说明：</span> <%=theme.data.themeInfo%></div>
        </div>
        <div class="theme-style-list fn-clear">
        	<div class="theme-style-list-warn"><span>主题风格：</span>（ 当然风格已高亮显示。点击其他风格将被激活新风格。 ）</div>
        	<ul class="fn-clear">
            	<%
					var styles = fso.collect("profile/themes/" + theme.name + "/style", true);
					for ( var stylesItem = 0 ; stylesItem < styles.length ; stylesItem++ ){
						var _current = styles[stylesItem] === theme.style ? ' class="current"' : '';
				%>
            	<li<%=_current%>><img src="profile/themes/<%=theme.name%>/style/<%=styles[stylesItem]%>/priview.jpg" /></li>
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
		%>
        
        <h3><span class="iconfont">&#367;</span> 其他可选主题</h3>
        <div class="theme-other">
        	<ul class="fn-clear theme-list">
            <%
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
			%>
            	<li>
                	<div class="list-area fn-clear">
                		<div class="list-priview"><img src="profile/themes/<%=listFolder%>/priview.jpg" /></div>
                        <div class="list-info">
                        	<div class="list-info-title fn-textoverhide"><%=listXMLThemeName%> ( <%=listXMLThemeVersion%> )</div>
                            <div class="list-info-msg"><%=listXMLThemeInfo%></div>
                            <div class="list-info-action fn-clear"><a href="javascript:;" class="fn-clear"><span class="iconfont">&#47;</span> <span class="icontext">分享</span></a> <a href="javascript:;" class="fn-clear action-setup" data-id="<%=listFolder%>"><span class="iconfont">&#409;</span> <span class="icontext">安装</span></a> <a href="javascript:;" class="fn-clear"><span class="iconfont">&#356;</span> <span class="icontext">删除</span></a> </div>
                        </div>
                    </div>
                    <div class="theme-install">
                    sdaf
                    </div>
                </li>
            <%
						}
					}
				}
			%>
            </ul>
        </div>
    </div>
</div>

<%
	}else{
		console.log('<div class="tpl-space fn-clear"><div class="theme-zone">数据库连接失败</div></div>');
	}
%>