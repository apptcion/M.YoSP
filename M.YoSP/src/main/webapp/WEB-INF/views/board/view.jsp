<%@page import="java.util.ArrayList"%>
<%@page import="org.myosp.domain.CommentDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${board.getTitle() }" /></title>
<link href="<c:url value="/resources/css/view.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="${path}/resources/js/view.js"></script>
<script>
	$(function() {
		var page = Number($("#page").val());
		var isLike = !JSON.parse($("#isLike").val());
		var board_id = Number($("#board_id").val());
		var ComSize = Number($("#ComSize").val());
		var UserId = String($("#UserId").val());
		var realEnd = Number($("#realEnd").val());
		var Cheight = Number($("#comments").css("height").slice(0,
				$('#comments').css('height').length - 2));
		var UserName = $("#UserName").val();

		function load() {
			var len = Number($("div[class='CommentWrapper']:hidden").length);
			if (len <= 5) {
				$("#more").hide();
			}
			$("div[class='CommentWrapper']:hidden").slice(0, 10).show();
		}
		function turn(now) {
			if (!now) { // to like
				$("#likeButtonArea>img").remove();
				$("#likeButtonArea")
						.append(
								'<img id="islike" src="<c:url value="/resources/img/good.png"/>">');
				isLike = true;

			} else { // to dislike
				$("#likeButtonArea>img").remove();
				$("#likeButtonArea")
						.append(
								'<img id="islike" src="<c:url value="/resources/img/dislike.png"/>">');
				isLike = false;
			}
		}

		///////////////////////기본 설정 ///////////////////////////////////////////////////
		$("#header>#menus>li>a").css("color", "black");
		$("a[id='" + page + "']").parent().parent().css("background-color",
				"rgba(0,0,0,0.25)")
		turn(isLike);
		if (ComSize == 0) {
			$("#other").css('top', '20px')
			$("#more").hide()
		} else if (ComSize <= 5) {
			load();
			$("#more").hide();
		}

		$(".tr" + board_id).css("border", "solid 2px black")
		$("div[class='CommentWrapper']").slice(0, 5).show();
		////////////////////////////////////////////////////////////////////////////////
		$("#load").click(function(e) {
			e.preventDefault();
			load();
		})

		$(".num").click(
				function() {
					location.href = "/board/view?id=" + board_id + "&page="
							+ $(this).children("div").children("a").attr("id");

				})

		$(".previous").click(function() {
			if (page - 5 < 1) {
				var ToPage = 1;
			} else {
				var ToPage = page - 5;
			}

			location.href = "/board/view?id=" + board_id + "&page=" + ToPage
		})

		$(".next").click(function() {
			if (page + 5 > realEnd) {
				var ToPage = realEnd;
			} else {
				var ToPage = page + 5;
			}
			location.href = "/board/view?id=" + board_id + "&page=" + ToPage
		})

		$("#like").click(function() {
			$.ajax({
				url : 'turn',
				data : {
					"now" : isLike,
					"UserId" : UserId,
					"board_id" : board_id
				},
				success : function(result) {
					turn(!result);
					location.reload();
				}
			})
		})

		$("#writing").keyup(function(e) {
			var content = $(this).val();
			$("#Count").css("color", "");
			$("#Count").empty();
			if (content.length > 200) {
				$("#Count").css("color", "red");
				$("#Count").append("200자/200자")
				$(this).blur();
			} else {
				$("#Count").append(content.length + "자/200자");
			}
		})

		$("#enrolbutton").click(function() {

			if ($("#writing").val().length > 0) {
				$.ajax({
					url : 'enroll',
					data : {
						"board_id" : board_id,
						"Content" : $("#writing").val()
					},
					success : function(result) {
						alert("댓글이 등록되었습니다");
						location.reload();
					}
				})
			}
		})

		$("svg[class*='svg']").click(function() {
			var ClassName = $(this).attr("class");
			$(this).siblings("." + ClassName).show();
			$("#cover").show();

		})

		$("#cover").on('click', function() {
			$("svg[class*='svg']").siblings(".inter").hide();
			$("#BoardInter").hide();
			$(this).hide();
		})

		$(window).scroll(function() {

			if ($("#cover").css("display") == "block") {
				$("#cover").hide();
				$("svg[class*='svg']").siblings(".inter").hide();
				$("#BoardInter").hide();
			}
		});

		$(".R_alter").click(
				function() {
					var Cmodal_id = Number($(this).parent()
							.siblings(".CHeader").attr("id"));
					var Con = $(this).parent().siblings(".Ccon").html()
							.replace(/<br>/g, "\n").slice(7);
					Con = Con.slice(0, Con.length - 6);

					console.log(Con);
					$("#Cmodal_id").val(Cmodal_id);
					$("#Cmodal_textarea").text(Con);
					$("#Cmodal").show();
					$("#Mcover").show();

					$("#cover").hide();
					$("svg[class*='svg']").siblings(".inter").hide();
				});

		$("#Mcover").click(function() {
			$("#Cmodal").hide();
			$("#Mcover").hide();
		})

		$(window).keyup(function(event) {
			if (event.keyCode == 27) {
				$("#Cmodal").hide();
				$("#Mcover").hide();
			}
		})

		$("#Cclose").click(function() {
			$("#Cmodal").hide();
			$("#Mcover").hide();
		})

		$(".R_del").click(function() {
			console.log("test")
			var test = confirm("정말 삭제하시겠습니까?");
			if (test) {
				var ComId = $(this).parent().siblings(".CHeader").attr("id");
				$.ajax({
					url : 'Cdel',
					data : {
						comment_id : Number(ComId),
					},
					success : function(result) {
						location.reload();
					}
				})
			}
		});

		$("#Csubmit").click(function() {
			if ($("#Cmodal_textarea").val().length > 0) {
				$.ajax({
					url : 'Cupdate',
					data : {
						comment_id : Number($("#Cmodal_id").val()),
						Con : $("#Cmodal_textarea").val()
					},
					success : function() {
						$("#Cmodal").hide();
						$("#Mcover").hide();
						location.reload();
					}

				})
			}
		})

		$("#BoardSVG").click(function() {
			$("#BoardInter").show();
			$("#cover").show();
		})

		$("#BoardModify").click(function() {
			console.log("test BoardSVG");
			location.href = "/board/modify?BoardId=" + board_id;

		})

		$("#BoardDel").click(function() {
			console.log("test BoardSVG");
			$.ajax({
				url : 'exeDel',
				data : {
					BoardId : board_id
				},
				success : function() {
					location.replace("/board")
				}
			})
		})

	});
</script>
</head>
<body>
	<input id="board_id" type="hidden" value="${id }" />
	<input id="page" type="hidden" value="${page }" />
	<input id="isLike" type="hidden" value="${isLike }">
	<input id="ComSize" type="hidden" value="${ComSize }" />
	<input id="realEnd" type="hidden" value="${pageMaker.realEnd }">
	<input id="UserId" type="hidden" value="${UserId }" />
	<%
		pageContext.setAttribute("br", "<br/>");
	pageContext.setAttribute("cn", "\n");
	%>
	<%@include file="../includes/header.jsp"%>
	<div id="View_wrap">
		<div id="view">
			<div id="Viewheader">
				<div id="leftHeader">
					<div id="title">
						<c:out value="${board.getTitle() }" />
					</div>
					<div id="writer">
						<c:out value="${board.getWriter() }" />
					</div>


					<c:set var="date">
						<fmt:formatDate value="${board.getWriteDate() }"
							pattern="yyyy.MM.dd" />
					</c:set>
					<div id="writeDate">
						<c:out value="${date }" />
					</div>

				</div>
				<div id="rightHeader">
					<div id="views">
						조회
						<c:out value="${board.getViews() }" />
					</div>
					<div id="good">
						추천
						<c:out value="${board.getGood() }" />
					</div>
				</div>
				<svg id="BoardSVG">
       	 		<path
						d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" />
    		</svg>
				<c:if test="${board.getMemberId() eq UserId }">

					<div id="BoardInter">
						<a id="BoardModify">수정</a> <a id="BoardDel">삭제</a>
					</div>
				</c:if>
			</div>

			<div id="contentWrap">
				<div id="content">
									<c:out value="${fn:replace(board.getContent(),cn,br)}"
					escapeXml="false" />
					
				</div>
				<fieldset id="ImgWrap">
					<legend>업로드된 이미지</legend>
					<c:forEach items="${files}" var="file">
						<c:set var="fileDate">
							<fmt:formatDate value="${file.getDate() }" pattern="yyyy-MM-dd" />
						</c:set>
						<img class="resources"
							src="/board/display?fileName=${file.getFileOriginalName()}&uuid=${file.getUuid()}&date=${fileDate }" />
					</c:forEach>
				</fieldset>
			</div>
			<div id="likeButton">
				<security:authorize access="isAuthenticated()">
					<a id="like">
						<div id="likeButtonArea">
							<!-- img영역 -->
						</div>
					</a>
				</security:authorize>
				<security:authorize access="isAnonymous()">
					<p id="noLogin">
						<img id="islike" src="<c:url value="/resources/img/dislike.png"/>">
					</p>
				</security:authorize>
			</div>




		</div>
		<div id="comment">
			<h2>댓글</h2>
			<div id="Count">0자/200자</div>
			<div id="input">
				<security:authorize access="isAnonymous()">
					<textarea id="writing" disabled placeholder="로그인 후 이용해 주세요"></textarea>
				</security:authorize>
				<security:authorize access="isAuthenticated()">
					<textarea id="writing" placeholder="댓글을 입력하세요" maxlength="200"></textarea>
				</security:authorize>
				<div id="enroll">
					<button id="enrolbutton">등록</button>
				</div>
			</div>
			<div id="Cmodal">
				<div id="Cmodal_title">
					<h2>댓글 수정</h2>
				</div>
				<input id="Cmodal_id" type="hidden" value="">
				<textarea id="Cmodal_textarea" placeholder="댓글을 입력하세요"
					maxlength="200"></textarea>
				<button id="Csubmit">수정</button>
			</div>
			<div id="Mcover"></div>
		</div>
		<div id="comments">
			<c:forEach items="${comments }" var="comment" varStatus="status">
				<div class="CommentWrapper">
					<div class="CHeader" id="${comment.getComment_id() }">
						<div class="Cname">
							<c:out value="${comment.getUserName() }" />
						</div>
						<c:if test="${comment.getUserName() eq board.getWriter() }">
							<div class="isWriter">작성자</div>
						</c:if>
						<c:set var="WriteDate">
							<fmt:formatDate value="${comment.getWriteDate() }"
								pattern="yyyy.MM.dd" />
						</c:set>

						<div class="Cdate">
							<c:out value="${WriteDate}" />
						</div>
					</div>
					<div class="Ccon">
						<c:out value="${fn:replace(comment.getContent(),cn,br)}"
							escapeXml="false" />
					</div>
					<svg class="svg${status.count }">
       	 					<path
							d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" />
    				</svg>
					<div class="inter svg${status.count }" id="${status.count }">
						<c:choose>
							<c:when test="${UserId eq comment.getMember_id() }">
								<a class="alter inter_R R_alter">수정</a>
								<a class="del inter_R R_del">삭제</a>
							</c:when>
							<c:otherwise>
								<a class="alter inter_N N_alter">수정</a>
								<a class="del inter_N N_del">삭제</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</c:forEach>
			<c:if test="${ empty comments}">
				<div class="CommentWrapper">
					<h3>아직 댓글이 없습니다</h3>
				</div>

			</c:if>
			<fieldset id="more">
				<legend align="center">
					<a href="#" id="load">더 보기</a>
				</legend>
			</fieldset>
			<%@include file="../includes/list.jsp"%>
		</div>
	</div>
	<div id="cover"></div>
	<%@include file="../includes/footer.jsp"%>
</body>
</html>