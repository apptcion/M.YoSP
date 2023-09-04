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
<title>MyPage</title>
<link href="<c:url value="/resources/css/MyPage.css" />"
	rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {

		let NowEmail = $("#email>input").val();
		$("#header>#menus>li>a").css("color", "black");

		$("#cover").click(function() {
			$("#modal").hide();
			$(this).hide();
		})

		$(window).keyup(function(event) {
			if (event.keyCode == 27) {
				$("#modal").hide();
				$("#cover").hide();
				$("#pwModal").hide();
				$("#pwCover").hide();
				$("#warn").text("");
				$("#pwModal>input").val("")
			}
		})

		$("#modal>a").click(function(event) {
			event.preventDefault();
			$("#modal").hide();
			$("#cover").hide();
		})

		$("#resign>button").click(function() {
			$("#modal").css("display", "flex")
			$("#cover").show();
		})

		$("#modal>button").click(function() {
			$.ajax({
				url : "resign",
				success : function() {
					location.replace("/login/logout")
				}
			})
		})

		$("#email>button").click(
				function() {
					if ($("#email>input").val().match("@gmail.com")
							&& $("#email>input").val().length > 10
							&& $("#email>input").val() != NowEmail) {
						$.ajax({
							url : 'modifyEmail',
							data : {
								email : $("#email>input").val()
							},
							success : function() {
								location.reload();
							}
						})
					}
				})

		$("#email>input").keyup(function(event) {
			if (event.keyCode == 13) {
				if ($("#email>input").val().match("@gmail.com")
						&& $("#email>input").val().length > 10
						&& $("#email>input").val() != NowEmail) {
					$.ajax({
						url : 'modifyEmail',
						data : {
							email : $("#email>input").val()
						},
						success : function() {
							location.reload();
						}
					})
				}
			}
		})

		$("#close").click(function() {
			$("#pwModal").hide();
			$("#pwCover").hide();
		})

		$("#pwCover").click(function() {
			$("#pwModal").hide();
			$("#pwCover").hide();
			$("#warn").text("");
			$("#pwModal>input").val("")
		})

		$("#close").click(function() {
			$("#pwModal").hide();
			$("#pwCover").hide();
			$("#warn").text("");
			$("#pwModal>input").val("")
		})

		$("#password>button").click(function() {
			$("#pwModal").show();
			$("#pwCover").show();
		})

		$("#pwModal>#submit").click(
				function() {
					var NewPw = $("#pwModal>input").val()
					if (NewPw.length >= 6
							&& NewPw.length <= 10) {
						$.ajax({
							url : '/login/changePW',
							data : {
								newPw : NewPw,
								id : $("#UserName").val()
							},
							success : function() {
								location.replace("/login/logout")
							}
						})
					} else {
						$("#warn").text("비밀번호는 6글자 이상 10글자 이하여야합니다");
						$("#pwModal>input").focus();
					}
				})
	})
</script>
</head>
<body>
	<%@include file="./includes/header.jsp"%>
	<input id="UserName" type="hidden" value="${userName }" readonly>
	<div id="MyPageWrap">
		<div id="UserData">
			<div id="profileDiv">
				<img id="profile" src="${path }/resources/img/profile.png" />
			</div>
			<div id="Data">
				<p id="title">계정 정보</p>
				<div id="email">
					<p>이메일</p>
					<input value="${email }" placeholder="이메일을 입력하세요">
					<button>수정</button>
					<br>
				</div>
				<div id="password">
					<p id="PwTitle">비밀번호</p>
					<button>비밀번호 변경</button>
					<img src="resources/img/warn.png">
					<p id="Warn">비밀번호 변경시 로그아웃 됩니다</p>
				</div>
				<div id="name">
					<p>이름</p>
					<input value="${userName }" readonly>
				</div>
			</div>
			<div id="resign">
				<button>회원탈퇴</button>
				<img src="resources/img/resign.png">
				<p>이 조치는 되돌릴 수 없습니다</p>
			</div>
			<div id="modal">
				<h2>정말 탈퇴하시겠습니까?</h2>
				<p>탈퇴 버튼 선택시, 계정은 삭제되며 복구되지 않습니다</p>
				<button>탈퇴</button>
				<a>취소</a>
			</div>
			<div id="cover"></div>
			<div id="pwModal">
				<h2>비밀번호 변경</h2>
				<p id="subtitle">변경할 비밀번호를 입력해주세요</p>
				<input type="password">
				<p id="warn"></p>
				<button id="submit">변경</button>
				<button id="close">
					<div id="X"></div>
				</button>
			</div>
			<div id="pwCover"></div>
		</div>
		<div id="Maps">
			<h1>나의 지도</h1>
			<div id="Map"></div>
		</div>
	</div>
	<%@include file="./includes/footer.jsp"%>
</body>
</html>