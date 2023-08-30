<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
<link href="<c:url value="/resources/css/modify.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function(){
		
	var boardId = $("#BoardId").val();
	
	
	$("#header>#menus>li>a").css("color", "black");
	$("#modify").click(function(){
		if($("#title>input").val().trim().length != 0 && $("#Content>textarea").val().trim().length != 0){
			$.ajax({
				url : "exeModify",
				data : {
					BoardId : boardId,
					Title : $("#title>input").val(),
					Content : $("#Content>textarea").val(),
					local : $("#local").val()
				},
				success : function(){
					location.replace("/board")
				}
			})
		}
	})
	$("#back").click(function(){
		history.back();
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
<input type="hidden" id="BoardId" value="${BoardId }">
<div id="ContentWrap">
	<div id="InputWrap">
		<div id="WriteHeader">
		<button id="back"><div id="X"></div></button>
						<div id="SiteName">
				Trip, Travel Route Itinerary Planner
			</div>
			<button id="modify">수정</button>
		</div>
		<div id="WriteWrap">
			<div id="title">
				<input placeholder="제목" value="${title }" maxlength="10">
				<p>${fn:length(title) }자/10자</p>
			</div>
			<div id="Content">
				<textarea placeholder="내용을 입력하세요" maxlength="1000">${content }</textarea>
				<p>${fn:length(content) }자/1000자</p>
			</div>
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