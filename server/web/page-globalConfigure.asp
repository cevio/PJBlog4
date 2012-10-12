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
				blog_global.seotitle = rs("seotitle").value;
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