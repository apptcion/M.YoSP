<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 작성</title>
<link href="<c:url value="/resources/css/write.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function(){
	$("#header>#menus>li>a").css("color", "black");
	$("#back").click(function(){
		console.log("test");
		history.back();
	})
	
	$("#enroll").click(function(){
		if($("#title>input").val().trim().length != 0 && $("#Content>textarea").val().trim().length != 0){
			
			$.ajax({
			url : 'posting',
			data : {
				title : $("#title>input").val(),
				content : $("#Content>textarea").val(),
				area : $("#local").val()
			},
			success : function(result){
				history.back();
			}
		})
		}
	})
	
	$("#title>input").keyup(function(){
		$("#title>p").css("color","");
		$("#title>p").empty();
		if($(this).val().length >= 10){
			$("#title>p").append("10자/10자")
			$("#title>p").css("color","red");
			$(this).blur();
		}else{
			$("#title>p").append($(this).val().length + "자/10자")
		}
	})
	
	$("#Content>textarea").keyup(function(){
		$("#Content>p").css("color","")
		$("#Content>p").empty();
		if($(this).val().length >= 1000){
			$("#Content>p").append("1000자/1000자");
			$("#Content>p").css("color","red");
			$(this).blur();
		}else{
			$("#Content>p").append($(this).val().length +"자/1000자")
		}
	})
})
</script>
</head>
<body>
<%@include file="../includes/header.jsp"%>
<div id="ContentWrap">
	<div id="InputWrap">
		<div id="WriteHeader">
		<button id="back"><div id="X"></div></button>
			<div id="SiteName">
				Trip, Travel Route Itinerary Planner
			</div>
			<button id="enroll">등록</button>
		</div>
		<div id="WriteWrap">
			<div id="title">
				<input placeholder="제목" maxlength="10">
				<p>0자/10자</p>
			</div>
			<div id="Content">
				<textarea placeholder="내용을 입력하세요" maxlength="1000"></textarea>
				<p>0자/1000자</p>
			</div>
		</div>
		<div id="resources">
				<input type="file" name="file">
			
		</div>
		<div id="Category">
			<p>관련 지역</p>
			<select id="local">
				<c:forEach items="${area }" var="area">
					<option value="${area.getEnglishName() }"><c:out value="${area.getKoreanName() }"/></option>
				</c:forEach>
				
			</select>
		</div>
	</div>
</div>
<%@include file="../includes/footer.jsp" %>
</body>
</html>