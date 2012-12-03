// JavaScript Document
define(['assets/js/lib/syntaxhighlighter/scripts/shCore', 'assets/js/lib/syntaxhighlighter/styles/shCoreDefault.css'], function(){
	$(function(){
		var text = [
			'applescript			@shBrushAppleScript.js',
			'actionscript3 as3		@shBrushAS3.js',
			'bash shell				@shBrushBash.js',
			'coldfusion cf			@shBrushColdFusion.js',
			'cpp c					@shBrushCpp.js',
			'c# c-sharp csharp		@shBrushCSharp.js',
			'css					@shBrushCss.js',
			'delphi pascal			@shBrushDelphi.js',
			'diff patch pas			@shBrushDiff.js',
			'erl erlang				@shBrushErlang.js',
			'groovy					@shBrushGroovy.js',
			'java					@shBrushJava.js',
			'jfx javafx				@shBrushJavaFX.js',
			'js jscript javascript	@shBrushJScript.js',
			'perl pl				@shBrushPerl.js',
			'php					@shBrushPhp.js',
			'text plain				@shBrushPlain.js',
			'py python				@shBrushPython.js',
			'ruby rails ror rb		@shBrushRuby.js',
			'sass scss				@shBrushSass.js',
			'scala					@shBrushScala.js',
			'sql					@shBrushSql.js',
			'vb vbnet				@shBrushVb.js',
			'xml xhtml xslt html	@shBrushXml.js'
		], 
		trees = {},
		clsArr = [];
		
		for ( var i = 0 ; i < text.length ; i++ ){
			var p = text[i].split("@"),
				a = p[0],
				b = p[1];
				
			a = a.replace(/^\s+/, "").replace(/\s+$/, "");
			
			var c = a.split(" ");
			
			for ( var j = 0 ; j < c.length ; j++ ){
				trees[c[j]] = b;
			}
		}
		
		$("[data-type='syntax']").each(function(){
			var cls = $(this).attr("class"),
				cle = /brush\:\s([^\;]+)/.exec(cls);
				
			if ( cle && cle[1] ){
				if ( trees[cle[1]] !== undefined ){
					clsArr.push("assets/js/lib/syntaxhighlighter/scripts/" +  trees[cle[1]]);
				}
			}
		});
		
		if ( clsArr.length > 0 ){
			require.async(clsArr, function(){
				//SyntaxHighlighter.all();
				console.log("ok2");
			});
		}else{
			//SyntaxHighlighter.all();
			console.log("ok1");
		}
	});
});