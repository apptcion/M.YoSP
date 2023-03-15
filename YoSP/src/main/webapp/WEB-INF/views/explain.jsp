<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <link href="<c:url value="/resources/css/explain.css" />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/> 
    <script src="http://code.jquery.com/jquery-latest.js"></script>
 	<script src="${path}/resources/js/explain.js"></script>
	<script>
		$(document).ready(function(){
			
		})
	
	</script>

</head>
	<% session = request.getSession();%>
	<% String id =  (String)session.getAttribute("id");%>
<body>
	<div id="head">
			<ul>
				<li class="HeadList" id="logo"><a href="/yosp/"><img src="<c:url value='/resources/img/logo.png'/>" style="width : 200px; height : 50px;">Your Special Planner</a></li>
				<div id="menu">
					<a href="warning"><li class="HeadList"> <h4>여행후기</h4>  </li></a>
					<a href="explain"><li class="HeadList"> <h4> YoSP </h4> </li></a>
					<li class="HeadList"><h4>
						<%if(id==null){ %>
							<a href="login">로그인</a> 
						<%}else{ %>
							<a href="logout"><%out.println(id+"님"); %></a>
					
						<%} %>
					</h4></li>
				</div>
			</ul>
		</div>
	<div id="Content">
	<div id="back">
		<h1>YoSP - 요셉</h1>
	</div>
	
	</div>
</body>
</html>