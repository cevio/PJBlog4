<%
	var id = http.get("id") || "",
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		fns = require("fn"),
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
        <tr class="<%=((log_category + "") === (this("id").value + "") ? "choose-current" : "")%>" data-eq="2">
        	<td>2: </td>
            <td></td>
            <td><%=this("cate_name").value%></td>
            <td class="c"><a href="javascript:;" data-id="<%=this("id").value%>" class="choose-cate">选定</a></td>
        </tr>
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
	uploadmediatype = "<%=uploadmediatype%>",
	userid = <%=config.user.id%>,
	userhashkey = '<%=config.user.hashkey%>';
</script>

<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title"><%=( mode === "add" ? "新建日志" : "编辑日志" )%></div>
  <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context">
	<form action="<%=actionURL%>" method="post" style="margin:0; padding:0;">
        <input type="hidden" value="<%=id%>" name="id" />
        <input type="hidden" value="<%=log_category%>" name="log_category" />
        <input type="hidden" value="<%=log_category%>" name="log_oldCategory" />
        <input type="hidden" value="<%=log_cover%>" name="log_cover" />
        <textarea name="log_shortcontent" style="position:absolute; top:-99999px; left:-99999px;"></textarea>
        <div class="article fn-clear">
        	<div class="write-zone">
            	<div class="log-title"><input type="text" value="<%=log_title%>" name="log_title" placeholder="日志标题" /></div>
                <div class="log-content"><textarea name="log_content"><%=fns.HTMLStr(log_content)%></textarea></div>
            </div>
        </div>
     
        <ul class="fn-clear log-tools">
        	<li class="fn-left side-category">
            	<div class="content">
                	<div class="pannel ui-wrapshadow">
                    	<div class="title fn-clear">
                        	<span class="fn-left">选择分类</span>
                        </div>
                        <div class="zone">
                        	<table cellpadding="0" cellspacing="0" width="100%">
                        	<%
								dbo.trave({
									conn: config.conn,
									sql: "Select * From blog_category Where cate_root=0 And cate_outlink=False Order By cate_order Asc",
									callback: function(rs){
										if ( rs.Bof || rs.Eof ){}else{
											this.each(function(){
							%>
                            	<tr class="<%=((log_category + "") === (this("id").value + "") ? "choose-current" : "")%>" data-eq="1">
                                	<td>1: </td>
                                	<td><%=this("cate_name").value%></td>
                                    <td></td>
                                    <td width="60" class="c"><a href="javascript:;" data-id="<%=this("id").value%>" class="choose-cate">选定</a></td>
                                </tr>
                                <%getSecondDatas(rs("id").value)%>
                            <%
											});
										}
									}
								});
							%>
                            </table>
                        </div>
                    </div>
                </div>
            </li>
            <li class="fn-right side-cover">
            	<div class="content">
                	<div class="pannel ui-wrapshadow">
                    	<div class="title fn-clear">
                        	<span class="fn-left">封面图片</span>
                        </div>
                        <div class="zone fn-clear">
                        	<div class="fn-left imgs ui-wrapshadow"><img src="<%=log_cover%>" id="cover-img" /></div>
                           	<div class="fn-left actions"><div class="ins">从服务器上选取已经存在的图片作为封面</div><input type="file" id="upload" /></div>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
        
        <ul class="fn-clear log-tools">
        	<li class="fn-left side-tags">
            	<div class="content">
                	<div class="pannel ui-wrapshadow">
                    	<div class="title fn-clear">
                        	<span class="fn-left">标签设置</span>
                        </div>
                        <div class="zone">
                        	<div class="ins">标签填写以英文逗号或者空格分隔</div>
                        	<input type="text" value="<%=log_tags%>" name="log_tags" placeholder="标签..." style="width:370px;">
                        </div>
                    </div>
                </div>
            </li>
        </ul>
        
        <%
			var sap = require("sap"),
				proxys = sap.getPorts("response.article.write.plugin");
			
			sap.exec(proxys, {
				callback: function( dataparams ){
					if ( typeof dataparams === "function" ){
						console.log(dataparams());
					}else{
						console.log(dataparams);
					}
				}
			});
		%>
        
        <div class="submit"><input type="button" value="提交" class="button" id="submit" /></div>
    </form>
</div>
<%
	}else{
		console.log("连接数据库失败");
	}
%>