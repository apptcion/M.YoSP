<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function() {
	$("#logout").trigger("click");
});

</script>
<form method="post" action="/login/logout">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
           <button type="submit" id="logout">로그아웃</button>
    </form>
</body>
</html>