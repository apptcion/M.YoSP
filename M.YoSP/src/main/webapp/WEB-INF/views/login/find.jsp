<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>비밀번호 복구</title>

<link href="<c:url value="/resources/css/find.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="${path}/resources/js/find.js"></script>
<script>
 	$(function(){
 		
 		var chId = false;
 		var isRun = false;
 		var psEmail = false;
 		var psCode = false;
 		
 		var Time = 300;
 		var InterTimer;
 		
 		$("#back").on('click',function(){
 			location.href = "/login"
 		})
 		
 		
 		 $("#id").focus(function(){
 			chId = false;
 			psCode = false;
 		})
 		$("#email").focus(function(){
 			psEmail = false;
 			psCode = false;
 		})
 		
 		$("#id").blur(function(){
 			$.ajax({
 				url : 'inUse',
 				data : {
 					id : $("#id").val()
 				},
 				success : function(result){
 					if(!result){
 						$("#id").css("border-bottom","solid 1px red");
 						$("#warn").text("존재하지 않는 아이디");
 						$("#warn").css("color","red");
 						$("#id").focus();
 					}else{
 						$("#id").css("border-bottom","solid 1px black");
 						$("#warn").text("");
 						$("#warn").css("color","");
 						chId = true;
 					}
 				}
 			});
 		});
 		
 		$("#tryCheck, #retry").click(function(){
 			if(chId && !isRun){
 				isRun = true;
 				$("#code").css("border","solid 1px black");
 				ShowModal("전송중...","시간이 걸릴수 있습니다.<br> 이 창을 닫아도 됩니다",false);
 				
 				if(Time != 300){
 					clearInterval(InterTimer)
 					Time = 300;
 				}
 				$.ajax({
 					url : 'sendMail',
 					data : {
 						id : $("#id").val(),
 						email : $("#email").val()
 					},
 					success : function(result){
 						if(result){
 							psEmail = true
 							ShowModal("이메일 전송",$("#email").val() + "로 코드가 전송되었습니다. <br>이메일을 확인해주세요",false);
 			 				InterTimer = setInterval(function(){
 			 					Time = timer(Time);
 			 					},1000);
 			 				
 			 				setTimeout(function(){
 			 					isRun = false;
 			 				},10000);
 			 			}else{
 			 				ShowModal("오류가 발생했습니다","아이디와 이메일 정보가 일치하지 않습니다",false);
 							isRun = false;
 			 				$("#email").focus();
 			 				return;
 			 			}
 					}
 				});
 			}
 		});
 		
 		$("#check").click(function(){
 			if(psEmail){
 	 			$.ajax({
 	 				url : 'checkKey',
 	 				data : {
 	 					key : $("#code").val()
 	 				},
 	 				success : function(result){
 	 					console.log(result)
 	 					if(result){
 	 						clearInterval(InterTimer);
 	 						$("#timer").text("");
 	 						Time = 300;
 	 						ShowModal("코드 확인","인증되었습니다, 이 창을 닫은 후 비밀번호를 변경해주세요",false);
 	 						$("#code").css("border","solid 1.5px green");
 	 						psCode = true;
 	 					}else{
 	 						ShowModal("코드 불일치","코드가 일치하지 않습니다",false);
 	 						psCheck = false;
 	 						$("#code").css("border","solid 1.5px red");
 	 						$("#code").focus(); 	 					}
 	 				}
 	 			})
 			}
 		});
 		
 		$(".find").click(function(){
 			if(psCode){
 				ShowModal("비밀번호 변경","변경할 비밀번호를 입력해주세요",true);
 			}
 		})
 		
 		
 		
 		$("#modal>#submit").click(function(event){
 			var NewPw = $(this).siblings("input").val();
 				console.log(NewPw);
 				console.log(typeof NewPw);
 				console.log(NewPw.length)
 	 			if(NewPw.length < 6 || NewPw.length > 10){
 	 				$(this).siblings("input").focus();
 	 				$(this).siblings(".warn").text("비밀번호는 6자리 이상, 10자리 이하여야합니다");
 	 				$(this).siblings(".warn").css("color","red");
 	 				$(this).siblings("input").css("border-bottom","solid 1px red");
 	 			}else{
 	 				console.log("test")
 	 				$.ajax({
 	 					url : 'changePW',
 	 					data : {
 	 						newPw : NewPw
 	 					},
 	 					success : function(){
 	 						location.replace("/login")
 	 					}
 	 				})
 	 			}
 		})
 		
 		
 		$("#cover, #close").click(function(){
 			HideModal();
 		})
 		
 		$(window).keyup(function(eveny){
        	if(eveny.keyCode == 27){
				HideModal();
        	}
        })
 		
		function timer(LeaveTime){
			if(LeaveTime <= 1){
				psEmail = false;
				ShowModal("시간 초과","코드의 유효시간이 지났습니다, 다시 시도해주세요",false);
				clearInterval(InterTimer);
				$("#timer").text("");
				Time = 300;
						
			}
			LeaveTime -= 1;
					
			if(LeaveTime > 150){
				$("#timer").css("color","green");
			}else if(LeaveTime > 60){
				$("#timer").css("color","orange");
			}else{
				$("#timer").css("color","red");
			}
			$("#timer").text(TimeToString(LeaveTime));
			
			return LeaveTime;
		}
 		
 		function TimeToString(time){
 			var min = Math.floor(time/60);
 			var sec = time%60;
 			
 			return min + " : " + sec;
 		}
 		
 		function ShowModal(title, content,haveInput){
 			
 			if(haveInput){
 				$("#modal").children("#dataInput").show();
 				$("#modal").children("#submit").show();
 			}
 			$("#modal").show();
 			$("#cover").show();
 			$("#modal>#title").html(title);
 			$("#modal>#body").html(content);
 			
 		}
 		function HideModal(){
 			$("#modal").hide();
 			$("#cover").hide();
 			$("#modal").children("#dataInput").hide();
 			$("#modal").children("#submit").hide();
 			$("#modal").children(".warn").text("");
 			$("#modal").children("input").css("border-bottom","solid 1px black");
 		}
 		
 	})
 	</script>
</head>
<body>
	<div id="formContain">
		<h1>TRIP - Find</h1>
		<div id="inform">
			<div id="informations">
				<label>
					<div>아이디</div> <input id="id" type="text">
					<div id="warn"></div>
				</label> <br> <br> <label>
					<div>이메일</div> <input id="email" type="email">
				</label>

				<button id="tryCheck">이메일 인증</button>
				<a id="retry">인증번호 재전송</a> <br id="here"> <br>

			</div>

			<input id="code" placeholder="이메일로 전송된 인증번호를 입력해주세요">
			<div id="timer"></div>
			<button id="check">인증번호 확인</button>
			<a class="find"> <span>비밀번호 변경</span>
				<div class="transition"></div>
			</a>
		</div>
		<a id="back" href="/">돌아가기</a>
		<div id="modal">
			<button id="close"><div id="X"></div></button>
			<h2 id="title"></h2>
			<div id="body"></div>
			<input id="dataInput" type="password">
			<div class="warn"></div>
			<button id="submit">변경</button>
		</div>
		<div id="cover"></div>
	</div>
</body>
</html>