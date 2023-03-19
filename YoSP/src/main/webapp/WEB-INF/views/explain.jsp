<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>YoSP</title>
    <link href="<c:url value="/resources/css/explain.css" />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/> 
    <script src="http://code.jquery.com/jquery-latest.js"></script>
 	<script src="${path}/resources/js/explain.js"></script>


</head>
	<% session = request.getSession();%>
	<% String id =  (String)session.getAttribute("id");%>
<body>
	<div id="head">
			<ul>
				<li class="HeadList" id="logo"><a href="/yosp/"><img src="<c:url value='/resources/img/logo.png'/>" style="width : 200px; height : 50px;">Your Special Planner</a></li>
				<div id="menu">
					<a href="warning"><li class="HeadList"> <h4>여행후기</h4>  </li></a>
					<a href="explain"><li class="HeadList"> <h4> YoSP </h4> </li></a>
					<li class="HeadList"><h4>
						<%if(id==null){ %>
							<a href="login">로그인</a> 
						<%}else{ %>
							<a href="logout"><%out.println(id+"님"); %></a>
					
						<%} %>
					</h4></li>
				</div>
			</ul>
	</div>
	<div id="Content">
		<div id="back">
			<div id="Name">
				<h1>YoSP</h1>
				<p>Your Special Planner</p>
			</div>
			<div id="line"></div>
			<div id="descriptions">
			<h2>목록</h2>
				<ol>
					<li>사이트의 목적</li>
					<li>사이트의 구성</li>
					<li>사이트의 사용법</li>
				</ol>
			
			</div>
		</div>
		<a id="arrow"></a>
		<div id="mainContent">
			<div id="purpose">
			<div class="title"><div class="bar purpose"></div>	
				<h1>사이트 목적</h1>
			</div>
			<hr>
			<div class="content">
				<h3>손쉽게 짤수 있는 여행 일정</h3>
				<br><br>
				간단하게 여행일정을 짤 수 있도록 하고 싶었습니다.<br>
				<br>
				사용자가 광고가 아닌 실제 리뷰만을 보고 여행지를 결정하고,<br>
				오래 이동하지 않도록 사용자들의 다양한 리뷰와 최적화된 경로를 제공합니다.<br>
				<br>
				이 사이트만을 이용하여 편리하게 여행할 수 있습니다.
				
				
			</div>
			
			</div>
		
			<div id="composition">
				<div class="title"><div class="bar composition"></div>
					<h1>사이트 구성</h1>
				</div>
				<hr>
				<div class="content">
					<h3>간단하고 편리한 구성</h3>
					<ul>
						<li><a href="/yosp">메인화면</a></li><br>
						<li>
						회원관련
							<ol>
								<br>
								<li><a href="/yosp/login">로그인</a></li>
								<li><a href="/yosp/join">회원가입</a></li>
								<li><a href="/yosp/secession">회원탈퇴</a></li>
								<li><a href="/yosp/FindPW">비밀번호 복구</a></li>
							</ol>
						</li><br>
						<li>
							메인기능
							<ol>
								<br>
								<li><a href="/yosp/planner">여행 일정</a></li>
								<li><a href="board">여행 리뷰</a></li>
							</ol>
						</li><br>
						<li><a href="/yosp/explain">YoSP 설명</a></li>
					</ul>
					<div id="text">
							편리하게 사용할 수 있도록 사이트 페이지를 간단하게 구성하였습니다.<br>
							<br>
							<h5>메인기능,설명 그리고 로그인 관련,</h5>
							<br>
							이 3가지 기능만으로 사이트를 구성하여 누구든 사용할 수 있습니다.
						
					
					</div>
				</div>
			</div>
			
			<div id="manual">
				<div class="title"><div class="bar manual"></div>
					<h1>사이트 사용법</h1>
				</div>
				<hr>
				<div class="content">
					<h3>빠르고 쉬운 사용</h3>
					
						<div id=text>
							<h4>1. 커뮤니티를 통한 여행지 선정</h4>
							<div>
								만약 여행지를 정하지 않았거나 구체적인 장소들을 정하지 않으셧다면<br>
								커뮤니티를 통해 사용자들의 실제 리뷰를 보고 정하실 수 있습니다.<br>
								<br>
								커뮤티니의 글들은 지역,장소,긍정평가,부정평가 등등 카테고리로 분류되어 쉽게 원하는 정보를 얻을 수 있습니다.<br>
								<br>
								로그인 없이도 글을 볼 수 있어 간단하게 정보만 얻어 갈 수 도 있습니다.<br>
								<br>
								단, 글쓰기,댓글,추천/비추천 등은 로그인 후 이용하실수 있습니다
							</div><br>
							<h4>2. 여행 일정 만들기</h4>
							<div>
								여행지와 구체적인 장소들을 정하셨다면, <a href="/yosp/planner">여행계획 페이지</a>로 이동하여<br>
								여행지, 여행일수, 어떤 숙소에 언제 묵을지, 몇번째 날에 어디를 갈지를 정해주세요,<br>
								그 후에 여행 일정 생성 버튼을 누르면 YoSP가 가장 최적화된 경로를 만들어 줍니다.<br>
								<br>
								생성된 경로는 이미지로 다운로드 받을 수 있습니다.<br>
								<br>
								해당 과정에서 로그인은 필요하지 않지만, 로그인 한다면 My Page에서 해당경로를 이후에도 다운받을수 있습니다
							
							</div>
						</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>