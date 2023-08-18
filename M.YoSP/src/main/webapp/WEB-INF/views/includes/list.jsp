<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<c:url value="/resources/css/includes/list.css" />" rel="stylesheet">
</head>
<body>
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
						<security:authorize access="isAuthenticated()">
							<a
								href="view?id=${board.getBoard_id() }&page=${page }&order=byViewsDesc&local=etc&Username=<security:authentication property="principal.Username"/>&search=">
								<c:out value="${board.getTitle() }" />
							</a>
						</security:authorize>
						<security:authorize access="isAnonymous()">
							<a
								href="view?id=${board.getBoard_id() }&page=${page }&order=byViewsDesc&local=etc&Username=&search=">
								<c:out value="${board.getTitle() }" />
							</a>
						</security:authorize>
						</div>
						<div class="writer"><c:out value="${board.getWriter() }" /></div>
						<div class="date"><c:out value="${date }" /></div>
						<div class="view"><c:out value="${board.getViews() }" /></div>
					</div>
				</c:forEach>
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
</body>
</html>