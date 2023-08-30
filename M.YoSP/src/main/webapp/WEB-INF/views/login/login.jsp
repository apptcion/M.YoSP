<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="<c:url value="/resources/css/login.css" />" rel="stylesheet">
	<title>Login</title>
</head>
<body>
	<div id="login">
	<h1>TRIP - Login</h1>
		<form action="/login" method="POST">
			<label class="data">
			<div class="text">아이디</div><br>
			<input type="text" name="username" required></label>
			<br>
			<label class="data">
			<div class="text">비밀번호</div><br>
			<input type="password" name="password"></label>
			
			<br>
			<label id="remember-me"><input type="checkbox"name="remember-me">자동 로그인</label>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<label><button id="hidden" value="login"></button>
			<div id="login_button">
			<a class="login"> 
         		<span>로그인</span>
     	 		<div class="transition"></div>
    		</a>
    		</div>
    		</label>
    		<div id="move">
    			<a href="/login/find">비밀번호 찾기</a>
    			<a href="/login/signup"> 회원가입 </a>
    		</div>
		</form>
		<div id="error">
			<c:out value="${error }"/>
		</div>
	</div>
</body>
</html>