 $(document).ready(function(){
	$("html,body").on('mousewheel',function(e){ 
	        var wheel = e.originalEvent.wheelDelta; 
	         if(wheel < 0){
	 			$("#head").css("box-shadow","0px 1px 20px");
	         }else{
	        	 var scrollTop = $(window).scrollTop();
	        	 if(scrollTop < 400){
	        		 $("#head").css("box-shadow","");
	        	 }
	         }
	});

})