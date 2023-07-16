<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="<c:url value="/resources/css/login.css" />" rel="stylesheet">
	<title>로그인</title>
</head>
<body>
	<div id="login">
	<h1>TRIP - Login</h1>
		<form action="/login" method="POST">
			<label>
			<div class="text">아이디</div><br>
			<input type="text" class="data" name="username" required></label>
			<br>
			<label>
			<div class="text">비밀번호</div><br>
			<input type="password" class="data" name="password"></label>
			
			<br>
			<label id="remember-me"><input type="checkbox"name="remember-me">자동 로그인</label>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<label><button id="hidden" value="login"></button>
			<a class="login"> 
         		<span>로그인</span>
     	 		<div class="transition"></div>
    		</a></label>
    		<div id="move">
    			<a>비밀번호 찾기</a>
    			<a> 회원가입 </a>
    		</div>
		</form>
	
	
	</div>
</body>
</html>




<!--<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<title>로그인</title>
	
	<link href="<c:url value="/resources/css/login.css" />" rel="stylesheet">
	
    <script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/login.js"></script>
</head>
<body>
		<div id="formContain">
			<h1>YoSP-login</h1>
			<div id="inform">
				<div id="informations" method="post" action="/login">
					<label><div class="text id">아이디</div>
					<input  id="id" name="id" type="text" required></label><br>
					<br id="here"><br>
					<label><div class="text password">비밀번호</div>
					<input id="password" name="password" type="password" required></label><br>
				</div>
				
				<a class="login"> 
         				<span>로그인</span>
     	 				<div class="transition"></div>
    				</a>
				<a href="FindPW" id="findpw">비밀번호 찾기</a>
				<a href="join" id="join">회원가입 하기</a>
			</div>
		</div>
</body>
</html> -->