<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<title>로그인</title>
	
	<link href="<c:url value="/resources/css/secession.css" />" rel="stylesheet">
	
    <script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/secession.js"></script>
</head>
<body>
		<div id="formContain">
			<h1>YoSP-secession</h1>
			<div id="inform">
				<div id="informations">
					<label><div class="text id">아이디</div>
					<input  id="id" name="id" type="text" required></label><br>
					<br id="here"><br>
					<label><div class="text password">비밀번호</div>
					<input id="password" name="password" type="password" required></label><br>
					
				</div>
				<a class="secession"> 
         			<span>회원탈퇴</span>
     	 			<div class="transition"></div>
    			</a>
				<a id="back">돌아가기</a>
			</div>
		</div>
</body>
</html>