<%@page import="com.portfolio.vo.boardVO"%>
<%@page import="java.util.List"%>
<%@page import="com.portfolio.dao.boardDAOImpl"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
    <link href="<c:url value="/resources/css/board.css" />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/> 
 	<script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/board.js"></script>
 	
 	<script>
		$(function(){
			
			$("#filter-menus li").mouseenter(function(event){
				$(this).find("div").parent().css("background","white");
				$(this).find("div").parent().children("a").css("color","black")
				
				$(this).find("div").slideDown("fast");
			}).mouseleave(function(){
				$(this).find("div:visible").slideUp(50,function(){
					$(this).parent().css("background","");
				});
			});
		});
 	
 	</script>
</head>
<body>
	<%@include file="../views/includes/header.jsp" %>
	<div id="content">
		<div id="search">
			<input id="searchInput">
			<button id="doSearch">검색</button>
		</div>
		<div id="filter">
				<ul id="filter-menus">
					<li>
						<a>지역</a>
						<div id="local">
							<a>서울</a>
							<a>부산</a>
							<a>대구</a>
							<a>대전</a>
						</div>		
					</li>
					<li>
						<a>종류</a>
						<div id="type">
							<a>숙소</a>
							<a>공원</a>
							<a>식당</a>
							<a>기타</a>
						</div>		
					</li>
					<li>
						<a>리뷰 유형</a>
						<div id="positive">
							<a>긍정</a>
							<a>부정</a>
							<a>기타</a>
						</div>		
					</li>
					<li>
						<a>정렬 방식</a>
						<div id="sort">
							<a>조회수</a>
							<a>추천수</a>
							<a>시간순</a>
							<a>기타</a>
						</div>
					</li>		
				</ul>
		</div>
		<div id="list">
		<table id="table">
			<thead>
				<tr>
					<td id="pid">번호</td>
					<td id="title">제목</td>
					<td id="writer">작성자</td>
					<td id="views">조회수</td>
					<td id="date">작성일</td>
				</tr>
			</thead>
			<c:forEach items="${list }" var="board">
					<tr>
						<td><c:out value="${board.getPid() } "/></td>
						<td><c:out value="${board.getTitle() } "/></td>
						<td><c:out value="${board.getWriter() } "/></td>
						<td><c:out value="${board.getViews() } "/></td>
						<td><c:out value="${board.getDate() } "/></td>
					</tr>
				</c:forEach>
		</table>
		
		</div>
		<div id="insert">
			<button>글쓰기</button>
		</div>
	</div>
	<%@include file="../views/includes/footer.jsp" %>
</body>
</html>