<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign Up</title>
<link href="<c:url value="/resources/css/join.css" />" rel="stylesheet">
<link rel="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="${path}/resources/js/join.js"></script>
<script>
			
$(document).ready(function(){
	
	var chId = false;
	var chPw = false;
	
	
	$("#id").focus();
	$("#id").focus(function(){
		chId = false;
	})
	
	$("#password").focus(function(){
		chPw = false;
	})
	
	$("#pwCheck").focus(function(){
		chPw = false;
	})
	$("#id").blur(function(){
		if($(this).val().length > 10 || $(this).val().length < 3){
			$(this).focus();
			$(this).css("border-bottom","solid 1.5px red")
			$(this).siblings(".warn").text("아이디는 3글자 이상, 10글자 이하여야합니다");
			$(this).siblings(".warn").css("color","red")
			chId = false;
			
			
		}else{
			
			$.ajax({
				url : 'inUse',
				data : {
					id : $(this).val()
				},
				success : function(result){
					console.log(result);
					if(!result){
						$("#id").css("border-bottom","solid 1.5px green")
						$("#id").siblings(".warn").text("");
                        chId = true;
					}else{
						$("#id").css("border-bottom","solid 1.5px red")
						$("#id").siblings(".warn").text("이미 사용중인 아이디입니다")
						$("#id").siblings(".warn").css("color","red")
						$("#id").focus();
                        chId = false;
					}
				}
			})
		}
	});
	
	$("#password").blur(function(){
		if(!chId){
			$("#id").focus();
			return;
		}
		if($(this).val().length < 6){
			$(this).css("border-bottom","solid 1.5px red")
			$(this).siblings(".warn").text("비밀번호는 6글자 이상이어야합니다");
			$(this).siblings(".warn").css("color","red")
			$(this).focus();
            chPw = false;
		}else{
			if($("#pwCheck").val() != "" && $("#pwCheck").val() != $(this).val()){
	            $("#password").css("border-bottom","solid 1.5px red");
	            $("#pwCheck").css("border-bottom","solid 1.5px red");
	            $("#pwCheck").siblings(".warn").text("비밀번호가 다릅니다");
	            $("#pwCheck").siblings(".warn").css("color","red");
	            chPw = false;
			}else{
				$(this).css("border-bottom","solid 1.5px green");
				$("#password").siblings(".warn").text("");
				chPw = true;
			}
		}
	})


    $("#pwCheck").blur(function(){
        var checkVal = $(this).val();
        var pwVal = $("#password").val();


        if(checkVal == pwVal){
            $("#password").css("border-bottom","solid 1.5px green");
            $(this).css("border-bottom","solid 1.5px green");
            $(this).siblings(".warn").text("");
            chPw = true;
        }else{
            $("#password").css("border-bottom","solid 1.5px red");
            $(this).css("border-bottom","solid 1.5px red");
            $(this).siblings(".warn").text("비밀번호가 다릅니다");
            $(this).siblings(".warn").css("color","red");
            $(this).val() == null;
            $("#password").focus();
            chPw = false;
        }
    })
    
    
    
	
	$("#back").on("click",function(){
		location.replace("/login");
	});
	
	$("#showPw").on('click',function(){
		console.log($(this).val());
	})
	
	
	
	$(".join").click(function(){
		if(chPw && chId){
			$.ajax({
				url : 'exeJoin',
				data : {
					id : $("#id").val(),
					password : $("#password").val(),
					email : $("#email").val(),
				},
				success : function(){
					location.replace('/login');
				}
			});
		}
	});
	
	
})

</script>
</head>
<body>
	<div id="formContain">
		<h1>TRIP - Sign Up</h1>
		<div id="inform">
			<div id="informations">
				<label>
					<div class="text id">아이디</div> 
					<input id="id" type="text" required>
					<div class="warn"></div>
				</label> 
				
				<br>
				
				<label>
						<div class="text password">비밀번호</div> 
					   <input id="password" type="password" required>
					   <div class="warn"></div>
				</label>
				
				<br>
				
				<label>
					<div class="text pwCheck">비밀번호 확인</div>
					<input id="pwCheck" type="password" required>
					<div class="warn"></div>
				</label>
				<i class="fa fa-eye fa-lg"></i>
				
				<br>
				
				<label>
					<div class="text email">구글 이메일</div> 
					<input id="email" type="email" pattern=".+@gmail.com" placeholder="비밀번호 복구시  사용">
					<div class="warn"></div>
				</label>
				
				<br>
			</div>
			<div id="join_button">
				<a class="join"> <span>회원가입</span>
					<div class="transition"></div>
				</a>
			</div>
			<a id="back"> 돌아가기 </a>
		</div>
	</div>
</body>
</html>