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
				blog_global.canregister = rs("canregister").value;
				blog_global.commentvaildor = rs("commentvaildor").value;
				blog_global.commentdelaytimer = rs("commentdelaytimer").value;
				blog_global.commentmaxlength = rs("commentmaxlength").value;
			}
		});
%>

<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">全局设置</div>
  <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context">
  <form action="server/configure.asp?j=normal" method="post" id="postSetForm">
    <div class="fn-clear configure-list">
      <div class="fn-right con-name ui-wrapshadow">基本设置</div>
      <div class="configs ui-wrapshadow ui-table ui-table-custom">
        <table cellpadding="0" cellspacing="0">
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
            <td class="keyvalue"><input type="text" value="<%=blog_global.seotitle%>" name="seotitle" class="long">
              <div class="info">调用于网站页面源码title标签内容</div></td>
          </tr>
          <tr>
            <td class="key">SEO描述</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.webdescription%>" name="webdescription" class="longer">
              <div class="info">让SEO更友好，请认真填写此处。</div></td>
          </tr>
          <tr>
            <td class="key">SEO关键字</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.webkeywords%>" name="webkeywords" class="longer">
              <div class="info">关键字影响收录。</div></td>
          </tr>
          <tr>
            <td class="key">博主昵称</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.nickname%>" name="nickname" class="short"><div class="info">昵称修改后，后台登入的账号即为昵称账号。</div></td>
          </tr>
          <tr>
            <td class="key">博主邮箱</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.authoremail%>" name="authoremail" class="long"></td>
          </tr>
          <tr>
            <td class="key">网站地址</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.website%>" name="website" class="long">
              <div class="info">示例：http://pjhome.net http://pjhome.net/web 请不要在最后添加斜线，以保证系统对路径处理的统一性。</div></td>
          </tr>
          <tr>
            <td class="key">网站状态</td>
            <td class="keyvalue"><input type="radio" value="1" name="webstatus" <%=blog_global.webstatus === true ? "checked" : ""%> />
              开放
              <input type="radio" value="0" name="webstatus" <%=blog_global.webstatus !== true ? "checked" : ""%> />
              关闭
              <div class="info">如果选择关闭，网站将无法访问。但是可以通过输入后台地址进行访问，来解除整站限制。<br />
                <span>选择需慎重。</span></div></td>
          </tr>
        </table>
      </div>
    </div>
    <div class="fn-clear configure-list">
      <div class="fn-right con-name ui-wrapshadow">日志设置</div>
      <div class="configs ui-wrapshadow ui-table ui-table-custom">
        <table>
          <tr>
            <td class="key" width="100">日志预览长度</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.articleprivewlength%>" name="articleprivewlength" class="shorter"> 个字符</td>
          </tr>
          <tr>
            <td class="key">每页日志数量</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.articleperpagecount%>" name="articleperpagecount" class="shorter">  篇</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="fn-clear configure-list">
       <div class="fn-right con-name ui-wrapshadow">评论设置</div>
       <div class="configs ui-wrapshadow ui-table ui-table-custom">
        <table>
          <tr>
            <td class="key" width="100">需要审核?</td>
            <td class="keyvalue"><input type="checkbox" value="1" name="commentaduit" <%=blog_global.commentaduit === true ? 'checked="checked"' : ''%>>
              <span class="info">开启评论审核功能？</span></td>
          </tr>
          <tr>
            <td class="key">评论每页条数</td>
            <td class="keyvalue"><input type="text" name="commentperpagecount" value="<%=blog_global.commentperpagecount%>" class="shorter" /></td>
          </tr>
          <tr>
            <td class="key" width="100">评论验证码？</td>
            <td class="keyvalue"><input type="checkbox" value="1" name="commentvaildor" <%=blog_global.commentvaildor === true ? 'checked="checked"' : ''%>>
              <span class="info">主题模块中必须在评论发表区域包含验证码，系统自动检测验证码。</span></td>
          </tr>
          <tr>
            <td class="key" width="100">评论延迟时常</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.commentdelaytimer%>" name="commentdelaytimer" /> 秒 
              <span class="info">防止数据库死锁必要手段。</span></td>
          </tr>
          <tr>
            <td class="key" width="100">评论字数限制</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.commentmaxlength%>" name="commentmaxlength" /> 字</td>
          </tr>
        </table>
      </div>
    </div>
     <div class="fn-clear configure-list">
      <div class="fn-right con-name ui-wrapshadow">通用头像设置</div>
       <div class="configs ui-wrapshadow ui-table ui-table-custom">
        <table>
          <tr>
            <td class="key">头像尺寸</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.gravatarS%>" name="gravatarS" class="shorter">
              <span class="info">请填写数字。这里是你头像的大小，他的规格在80-512之间。</span></td>
          </tr>
          <tr>
            <td class="key">头像限制等级</td>
            <td class="keyvalue"><input type="text" name="gravatarR" value="<%=blog_global.gravatarR%>" class="short" />
              <div class="info"> 1. G: 使用所有网站。<br />
                2. PG: 适用于含 ”粗鲁，挑逗，小暴力“的网站。<br />
                3. R: 适用于”强暴力，裸露，毒品“等的网站。<br />
                4. X: 适用于”性交，超强暴力“的网站。 </div></td>
          </tr>
          <tr>
            <td class="key">头像容错地址</td>
            <td class="keyvalue"><input type="text" name="gravatarD" value="<%=blog_global.gravatarD%>" class="long" />
              <div class="info">如果该邮箱未注册GRA头像，那么将使用这里的头像地址作为头像。</div></td>
          </tr>
        </table>
      </div>
    </div>
    <div class="fn-clear configure-list">
      <div class="fn-right con-name ui-wrapshadow">附件上传设置</div>
       <div class="configs ui-wrapshadow ui-table ui-table-custom">
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
      </div>
    </div>
    <div class="fn-clear configure-list">
      <div class="fn-right con-name ui-wrapshadow">网站安全</div>
       <div class="configs ui-wrapshadow ui-table ui-table-custom">
        <table>
          <tr>
            <td class="key">开启本站注册</td>
            <td class="keyvalue"><input type="radio" value="1" name="canregister" <%=(blog_global.canregister === true ? "checked": "")%> />
              开放
              <input type="radio" value="0" name="canregister" <%=(blog_global.canregister === false ? "checked": "")%> />
              关闭 </td>
          </tr>
          <tr>
            <td class="key">附件防盗链白名单</td>
            <td class="keyvalue"><input type="text" value="<%=blog_global.binarywhitelist%>" name="binarywhitelist" class="longer"></td>
          </tr>
        </table>
      </div>
    </div>
    <%
		var sap = require("sap"),
			proxys = sap.getPorts("response.global.save.plugin");
		
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
    <div class="submit-area">
      <input type="submit" value="保存设置" class="button" />
    </div>
  </form>
</div>
<%
	}else{
		console.log("数据库连接失败。");
	}
%>
