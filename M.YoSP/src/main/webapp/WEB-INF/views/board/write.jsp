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
<title>게시물 작성</title>
<link href="<c:url value="/resources/css/write.css" />" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

var count = 1;

var forOb = [];
forOb[0] = '';

var formData = new FormData();
	function readFile(file,num){
		var reader = new FileReader();
		reader.onload = function(e){ $('.imgNum' + num).attr('src', e.target.result); }
		reader.readAsDataURL(file);
		forOb[num] = file;
		console.log(forOb)
	}



	$(function() {
		$("#header>#menus>li>a").css("color", "black");
		$("#back").click(function() {
			console.log("test");
			history.back();
		})

		var regex = new RegExp("(.*?)\.(exe|sh|zip|txt|alz|js)$");
		var maxSize = 20971500 //20MB;
		var csrf = $("#csrf");

		$("#enroll")
				.click(
						function() {
							if ($("#title>input").val().trim().length != 0
									&& $("#Content>textarea").val().trim().length != 0) {

								formData.append("title", $("#title>input")
										.val());
								formData.append("content", $(
										"#Content>textarea").val());
								formData.append("area", $("#local").val());
								formData.append(csrf.attr("name"), csrf.val())
								
								forOb.forEach(function(file){
									if(file != ''){
										formData.append("uploadFile",file);
									}
								})

								$.ajax({
									url : 'posting',
									type : 'POST',
									processData : false,
									contentType : false,
									data : formData,
									success : function(result) {
										location.replace("/board")
									}
								})
							}
						})

		$("#title>input").keyup(function() {
			$("#title>p").css("color", "");
			$("#title>p").empty();
			if ($(this).val().length >= 10) {
				$("#title>p").append("10자/10자")
				$("#title>p").css("color", "red");
				$(this).blur();
			} else {
				$("#title>p").append($(this).val().length + "자/10자")
			}
		})

		$("#Content>textarea").keyup(function() {
			$("#Content>p").css("color", "")
			$("#Content>p").empty();
			if ($(this).val().length >= 1000) {
				$("#Content>p").append("1000자/1000자");
				$("#Content>p").css("color", "red");
				$(this).blur();
			} else {
				$("#Content>p").append($(this).val().length + "자/1000자")
			}
		})

		$("#file").change(function(e){
			var arr = jQuery.makeArray(this.files)
			console.log(arr)
			
			arr.forEach(function(file){
	   			$("#imgs").append("<div class='imgWrap' id='WrapId"+ count + "'>")
   	   			$("#WrapId" + count).append("<img class='output imgNum" + count + "'>")
   	   			$("#WrapId" + count).append("<div class='delImg'><button></div>")
				readFile(file,count)
				count++;
			})
		})
		
		
		var fileDrop = document.querySelector(".uploadModal");
		
		fileDrop.addEventListener('drop',function(e){
			e.preventDefault()
			$(this).css("border","dashed 3px #e5e7eb");
   			$("#uploadDiv").css("background-color","black")
   			$("#uploadDiv").css("color","white")
   			var arr = jQuery.makeArray(e.dataTransfer.files);
   			arr.forEach(function(file){
   				var formatType = file.name.substring(file.name.lastIndexOf(".")+1);
   	   			console.log(formatType);
   	   			if(formatType == "jpg" || formatType == "png" || formatType == "gif"){
   	   				readFile(file,count);
   	   				count++;
   	   				$("#imgs").append("<div class='imgWrap' id='WrapId"+ count + "'>")
   	   				$("#WrapId" + count).append("<img class='output imgNum" + count + "'>")
   	   				$("#WrapId" + count).append("<div class='delImg'><button></div>")
   	   			}
   			})
			});
				
		fileDrop.addEventListener('dragover', function(e) {
        	e.preventDefault();
        
    	    var vaild = e.dataTransfer.types.indexOf('Files') >= 0;
    	    $(this).css("border","dashed 3px #a6b6fd")
    	    $("#uploadDiv").css("background-color","#e5e7eb")
    	    $("#uploadDiv").css("color","#a3aab5")
   		 });
   	
   		fileDrop.addEventListener('dragleave', function(e){
   			$(this).css("border","dashed 3px #e5e7eb")
   			$("#uploadDiv").css("background-color","black")
   			$("#uploadDiv").css("color","white")
   		})
   		
   		$("#upload>button").click(function(){
	   			$("#uploadCover").show();
   	   			$(".uploadModal").show();
   		})
   		
   		$("#uploadCover").click(function(){
   			$(this).hide();
   			$(".uploadModal").hide();
   		})
   		
   		$(window).keyup(function(e){
   			if(e.keyCode == 27){
   	   			$("#uploadCover").hide();
   	   			$(".uploadModal").hide();
   			}
   		})
   		$("#close").click(function(){
	   			$("#uploadCover").hide();
   	   			$(".uploadModal").hide();
   		})
   		$("div").on('click','.delImg',function(){
   			$(this).parent().remove();
   			console.log($(this).parent().attr("id").substring(6))
   			console.log(typeof $(this).parent().attr("id").substring(6))
   			forOb[Number($(this).parent().attr("id").substring(6))] = '';
   			console.log(forOb)
   		})
	})
	
	
</script>
</head>
<body>
	<%@include file="../includes/header.jsp"%>
	<div id="ContentWrap">
		<div class="uploadModal">
			<button id="close">
				<div></div>
			</button>
			<label for="file"><div id="uploadDiv">파일 찾기</div></label> <input
				type="file" id="file" multiple accept="image/gif, image/png, image/jpg"> <img id="UploadImg"
				src="/resources/img/upload.png">
			<p>최대 50MB이하, png,jpg,gif 첨부 가능</p>
			<fieldset id="imgs">
				<legend align="center">업로드된 이미지</legend>
			</fieldset>
		</div>
		<div id="uploadCover"></div>
		<div id="InputWrap">
			<div id="WriteHeader">
				<input type="hidden" id="csrf" name="${_csrf.parameterName }"
					value="${_csrf.token }">
				<button id="back">
					<div id="X"></div>
				</button>
				<div id="SiteName">Trip, Travel Route Itinerary Planner</div>
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
			<div id="upload">
				<button>파일 업로드</button>
			</div>
			<div id="Category">
				<p>관련 지역</p>
				<select id="local">
					<c:forEach items="${area }" var="area">
						<option value="${area.getEnglishName() }"><c:out
								value="${area.getKoreanName() }" /></option>
					</c:forEach>
					<option value="etc" selected>기타</option>

				</select>
			</div>
		</div>
	</div>
	<%@include file="../includes/footer.jsp"%>
</body>
</html>