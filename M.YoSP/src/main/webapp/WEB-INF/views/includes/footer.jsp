<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<c:url value="/resources/css/includes/footer.css" />"
	rel="stylesheet">
</head>
<body>
	<footer>

		<div id="L">
			<h1>Trip, Travel Route Itinerary Planner</h1>
			<p>Our Mission is to make your travel easy and comfortable.</p>

		</div>
		<img id="earth" src="${path }/resources/img/earth.png" />
		<div id="R">
			<div id="siteMap">
				<h2>Site Map</h2>
				<ul>
					<li><a href="/">Main Page</a></li>
					<li><a href="/login">Sign in</a></li>
					<li><a href="/login/find">Find Password</a></li>
					<li><a href="#">How to Use</a></li>
					<li><a href="#">Go to Use</a></li>
				</ul>
			</div>
			<div id="CopyAndInform">
				<div id="copyright">ⓒ 2023. Trip Co. all rights reserved</div>
				<div id="information">
					Tel : 010-1111-1111 <br> email : Mail4M.yosp@gmail.com
				</div>
			</div>
		</div>
		<hr>
	</footer>


</body>
</html>