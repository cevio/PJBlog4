<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
	if ( connecte === true ){
		var id = http.get("id"),
			pname,
			pfolder,
			pmark,
			pstatus;
			
		if ( id.length > 0 ){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_plugin Where id=" + id,
				callback: function(rs){
					pname = rs("pluginname").value;
					pmark = rs("pluginmark").value;
					pfolder = rs("pluginfolder").value;
					pstatus = rs("pluginstatus").value;
				}
			});
%>
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">插高级应用中心 - <%=pname%></div>
  <div class="fn-right ui-position-tools">
  	<a href="?p=plugin">已安装插件</a> 
    <a href="?p=plugin&t=list">未安装插件</a> 
    <a href="?p=plugin&t=online">在线插件</a>
  </div>
</div>
<div class="ui-context">
			<%
            if ( pstatus ){
                config.plugin = {};
                config.plugin.mark = pmark;
                config.plugin.folder = "profile/plugins/" + pfolder;
                config.plugin.id = Number(id);
                config.plugin.setting = {};
                
                dbo.trave({
                    conn: config.conn,
                    sql: "Select * From blog_moden Where modemark=" + id,
                    callback: function(rs){
                        if ( !(rs.Bof || rs.Eof) ){
                            this.each(function(){
                                config.plugin.setting[this("modekey").value] = this("modevalue").value;
                            });
                        }
                    }
                });
%>
<script language="javascript">
	config.plugin = {
		folder: '<%=config.plugin.folder%>'
	};
</script>
<%
                include(config.plugin.folder + "/configure.asp");
            }else{
                console.log("插件已被停用");
            }
            %>
</div>
<%
		}else{
			console.log("错误的插件ID");
		}
	}else{
		console.log("数据库连接失败");
	}
%>