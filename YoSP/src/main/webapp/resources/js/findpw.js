 		$(document).ready(function(){
 			const id = $("#id");
 			const email = $("#email");
 			
 			var check1 = false; //id 존재
 			var check2 = false; // email 형식이 올바름
 			
 			var finishEmailCheck = false; // email 인증을 통과함
 			
 			id.on("blur",function(){
 				if(id.val() == ""){
 					
 					check1 = false;
 					
 					id.css("border-bottom","solid 1px red");
 					$(".id").css("color","red");
 				
 					id.focus();
 				
 				}else{
 					
 					id.css("border-bottom","solid 1px black");
 					$(".id").css("color","black");
 					
 					$.ajax({
 						url : '/yosp/isUsing',
 						type : 'POST',
 						data : {
 							id : id.val()
 						},
 						success : function(e){
 							if(e == "0"){
 								check1 = true;
 							}else{
 			 					
 								id.css("border-bottom","solid 1px red");
 			 					$(".id").css("color","red");
 			 					
 			 					id.focus();
 			 					
 								check1 = false;
 							}
 						}
 					})
 					
 				}
 			});
 			
 			$("#tryCheck").click(function(){

 				if(email.val() == "" || !email.val().match("@gmail")){
 					
 					email.css("border-bottom","solid 1px red");
 					$(".email").css("color","red");
 					
 					email.focus();
 					
 					check2 = false;
 					
 					return;
 				}else{
 					
 					email.css("border-bottom","solid 1px black");
 					$(".email").css("color","black");
 					
 					check2 = true;
 					if(!check1){
 						
 						id.focus();
 					
 					}else if(!check2){
 					
 						email.focus();
 					
 					}else if(check1 && check2){
 					
 						$.ajax({
 							url : '/yosp/mailSend',
 							type : 'post',
 							data : {
 								id : id.val(),
 								email : email.val()
 							},
 							success : function(e){
 								if(e == "1"){
 									alert("인증번호가 전송되었습니다");
 									$("#code").attr('readonly',false);
 									finishEmailCheck = false;
 								}else{
 									alert("이메일이 본인이 맞는지 다시 확인해주세요");
 				 					email.css("border-bottom","solid 1px red");
 				 					$(".email").css("color","red");
 				 					
 				 					email.focus();
 								}
 							}
 						})
 					}
 					
 				}
 			});
 			
 			$("#retry").click(function(){
 				if(!check1){
						
						id.focus();
					
					}else if(!check2){
					
						email.focus();
					
					}else if(check1 && check2){
					
						$.ajax({
							url : '/yosp/mailSend',
							type : 'post',
							data : {
								email : email.val()
							},
							success : function(){
								
								alert("인증번호가 전송되었습니다");
							}
						})
					}
 			})
 			
 			
 			$("#check").click(function(){
 				$.ajax({
 					url : '/yosp/codeCheck',
 					type : 'POST',
 					data : {
 						inputCode : $("#code").val()
 					},
 					success : function(e){
 						if(e== "1"){
 							$("#code").css("border","solid 2px green");
 							$("#code").attr('readonly',true);
 							finishEmailCheck = true;
 							
 						}else if(e == "0"){
 							$("#code").css("border","solid 2px red");
 						}
 					}
 				})
 			})
 			
 			$(".find").click(function(){
 				if(!check1){
 					id.focus();
 				}else if(!check2){
 					email.focus();
 				}else if(!finishEmailCheck){
 					alert("이메일 인증이 완료되지 않았습니다")
 				}else if(check1 && check2 && finishEmailCheck){
 					$.ajax({
 						url : '/yosp/find',
 						type : 'POST',
 						data : {
 							id : id.val()
 						},
 						success : function(e){
 							alert("비밀번호는 " + e + "입니다");
 							location.href="/yosp/login";
 						}
 						
 					})
 					
 				}
 			})
 			
 			
 			
 			
 			
 			
 			
 			
 		})