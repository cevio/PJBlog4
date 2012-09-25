<%
	var mode = http.get("mode");
%>
<div class="tpl-space fn-clear">
	<div class="article-zone">
    	<div class="write-area">
        	<form action="" method="post" style="margin:0; padding:0;">
                <h3><span class="iconfont">&#367;</span> <%console.log( mode === "add" ? "新建日志" : "编辑日志" )%></h3>
                <div class="write-zone">
                    <div class="log-title maginbom"><input type="text" value="" name="log_title" placeholder="日志标题" /></div>
                    <div class="log-cate maginbom fn-clear">
                        <input type="hidden" value="3" name="log_category" />
                        <div class="fn-left log-cate-title">
                            <span class="import">分类</span>
                            <span class="gray">选择本文所属的分类，允许只能选择一个分类作为所述分类。</span>
                        </div>
                        <div class="fn-left log-cate-content">
                            <ul>
                                <li class="fn-clear">
                                    <div class="cate-one"><span class="fn-wordWrap cate-name" data-id="1">ASP技术</span></div>
                                    <div class="cate-two fn-clear">
                                        <ul>
                                            <li><span class="fn-wordWrap cate-name" data-id="2">模板化</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="3">基础教程</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="4">框架架构</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="5">企业网站</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="6">平台开发</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="7">腾讯接口扩展</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="8">远程访问</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="9">Com组件开发</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="10">VBScript语法</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="11">JScript语法</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="12">ASP趋势</span></li>
                                            <li><span class="fn-wordWrap cate-name" data-id="13">Obay框架</span></li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="fn-clear">
                                    <div class="cate-one"><span class="fn-wordWrap cate-name">Javascript技术</span></div>
                                    <div class="cate-two fn-clear">
                                        <ul>
                                            <li><span class="fn-wordWrap cate-name">sizzle框架</span></li>
                                            <li><span class="fn-wordWrap cate-name">seajs框架</span></li>
                                            <li><span class="fn-wordWrap cate-name">kissy框架</span></li>
                                            <li><span class="fn-wordWrap cate-name">jQuery框架</span></li>
                                            <li><span class="fn-wordWrap cate-name">ext框架</span></li>
                                            <li><span class="fn-wordWrap cate-name">prototype框架</span></li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="fn-clear">
                                    <div class="cate-one"><span class="fn-wordWrap cate-name">Css技术</span></div>
                                    <div class="cate-two fn-clear">
                                        <ul>
                                            <li><span class="fn-wordWrap cate-name">双飞翼</span></li>
                                            <li><span class="fn-wordWrap cate-name">kissyui</span></li>
                                            <li><span class="fn-wordWrap cate-name">etao iconfont</span></li>
                                            <li><span class="fn-wordWrap cate-name">bootTrap</span></li>
                                            <li><span class="fn-wordWrap cate-name">loops css</span></li>
                                            <li><span class="fn-wordWrap cate-name">less 应用</span></li>
                                        </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="log-content maginbom">
                        <div class="fn-clear head"><div class="tip-title fn-left">内容区域</div><div class="fn-right tags"><input type="text" value="" name="log_tags" placeholder="标签..."></div></div>
                        <textarea style="height:350px;"></textarea>
                    </div>
                    <div class="log-actions"><input type="submit" value="提交" class="tpl-button-blue log-submit" /></div>
                </div>
            </form>
        </div>
    </div>
</div>