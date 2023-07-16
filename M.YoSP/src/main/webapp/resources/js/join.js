$(document).ready(function(){
				const id = $("#id");
				const pw = $("#password");
				const email = $("#email");
				const Checkpw = $("#pwCheck");
				
				
				var check1 = false;
				var check2 = false;
				
				id.focus();
				
				
				///////////////////////////아이디 중복 확인 && 필수값 입력확인/////////////////////////
				
				id.on("blur",function(){
					if(id.val() == ""){
						id.focus();
						id.attr("placeholder","필수항목입니다");
					}else{
						
						$.ajax({
							url : '/yosp/isUsing',
							type : 'POST',
							data : {
								id : id.val(),
							},
							success : function(e){
								if(e == "1"){
									id.css("border-bottom","solid 1.5px green");
									$(".id").css("color","green");
									check1 = true;
								}else{
									id.css("border-bottom","solid 1px red");
									$(".id").css("color","red");
									check1 = false;
								}
							}
						})
					}
				});
				pw.on("blur",function(){
					if(pw.val() == ""){
						pw.focus();
						pw.attr("placeholder","필수항목입니다");
					}else if(Checkpw.val() != ""){
						if(Checkpw.val() == pw.val()){
							pw.css("border-bottom","solid 1.5px green");
							$(".password").css("color","green");
							
							Checkpw.css("border-bottom","solid 1.5px green");
							$(".pwCheck").css("color","green");
							check2 = true;
						}else{
							pw.css("border-bottom","solid 1.5px red");
							$(".password").css("color","red");
							
							Checkpw.css("border-bottom","solid 1.5px red");
							$(".pwCheck").css("color","red");
							check2 = false;
						}
					}
				});
				
				Checkpw.on("blur",function(){
					if(Checkpw.val() == pw.val()){
						pw.css("border-bottom","solid 1.5px green");
						$(".password").css("color","green");
						
						Checkpw.css("border-bottom","solid 1.5px green");
						$(".pwCheck").css("color","green");
						check2 = true;
					}else{
						pw.css("border-bottom","solid 1.5px red");
						$(".password").css("color","red");
						
						Checkpw.css("border-bottom","solid 1.5px red");
						$(".pwCheck").css("color","red");
						check2 = false;
					}
				});
				///////////////////////////input 색 초기화/////////////////////////////////
				
				id.on("focus",function(){
					if(id.val() != ""){
						id.css("border-bottom","solid 1px black");
						$(".id").css("color","black");
					}
				});
				pw.on("focus",function(){
					if(pw.val() != ""){
						pw.css("border-bottom","solid 1px black");
						$(".password").css("color","black");
					}
				})
				
				///////////////////////////회원가입 처리/////////////////////////////////////////
				
				$(".join").on("click",function(){
					if(!check1){ //id 통과
						id.focus();
					}else if(!check2){ // 비밀번호 통과
						pw.focus();
					}else if(email.val() != "" && !email.val().match("@gmail.com")){ //이메일이 형식에 맞는지 여부
						email.css("border-bottom","solid 1px red");
						$(".email").css("color","red");
						email.focus();
					}else if(check1 && check2){
						$.ajax({
							url : '/yosp/joinMemberShip',
							type : "POST",
							data : {
								id : id.val(),
								password : pw.val(),
								email : email.val()
							},
							success : function(){
								$.ajax({
									url : '/yosp/isPass',
									data : {
										id : id.val(),
										password : pw.val()
									},
									success : function(){
										location.href="/yosp/"
									}
								})
							},
							error : function(){
								alert("오류");
							}
						})
					}
				});
				
				/////////////////////////뒤로 가기/////////////////////////////////////////////
				
				$("#back").on("click",function(){
					history.back();
				})
				
				////////////////////////////////////////////////////////////////////////////
			});