<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function(){
		$("button").click(function(){
			var formData = new FormData();
			var inputFile = $("input[name='multipartFiles']");
			var files = inputFile[0].files;
			
			console.log(files);
			for(var i = 0; i < files.length; i++){
				formData.append("uploadFile",files[i]);
			}
			var csrf = $("#csrf")
			
			formData.append(csrf.attr("name"),csrf.val())
			
			$.ajax({
				url : 'uploadAjaxAction',
				method : 'POST',
				processData : false,
				contentType : false,
				data : formData,
				success : function(result){
					console.log("상겅")
				}
			})
		})
	})
</script>
</head>
<body>
		<div>
			<input type="file" name="multipartFiles" multiple="multiple">
			<input id="csrf" type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
		</div>
		<button>제출</button>
</body>
</html>