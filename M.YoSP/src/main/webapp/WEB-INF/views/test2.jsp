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
	
	
	var fileDrop = document.querySelector('.drop');
	
    fileDrop.addEventListener('drop', function(e) {
    	e.preventDefault();
 		
    });
	
   	fileDrop.addEventListener('dragover', function(e) {
        e.preventDefault();
        
        var vaild = e.dataTransfer.types.indexOf('Files') >= 0;
        $(this).css("border","dashed 1.5px green")
    });
   	
   	fileDrop.addEventListener('dragleave', function(e){
   		$(this).css("border","dashed 1.5px black")
   	})
})
</script>
</head>
<style>
	.drop{
		width : 400px;
		height : 400px;
		border : solid 1px black;
	
	}

</style>
<body>

				<div class="drop">
				<input type="file" name="file" id="file" multiple>
				</div>
			
</body>
</html>