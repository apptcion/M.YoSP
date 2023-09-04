<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<link href="<c:url value="/resources/css/includes/list.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function(){
		$("#insertButton").click(function(){
			location.href = "/board/write";
		})
	})
</script>
</head>
<div id="other">
		<div id="list">
			<div id="Theader">
				<div id="nums">No</div>
				<div id="titles">제목</div>
				<div id="writers">작성자</div>
				<div id="Oviews">조회수</div>
				<div id="dates">작성일</div>
			</div>
			<div id="tbody">
				<c:forEach items="${list }" var="board" varStatus="status">
					<div class="tr tr${board.getBoard_id() }">
						<c:set var="date">
							<fmt:formatDate value="${board.getWriteDate() }"
								pattern="yyyy.MM.dd" />
						</c:set>
						<div class="Onum"><c:out value="${status.count }"/></div>
						<div class="title">
							<a
								href="/board/view?id=${board.getBoard_id() }&page=${page }">
								<c:out value="${board.getTitle() }" />
							</a>
						</div>
						<div class="writer"><c:out value="${board.getWriter() }" /></div>
						<div class="date"><c:out value="${date }" /></div>
						<div class="view"><c:out value="${board.getViews() }" /></div>
					</div>
				</c:forEach>
				<c:if test="${empty list }">
					<div id="NoResult">
						<h1>조건에 맞는 게시물이 없습니다.</h1>
						<p>아래의 내용을 확인해보세요</p>
						<ol>
							<li>검색은 제목을 기준으로 검색합니다</li>
							<li>띄어쓰기가 일치해야 합니다</li>
							<li>지역이 맞지 않을 수 있습니다 (기타로 설정시 모든 지역이 나옵니다)</li>
							<li>게시물이 삭제되었을 수 있습니다.</li>
						</ol>
					</div>
				</c:if>
			</div>

			<div class="pull-right">
				<ul class="pagination">

					<c:if test="${pageMaker.prev }">
						<li class="paginate_button previous"><a href="#"><span
								class="arrow_prev"></span></a></li>

					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage }"
						end="${pageMaker.endPage }">
						<li class="paginate_button num"><div>
								<a href="#" id="${num }">${num }</a>
							</div></li>
					</c:forEach>

					<c:if test="${pageMaker.next }">
						<li class="paginate_button next"><a href="#"><span
								class="arrow_next"></span></a></li>

					</c:if>
				</ul>
			</div>
			<div id="insert">
				<button id="insertButton">글쓰기</button>
			</div>
		</div>
	</div>
</html>