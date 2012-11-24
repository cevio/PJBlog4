<%
define(function(require){
	var cacheMode = require.async("cacheHandle"),
		fso = require.async("FSO"),
		stream = require.async("STREAM");
		
	function cacheTemplateFile( context ){
		var percent = "%";
		return '<' + percent + '\ndefine(function(){ \n    return ' + context + ';\n});\n' + percent + '>';
	}
	
	if ( cacheMode === undefined ){
		console.push(selector(cacheHandle) + " 模块未知，请确认该模块是否存在或者符合规范。");
		return null;
	}else{
		return (function(dataList){
			var cache = function(key, value){
				if ( value === undefined ){
					if ( typeof key !== "string" ){ cache.set(key); }else{ return cache.get(key); }
				}else{
					cache.set(key, value);
				}
			}
			
			function object2array(object){
				var arr1 = [];
				for ( var i = 0 ; i < object.length ; i++ ){
					var arr2 = [];
					for ( var j = 0 ; j < object[i].length ; j++ ){
						var tmp_data = object[i][j];
						if ( typeof tmp_data === "date" ){
							tmp_data = (new Date( tmp_data )).getTime();
						}
						arr2.push(tmp_data);
					}
					arr1.push(arr2);
				}
				return arr1;
			}
			
			function createAppName(appKeyName, appKeyID){
				return config.cookie + "_" + appKeyName + (appKeyID === undefined ? "" : "_" + appKeyID);
			}
			
			function createAppFile(appKeyName, appKeyID){
				return createAppName(appKeyName, appKeyID) + ".asp";
			}
			
			function getFromApplication(appKeyName, appKeyID){
				var appCache = cache.get(createAppName(appKeyName, appKeyID));
				
				if ( appCache && appCache.length && (appCache.length >= 0) ){
					return object2array(appCache);
				}else{
					return null;
				}
			}
			
			function getFromFiles(appKeyName, appKeyID){
				var file = config.cacheAccess + "/" + createAppFile(appKeyName, appKeyID);
				if ( fso.exsit(file) ){
					var arr = require.async(file);
					return arr;
				}else{
					return null;
				}
			}
			
			function getFromDataBase(appSQL){
				try{
					var dbo = require.async("DBO"),
						connecte = require.async("openDataBase"),
						arr = [],
						sql,
						sqlfn;
						
					if ( typeof appSQL !== "string"){
						sql = appSQL.sql;
						sqlfn = appSQL.callback;
					}else{
						sql = appSQL;
					}
						
					if ( connecte === true ){
						dbo.trave({
							sql: sql,
							conn: config.conn,
							callback: function(rs){
								arr = object2array(this.getRows());
								if ( typeof sqlfn === "function" ){
									arr = sqlfn(arr);
								}
							}
						});
					}else{
						console.push("数据库打开失败");
					}
					
					return arr;
				}catch(e){
					return null;
				}
			}
			
			function setFile(dataArray, appKeyName, appKeyID){
				try{
					stream.save(cacheTemplateFile(JSON.stringify(dataArray)), config.cacheAccess + "/" + createAppFile(appKeyName, appKeyID));
					return true;
				}catch(e){
					return false;
				}
			}
			
			function setApplication(dataArray, appKeyName, appKeyID){
				try{
					cache.set(createAppName(appKeyName, appKeyID), dataArray);
					return true;
				}catch(e){
					return false;
				}
			}
			
			cache.set = function(key, value){
				Application.Lock();
				if ( typeof key === "object" ){
					for ( var items in key ){
						Application.StaticObjects(config.appName).Item(items) = key[items];
					}
				}else{
					Application.StaticObjects(config.appName).Item(key) = value;
				}
				Application.UnLock();
			}
			
			cache.get = function(key){
				return Application.StaticObjects(config.appName).Item(key);
			}
			
			cache.build = function(appKeyName, appKeyID){
				var datas = cacheMode[appKeyName];
				
				if ( datas === undefined ){
					console.push("cache[" + appKeyName + "] 不存在，请检查配置缓存文件。");
					return null;
				}else{
					var appMode = datas(appKeyID),
						dataCache = getFromDataBase(appMode);
						
					if ( setFile(dataCache, appKeyName, appKeyID) ){
						if ( setApplication(dataCache, appKeyName, appKeyID) ){
							return dataCache;
						}else{
							return null;
						}
					}else{
						console.push("cache.save[" + createAppFile(appKeyName, appKeyID) + "] error.");
						return null;
					}
				}
			}
			
			cache.load = function(appKeyName, appKeyID){
				var datas = cacheMode[appKeyName];
				if ( datas === undefined ){
					console.push("cache[" + appKeyName + "] 不存在，请检查配置缓存文件。");
					return null;
				}else{
					var appMode = datas(appKeyID),
						appCache = getFromApplication(appKeyName, appKeyID);
						
					if ( appCache === null ){
						var fileCache = getFromFiles(appKeyName, appKeyID);
						if ( fileCache === null ){
							var dataCache = getFromDataBase(appMode);
							if ( dataCache === null ){
								return null;
							}else{
								setFile(dataCache, appKeyName, appKeyID);
								setApplication(dataCache, appKeyName, appKeyID);
								console.push("cache[" + appKeyName + "] from database.");
								return dataCache;
							}
						}else{
							setApplication(fileCache, appKeyName, appKeyID);
							console.push("cache[" + appKeyName + "] from file.");
							return fileCache;	
						}	
					}else{
						console.push("cache[" + appKeyName + "] from app.");
						return appCache;
					}
				}
			}
			
			cache.destory = function(appKeyName, appKeyID){
				try{
					Application.Lock();
					Application.StaticObjects(config.appName).Remove(createAppName(appKeyName, appKeyID));
					Application.UnLock();
				}catch(e){}
				if ( fso.exsit(config.cacheAccess + "/" + createAppFile(appKeyName, appKeyID)) ){
					fso.destory(config.cacheAccess + "/" + createAppFile(appKeyName, appKeyID));
				}
			}

			return cache;
		})(cacheMode);
	}
});
%>