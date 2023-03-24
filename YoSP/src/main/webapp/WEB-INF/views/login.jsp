<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
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
				<div id="informations">
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
</html>