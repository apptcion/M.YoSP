<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<p>principal-	<security:authentication property="principal"/></p>
	<p>이름- <security:authentication property="principal.Username" /></p>
	<p>MemberDTO : <security:authentication property="principal.member"/></p>
	<p>사용자 아이디 : <security:authentication property="principal.member.user_id" /></p>
	<p>사용자 권한 목록 : <security:authentication property="principal.member.authList"/>   </p>
</body>
</html>