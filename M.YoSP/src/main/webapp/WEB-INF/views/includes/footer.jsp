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

		<div id="R">
			<h1>Trip, Travel Route Itinerary Planner</h1>
			<p style="font-family: serif; font-style: italic">Our Mission is
				to make your travel easy and comfortable.</p>

		</div>
		<div id="L">
			<div>
				<h2>Site Map</h2>
				<ul>
					<li><a>Main Page</a></li>
					<li><a>Sign in</a></li>
					<li><a>Find Password</a></li>
					<li><a>How to Use</a></li>
					<li><a>Go to Use</a></li>
				</ul>
			</div>
			<div>ⓒ 2023. Trip Co. all rights reserved</div>
			<div>
				Tel : 010-1111-1111 <br> email : Mail4M.yosp@gmail.com
			</div>
		</div>
	</footer>


</body>
</html>