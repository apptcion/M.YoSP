<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>여행 플래너  - Trip</title>
    <link href="<c:url value="/resources/css/home.css" />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/> 
    <script src="resources/js/jquery-3.6.4.min.js"></script>
 	<script src="${path}/resources/js/home.js"></script>
</head>
<body>
	<div class="MainPage">
		<div class="Content">
				<%@include file="../views/includes/header.jsp" %>
			<div class="Background">
				<video muted autoplay loop>
					<source src="<c:url value='/resources/video/Bg.mp4'/>" type="video/mp4">
				</video>
				
			</div>
			<div class="SceneContainer">
				<div class="SceneOutput">
					<ul id="ScenesList">
						<li  id="Scene1"><div class="Scenes" id="First">
							<div id="start">
								&nbsp;&nbsp;<div id="tit"><img src="<c:url value='/resources/img/logo2.png'/>"></div>
		    					<p id="ex">이미 이용하신 적이 있니요?</p>
		    					<a href="CreateMap" class="travel"> 
         							<span>여행하기</span>
     	 							<div class="transition"></div>
    							</a>
    							<a id="f" style="font-weight : bold">처음이라면? 3단계 간단 설명보기 &darr;</a>
	 						</div>
					
						</div></li>
						<li id="Scene2"><div class="Scenes steps" id="Second">
							<fieldset>
							<legend><h1 class="animate__animated">Step 1</h1></legend>
							<p class="animate__animated">
									여행 계획의 시작 단계입니다.<br>
									설명을 다 들은 후,<br>
									여행버튼을 클릭하면 여행지 선택화면으로 넘어갈 수 있습니다<br>
									그곳에서 여행하고 싶은 곳을 선택해주세요.<br>
									여행지 목록은 국내 여행지만 있습니다.<br>
									 어디로 갈지 정하지 못하셨다면,<br>
									상단의 여행 리뷰를 확인하여  여러 의견을 보고 결정하셔도 좋습니다.
							</p>
							</fieldset>
						</div></li>
						<li id="Scene3"><div class="Scenes steps" id="Thrid">
						<fieldset>
						<legend><h1 class="animate__animated">Step 2</h1></legend>
							<p class="animate__animated">
							        여행 계획을 세우는 두 번째 단계입니다.<br>
						   	        여행지를 선택한 후 해당 여행지의 지도를 보면서<br>
				           	        총 여행 일수, 가고 싶은 장소, 식당 그리고 숙소를 선택해주세요.<br>
					                           이것 또한 마찬가지로 상단의 여행 리뷰를 이용하셔도 됩니다.<br>
						                 단, 여행 날짜와 숙박 일수는 일치해야 합니다.
								</p>
								</fieldset>
						</div></li>
						<li id="Scene4"><div class="Scenes steps" id="Fourth">
						<fieldset>
						<legend><h1 class="animate__animated">Step 3</h1></legend>
							<p class="animate__animated">
								여행계획을 세우는 마지막 단계입니다.<br>
								요셉(yosp)이 입력한 정보를 바탕으로 가장 최적화된 경로를 만들어줍니다.<br>
								마음에 들지 않는다면 원하는 대로 경로를 수정할 수 있습니다.<br>
								모든 수정이 완료된다면 이미지로 내려받을다운로드 할 수 있습니다.<br>
								로그인은 필수가 아니지만 로그인한시 이전에 만든 경로를 언제든지 다운로드받을 수 있습니다.
							</p>
							</fieldset>
						</div></li>
						<li id="Scene5"><div class="Scenes">
							<div id="ToPlanContainer">
								<fieldset id="T">
								<img src="<c:url value='/resources/img/jeju.jpg' />">
								<p>
									사용방법을 잘 익히셨으면 좋겠네요<br><br>
								
									YoSP에서는 여행 날짜, 갈려고 하는 곳, 묵으려고 하는 호텔만 정하면 경로를 자동으로 만듭니다.<br><br>
									또한 그러한 여행정보 또한 같이 제공하여 사용자의 편의를 우선시 했습니다<br>
								    
									
									이제 한번 여행 계획을 짜러 가볼까요?<br><br>
								
									당신만의 특별한 계획, YoSP
								
								</p>
								<a  href="/yosp/planner" class="ToPlan"> 
         							<span>계획하러 가기</span>
     	 							<div class="transition"></div>
    							</a>
    							</fieldset>
    						</div>
						</div></li>
					</ul>
				</div>
			</div>
		
		</div>
	
	
	</div>
	
</body>
</html>
