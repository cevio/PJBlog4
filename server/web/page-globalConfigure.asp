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
                	<td class="key">博主昵称</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.nickname%>" name="nickname" class="short"></td>
                </tr>
                <tr>
                	<td class="key">网站地址</td>
                    <td class="keyvalue"><input type="text" value="<%=blog_global.website%>" name="website" class="long"></td>
                </tr>
                <tr>
                	<td class="key">网站状态</td>
                    <td class="keyvalue"><input type="radio" value="1" name="webstatus" <%=blog_global.webstatus === true ? "checked" : ""%> /> 开放 <input type="radio" value="0" name="webstatus" <%=blog_global.webstatus !== true ? "checked" : ""%> /> 关闭</td>
                </tr>
            </table>
        </fieldset>
        
        <fieldset>
        	<legend>QQ登入设置</legend>
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