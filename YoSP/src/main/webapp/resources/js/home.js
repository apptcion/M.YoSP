/**
 * 
 */
    
   
    $(document).ready(function(){
		
    	
    	var isIng = false;
    	
		 $('#f').click(function() {
			 PageUp();
		 })
		 
    	
    	
			
		var Scenes;
		var SceneNumber;
		var ScenesIndex = 1;
		
		Scenes = $("#ScenesList");
		///////////////////////////로그인 전용///////////////////////////////////////////
		//TODO
		
		
		/////////////////////////////////////////////////////////////////////////////
		function PageUp(){  // 아래에 있는 페이지가 위로 올라감
			if(ScenesIndex != 5){
			Scenes.animate({
				top : '-=100vh'
			},500);
			$("#head").css("background" , "white");
			$("#menu a").css("color","black")
			ScenesIndex++;
            	if(jQuery('#Scene' + ScenesIndex + '>div').attr("class").includes('steps')){
           			setTimeout(function(){
           			    $('#Scene' + ScenesIndex + '>div>fieldset>legend>h1').addClass('animate__fadeInUp');
           			 },200);
           	 		setTimeout(function(){
           	 		$('#Scene' + ScenesIndex + '>div>fieldset>p').addClass('animate__fadeInLeftBig');
           	 		},200);
            	}
       	 		$('#Scene' + (ScenesIndex-1) + '>div>fieldset>legend>h1').removeClass('animate__fadeInUp');
       	 		$('#Scene' + (ScenesIndex-1) + '>div>fieldset>legend>h1').removeClass('animate__fadeInDown');
       			$('#Scene' + (ScenesIndex-1) + '>div>fieldset>p').removeClass('animate__fadeInLeftBig');
			}if(ScenesIndex == 5){
				$('#T').addClass('fade-in-box');
				setTimeout(function() {
					$('#R').addClass('fade-in-box');
				},350);
				
			}
		}
		function PageDown(){        /// 위에 있는 페이지가 아래로 내려감
			if(ScenesIndex != 1){
				Scenes.animate({
					top : '+=100vh'
				},500);
				ScenesIndex--;
				
            	if(jQuery('#Scene' + ScenesIndex + '>div').attr("class").includes('steps')){
           			setTimeout(function(){
           			    $('#Scene' + ScenesIndex + '>div>fieldset>legend>h1').addClass('animate__fadeInDown');
           			 },200);
           	 		setTimeout(function(){
           	 		$('#Scene' + ScenesIndex + '>div>fieldset>p').addClass('animate__fadeInLeftBig');
           	 		},200);
            	}
       	 		$('#Scene' + (ScenesIndex+1) + '>div>fieldset>legend>h1').removeClass('animate__fadeInUp');
       	 		$('#Scene' + (ScenesIndex+1) + '>div>fieldset>legend>h1').removeClass('animate__fadeInDown');
       			$('#Scene' + (ScenesIndex+1) + '>div>fieldset>p').removeClass('animate__fadeInLeftBig');
	            
				if(ScenesIndex == 1){ 
					$("#head").css("background" , "none");
					$("#menu a").css("color", "white");
				}
			}if(ScenesIndex == 4){
				$('#T').removeClass('fade-in-box');
				$('#R').removeClass('fade-in-box');
			}
		}
		
		 $(".SceneOutput").on('mousewheel',function(e){ 
		        var wheel = e.originalEvent.wheelDelta; 
		        if(!isIng){
		        	isIng = true;
			        if(wheel>0){ 
		            	  PageDown();
		      
		              } else {   
		                PageUp();
		              }
			        setTimeout(function(){
			        	isIng = false;
			        },200);
		        }	      
		         
		            });
		    function scroll_on() {
		        $('.Mainpage').on('scroll touchmove mousewheel', function(e) {
		            e.preventDefault();
		            e.stopPropagation();
		            return false;
		        });
		    }
		  
		    // 스크롤 제한 OFF
		    function scroll_off() {
		        $('.MainPage').off('scroll touchmove mousewheel');
		    }
		    

	})