<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<title>비밀번호 복구</title>
	
	<link href="<c:url value="/resources/css/findpw.css" />" rel="stylesheet">
	
    <script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/findpw.js"></script>
 	<script>
 	
 	
 	</script>
</head>
<body>
	<div id="formContain">
		<h1>YoSP-find</h1>
		<div id="inform">
			<div id="informations">
        		<label><div class="text id">아이디</div>
        		<input id="id" name="id" type="text" required></label>
        		<br><br>

				<label><div class="text email">이메일</div>
				<input  id="email" name="email" type="email" required></label>
				<button id="tryCheck">이메일 인증</button><br>
				
    		    <a id="retry">인증번호 재전송</a>
				<br id="here"><br>
				
			</div>
			
			<input id="code" placeholder="이메일로 전송된 인증번호를 입력해주세요"><br>
     		<button id="check">인증번호 확인</button>
			<br>
			
			<a class="find"> 
				 <span>비밀번호 찾기</span>
				  <div class="transition"></div>
			</a>
		</div>
	</div>
</body>
</html>