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
<title>Insert title here</title>
<link href="<c:url value="/resources/css/showMap.css" />"
	rel="stylesheet">
</head>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a4deef496ca0e06141a54eeea561a0d9&libraries=services"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function(){
	let mapParameter = $("#parameter").val();
	
	var lines = [];
	var paths = [];
	var colors = ['#e54b4b','#e5794b','#e5c34b','#4be56d','#4bc9e5','#4b76e5','#b83dbb','#c25540','#58ac15','#153fab']
	
	$("#header>#logo").remove();
	$("#header>#menus>li>a").css("color","black")
	
	var Planlength;
	$.ajax({
		url : 'getMapData',
		method : 'get',
		data : {
			parameter : mapParameter
		},
		success : function(data){
			console.log(data)
			var JsonMapData = jQuery.parseJSON(data)
			
			console.log(JsonMapData)
			
			PlanLength = JsonMapData.length;
			for(var i = 0; i < JsonMapData.length; i++){
				var tmpPath = [];
			
				var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
		        imageSize = new kakao.maps.Size(36, 37)  // 마커 이미지의 크기
		        
		        //Lat = y
		        //Lng = x
		        
				var tempStartPointMarker = new kakao.maps.Marker({
					position : new kakao.maps.LatLng(JsonMapData[i].StartPoint.y, JsonMapData[i].StartPoint.x)
				})
		        
				tmpPath.push(new kakao.maps.LatLng(JsonMapData[i].StartPoint.y, JsonMapData[i].StartPoint.x))
				
				var acts = 0;
				
				for(var i2 = 0; i2 < JsonMapData[i].Acts.length; i2++){
					
					imgOptions =  {
				            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
				            spriteOrigin : new kakao.maps.Point(0, (acts*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
				            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
				        }
				    markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions)
					
					var tempMarker = new kakao.maps.Marker({
						position : new kakao.maps.LatLng(JsonMapData[i].Acts[i2].y, JsonMapData[i].Acts[i2].x),
					})
					
					if(JsonMapData[i].Acts[i2].type != 'hotel'){
						tempMarker.setImage(markerImage)
						acts++;
					}
					
					tempMarker.setMap(map)
					tmpPath.push(new kakao.maps.LatLng(JsonMapData[i].Acts[i2].y, JsonMapData[i].Acts[i2].x))
					
				}
				
				var tempEndPointMarker = new kakao.maps.Marker({
					position : new kakao.maps.LatLng(JsonMapData[i].EndPoint.y, JsonMapData[i].EndPoint.x)
				})
				
				tempEndPointMarker.setMap(map)
				tmpPath.push(new kakao.maps.LatLng(JsonMapData[i].EndPoint.y, JsonMapData[i].EndPoint.x))
			
				tmpLine = new kakao.maps.Polyline({
					map : map,
					path : null,
		    		strokeWeight: 2, // 선의 두께입니다 .
		    			strokeColor: colors[i], // 선의 색깔입니다.
						strokeOpacity: 0.8, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다.
							strokeStyle: 'solid' // 선의 스타일입니다.
				})
				
				paths.push(tmpPath);
				lines.push(tmpLine)
				
				$("#dayList").append('<div class="days sel" id="' + i + '">' + (i+1) + '일차</div>')
				
			}
			
			for(var i = 0; i < lines.length; i++){
				lines[i].setPath(paths[i])
			}
			
			
			
			var HotelArrStr = $("#HotelArr").val();
			var FoodArrStr = $("#FoodArr").val();
			var ActivityArrStr = $("#ActivityArr").val();
			
			var HotelArr = HotelArrStr.split(",")
			var FoodArr = FoodArrStr.split(",")
			var ActivityArr = ActivityArrStr.split(",")
			
			$(".ShowDetail").slideUp(0);
			
			var sumHotel = 0;
			var maxHotel = 0;
			var minHotel = 0;
			for(var i = 0;  i < HotelArr.length; i++){
				sumHotel += Number(HotelArr[i])
				if(Number(HotelArr[i]) > maxHotel){
					maxHotel = Number(HotelArr[i])
				}
				
				if(i == 0 || minHotel > Number(HotelArr[i])){
					minHotel = Number(HotelArr[i])
				}
			}
	
			var sumFood = 0;
			var maxFood = 0;
			var minFood = 0;
			for(var i = 0;  i < FoodArr.length; i++){
				sumFood += Number(FoodArr[i])
			
				if(Number(FoodArr[i]) > maxFood){
					maxFood = Number(FoodArr[i])
				}
				
				if(i == 0 || minFood > Number(FoodArr[i])){
					minFood = Number(FoodArr[i])
				}
			}
			
			var sumActivity = 0;
			var maxActivity = 0;
			var minActivity = 0;
			for(var i = 0;  i < ActivityArr.length; i++){
				sumActivity += Number(ActivityArr[i])
				if(Number(ActivityArr[i]) > maxActivity){
					maxActivity = Number(ActivityArr[i])
				}
				
				if(i == 0 || minActivity > Number(ActivityArr[i])){
					minActivity = Number(ActivityArr[i])
				}
			}
			
			$("#moneySum>p").text(CMSV1(sumActivity + sumHotel + sumFood))
			
			$("#HotelIndiv").text("숙박비 : " + CMSV1(sumHotel) + "원")
			
				$("#HotelDetailAver").text("1박 평균 금액 : " + CMSV1(Math.round(sumHotel / HotelArr.length)))
				$("#HotelDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(maxHotel) + "원");
				$("#HotelDetailLow").text("일일 최소 소비 금액 : " + CMSV1(minHotel) + "원");
			
			
			$("#FoodIndiv").text("식비 : " + CMSV1(sumFood) + "원")
			
				$("#FoodDetailAver").text("1박 평균 금액 : " + CMSV1(Math.round(sumFood / FoodArr.length)))
				$("#FoodDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(maxFood) + "원");
				$("#FoodDetailLow").text("일일 최소 소비 금액 : " + CMSV1(minFood) + "원");
			
			$("#ActiveIndiv").text("활동비 : " + CMSV1(sumActivity) + "원")
			
				$("#ActiveDetailAver").text("1박 평균 금액 : " + CMSV1(Math.round(sumActivity / ActivityArr.length)))
				$("#ActiveDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(maxActivity) + "원");
				$("#ActiveDetailLow").text("일일 최소 소비 금액 : " + CMSV1(minActivity) + "원");
		
			
				
				var tempDate = new Date($("#StartDay").val())
				
				for(var i = 0;i < PlanLength; i++){
					$("#detailSet-rows").append("<div class='detailSet-row' id='DSW" + i + "'></div>")
					$("#DSW" + i).append("<div class='detailSetDate'>" + (tempDate.getMonth() + 1) + "/" + tempDate.getDate() + "</div>")
					$("#DSW" + i).append("<div class='detailSetSum'>" + CMSV1(Number(HotelArr[i]) + Number(FoodArr[i]) + Number(ActivityArr[i])) + "원</div>")
					
					
					var StartTimeStr = "";
					console.log(String(JsonMapData[i].StartTime.Hour).length)
					if(String(JsonMapData[i].StartTime.Hour).length == 1){
						StartTimeStr += "0" + JsonMapData[i].StartTime.Hour	
					}else{
						StartTimeStr += JsonMapData[i].StartTime.Hour
					}
					StartTimeStr += ":"
					if(String(JsonMapData[i].StartTime.min).length == 1){
						StartTimeStr += "0" + JsonMapData[i].StartTime.min;
					}else{
						StartTimeStr += "0" + JsonMapData[i].StartTime.min;
					}
					
					var EndTimeStr = "";
					
					if(String(JsonMapData[i].EndTime.Hour).length == 1){
						EndTimeStr += "0" + JsonMapData[i].EndTime.Hour	
					}else{
						EndTimeStr += JsonMapData[i].EndTime.Hour
					}
					EndTimeStr += ":"
					if(String(JsonMapData[i].EndTime.min).length == 1){
						EndTimeStr += "0" + JsonMapData[i].EndTime.min;
					}else{
						EndTimeStr += "0" + JsonMapData[i].EndTime.min;
					}
					
					$("#DSW" + i).append("<div class='detailSetStart'>" + StartTimeStr + "</div>")
					$("#DSW" + i).append("<div class='detailSetEnd'>" + EndTimeStr + "</div>")
					$("#DSW" + i).append("<div class='detailSet-scroll'></div>");
					$("#originSetDetail").clone().removeAttr("id").addClass('SetDetail').appendTo("#DSW" + i)
				
					$("#DSW" + i + " .Food_Detail").text(CMSV1(FoodArr[i]) + "원")
					$("#DSW" + i + " .Activity_Detail").text(CMSV1(ActivityArr[i]) + "원")
					$("#DSW" + i + " .Hotel_Detail").text(CMSV1(HotelArr[i]) + "원")			
					
					tempDate.setDate(tempDate.getDate() + 1)
					
				}
				
				
				
				$(".SetDetail").slideUp(0)
				
		},
		error : function(){
			alert("존재하지 않는 지도입니다")
		}
	})
	
	String.prototype.insertAt = function(index,str){
		return this.slice(0,index) + str + this.slice(index)
	};
	
	String.prototype.reverse = function(){
		var splitString = this.split("");
		var reverseArray = splitString.reverse();
		var joinArray = reverseArray.join("");
		
		return joinArray;
	}
	
	function CMSV1(OriginNum){

		var NumLength = String(OriginNum).length;
		var NumStr = String(OriginNum).reverse();
		var LeaveLength = NumLength;
		var count = 1;
		
		while(LeaveLength > 3){
			NumStr = NumStr.insertAt(count * 3 + (count-1),",");
			count++;
			LeaveLength = LeaveLength - 3;
		}
		return NumStr.reverse();
	} // 10000 to 10,000
	
	$(document).on('click','div[class*=scroll-btn]',function(){
		
		if($(this).attr("class").includes("statusDown")){

			$(this).siblings(".ShowDetail").slideUp(50);
			$(this).parent().css("margin-top","0px")
			$(this).removeClass("statusDown")
		}else{
			
			$(this).addClass("statusDown");
			$(this).siblings(".ShowDetail").slideDown(50);
			$(this).parent().css("margin-top","10px")
		}
	})
	
			$(document).on('click','div[class*=detailSet-scroll]',function(){
			if(!$(this).attr("class").includes("statusDown")){ // ^ 상태라면
				$(this).siblings(".SetDetail").slideDown(50);
				$(this).parent().css("margin-top","10px")
				$(this).addClass("statusDown")
			}else{
				$(this).siblings(".SetDetail").slideUp(50);
				$(this).parent().css("margin-top","0px")
				$(this).removeClass("statusDown")			
			}
		})
		
		$(document).on('click','div[class*=sel]',function(){
			var id = Number($(this).attr("id"));
			$(this).removeClass("sel");
			$(this).addClass("nosel");
			lines[id].setMap(null);
		})
		
		$(document).on('click','div[class*=nosel]',function(){
			var id = Number($(this).attr("id"));
			$(this).removeClass("nosel");
			$(this).addClass("sel");
			lines[id].setMap(map)
		})
	
		$(document).on('click','#share',function(){
			var url = '';
			var textarea = document.createElement("textarea");
			document.body.appendChild(textarea);
			url = window.document.location.href;
			textarea.value = url;
			textarea.select();
			document.execCommand("copy");
			document.body.removeChild(textarea);
			alert("클립보드에 복사되었습니다")
		})
		
		$(document).on('click','.slideSVG',function(){
		if($("#showBudget").css("display") != 'none'){
			$("#showBudget").hide();
			$(".slideSVG>path").attr("d","M23 15 l 15 15 l -15 15");
			$("#slideToLeft").css("left","0px")
		}else{
			$("#showBudget").show();
			$(".slideSVG>path").attr("d","M38 15 l -15 15 l 15 15");
			$("#slideToLeft").css("left","465px")
				
		}
	})
})
</script>
<body>
<%@include file="includes/header.jsp"%>
	<main>
		<input id="parameter" value='${parameter }' type="hidden">
		 <input type="hidden" id="lng" value="${local.getLng() }"> 
		 <input type="hidden" id="lat" value="${local.getLat() }">
		 <input type="hidden" id="HotelArr" value="${HotelArr }">
		 <input type="hidden" id="FoodArr" value="${FoodArr }"> 
		 <input type="hidden" id="ActivityArr" value="${ActivityArr }">
		 <input type="hidden" id="StartDay" value="${StartDay }">


		<div id="showBudget">

			<div id="result">
				<div id="moneySum">
					총 합계 :
					<p></p>
					원
				</div>
				<div id="moneyIndiv">
					<ul>
						<li id="HotelIndiv"></li>
						<li id="FoodIndiv"></li>
						<li id="ActiveIndiv"></li>
					</ul>
				</div>

				<div id="Usedetail">
					<div id="HotelDetail" class="DetailExpense">
						<div id="HotelDetailTitle">숙박비</div>
						<div class="scroll-btn"></div>

						<div id="HotelShowDetail" class="ShowDetail">
							<div id="HotelDetailAver" class="DetailAver"></div>
							<div id="HotelDetailHeight" class="DetailHeight"></div>
							<div id="HotelDetailLow" class="DetailLow"></div>
						</div>

					</div>
					<div id="FoodDetail" class="DetailExpense">
						<div id="FoodDetailTitle">식사비</div>
						<div class="scroll-btn"></div>

						<div id="FoodShowDetail" class="ShowDetail">

							<div id="FoodDetailAver" class="DetailAver"></div>
							<div id="FoodDetailHeight" class="DetailHeight"></div>
							<div id="FoodDetailLow" class="DetailLow"></div>
						</div>

					</div>
					<div id="ActiveDetail" class="DetailExpense">
						<div id="ActiveDetailTitle">활동비</div>
						<div class="scroll-btn"></div>

						<div id="ActiveShowDetail" class="ShowDetail">
							<div id="ActiveDetailAver" class="DetailAver"></div>
							<div id="ActiveDetailHeight" class="DetailHeight"></div>
							<div id="ActiveDetailLow" class="DetailLow"></div>
						</div>

					</div>

				</div>
				<!-- For CLone -->
				<div id="originSetDetail">
					<div class="SetDetail-Hotel">
						숙박비 : <div class="Hotel_Detail" ></div>
					</div>
					<div class="SetDetail-Food">
						식사비 : <div class="Food_Detail"></div>
					</div>
					<div class="SetDetail-Activity">
						활동비 : <div class="Activity_Detail"></div>
					</div>
				</div>
				<!-- End For Clone -->
				<div id="detailSet">
					<div id="detailSet-header">
						<div id="detailSet-Date">일자</div>
						<div id="detailSet-Sum">사용금액</div>
						<div id="detailSet-Start">일정 시작</div>
						<div id="detailSet-End">일정 종료</div>
					</div>
					<div id="detailSet-rows"></div>


				</div>
				<div id="share">공유하기</div>
			</div>
		</div>
										<div id="slideToLeft">
							<div id="slideCircle">
								<svg class="slideSVG">
										<path d="M38 15 l -15 15 l 15 15" fill="transparent"
										stroke="white" stroke-width="3"></path>
									</svg>
							</div>
						</div>
		<div id="map"></div>
		<div id="dayList"></div>
	</main>
</body>

<script>

	var mapContainer = document.getElementById('map');
	let CenterLng = $("#lng").val();
	let CenterLat = $("#lat").val();
	mapOption = {
			center : new kakao.maps.LatLng(CenterLat, CenterLng), // 지도의 중심좌표
			level : 5
		// 지도의 확대 레벨
		};
	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
</script>
</html>