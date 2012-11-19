<%
	var id = http.get("id") || "",
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		mode,
		actionURL;
		
	if ( id.length === 0 ){
		mode = "add";
		actionURL = "server/article.asp?j=add";
	}else{
		mode = "edit";
		actionURL = "server/article.asp?j=update";
	}
		
	function getSecondDatas(id){
		dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_category Where cate_root=" + id + " And cate_outlink=False Order By cate_order Asc",
				callback: function(ret){
					if ( ret.Bof || ret.Eof ){}else{
						this.each(function(){
		%>
		<li class="second-bar-items">
        	<div class="second-bar-items-area fn-clear items-bar<%=((log_category + "") === (this("id").value + "") ? " choose-current" : "")%>">
                <div class="second-bar-items-name fn-left fn-wordWrap"><%=this("cate_name").value%></div>
                <div class="second-bar-items-info fn-left fn-wordWrap"><%=this("cate_info").value%></div>
                <div class="second-bar-items-action fn-left"><a href="javascript:;" class="choose-cate" data-id="<%=this("id").value%>">选定</a></div>
            </div>
        </li>
		<%
						});
					}
				}
			})
	}
		
	if ( connecte === true ){
	
		var log_title = "",
			log_category = "",
			log_tags = "",
			log_content = "",
			log_cover = "";
			
		var articleCuts = 300,
			uploadimagetype,
			uploadlinktype,
			uploadswftype,
			uploadmediatype;
			
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function( rs ){
				articleCuts = rs("articleprivewlength").value;
				uploadimagetype = rs("uploadimagetype").value;
				uploadlinktype = rs("uploadlinktype").value;
				uploadswftype = rs("uploadswftype").value;
				uploadmediatype = rs("uploadmediatype").value;
			}
		});
			
		
		if ( mode === "edit" ){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_article Where id=" + id,
				callback: function(rs){
					if ( rs.Bof || rs.Eof ){}else{
						log_title = rs("log_title").value;
						log_category = rs("log_category").value;
						log_tags = rs("log_tags").value;
						log_content = rs("log_content").value;
						log_cover = rs("log_cover").value;
						
						var module_tags = require("tags");
						log_tags = module_tags.reFormatTags(log_tags);
						log_tags = (function(modules){
							var arrays = []
						
							for ( var i = 0 ; i < log_tags.length ; i++ ){
								var value = modules.readTag( log_tags[i] );
								
								if ( value.success === true ){
									arrays.push( value.data.name );
								}
							}
							
							return arrays.join(",");
						})(module_tags);

					}
				}
			});
		}
%>

<script language="javascript">
var articleCut = <%=articleCuts%>,
	uploadimagetype = "<%=uploadimagetype%>",
	uploadlinktype = "<%=uploadlinktype%>",
	uploadswftype = "<%=uploadswftype%>",
	uploadmediatype = "<%=uploadmediatype%>";
</script>

<div class="tpl-space fn-clear">
	<div class="article-zone">
    	<div class="write-area">
        	<form action="<%=actionURL%>" method="post" style="margin:0; padding:0;">
            	<input type="hidden" value="<%=id%>" name="id" />
                <textarea name="log_shortcontent" style="position:absolute; top:-99999px; left:-99999px;"></textarea>
                <h3><span class="iconfont">&#367;</span> <%console.log( mode === "add" ? "新建日志" : "编辑日志" )%></h3>
                <div class="write-zone">
                	<!--标题以及分类选择-->
                    <div class="log-title fn-clear maginbom">
                    	<div class="fn-left title-name"><input type="text" value="<%=log_title%>" name="log_title" placeholder="日志标题" /></div>
                        <div class="fn-right category-name tpl-button-green"><a href="javascript:;" class="fn-wordWrap click-cate">选择分类</a></div>
                    </div>
                    
                    <!--分类选择-->
                    <div class="log-cate maginbom">
                    	<input type="hidden" value="<%=log_category%>" name="log_category" />
                        <input type="hidden" value="<%=log_category%>" name="log_oldCategory" />
                        <ul class="first-bar">
                        	<%
								dbo.trave({
									conn: config.conn,
									sql: "Select * From blog_category Where cate_root=0 And cate_outlink=False Order By cate_order Asc",
									callback: function(rs){
										if ( rs.Bof || rs.Eof ){}else{
											this.each(function(){
							%>
                        	<li class="first-bar-items">
                            	<div class="first-bar-items-area fn-clear items-bar<%=((log_category + "") === (this("id").value + "") ? " choose-current" : "")%>">
                                    <div class="first-bar-items-name fn-left fn-wordWrap"><%=this("cate_name").value%></div>
                                    <div class="first-bar-items-info fn-left fn-wordWrap"><%=this("cate_info").value%></div>
                                    <div class="first-bar-items-action fn-left"><a href="javascript:;" class="choose-cate" data-id="<%=this("id").value%>">选定</a></div>
                                </div>
                                <ul class="second-bar">
                                	<%getSecondDatas(rs("id").value)%>
                                </ul>
                            </li>
                            <%
											});
										}
									}
								});
							%>
                        </ul>
                    </div>
                    
                    <!--内容书写-->
                    <div class="log-content maginbom">
                        <!--<div class="fn-clear head"><div class="tip-title fn-left">内容区域</div><div class="fn-right tags"><input type="text" value="<%=log_tags%>" name="log_tags" placeholder="标签..."></div></div>-->
                        <textarea style="height:550px;" name="log_content"><%=log_content%></textarea>
                    </div>
               		<div class="tools-configure fn-clear">
                    	<div class="fn-left tools-configure-left">
                            <div class="sidepannel maginbom">
                                <div class="leader-box">
                                    <div class="heads fn-clear">
                                        <div class="main-point fn-left">文章标签设置</div>
                                        <div class="other-point fn-left"><a href="javascript:;">从库中选取标签</a></div>
                                    </div>
                                    <div class="bodys">
                                        <div class="infos">标签填写以英文逗号或者空格分隔</div>
                                        <input type="text" value="<%=log_tags%>" name="log_tags" placeholder="标签..." style="width:370px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="fn-right tools-configure-right">
                            <div class="sidepannel maginbom log-coverside">
                                <div class="leader-box">
                                    <div class="heads fn-clear">
                                        <div class="main-point fn-left">日志封面</div>
                                        <div class="other-point fn-left"></div>
                                    </div>
                                    <div class="bodys fn-clear">
                                    	<input type="hidden" value="<%=log_cover%>" name="log_cover" />
                                        <div class="fn-left imgs"><img src="<%=log_cover%>" id="cover-img" /></div>
                                        <div class="fn-left actions"><input type="file" id="upload" /></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="log-actions"><input type="button" value="提交" class="tpl-button-blue log-submit" id="submit" /></div>
                </div>
            </form>
        </div>
    </div>
</div>
<%
	}else{
%>
	<div class="tpl-space fn-clear" style="padding:60px 80px;">打开数据库失败</div>
<%	
	}
%>