<%
var dbo = require("DBO"),
	connecte = require("openDataBase"),
	_page = http.get("page"),
	_cate = http.get("c"),
	_sql,
	cate
	pageInfo = [];
	
	if ( connecte === true ){
	
	var categoryBeyondArray = {};
        
	dbo.trave({
		conn: config.conn,
		sql: "Select * From blog_category",
		callback: function(){
			this.each(function(){
				categoryBeyondArray[this("id").value + ""] = {
					id: this("id").value,
					name: this("cate_name").value,
					out: this("cate_outlink").value
				}
			});
		}
	});
%>
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">日志列表</div>
  <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context">

	<%
		if ( categoryBeyondArray !== {} ){
	%>
    <ul class="categoryList fn-clear">
    	<li class="fn-left ui-wrapshadow"><a href="?p=article">全部</a></li>
    	<%
			for ( var cateItem in categoryBeyondArray ){
				if ( !categoryBeyondArray[cateItem].out ){
		%>
        	<li class="fn-left ui-wrapshadow"><a href="?p=article&c=<%=categoryBeyondArray[cateItem].id%>"><%=categoryBeyondArray[cateItem].name%></a></li>
        <%
				}
			}
		%>
    </ul>
    <%
		}
	%>

	<div class="ui-table ui-table-custom">
	<table cellspacing="0" class="table">
        <!-- cellspacing='0' is important, must stay -->
        <tbody>
            <tr>
                <th>标题</th>
                <th width="150">分类</th>
                <th width="100">&nbsp;</th>
            </tr>
            <!-- Table Header -->
 <%	
    if ( _page.length === 0 ){
        _page = 1;
    }else{
        _page = Number(_page);
    }
    
    if ( _page < 1 ){
        _page === 1;
    }
	
	if ( _cate.length === 0 ){ cate = 0; }
	_cate = Number(_cate);
	
	if ( _cate > 0 ){
		if ( config.user.id > 0 ){
			_sql = "Select * From blog_article Where log_category=" + _cate + " And log_uid=" + config.user.id + " Order By log_posttime DESC";
		}else{
			_sql = "Select * From blog_article Where log_category=" + _cate + " Order By log_posttime DESC";
		}
	}else{
		if ( config.user.id > 0 ){
			_sql = "Select * From blog_article Where log_uid=" + config.user.id + " Order By log_posttime DESC";
		}else{
			_sql = "Select * From blog_article Order By log_posttime DESC";
		}
	}
        
    
        dbo.trave({
            conn: config.conn,
            sql: _sql,
            callback: function(rs){
                if ( !(rs.Bof || rs.Eof) ){
                    pageInfo = this.serverPage(_page, 10, function(i){
                        var even = "";
                        if ( (i + 1) % 2 === 0 ){
                            even = ' class="even"';
                        }
						var categorys = categoryBeyondArray[this("log_category").value + ""];
%>
                <tr<%=even%>>
                    <td><a href="article.asp?id=<%=this("id").value%>" target="_blank"><%=this("log_title").value%></a></td>
                    <td><a href="?p=article&c=<%=categorys.id%>"><%=categorys.name%></a></td>
                    <td class="action"><%if ( this("log_istop").value === true ){%><a href="javascript:;" data-id="<%=this("id").value%>" class="action-untop">取消</a><%}else{%><a href="javascript:;" data-id="<%=this("id").value%>" class="action-top">置顶</a><%}%><a href="?p=writeArticle&id=<%=this("id").value%>">编辑</a><a href="javascript:;" data-id="<%=this("id").value%>" class="action-del">删除</a></td>
                </tr>
<%	
                    });
                }else{
%>
            <tr><td colspan="3">没有数据，请 <a href="?p=writeArticle">添加</a> 。</td></tr>
<%
                }
            }
        });
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
	}else{
		console.log("连接数据库失败");
	}
	 %>
</div>
