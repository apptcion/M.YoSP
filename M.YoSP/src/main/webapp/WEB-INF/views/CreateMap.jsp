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
<title>여행하기</title>
<link href="<c:url value="/resources/css/CreateMap.css" />"
	rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {
		$("#header>#menus>li>a").css("color", "black");
		$("#search>input").keyup(
				function() {
					var Areas = $(".Areas");
					var keyWord = $(this).val().toUpperCase();
					for (var i = 0; i < Areas.length; i++) {
						var EnglishName = $(Areas[i]).children(".EnglishName")
								.val().toUpperCase();
						var KoreanName = $(Areas[i]).children(".KoreanName")
								.val();
						if (!EnglishName.match(keyWord.toUpperCase())
								&& !KoreanName.match(keyWord)) {
							$(Areas[i]).addClass("hide")
						} else {
							$(Areas[i]).removeClass("hide");
						}
					}
				})

		$(".Areas")
				.on(
						'click',
						function() {
							$("#modal>h1").empty();
							$("#modal>p").empty();
							$("#modal>img").remove();
							$("#modal>div").empty();

							$("#modal>h1").append(
									$(this).children(".EnglishName").val()
											.toUpperCase());
							$("#modal>p").append(
									$(this).children(".KoreanName").val());
							$("#modal>div").append(
								$(this).children(".intro").val()		
							);
							$("#modal").append(
									"<img src='resources/img/area/"
											+ $(this).children(".EnglishName")
													.val() + ".png'>")
							$("#modal>input").val($(this).children(".EnglishName").val())
							$("#modal").show();
							$("#cover").show();

						});
		$("#create").click(function(){
			location.href="/Creating?area=" + $(this).siblings("input").val();
		})
		
		$("#cover").click(function() {
			$("#modal").hide();
			$("#cover").hide();
		})

		$(window).keyup(function(e) {
			if (e.keyCode == 27) {
				$("#modal").hide();
				$("#cover").hide();
			}
		})

		$("#close").click(function() {
			$("#modal").hide();
			$("#cover").hide();
		})
	})
</script>
</head>
<body>
	<%@include file="./includes/header.jsp"%>
	<div id="modal">
		<h1></h1>
		<p></p>
		<div></div>
		<input type="hidden" value="">
		<button id="create">일정 만들기</button>
		<button id="close">
			<div id="X"></div>
		</button>
	</div>
	<div id="cover"></div>
	<div id="ContentWrap">
		<div id="search">
			<p>어디로 가시나요?</p>
			<input placeholder="지역이름 입력">

		</div>
		<div id="AreaContainer">
			<c:forEach items="${area}" var="Area">
					<div id="${Area.getEnglishName() }"
						class="Areas ${Area.getKoreanName() } ${Area.getEnglishName()}">
						<input type="hidden" class="EnglishName"
							value="${Area.getEnglishName() }"> <input type="hidden"
							class="KoreanName" value="${Area.getKoreanName() }">
						<input class="intro" value="${Area.getIntro() }" type="hidden">	
							 <img
							src="resources/img/area/${Area.getEnglishName() }.png" />
						<h2>${Area.getEnglishName() }</h2>
						<p>${Area.getAddress() }</p>
					</div>
			</c:forEach>
		</div>
	</div>
	<%@include file="./includes/footer.jsp"%>
</body>
</html>