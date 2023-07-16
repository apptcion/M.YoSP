<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<c:url value="/resources/css/includes/header.css" />" rel="stylesheet">
	<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="${path}/resources/js/includes/header.js"></script>
	
	<script>
		$(function() {
			$(window).scroll(function() {
				if($(window).scrollTop() > 0){
					$("#header").css("background","white")
				}else{
					$("#header").css("background","")
				}
			})
		})
	
	</script>
</head>
<body>
<div id="header">
	<div id="logo">
		<a href="/">
			<h2>TRIP</h2>
			<p>Trip Route Itinerary Planner</p>
			
		</a>
	</div>
	<ul id="menus">
		<li id="menu1">
			<a href="/board/?page=1&order=byViewsDesc&local=etc">여행후기</a>
		</li>
		<li id="menu2">
			<a href="#">TRIP</a>
		</li>
		<li id="menu3">
			<security:authorize access="isAnonymous()">
				<a href="/login">로그인</a>
			</security:authorize>
			<security:authorize access="isAuthenticated()">
				<a href="/logout">로그아웃</a>
			</security:authorize>
		</li>
	</ul>
</div>
</body>
</html>