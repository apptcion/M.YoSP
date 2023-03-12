 		$(document).ready(function(){
 			var id = $("#id");
 			var pw = $("#password");
 			
 			id.focus();
 			
			$(".secession").on("click",function(){
					$.ajax({
						url : '/yosp/isPass',
						type : 'POST',
						data : {
							id : id.val(),
							password : pw.val()
						},
						success : function(e){
							if(e == "1"){
								$.ajax({
									url : '/yosp/doSecession',
									type : 'POST',
									data : {
										id : id.val(),
										password : pw.val()
									},
									success : function(){
										location.href="/yosp"
									}
								})
							}else if(e=="0"){
								pw.css("border-bottom","solid 1px red");
								$(".password").css("color","red");
								pw.focus();
							}else if(e=="-1"){
								id.css("border-bottom","solid 1px red");
								$(".id").css("color","red");
								pw.css("border-bottom","solid 1px red");
								$(".password").css("color","red");
								id.focus();
							}
						}
					});
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