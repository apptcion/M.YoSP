<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="/board/exUploadPost" method="post" enctype="multipart/form-data">
	
		<div>
			<input type="file" name="files">
		</div>
		<input type="hidden" name="${_csrf.parameterName }" value="${ _csrf.token}" />
		<div>
			<input type="submit">
		</div>
	</form>
</body>
</html>