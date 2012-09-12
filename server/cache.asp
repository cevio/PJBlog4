<%
define(function(require){
	var cacheMode = require.async("cacheHandle"),
		fso = require.async("FSO"),
		stream = require.async("STREAM");
	
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
						arr2.push(object[i][j]);
					}
					arr1.push(arr2);
				}
				return arr1;
			}
			
			function createAppName(appKeyName, appKeyID){
				return appKeyName + (appKeyID === undefined ? "" : "_" + appKeyID);
			}
			
			function createAppFile(appKeyName, appKeyID){
				return createAppName(appKeyName, appKeyID) + ".cce";
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
				var file = createAppFile(appKeyName, appKeyID);
				if ( fso.exsit(file) ){
					var arr = new Function("return " + stream.load(config.cacheAccess + "/" + file))();
					return arr;
				}else{
					return null;
				}
			}
			
			function getFromDataBase(appSQL){
				try{
					var dbo = require.async("DBO"),
						arr;
					
					dbo.trave({
						sql: appSQL,
						conn: config.conn,
						callback: function(rs){
							arr = object2array(this.getRows());
						}
					});
					
					return arr;
				}catch(e){
					return null;
				}
			}
			
			function setFile(dataArray, appKeyName, appKeyID){
				try{
					stream.save(JSON.stringify(dataArray), createAppFile(appKeyName, appKeyID));
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
					var appMode = datas[appKeyName](appKeyID),
						dataCache = getFromDataBase(appMode);
						
					if ( setFile(dataArray, appKeyName, appKeyID) ){
						if ( setApplication(dataArray, appKeyName, appKeyID) ){
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
					var appMode = datas[appKeyName](appKeyID),
						appCache = getFromApplication(appKeyName, appKeyID);
					if ( appCache === null ){
						var fileCache = getFromFiles(appKeyName, appKeyID);
						if ( fileCache === null ){
							var dataCache = getFromDataBase(appMode);
							if ( dataCache === null ){
								return [];
							}else{
								setFile(dataCache, appKeyName, appKeyID);
								setApplication(dataCache, appKeyName, appKeyID);
								return dataCache;
							}
						}else{
							setApplication(fileCache, appKeyName, appKeyID);
							return fileCache;	
						}	
					}else{
						return appCache;
					}
				}
			}

			return cache;
		})(cacheMode);
	}
});
%>