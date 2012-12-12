<%
define(function( require, exports, module ){

	var recordSetCoretions = function( object ){
		this.object = object;
	}

	function getRows( arr, fieldslen ){
		var len = arr.length / fieldslen, data=[], sp; 
		
		for( var i = 0; i < len ; i++ ) { 
			data[i] = new Array(); 
			sp = i * fieldslen; 
			for( var j = 0 ; j < fieldslen ; j++ ) { data[i][j] = arr[sp + j] ; } 
		}
		
		return data; 
	}

	recordSetCoretions.prototype.each = function(callback){
		var i = 0;
		this.object.MoveFirst();
				
		while ( !this.object.Eof )
		{
			callback.call(this.object, i);
			this.object.MoveNext();
			++i;
		}
	}

	recordSetCoretions.prototype.getRows = function(){
		var tempArr = [];
				
		try{ 
			tempArr = this.object.GetRows().toArray(); 
		}catch(e){}
		
		return getRows( tempArr, this.object.Fields.Count );
	}

	recordSetCoretions.prototype.serverPage = function(absolutePage, pageSize, callback){
		var _Core = this.object, 
			i = 0;
				
		var RsCount = _Core.RecordCount;
		if ( pageSize > RsCount ) pageSize = RsCount;
		
		var PageCount = Math.ceil( RsCount / pageSize );
		if ( PageCount < 0 ) PageCount = 0;
		if ( absolutePage > PageCount ) absolutePage = PageCount;
		if ( absolutePage < 1 ) absolutePage = 1;
		
		_Core.PageSize = pageSize;
		_Core.AbsolutePage = absolutePage;
		
		if ( typeof callback === "function" ){
			while ( !_Core.Eof &&  i < pageSize )
			{
				var t = callback.call(_Core, i);

				if ( t === undefined ){
					t = true;
				}

				if ( t === false ){
					break;
				}else{
					i++;
					_Core.MoveNext();
				}
			}
		}
		
		return [RsCount, pageSize, absolutePage, PageCount];
	}

	// 添加数据
	// 数据结构 data{json}(true) table{string}(true) conn{object}(true) rs{object}(false) callback
	exports.add = function( options ){

		if ( options === undefined ){ options = {} };
		if ( options.rs === undefined ){ options.rs = this.createRecordSet(); }

		try{
			options.rs.Open( "Select * From " + options.table, options.conn, 3, 2 );
			options.rs.AddNew();
			(typeof options.callback === "function") && options.callback.call(options.rs);
			for ( var items in options.data ){
				console.push(items + ": " + options.data[items]);
				options.rs(items) = options.data[items];
			}
			options.rs.Update();
			options.rs.Close();
		}catch(e){
			console.push(e.message);
		}

		return this;

	}
	
	// 更新数据
	// 数据结构 data{json}(true) table{string}(true) key{string}(true) keyValue(string)(true) conn{object}(true) rs{object}(false)
	exports.update = function( options ){
		if ( options === undefined ){ options = {} };
		if ( options.rs === undefined ){ options.rs = this.createRecordSet(); }

			options.rs.Open("Select * From " + options.table + " Where " + options.key + "=" + options.keyValue, options.conn, 3, 3);
			for ( var items in options.data ){
				options.rs(items) = options.data[items];
			}
			options.rs.Update();
			(typeof options.callback === "function") && options.callback.call(options.rs);
			options.rs.Close();

		return this;
	}
	
	// 删除数据
	// 数据结构 data{json}(true) table{string}(true) conn{object}(true) rs{object}(false)
	exports.destory = function( options ){
		if ( options === undefined ){ options = {} };
		if ( options.rs === undefined ){ options.rs = this.createRecordSet(); }
		
		try{
			for ( var items in options.data ){
				options.rs.Open("Select * From " + options.table + " Where " + items + "=" + options.data[items], options.conn, 3, 3);
				options.rs.Delete();
				options.Close();
			}
		}catch(e){
			console.push(e.message);
		}

		return this;
	}

	// 删除数据
	// 数据结构 type{number}(false) sql{string}(true) conn{object}(true) rs{object}(false) callback{function}(false)
	exports.trave = function( options ){
		if ( options === undefined ){ options = {} };
		if ( options.rs === undefined ){ options.rs = this.createRecordSet(); }
		if ( options.type === undefined ){ options.type = 1; }

		var ret;

		try{
			if ( options.callback === undefined ){
				ret = options.conn.Execute(options.sql);
			}else{
				options.rs.Open(options.sql, options.conn, 3, options.type);
				ret = options.callback.call(new recordSetCoretions(options.rs), options.rs, options.conn);
				options.rs.Close();
			}
		}catch(e){
			console.push(e.message);
		}

		return ret;
	}

	exports.createRecordSet = function(){
		return new ActiveXObject(config.nameSpace.record);
	}
});
%>