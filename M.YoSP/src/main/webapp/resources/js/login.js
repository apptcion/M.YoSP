 		$(document).ready(function(){
 			var id = $("#id");
 			var pw = $("#password");
 			var name= $("#name");
 			
 			id.focus();
 			
			$(".login").on("click",function(){
				$.ajax({
					url : '/yosp/isPass',
					type : "POST",
					data : {
						id : id.val(),
						password : pw.val(),
					},
					success : function(e){
						if(e == "1"){ //통과
							location.href="/yosp/"
						
						}else if(e == "0"){ //아이디가 존재하지만 비밀번호가 다름
						
							pw.css("border-bottom","solid 1px red");
							$(".password").css("color","red");
							pw.focus();
							
						}else if(e== "-1"){ //아이디가 존재하지 않음
							
							id.css("border-bottom","solid 1px red");
							$(".id").css("color","red");
							
							pw.css("border-bottom","solid 1px red");
							$(".password").css("color","red");
							
							id.focus();
						}
					},
					error : function(e){
						alert(e);
					}
				})
			});
			$("#id").on("blur",function(){
				if(id.val()==""){
					id.focus();
					id.attr("placeholder","필수항목입니다");
				}
			});
			$("#password").on("blur",function(){

				if(pw.val()==""){
					
					pw.focus();
					pw.attr("placeholder","필수항목입니다");
				
				}
			});
 		});