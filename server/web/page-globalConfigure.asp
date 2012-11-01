<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
	if ( connecte === true ){
		var blog_global = {};
		
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function(rs){
				blog_global.title = rs("title").value;
				blog_global.description = rs("description").value;
				blog_global.website = rs("website").value;
				blog_global.qq_appid = rs("qq_appid").value;
				blog_global.qq_appkey = rs("qq_appkey").value;
				blog_global.nickname = rs("nickname").value;
				blog_global.webstatus = rs("webstatus").value;
				blog_global.articleprivewlength = rs("articleprivewlength").value;
				blog_global.articleperpagecount = rs("articleperpagecount").value;
				blog_global.webdescription = rs("webdescription").value;
				blog_global.webkeywords = rs("webkeywords").value;
				blog_global.authoremail = rs("authoremail").value;
				blog_global.seotitle = rs("seotitle").value,
				blog_global.commentaduit = rs("commentaduit").value;
				blog_global.commentperpagecount = rs("commentperpagecount").value;
				blog_global.gravatarS = rs("gravatarS").value;
				blog_global.gravatarR = rs("gravatarR").value;
				blog_global.gravatarD = rs("gravatarD").value;
				blog_global.uploadimagetype = rs("uploadimagetype").value;
				blog_global.uploadlinktype = rs("uploadlinktype").value;
				blog_global.uploadswftype = rs("uploadswftype").value;
				blog_global.uploadmediatype = rs("uploadmediatype").value;
				blog_global.binarywhitelist = rs("binarywhitelist").value;
			}
		});
%>

<div class="tpl-space fn-clear">
	<div class="globalconfigure-zone">
    	<h3><span class="iconfont">&#367;</span> 全局设置</h3>
    <form action="server/configure.asp?j=normal" method="post" id="postSetForm">
        <fieldset>
        	<legend>基本设置</legend>
            <table>
            	<tr>
                	<td class="key">网站名称</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.title%>" name="title" class="long"></td>
                </tr>
                <tr>
                	<td class="key">网站描述</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.description%>" name="description" class="longer"></td>
                </tr>
                <tr>
                	<td class="key">SEO标题</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.seotitle%>" name="seotitle" class="long"><div class="info">调用于网站页面源码title标签内容</div></td>
                </tr>
                <tr>
                	<td class="key">SEO描述</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.webdescription%>" name="webdescription" class="longer"><div class="info">让SEO更友好，请认真填写此处。</div></td>
                </tr>
                <tr>
                	<td class="key">SEO关键字</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.webkeywords%>" name="webkeywords" class="longer"><div class="info">关键字影响收录。</div></td>
                </tr>
                <tr>
                	<td class="key">博主昵称</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.nickname%>" name="nickname" class="short"></td>
                </tr>
                <tr>
                	<td class="key">博主邮箱</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.authoremail%>" name="authoremail" class="long"></td>
                </tr>
                <tr>
                	<td class="key">网站地址</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.website%>" name="website" class="long"><div class="info">示例：http://pjhome.net http://pjhome.net/web 请不要在最后添加斜线，以保证系统对路径处理的统一性。</div></td>
                </tr>
                <tr>
                	<td class="key">网站状态</td>
                    <td class="keyvalue"><input type="radio" value="1" name="webstatus" <%=blog_global.webstatus === true ? "checked" : ""%> /> 开放 <input type="radio" value="0" name="webstatus" <%=blog_global.webstatus !== true ? "checked" : ""%> /> 关闭<div class="info">如果选择关闭，网站将无法访问。但是可以通过输入后台地址进行访问，来解除整站限制。<br /><span>选择需慎重。</span></div></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>QQ登入设置</legend>
            <p class="info">QQ登入需要博主自己在 <a href="http://connect.qq.com/manage/" target="_blank">QQ互联开放平台</a> 申请自己的OPENID和OPENKEY。在那里请先注册成为开发者，然后点击 添加网站/应用 。添加网站将为你生成这2个关键字符串，你只需要填写到下面即可。注意的是，网站需要验证，你可以通过对首页文件稍作修改，验证完毕后还原即可（具体看提示说明），而回调地址则根据说明填写，在这里你需要写入你的网站域名即可，如果是二级域名则填写二级域名。如有疑问，请移步至 <a href="http://bbs.pjhome.net" target="_blank">官方</a> 求助。</p>
            <table>
            	<tr>
                	<td class="key">QQ APP ID</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.qq_appid%>" name="qq_appid" class="long"></td>
                </tr>
                <tr>
                	<td class="key">QQ APP KEY</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.qq_appkey%>" name="qq_appkey" class="longer"></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>日志模块设置</legend>
            <table>
            	<tr>
                	<td class="key">日志预览长度</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.articleprivewlength%>" name="articleprivewlength" class="shorter"></td>
                </tr>
                <tr>
                	<td class="key">每页日志数量</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.articleperpagecount%>" name="articleperpagecount" class="shorter"></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>评论模块设置</legend>
            <table>
            	<tr>
                	<td class="key">需要审核?</td>
                    <td class="keyvalue"><input type="checkbox" value="1" name="commentaduit" <%=blog_global.commentaduit === true ? 'checked="checked"' : ''%>> <span class="info">开启评论审核功能？</span></td>
                </tr>
                <tr>
                	<td class="key">评论每页条数</td>
                    <td class="keyvalue"><input type="text" name="commentperpagecount" value="<%=blog_global.commentperpagecount%>" class="shorter" /></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>全球通用头像设置</legend>
            <table>
            	<tr>
                	<td class="key">头像尺寸</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.gravatarS%>" name="gravatarS" class="shorter"> <span class="info">请填写数字。这里是你头像的大小，他的规格在80-512之间。</span></td>
                </tr>
                <tr>
                	<td class="key">头像限制等级</td>
                    <td class="keyvalue"><input type="text" name="gravatarR" value="<%=blog_global.gravatarR%>" class="short" /> <div class="info">
                    	1. G: 使用所有网站。<br />
                        2. PG: 适用于含 ”粗鲁，挑逗，小暴力“的网站。<br />
                        3. R: 适用于”强暴力，裸露，毒品“等的网站。<br />
                        4. X: 适用于”性交，超强暴力“的网站。
                    </div></td>
                </tr>
                <tr>
                	<td class="key">头像容错地址</td>
                    <td class="keyvalue"><input type="text" name="gravatarD" value="<%=blog_global.gravatarD%>" class="long" /><div class="info">如果该邮箱未注册GRA头像，那么将使用这里的头像地址作为头像。</div></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>上传设置</legend>
            <table>
            	<tr>
                	<td class="key">图片类型</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.uploadimagetype%>" name="uploadimagetype" class="long"></td>
                </tr>
                <tr>
                	<td class="key">附件类型</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.uploadlinktype%>" name="uploadlinktype" class="long"></td>
                </tr>
                <tr>
                	<td class="key">FLASH类型</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.uploadswftype%>" name="uploadswftype" class="long"></td>
                </tr>
                <tr>
                	<td class="key">多媒体类型</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.uploadmediatype%>" name="uploadmediatype" class="long"></td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>安全设置</legend>
            <table>
            	<tr>
                	<td class="key">附件防盗链白名单</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.binarywhitelist%>" name="binarywhitelist" class="longer"></td>
                </tr>
            </table>
        </fieldset>
        
        <div class="submit-area">
        	<input type="submit" value="保存设置" class="tpl-button-blue" />
        </div>
    </form>
    </div>
</div>
<%
	}else{
		console.log("数据库连接失败。");
	}
%>