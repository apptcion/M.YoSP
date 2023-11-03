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
			
			$("#HeaderprofileDiv").click(function(){
				$("#HeaderCover").show();
				$("#UserMenu").css("display","flex")
			})
			
			
			$("#HeaderCover").click(function(){
					$(this).hide();
					$("#UserMenu").css("display","none");	
			})
		})
	
	</script>
</head>
<body>
<div id="header">
	<div id="logo">
		<a href="/">
			<h2>Trip</h2>
			<p>Trip Route Itinerary Planner</p>
			
		</a>
	</div>
	<ul id="menus">
		<li id="menu1">
			<a href="/board">여행후기</a>
		</li>
		<li id="menu2">
			<a href="/CreateMap">TRIP</a>
		</li>
		<li id="menu3">
			<security:authorize access="isAnonymous()">
				<a href="/login">로그인</a>
			</security:authorize>
			<security:authorize access="isAuthenticated()">
				<div id="HeaderprofileDiv">
				<img id="Headerprofile" src="${path }/resources/img/profile.png"></div>
				
				<div id="UserMenu">
					<a href="/MyPage">MyPage</a><br>
					<a href="/login/logout">로그아웃</a>
				</div>
			</security:authorize>
		</li>
	</ul>
	<div id="HeaderCover"></div>
</div>
</body>
</html>