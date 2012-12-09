<%
define(function(){
});
%>
<div class="ui-table ui-table-custom">
<table cellspacing="0" class="table">
<!-- cellspacing='0' is important, must stay -->
<tbody>
	<tr>
		<th width="40">编号</th>
		<th width="100">网站名</th>
		<th width="180">简介</th>
		<th width="230">网址</th>
		<th width="160">LOGO</th>
		<th width="40">审核</th>
		<th width="40">管理</th>
	</tr>
	<!-- Table Header -->
<%
var dbo = require("DBO"),
	connecte = require("openDataBase"),
	__date = require("DATE"),
	_page = http.get("page"),
	_p = http.get("p"),
	_id = http.get("id"),
	_top=config.plugin.setting.top?Number(config.plugin.setting.top)||10:10,
	_date=config.plugin.setting.date?config.plugin.setting.date||"y-m-d h:i:s":"y-m-d h:i:s",
	pageInfo = [];
	if (_page.length === 0)
	{
		_page = 1;
	}
	else{
		_page = Number(_page);
	}
	if ( _page < 1 ){
		_page = 1;
	}
	if ( connecte === true ){
		var categoryBeyondArray = {};
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_link Order By id DESC",
			callback: function(rs){
				if ( !(rs.Bof || rs.Eof) ){
					pageInfo = this.serverPage(_page, _top, function(i){
						var even = "";
						if ( (i + 1) % 2 === 0 ){
							even = ' class="even"';
						}
%>
	<tr<%=even%>>
		<td><%=this("id").value%></td>
		<td><%=this("linkname").value%></td>
		<td><%=this("linkinfo").value%></td>
		<td><a href='<%=this("linkurl").value%>' target='_blank'><%=this("linkurl").value%></a></td>
		<td><%if (this("linkurl").value!="")
		{
			console.log('<img src="'+this("linkimage").value+'"/>');
		}%></td>
		<td><a href="javascript:;" data-id="<%=this("id").value%>" class="action-aduit"><%if (this("linkaduit").value === true){%><span style="color:#0000FF">√</span><%}else{%><span style="color:#FF0000">×</span><%}%></a></td>
		<td><a href="javascript:;" data-id="<%=this("id").value%>" class="action-del">删除</a></td>
	</tr>
<%	
					});
				}else{
%>
	<tr><td colspan="7">亲,还没有博主申请友情链接哦。</td></tr>
<%
				}
			}
		});
	}else{
%>
	<tr><td colspan="7">数据库连接失败，请检查数据库连接配置文件。</td></tr>
<%		
	}
%>
</tbody>
</table>
</div>
<%
	if ( pageInfo.length > 0 ){
		if ( pageInfo[3] > 1 ){
			console.log('<div class="pagebar fn-clear"><span class="fn-left join"></span>');
			var fns = require.async("fn"),
				pages = fns.pageAnalyze(pageInfo[2], pageInfo[3], 9);
				
			fns.pageOut(pages, function(i, isCurrent){
				if ( isCurrent === true ){
					console.log('<span class="fn-left pages">' + i + '</span>');
				}else{
					console.log('<a href="?p=article&page=' + i + '&c=' + _cate + '" class="fn-left pages">' + i + '</a>');
				}
			});
			console.log('</div>');
		}
	}
%>
<%
//});
//console.log(JSON.stringify(config.plugin));
%>
<script type="text/javascript">
var foler = '<%=config.plugin.folder%>';
</script>
<link rel="stylesheet" href="<%=config.plugin.folder%>/system.css" type="text/css" />
