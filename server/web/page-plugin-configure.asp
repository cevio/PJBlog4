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
<div class="tpl-space fn-clear">
    <div class="pconfig-zone">
    	<h3><span class="iconfont">&#367;</span> 插件高级应用 - <%=pname%></h3>
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
                console.log('<div style="padding:30px;">插件已被停用</div>');
            }
            %>
    </div>
</div>
<%
		}else{
			console.log('<div class="tpl-space fn-clear"><div class="plugin-zone">错误的插件ID</div></div>');
		}
	}else{
		console.log('<div class="tpl-space fn-clear"><div class="plugin-zone">数据库连接失败</div></div>');
	}
%>