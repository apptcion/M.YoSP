<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행하기</title>
<link href="<c:url value="/resources/css/CreateMap.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function(){
	$("#header>#menus>li>a").css("color", "black");
	$("#search>input").keyup(function(){
		var Areas = $(".Areas");
		var keyWord = $(this).val().toUpperCase();
		for(var i = 0;i<Areas.length; i++){
			var EnglishName = $(Areas[i]).children(".EnglishName").val().toUpperCase();
			var KoreanName = $(Areas[i]).children(".KoreanName").val();	
			if(!EnglishName.match(keyWord.toUpperCase()) && !KoreanName.match(keyWord)){
				$(Areas[i]).addClass("hide")
			}else{
				$(Areas[i]).removeClass("hide");
			}
		}
	})
	
	$(".Areas").on('click',function(){
		$("#modal>h1").empty();
		$("#modal>p").empty();
		$("#modal>img").empty();
		
		var path = $("#path").val();
		
		console.log($(this).children("img"))
		
		$("#modal>h1").append($(this).children(".EnglishName").val());
		$("#modal>p").append($(this).children(".KoreanName").val());
		$("#modal>img").append("<img src='" + path + "/resources/img/" +$(this).children(".EnglishName").val()+  ".png'>");
		
		$("#modal").show();
		$("#cover").show();
		
	})
})
</script>
</head>
<body>
<%@include file="./includes/header.jsp" %>
	<div id="modal">
	<h1></h1>
	<p></p>
	<img>
	<button>일정 만들기</button>
	</div>
	<div id="cover"></div>
<div id="ContentWrap">
	<div id="search">
		<p>어디로 가시나요?</p>
		<input placeholder="지역이름으로 검색"><img src="resources/img/search.png">
	
	</div>
	<div id="AreaContainer">
		<c:forEach items="${area}" var="Area">
			<div id="${Area.getEnglishName() }" class="Areas ${Area.getKoreanName() } ${Area.getEnglishName()}">
				<input type="hidden" class="EnglishName" value="${Area.getEnglishName() }">
				<input type="hidden" class="KoreanName" value="${Area.getKoreanName() }">
				<img src="${path }/resources/img/area/seoul.png"/>
				<h2>${Area.getKoreanName() }, ${Area.getEnglishName() }</h2>
			</div>
		</c:forEach>
	</div>
</div>
<%@include file="./includes/footer.jsp" %>
</body>
</html>