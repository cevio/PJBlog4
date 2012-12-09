/* Js Document */
$(".action-aduit").click(function(){
	var data_id=$(this).attr("data-id");
	if (data_id)
	{
		$.getJSON(foler+"/system.asp",{"j":"aduit","id":data_id},function(result){
			if (result.success==true)
			{
				window.location.reload()();
			}
			else{
				alert("设置出错");
			}
		});
	}
});
$(".action-del").click(function(){
	var data_id=$(this).attr("data-id");
	if(data_id&&window.confirm("确实要删除吗？")){
		$.getJSON(foler+"/system.asp",{"j":"del","id":data_id},function(result){
			if (result.success==true)
			{
				window.location.reload()();
			}
			else{
				alert("删除失败");
			}
		});
    }
});
