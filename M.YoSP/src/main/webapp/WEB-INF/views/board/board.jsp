<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<link href="<c:url value="/resources/css/board.css" />" rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="${path}/resources/js/board.js"></script>

<script>
		$(function(){
			var page = Number($("#page").val());
			var order = String($("#order").val());
			var local = String($("#local").val());
			var realEnd = Number($("#realEnd").val());
			
			$("#header>#menus>li>a").css("color","black"); // 해당 페이지에서만 적용
			
			$(".num>div>#" + page).parent("div").css("background-color","rgba(0,0,0,0.25)")
			
			$("#filter-menus li").mouseenter(function(event){
				
				$(this).css("background-color","rgba(0,0,0,0.25)");
				$(this).children("a").css("font-weight","bold");
				$(this).find("div").slideDown("fast");
				$(this).find("div").css("display","flex");
			}).mouseleave(function(){
				$(this).css("background-color","");
				$(this).children("a").css("font-weight","normal");
				$(this).find("div:visible").css("display","none");
				$(this).find("div:visible").slideUp(50);
			});
			
			
			$("#insertButton").click(function(){
				location.href="board/insert";
			});
			
			
			$("#local>a").click(function(){
				local = String($(this).attr("id"));
				location.href = "/board/?page=" + 1 +"&order=" + order + "&local=" +local
			})
			
			
			
			
			$("#sort>a").click(function(){
				order = String($(this).attr("id"));
				location.href = "/board/?page=" + page +"&order=" + order + "&local=" + local;
			})
			$(".num").click(function(){
				location.href = "/board/?page=" + $(this).children("div").children("a").attr("id") + "&order=" + order + "&local=" + local;
			})
			
			$(".previous").click(function(){
				if(page-5 < 1){
					var ToPage = 1;
				}else{
					var ToPage = page-5;
				}
				
				location.href="/board/?page=" + ToPage + "&order=" + order + "&local=" + local;
			})
			
			$(".next").click(function(){
				if(page+5 > realEnd){
					var ToPage = realEnd;
				}else{
					var ToPage = page+5;
				}
				location.href="/board/?page=" + ToPage +"&order=" + order + "&local=" + local;
			})
		});
 	
 	</script>
</head>
<body>
	<%@include file="../../views/includes/header.jsp"%>
	<input id="page" type="hidden" value="${page }">
	<input id="realEnd" type="hidden" value="${pageMaker.realEnd }">
	<input id="order" type="hidden" value="${order }"/>
	<input id="local" type="hidden" value="${local }"/>
	
	
	<div id="content">
		<h1>여행 리뷰</h1>
		<div id="bar1"></div>
		<div id="search">
			<input id="searchInput">
			<button id="doSearch">검색</button>
		</div>
		<!-- 		<div id="back"></div> -->
		<div id="filter">
			<ul id="filter-menus">
				<li><a>지역</a>
					<div class="submenu" id="local">
				<c:forEach items="${areaList }" var="area">
						<a id="${area.getEnglishName() }"><c:out value="${area.getKoreanName() }"/></a>
				</c:forEach>
						<a id="etc">기타</a>
					</div></li>
				<li><a>정렬 방식</a>
					<div class="submenu" id="sort">
						<a id="byViewsDesc">조회수 내림차순</a>
						<a id="byViewsAsc">조회수 오름차순</a>
						<a id="byLikeDesc">추천수 내림차순</a>
						<a id="byLikeAsc">추천수 오름차순</a>
						<a id="byTimeDesc">최신순</a>
						<a id="byTimeAsc">오래된순</a>
					</div></li>
			</ul>
		</div>

		<div id="list">
			<table id="table">
				<thead>
					<tr>
						<td id="title">제목</td>
						<td id="writer">작성자</td>
						<td id="views">조회수</td>
						<td id="date">작성일</td>
					</tr>
				</thead>
				<c:forEach items="${list }" var="board">
					<c:set var="date">
						<fmt:formatDate value="${board.getWriteDate() }"
							pattern="yyyy.MM.dd" />
					</c:set>
					<tr>
						<td><a href="view?id=${board.getBoard_id() }"><c:out
									value="${board.getTitle() }" /></a></td>
						<td><c:out value="${board.getWriter() }"></c:out></td>
						<td><c:out value="${board.getViews() }"></c:out></td>
						<td><c:out value="${date }"></c:out></td>
					</tr>
				</c:forEach>
			</table>

			<div class="pull-right">
				<ul class="pagination">

					<c:if test="${pageMaker.prev }">
						<li class="paginate_button previous"><a href="#"><span class="arrow_prev"></span></a></li>

					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage }"
						end="${pageMaker.endPage }">
						<li class="paginate_button num"><div><a href="#" id="${num }">${num }</a></div></li>
					</c:forEach>

					<c:if test="${pageMaker.next }">
						<li class="paginate_button next"><a href="#"><span class="arrow_next"></span></a></li>

					</c:if>
				</ul>
			</div>

		</div>
		<div id="insert">
			<button id="insertButton">글쓰기</button>
		</div>
	</div>
</body>
</html>