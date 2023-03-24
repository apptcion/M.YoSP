<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="<c:url value="/resources/css/join.css" />" rel="stylesheet">
<script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/join.js"></script>
<script>
			
$(document).ready(function(){
	$("#back").on("click",function(){
		history.back();
	})
})

</script>
</head>
<body>
		<div id="formContain">
			<h1>YoSP-joinMember</h1>
			<div id="inform">
				<div id="informations">
					<label><div class="text id">아이디</div>
					<input  id="id" name="id" type="text" required></label>
					<br><br>
					<label><div class="text password">비밀번호</div>
					<input id="password" name="password" type="password" required></label><br>
					<br>
					<label><div class="text pwCheck">비밀번호 확인</div>
					<input id="pwCheck" name="pwCheck" type="password" required></label><br>
					<br>
					<label><div class="text email">구글 이메일</div>
					<input id="email" name="email" type="email" pattern=".+@gmail.com" placeholder="비밀번호 복구시  사용"></label><br>
				</div>
				<a class="join"> 
         			<span>회원가입</span>
     	 			<div class="transition"></div>
    			</a>
    			<a id="back">
    				돌아가기
    			</a>
			</div>
		</div>
</body>
</html>