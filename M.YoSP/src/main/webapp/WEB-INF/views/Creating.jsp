<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trip - ${local.getKoreanName() }</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a4deef496ca0e06141a54eeea561a0d9&libraries=services"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {
		
		var sumTime = "총 12시간 0분"

		var CalSelisRun = false;
		var Core;
		var Ass;

		var SE = [ "StartTime", "EndTime" ];
		var HM = [ "Hour", "min" ]

		var PlanSt;
		var PlanLs;

		var averActivity;
		var averFood;
		var averHotel;

		var SumExpense = 0;
		var averSumExpense;
		
		var HotelExpense,HotelExpenseMax;
		var StartingPointstr;
		var foodExpense,foodExpenseMax;
		var activityExpense,activityExpenseMax;

		var Hotel_max;
		var Hotel_min;
		
		var Food_max;
		var Food_min;
		
		var Activity_max;
		var Activity_min;
		
		var HotelArr = [];
		var FoodArr = [];
		var ActivityArr = [];
		
		var StartCity;
		
		var finInitNumber = false;
		
		let nowDate = new Date();
		var LeftDate = new Date();
		var RightDate = initRightDate();
		ShowCalendar();

		var StartDay = LeftDate.getFullYear() + ". "
				+ (LeftDate.getMonth() + 1) + "." + LeftDate.getDate();
		var EndDay = LeftDate.getFullYear() + ". " + (LeftDate.getMonth() + 1)
				+ ". " + LeftDate.getDate();

		var PlObjArr = [];
		PlObjArr[0] = '';

		var GMFA;
		
		let gasoline = 1873;
		let diesel = 1780;
		let LPG = 1454;
		let CNG =  820;

		$("#period").append(StartDay + " - " + EndDay)
		$("#sumTime").append(sumTime)

		$("#step1, #step2, #step3").click(function() {
			
			$(".select").addClass("noSel")
			$(".select").removeClass("select")
			
			$("#StepImplList").children().hide();
			
			var go = $(this).attr('id').substring(4)
			
			
			switch(go){
			case '1':
				$("#ChDate").show();
				break;
			case '2':
				$("#Chcash").show();
				break;
			case '3':
				createStep3();
				$("#addPlace").show();
				break;
			}

			$(this).removeClass("noSel")
			$(this).addClass("select")
		})
		
		
		
		
		$("#detailSet-complete").click(function(){
			$("#step2").removeClass("select")
			$("#step2").addClass("noSel")
			
			$("#step3").addClass("select")
			$("#step3").removeClass("noSel")
			createStep3();
			$("#Chcash").hide();
			$("#addPlace").show();
		})
		
		$('#next').click(function(){
			var go = Number($(".select").attr('id').substring(4)) + 1;
			
			$("#StepImplList").children().hide();
			$(".select").addClass("noSel")
			$(".select").removeClass("select")
			
			
			switch(go){
			case 4: // 3 + 1 TODO /////////////////////////////////
				$("#ChDate").show();
				$("#step1").removeClass("noSel")
				$("#step1").addClass("select")
				break;
			case 2:
				$("#Chcash").show();
				$("#step2").removeClass("noSel")
				$("#step2").addClass("select")
				break;
			case 3:
				createStep3();
				$("#addPlace").show();
				$("#step3").removeClass("noSel")
				$("#step3").addClass("select")
				
				break;
			}
			
		})
		
		function canCreatePlan(){
			if(typeof HotelExpense == 'undefined' || typeof foodExpense == 'undefined' || typeof activityExpense == 'undefined'){
				return false;
			}else if(typeof StartingPointstr == 'undefined'){
				return false;
			}else{
				return true;
			}
		}
		
		function createStep3(){
			
			if($("#traffic>input").val() != '' && finInitNumber){
				
				addPlaceObjArr = [];
				for(var i = 0; i < dayMarkers.length; i++){
					for(var i2 = 0; i2 < dayMarkers[i]['Activitymarkers'].length; i2++){
						dayMarkers[i]['Activitymarkers'][i2].setMap(null);
					}
					for(var i2 = 0; i2 < dayMarkers[i]['Foodmarkers'].length; i2++){
						dayMarkers[i]['Foodmarkers'][i2].setMap(null);
					}
					
					for(var i2 = 0; i2 < dayMarkers[i]['Hotelmarkers'].length; i2++){
						dayMarkers[i]['Hotelmarkers'][i2].setMap(null);
					}
				}
				dayMarkers = [];
				
				$("#addPlaceColumns").empty();
				$("#showList").empty();
				
				$("#creMapWrap").remove();
				
				$("#Plperiod").text(StartDay + " - " + EndDay);
				
				var tempDate = new Date(StartDay)
				for(var i = 1;i < PlObjArr.length;i++){
					var thisaPCB = $("#addPlaceOrigin>.addPlaceColumnBody").clone().attr('id','aPCB' + i).appendTo("#addPlaceColumns")
					
					
					
					
					$(thisaPCB).children(".plainInfo").children(".PlDayInfo").text((tempDate.getMonth() +1)+ "/" + tempDate.getDate())

					$(thisaPCB).children(".detailInfo").children(".HotelExp").children("p").text(CMSV1(HotelArr[i-1]) + "원")
					$(thisaPCB).children(".detailInfo").children(".FoodExp").children("p").text(CMSV1(FoodArr[i-1]) + "원")
					$(thisaPCB).children(".detailInfo").children(".ActivityExp").children("p").text(CMSV1(ActivityArr[i-1]) + "원")

					$("#ShowPlaceOrigin").clone().attr('id','SHC' + i).addClass("SHC").appendTo("#showList")
					$("#SHC" + i).children().children('.ShowPlaceDate').text((tempDate.getMonth() + 1) + "." + tempDate.getDate() + " (" + getKoreanDay(tempDate.getDay()) + ")")
					
					addPlaceObjArr.push(cre_addPlaceObj(tempDate,i-1,null,null,null,null,[null,null,null,null,null]));
					dayMarkers.push(cre_dayMarkers([],[],[]));
					
					
					tempDate.setDate(tempDate.getDate() + 1)
				}
				LoadMarker('Hotelmarkers');
				
				
				$("#addPlace>#showLeft").append("<div id='creMapWrap'><div id='creMap'>지도 생성하기</div></div>")
			}else{
				alert("이전 설정부터 완료해주세요")
			}
			
		}
		
		$(document).on('click','#creMap',function(){
			
			if(CheckPlan()){
					if(confirm("일정은 위쪽부터 순서대로 만들어집니다. 진행하시겠습니까?")){
						var SortedPlan = SortPlanArr();
					}else{
						alert("일정 생성이 취소되었습니다")	
					}
			}else{
				alert("날짜당 1개의 숙소, 3개의 식당, 1개 이상의 관광지를 선택해주세요")
			}
		})
		
		function SortPlanArr(){
			
			//PlObjArr, addPlaceObjArr
			
			PlObjArr.shift();
			
			var resultArr = [];
			
			for(var i = 0; i < PlObjArr.length; i++){
				var dayActs = [];
				resultArr[i] = {
						'StartPoint' : addPlaceObjArr[i]['HotelObj'].placeData,
						'Acts' : dayActs
				}
				
				if(i + 1 != PlObjArr.length || PlObjArr.length == 1){
					resultArr[i].endPoint = addPlaceObjArr[i + 1]['HotelObj'].placeData;
				}else{
					resultArr[i].endPoint = null;
				}
				
				var tempHour = PlObjArr[i].EndTime.Hour - PlObjArr[i].StartTime.Hour;
				if (PlObjArr[i].StartTime.min > PlObjArr[i].EndTime.min) {
					tempHour--;
					min = PlObjArr[i].EndTime.min + (60 - PlObjArr[i].StartTime.min)
				} else {
					min = PlObjArr[i].EndTime.min - PlObjArr[i].StartTime.min;
				}
				
				tempMin = tempHour * 60 + min;
				
				resultArr[i].time = tempMin;
				
				if(PlObjArr[i].StartTime.Hour <= 5){
					
					if(addPlaceObjArr[i]['ActivityObj']){
						
					}
					
				}else if(5 <  PlObjArr[i].StartTime.Hour <= 9){
					
				}else if(9 < PlObjArr[i].StartTime.Hour <= 3){
					
				}else{
					
				}
				
				
			}
			
			console.log(resultArr)
			
			
			
			console.log(PlObjArr)
			//TODO
			
			return true;
			
		}
		
		function CheckPlan(){
			for(var i = 0; i < addPlaceObjArr.length; i++){
				var Activity = false;
				var Food = false;
				var Hotel = false;
				
				if(addPlaceObjArr[i]['HotelObj'].placeData != null){
					Hotel = true;
				}
				
				if(addPlaceObjArr[i]['FoodObj']['breakfast'] != null || addPlaceObjArr[i]['FoodObj']['lunch']  != null || addPlaceObjArr[i]['FoodObj']['dinner'] != null ){
					Food = true;
				}
				
				for(var i2 = 0; i2 < addPlaceObjArr[i]['ActivityObj']['placeDataArr'].length; i2++){
					if(addPlaceObjArr[i]['ActivityObj']['placeDataArr'][i2] != null){
						Activity = true;
					}
				}
				
				if(!Hotel || !Food || !Activity) return false;
				
			}
			
			
			return true;
		}
		
		
		$(document).on('click','div[class*=addPlaceScroll]',function(){
			if($(this).attr("class").includes("statusDown")){
				$(this).removeClass("statusDown")
				$(this).siblings(".detailInfo").slideUp(50)
				$(this).parent().css("height","20px")
				$(this).parent().css("margin-top","5px")
			}else{
				$(this).addClass("statusDown")
				$(this).parent().css("height","auto")
				$(this).parent().css("margin-top","10px")
				$(this).siblings(".detailInfo").slideDown(50)
			}
			
		})
		
		$(document).on('click','div[class=addHotelBody]',function(){
			var thisaPCBID = $(this).parent().parent().parent().attr('id').substring(4)
			
			$("#showList").children().hide();
			$("#SHC" + thisaPCBID).show();
			
			$("#SHC" + thisaPCBID).children().hide();
			$("#SHC" + thisaPCBID + ">.ShowHotel").show();
			
			SearchCategoryCode = 'AD5' // 숙박
			SHCID = thisaPCBID;
			LoadMarker('Hotelmarkers');
		})
		
		$(document).on('click','div[class=addFoodBody]',function(){
			var thisaPCBID = $(this).parent().parent().parent().attr('id').substring(4)
			
			$("#showList").children().hide();
			$("#SHC" + thisaPCBID).show();

			$("#SHC" + thisaPCBID).children().hide();
			$("#SHC" + thisaPCBID + ">.ShowFood").show();
			
			SearchCategoryCode = 'FD6' // 음식점
			SHCID = thisaPCBID;
			LoadMarker('Foodmarkers');
		})

		$(document).on('click','div[class*=addActivityPlaceBody]',function(){
			var thisaPCBID = $(this).parent().parent().parent().attr('id').substring(4)
			
			$("#showList").children().hide();
			$("#SHC" + thisaPCBID).show();
			
			$("#SHC" + thisaPCBID).children().hide();
			$("#SHC" + thisaPCBID + ">.ShowActivity").show();
			
			SearchCategoryCode = 'anything'
			SHCID = thisaPCBID;
			LoadMarker('Activitymarkers');
		})
		
		
		$("#goPrev").click(function() {
			if (!isMin()) {
				RightDate.setFullYear(LeftDate.getFullYear());
				RightDate.setMonth(LeftDate.getMonth());

				if (LeftDate.getMonth == 1) {
					LeftDate.setFullYear(LeftDate.getFullYear() - 1);
					LeftDate.setMonth(11);
				} else {
					LeftDate.setMonth(LeftDate.getMonth() - 1)
				}

				ShowCalendar();

				if (isMin()) {
					$(this).css("border-color", "#cccccc");
				}
				CanSelisRun = false;
				Core = 0;
				Ass = 0;
				PlanSt = 0;
				PlanLs = 0;
			}

		})

		
		
		$("#goNext").click(function() {
			LeftDate.setFullYear(RightDate.getFullYear());
			LeftDate.setMonth(RightDate.getMonth());

			if (RightDate.getMonth() == 11) {
				RightDate.setFullYear(RightDate.getFullYear() + 1);
				RightDate.setMonth(0)
			} else {
				RightDate.setMonth(RightDate.getMonth() + 1);
			}

			$("#goPrev").css("border-color", "black");
			ShowCalendar();

			CanSelisRun = false;
			Core = 0;
			Ass = 0;
			PlanSt = 0;
			PlanLs = 0;
		})

		function initRightDate() {
			return new Date(LeftDate.getFullYear(), (LeftDate.getMonth() + 1),
					LeftDate.getDate());
		}

		function getKoreanDay(num) {
			var result = '';
			switch (num) {
			case 0:
				result = "일"
				break;
			case 1:
				result = "월"
				break;
			case 2:
				result = "화"
				break;
			case 3:
				result = "수"
				break;
			case 4:
				result = "목"
				break;
			case 5:
				result = "금"
				break;
			case 6:
				result = "토"
				break;
			}
			return result;
		}

		function getEnglishDay(num) {
			var result = '';
			switch (num) {
			case 0:
				result = "sun"
				break;
			case 1:
				result = "mon"
				break;
			case 2:
				result = "tus"
				break;
			case 3:
				result = "wen"
				break;
			case 4:
				result = "thu"
				break;
			case 5:
				result = "fri"
				break;
			case 6:
				result = "sat"
				break;
			}
			return result;
		}

		function isMin() {
			if (nowDate.getFullYear() == LeftDate.getFullYear()) {
				if (nowDate.getMonth() == LeftDate.getMonth()) {
					return true;
				}
				return false;
			}
			return false;
		}

		function getLast(wDate) {

			if (wDate.getMonth() == 1) {
				if (wDate.getFullYear() % 4 == 0) {
					if (wDate.getFullYear() % 100 == 0) {
						if (wDate.getFullYear() % 400 == 0) {
							return 29;
						} else {
							return 28;
						}
					} else {
						return 29;
					}
				} else {
					return 28;
				}
			}

			if (((wDate.getMonth() + 1) <= 6 && (wDate.getMonth() + 1) % 2 == 1)
					|| ((wDate.getMonth() + 1) > 6 && (wDate.getMonth() + 1) % 2 == 0)) {
				return 31;
			} else {

				return 30;
			}
		}

		function ShowCalendar() {
			$("#leftY").html(
					LeftDate.getFullYear() + "년 " + (LeftDate.getMonth() + 1)
							+ "월");
			$("#rightY").html(
					RightDate.getFullYear() + "년" + (RightDate.getMonth() + 1)
							+ "월");
			var LeftLast = getLast(LeftDate);
			var LeftLine;
			var LeftStart = new Date(LeftDate.getFullYear(), LeftDate
					.getMonth(), 1).getDay();

			if (LeftLast == 31) {

				if (new Date(LeftDate.getFullYear(), LeftDate.getMonth(), 1)
						.getDay() == 5
						|| new Date(LeftDate.getFullYear(),
								LeftDate.getMonth(), 1).getDay() == 6) {
					LeftLine = 6;
				} else {
					LeftLine = 5;
				}

			} else if (LeftLast == 30) {

				if (new Date(LeftDate.getFullYear(), LeftDate.getMonth(), 1)
						.getDay() == 6) {
					LeftLine = 6;
				} else {
					LeftLine = 5;
				}

			} else if (LeftLast == 29) {
				LeftLine = 5;

			} else {
				if (new Date(LeftDate.getFullYear(), LeftDate.getMonth(), 1)
						.getDay() != 1) {
					LeftLine = 5;
				} else {
					LeftLine = 4;
				}
			}

			$("#Ldate").empty();
			var LeftDayNum = 1;
			$("#Ldate").append("<div class='Lweek' id='Lweek1'></div>")
			for (var First = 1; First <= 7; First++) {
				if (First > LeftStart) {

					if (First == 1) {
						$("#Lweek1")
								.append(
										"<div class='DayDiv sun normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>");
					} else if (First == 7) {
						$("#Lweek1")
								.append(
										"<div class='DayDiv sat normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>");
					} else {
						$("#Lweek1")
								.append(
										"<div class='DayDiv normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>");
					}
					LeftDayNum++;
				} else {
					$("#Lweek1").append("<div class='DayDiv'></div>")
				}
			}

			for (var week = 2; week < (LeftLine); week++) {
				$("#Ldate").append(
						"<div class='Lweek' id='Lweek" + week+ "'></div>")
				for (var fromTwo = 1; fromTwo <= 7; fromTwo++) {
					if (fromTwo == 1) {
						$("#Lweek" + week)
								.append(
										"<div class='DayDiv sun normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>")
					} else if (fromTwo == 7) {
						$("#Lweek" + week)
								.append(
										"<div class='DayDiv sat normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>");
					} else {
						$("#Lweek" + week)
								.append(
										"<div class='DayDiv normal L' id='L"
												+ LeftDayNum
												+ "' name='"
												+ CNL(new Date(LeftDate
														.getFullYear(),
														LeftDate.getMonth(),
														LeftDayNum)) + "'>"
												+ LeftDayNum + "</div>");
					}
					LeftDayNum++;
				}
			}

			$("#Ldate").append(
					"<div class='Lweek' id='Lweek" + LeftLine+ "'></div>")
			for (var last = 1; LeftDayNum <= LeftLast; last++) {
				if (last == 1) {
					$("#Lweek" + LeftLine).append(
							"<div class='DayDiv sun normal L' id='L"
									+ LeftDayNum
									+ "' name='"
									+ CNL(new Date(LeftDate.getFullYear(),
											LeftDate.getMonth(), LeftDayNum))
									+ "'>" + LeftDayNum + "</div>")
				} else if (last == 7) {
					$("#Lweek" + LeftLine).append(
							"<div class='DayDiv sat normal L' id='L"
									+ LeftDayNum
									+ "' name='"
									+ CNL(new Date(LeftDate.getFullYear(),
											LeftDate.getMonth(), LeftDayNum))
									+ "'>" + LeftDayNum + "</div>");
				} else {
					$("#Lweek" + LeftLine).append(
							"<div class='DayDiv normal L' id='L"
									+ LeftDayNum
									+ "' name='"
									+ CNL(new Date(LeftDate.getFullYear(),
											LeftDate.getMonth(), LeftDayNum))
									+ "'>" + LeftDayNum + "</div>");
				}
				LeftDayNum++;
			}

			var RightLast = getLast(RightDate);
			var RightLine;
			var RightStart = new Date(RightDate.getFullYear(), RightDate
					.getMonth(), 1).getDay();

			if (RightLast == 31) {

				if (new Date(RightDate.getFullYear(), RightDate.getMonth(), 1)
						.getDay() == 5
						|| new Date(RightDate.getFullYear(), RightDate
								.getMonth(), 1).getDay() == 6) {
					RightLine = 6;
				} else {
					RightLine = 5;
				}

			} else if (RightLast == 30) {

				if (new Date(RightDate.getFullYear(), RightDate.getMonth(), 1)
						.getDay() == 6) {
					RightLine = 6;
				} else {
					RightLine = 5;
				}

			} else if (RightLast == 29) {
				RightLine = 5;

			} else {
				if (new Date(RightDate.getFullYear(), RightDate.getMonth(), 1)
						.getDay() != 1) {
					RightLine = 5;
				} else {
					RightLine = 4;
				}
			}

			$("#Rdate").empty();
			var RightDayNum = 1;

			$("#Rdate").append("<div class='Rweek' id='Rweek1'></div>")
			for (var First = 1; First <= 7; First++) {
				if (First > RightStart) {

					if (First == 1) {
						$("#Rweek1").append(
								"<div class='DayDiv sun normal R' id='R"
										+ RightDayNum
										+ "' name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>");
					} else if (First == 7) {
						$("#Rweek1").append(
								"<div class='DayDiv sat normal R' id='R"
										+ RightDayNum
										+ "' name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>");
					} else {
						$("#Rweek1").append(
								"<div class='DayDiv normal R' id='R"
										+ RightDayNum
										+ "' name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>");
					}
					RightDayNum++;
				} else {
					$("#Rweek1").append("<div class='DayDiv'></div>")
				}
			}

			for (var week = 2; week < RightLine; week++) {
				$("#Rdate").append(
						"<div class='Rweek' id='Rweek" + week+ "'></div>")
				for (var fromTwo = 1; fromTwo <= 7; fromTwo++) {
					if (fromTwo == 1) {
						$("#Rweek" + week).append(
								"<div class='DayDiv sun normal R' id='R"
										+ RightDayNum
										+ "'  name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>")
					} else if (fromTwo == 7) {
						$("#Rweek" + week).append(
								"<div class='DayDiv sat normal R' id='R"
										+ RightDayNum
										+ "'  name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>");
					} else {
						$("#Rweek" + week).append(
								"<div class='DayDiv normal R' id='R"
										+ RightDayNum
										+ "'  name='"
										+ CNL(new Date(RightDate.getFullYear(),
												RightDate.getMonth(),
												RightDayNum)) + "'>"
										+ RightDayNum + "</div>");
					}
					RightDayNum++;
				}
			}

			$("#Rdate").append(
					"<div class='Rweek' id='Rweek" + RightLine+ "'></div>")
			for (var last = 1; RightDayNum <= RightLast; last++) {
				if (last == 1) {
					$("#Rweek" + RightLine).append(
							"<div class='DayDiv sun normal R' id='R"
									+ RightDayNum
									+ "' name='"
									+ CNL(new Date(RightDate.getFullYear(),
											RightDate.getMonth(), RightDayNum))
									+ "'>" + RightDayNum + "</div>")
				} else if (last == 7) {
					$("#Rweek" + RightLine).append(
							"<div class='DayDiv sat normal R' id='R"
									+ RightDayNum
									+ "' name='"
									+ CNL(new Date(RightDate.getFullYear(),
											RightDate.getMonth(), RightDayNum))
									+ "'>" + RightDayNum + "</div>");
				} else {
					$("#Rweek" + RightLine).append(
							"<div class='DayDiv normal R' id='R"
									+ RightDayNum
									+ "' name='"
									+ CNL(new Date(RightDate.getFullYear(),
											RightDate.getMonth(), RightDayNum))
									+ "'>" + RightDayNum + "</div>");
				}
				RightDayNum++;
			}

			if (LeftDate.getFullYear() == nowDate.getFullYear()
					&& LeftDate.getMonth() == nowDate.getMonth()) {
				for (var i = 1; i < nowDate.getDate(); i++) {
					$("#L" + i).addClass("AbsNoSel");
					$("#L" + i).removeClass("normal")
				}
			}
		}

		$(document)
				.on(
						'click',
						'div[class*=normal]',
						function() {
							if ($(".SelCore").length == 0) {
								$(this).addClass("dirSel SelCore Sel")
								$(this).removeClass("normal")
								var CanSelSt = Number($(this).attr("id")
										.substring(1)) - 9;
								var CanSelLs = Number($(this).attr("id")
										.substring(1)) + 9;
								var OverFlowSel = 0;
								var DownFlowSel = getLast(LeftDate) + 1;

								if ($(this).attr("class").includes("L")) {
									var site = "L";
									Core = CNL(new Date(LeftDate.getFullYear(),
											LeftDate.getMonth(), $(this).attr(
													"id").substring(1)));
								} else {
									var site = "R";
									Core = CNL(new Date(
											RightDate.getFullYear(), RightDate
													.getMonth(), $(this).attr(
													"id").substring(1)));
								}

								if (site == "L") {
									if (CanSelSt < $(".AbsNoSel").length) {
										CanSelSt = nowDate.getDate();
									}
								} else {
									if (CanSelSt < 10) {
										if (CanSelSt < 1) {
											CanSelSt = 1;
										}
										DownFlowSel = getLast(LeftDate)
												- (9 - Number($(this)
														.attr("id")
														.substring(1)));
									}

									if (CanSelLs > getLast(RightDate)) {
										CanSelLs = getLast(RightDate);
									}
								}

								if (site == "L") {
									if (CanSelLs > getLast(LeftDate)) {

										OverFlowSel = CanSelLs
												- getLast(LeftDate)
										CanSelLs = getLast(LeftDate);
									}
								} else {
									if (CanSelLs > getLast(RightDate)) {

										OverFlowSel = CalSelLs
												- getLast(RightDate)
										CanSelLs = getLast(RightDate);
									}

								}
								//---------------------------------------------------------------------------

								if (site == "L") {
									for (var i = CanSelLs + 1; i <= getLast(LeftDate); i++) {
										$("#L" + i).addClass("RelNoSel");
									}// 선택 후

									for (var i = OverFlowSel + 1; i <= getLast(RightDate); i++) {
										$("#R" + i).addClass("RelNoSel");
									}//다음달;

									for (var i = $(".AbsNoSel").length + 1; i < CanSelSt; i++) {
										$("#L" + i).addClass("RelNoSel")
									} //선택 전
								} else {
									for (var i = CanSelLs + 1; i <= getLast(RightDate); i++) {
										$("#R" + i).addClass("RelNoSel");
									} // 선택 후
									for (var i = 1; i < CanSelSt; i++) {
										$("#R" + i).addClass("RelNoSel")
									}// 선택 전
									for (var i = 1; i < DownFlowSel; i++) {
										$("#L" + i).addClass("RelNoSel")
									}

									$(".RelNoSel").removeClass("normal")
								}
								CalSelisRun = true;
								$(".RelNoSel").removeClass("normal")
							}
						})

		$(document).on('mouseover', 'div[class*=normal]', function() {
			if (CalSelisRun) {
				var assD = Number($(this).attr("name"));
				if (Core - assD > 0) {
					PlanSt = assD;
					PlanLs = Core;
				} else if (Core - assD <= 0) {
					PlanSt = Core;
					PlanLs = assD;
				}
				CreateIndir();
			}
		})

		$(document).on('mouseleave', 'div[class*=indirSel]', function() {
			if (CalSelisRun) {
				DelIndir();
			}
		})

		$(document).on('click', 'div[class*=SelCore]', function() {
			if (!CalSelisRun) {
				$(".indirSel").addClass("normal")
				$(".indirSel").removeClass("Sel indirSel")

				$(".SelCore").addClass("normal")
				if (!$(this).attr("class").includes("SelAss")) {
					$(".SelCore").removeClass("SelCore")
				}

				$(".SelAss").addClass("normal");
				$(".SelAss").removeClass("SelAss")

				$(".RelNoSel").addClass("normal")
				$(".RelNoSel").removeClass("RelNoSel")

				$(".Sel").removeClass("Sel")
				$(".dirSel").removeClass("dirSel")

				$("#sub-btn").removeClass("pass")

			} else {
				$(this).addClass("SelAss");
				PlanSt = Core;
				PlanLs = Core;
				CalSelisRun = false;

				$("#sub-btn").addClass("pass")
			}
		})

		$(document).on('click', 'div[class*=SelAss]', function() {
			DelIndir();
			if ($(this).attr("class").includes("SelCore")) {
				$(this).addClass("normal")
				$(this).removeClass("Sel SelAss dirSel SelCore");
				Core = 0;
				PlanSt = 0;
				PlanLs = 0;

				CalSelisRun = false;
			} else {
				$(this).addClass("normal")
				$(this).removeClass("SelAss dirSel Sel")
				CalSelisRun = true;
				CreateIndir();
			}
			$("#sub-btn").removeClass("pass")
		})

		$(document).on('click', 'div[class*=indirSel]', function() {
			CalSelisRun = false;
			$(this).addClass("dirSel SelAss");
			$(this).removeClass("indirSel")
			$("#sub-btn").addClass("pass")
		})

		$(document)
				.on(
						'click',
						'button[id=sub-btn]',
						function() {

							if ($(this).attr("class").includes("pass")) {
								var PlanLen = $(".Sel").length

								$("#cover").hide();

								PlanSt = String(PlanSt)
								PlanLs = String(PlanLs)

								$("#PlanDetail").empty();

								if (PlanSt[6] == '0') {
									StartDay = PlanSt.substring(0, 4) + "."
											+ PlanSt.substring(4, 6) + "."
											+ PlanSt.substring(7)
								} else {
									StartDay = PlanSt.substring(0, 4) + "."
											+ PlanSt.substring(4, 6) + "."
											+ PlanSt.substring(6, 8)
								}

								if (PlanLs[6] == '0') {
									EndDay = PlanLs.substring(0, 4) + "."
											+ PlanLs.substring(4, 6) + "."
											+ PlanLs.substring(7);
								} else {
									EndDay = PlanLs.substring(0, 4) + "."
											+ PlanLs.substring(4, 6) + "."
											+ PlanLs.substring(6, 8);
								}

								PlanStDate = new Date(StartDay)
								PlanLsDate = new Date(EndDay)

								$("#period")
										.html(
												StartDay
														+ " - "
														+ EndDay
														+ "<img id='calImg' src='/resources/img/calendar.png'>")
								var tempDate = new Date(StartDay);
								tempDate.setDate(tempDate.getDate() - 1)

								for (var i = 1; i <= PlanLen; i++) {
									tempDate.setDate(tempDate.getDate() + 1);

									$("#PlanDetail")
											.append(
													"<div class='PlanWeekWrap' id='PWW" + i +"'></div>")
									$("#PWW" + i)
											.append(
													"<div class='day'>"
															+ (tempDate
																	.getMonth() + 1)
															+ "/"
															+ tempDate
																	.getDate()
															+ "</div>"
															+ "<div class='week'>"
															+ getKoreanDay(tempDate
																	.getDay())
															+ "</div>"
															+ "<div class='stT'>10:00<img class='clockImg start' src='/resources/img/clock.png'></div>"
															+ "<div class='fnT'>22:00<img class='clockImg end' src='/resources/img/clock.png'></div>")

									PlObjArr[i] = cre_plObject(10, 0, 22, 0);

								}

								setSumTime();
							} else {
								alert("날짜를 선택해주세요")
							}
						})

		$(document).on('click', 'img[class*=clockImg]', function() {

			var PwwId = $(this).parent().parent().attr("id").substring(3);
			var plObj = PlObjArr[PwwId];

			var H;
			var M;

			$(this).addClass("altering")

			if ($(this).attr("class").includes("start")) {
				H = plObj[SE[0]][HM[0]];
				M = plObj[SE[0]][HM[1]];

				$("#timeSet").addClass("start")
			} else {
				$("#timeSet").addClass("end")

				H = plObj[SE[1]][HM[0]];
				M = plObj[SE[1]][HM[1]];

			}

			$("#H" + H).addClass("HtimeSetSel")
			$("#M" + M).addClass("MtimeSetSel")

			$("#timeSetCover").show();
			$("#timeSet").css("display", "flex");

			$("#HList").scrollTop((H - 1) * 68)
			$("#MList").scrollTop((M - 1) * 68)

		})

		$(document).on('click', 'div[class*=HSel]', function() {
			if ($(this).attr("class").includes("HtimeSetSel")) {
				$(this).removeClass("HtimeSetSel")
			} else {
				$(".HtimeSetSel").removeClass("HtimeSetSel")
				$(this).addClass("HtimeSetSel")
			}
		})

		$(document).on('click', 'div[class*=MSel]', function() {
			if ($(this).attr("class").includes("MtimeSetSel")) {
				$(this).removeClass("MtimeSetSel")
			} else {

				$(".MtimeSetSel").removeClass("MtimeSetSel")
				$(this).addClass("MtimeSetSel")
			}
		})

		$(document)
				.on(
						'click',
						'div[id=apply-btn]',
						function() {
							if ($(this).parent().parent().attr("class")
									.includes("start")) {

								var stH = Number($(".HtimeSetSel").attr("id")
										.substring(1));
								var stM = Number($(".MtimeSetSel").attr("id")
										.substring(1));

								var PwwId = $(".altering").parent().parent()
										.attr("id").substring(3);
								var plObj = PlObjArr[PwwId]

								var endH = plObj[SE[1]][HM[0]];
								var endM = plObj[SE[1]][HM[1]];

								if (canChange(stH, stM, endH, endM)) {
									var newPlobj = initTimeObj(stH, stM)

									PlObjArr[PwwId][SE[0]] = newPlobj;

									$("#timeSetCover").hide();
									$("#timeSet").hide();

									var stHstr;
									if (String(stH).length == 1) {
										stHstr = "0" + String(stH)
									} else {
										stHstr = String(stH)
									}

									var stMstr;
									if (String(stM).length == 1) {
										stMstr = "0" + String(stM)
									} else {
										stMstr = String(stM)
									}
									$("#PWW" + PwwId)
											.children(".stT")
											.html(
													stHstr
															+ ":"
															+ stMstr
															+ "<img class='clockImg start' src='/resources/img/clock.png'>");
									$(".HtimeSetSel")
											.removeClass("HtimeSetSel")
									$(".MtimeSetSel")
											.removeClass("MtimeSetSel")
									$("#timeSet").removeClass("start")

									setSumTime();
								} else {
									alert("시작 시간은 종료시간 전이어야 합니다")
								}
							} else {
								var endH = Number($(".HtimeSetSel").attr("id")
										.substring(1));
								var endM = Number($(".MtimeSetSel").attr("id")
										.substring(1));

								var PwwId = $(".altering").parent().parent()
										.attr("id").substring(3);
								var plObj = PlObjArr[PwwId]

								var stH = plObj[SE[0]][HM[0]];
								var stM = plObj[SE[0]][HM[1]];

								if (canChange(stH, stM, endH, endM)) {
									var newPlobj = initTimeObj(endH, endM);
									PlObjArr[PwwId][SE[1]] = newPlobj;

									$("#timeSetCover").hide();
									$("#timeSet").hide();

									var endHstr;
									if (String(endH).length == 1) {
										endHstr = "0" + String(endH)
									} else {
										endHstr = String(endH)
									}

									var endMstr;
									if (String(endM).length == 1) {
										endMstr = "0" + String(endM);
									} else {
										endMstr = String(endM)
									}

									$("#PWW" + PwwId)
											.children(".fnT")
											.html(
													endHstr
															+ ":"
															+ endMstr
															+ "<img class='clockImg end' src='/resources/img/clock.png'>")
									$(".HtimeSetSel")
											.removeClass("HtimeSetSel")
									$(".MtimeSetSel")
											.removeClass("MtimeSetSel")
									$("#timeSet").removeClass("end")

									setSumTime();

								} else {
									alert("종료 시간은 시작시간 후여야 합니다")
								}
							}
						})

		$(document).on('click', '#timeSetCover', function() {
			$("#timeSetCover").hide();
			$("#timeSet").hide();

			$(".HtimeSetSel").removeClass("HtimeSetSel")
			$(".MtimeSetSel").removeClass("MtimeSetSel")
			$("#timeSet").removeClass("end start")

		})

		$(window).on('keyup', function(e) {
			if (e.keyCode == 27) {
				$("#timeSetCover").hide();
				$("#timeSet").hide();

				$(".HtimeSetSel").removeClass("HtimeSetSel")
				$(".MtimeSetSel").removeClass("MtimeSetSel")
				$("#timeSet").removeClass("end")
			}
		})

		function canChange(stH, stM, endH, endM) {
			if (stH < endH) {
				return true;
			} else if (stH == endH) {
				if (stM < endM) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

		$(document).on('click', 'img[id=calImg]', function() { // 캘린더 초기화
			CalSelisRun = false;
			Core = 0;
			Ass = 0;

			PlanSt = 0;
			PlanLs = 0;

			nowDate = new Date();
			LeftDate = new Date();
			RightDate = initRightDate();

			PlObjArr.length = 0;
			PlObjArr[0] = '';

			$("#cover").show();

			$(".pass").removeClass("pass");

			$("#setting").show();
			$("#result").hide();
			
			
			ShowCalendar();
		})

		function compar(Date1, Date2) {
			if (Date1.getFullYear() > Date2.getFullYear()) {
				return 1;
			} else if (Date1.getFullYear() == Date2.getFullYear()) {
				if (Date1.getMonth() > Date2.getMonth()) {
					return 1;
				} else if (Date1.getMonth() == Date2.getMonth()) {
					if (Date1.getDate() > Date2.getDate()) {
						return 1
					} else if (Date1.getDate() == Date2.getDate()) {
						return 0;
					} else {
						return -1;
					}
				} else {
					return -1;
				}
			} else {
				return -1;
			}
		}

		function CNL(Date) {
			var year = String(Date.getFullYear());
			var month = String(Date.getMonth() + 1);
			var date = String(Date.getDate());

			if (month.length == 1) {
				month = "0" + month;
			}

			if (date.length == 1) {
				date = "0" + date;
			}
			return year + month + date;
		}

		function CreateIndir() {
			for (var i = PlanSt; i <= PlanLs; i++) {
				if ($("div[name=" + i + "]").attr("class")) {
					if ($("div[name=" + i + "]").attr("class").includes(
							"normal")) {

						$("div[name=" + i + "]").addClass("indirSel Sel")
					}
				}
			}
			$(".indirSel").removeClass("normal")
		}

		function DelIndir() {
			$(".indirSel").addClass("normal");
			$(".indirSel").removeClass("indirSel Sel")
		}

		function TimeObject() {
			var Hour, min;
		}

		function initTimeObj(Hour, min) {
			var temp = new TimeObject();
			temp.Hour = Hour;
			temp.min = min;

			return temp;
		}

		function plObject() {
			var StartTime, EndTime;
		}

		function cre_plObject(StH, StM, EtH, EtM) {
			var temp = new plObject()
			temp.StartTime = initTimeObj(StH, StM);
			temp.EndTime = initTimeObj(EtH, EtM);

			return temp;
		}

		function setSumTime() {
			var Hour = 0;
			var min = 0;
			for (var i = 1; i < PlObjArr.length; i++) {

				var PlObj = PlObjArr[i];

				var StH = PlObj[SE[0]][HM[0]];
				var EtH = PlObj[SE[1]][HM[0]];

				var StM = PlObj[SE[0]][HM[1]]
				var EtM = PlObj[SE[1]][HM[1]]

				Hour += (EtH - StH);
				if (StM > EtM) {
					Hour--;
					min += (EtM + (60 - StM));
				} else {
					min += (EtM - StM)
				}
			}

			if (min >= 60) {
				Hour += Math.floor(min / 60);
				min = min % 60;
			}

			sumTime = "총 " + Hour + "시간 " + min + "분"

			$("#sumTime").text(sumTime)
		}

		$(document).on('click', 'div[id=SetFinish-btn]', function() {
			if($("#traffic>input").val().length != 0){
				
				finInitNumber = true;
				HotelExpense = Number($("#hotel>input").val());
				StartingPointstr = $("#traffic>input").val();
				foodExpense = Number($("#food>input").val());
				activityExpense = Number($("#activity>input").val())

				var StartPointX;
				var StartPointY;
				
				var geocoder = new kakao.maps.services.Geocoder();
				
				geocoder.addressSearch(StartingPointstr, function(result, status) {
					if (status == kakao.maps.services.Status.OK) {
		
						GMFA = getMeter4Arrive(result[0].x,result[0].y);
						var carType = $("#traffic>select").val();
						GMFA.then(data =>{
							if(carType == '승용차'){
								var L = (data/24300)
							}else{
								var L = (data/33100)
							}
							
							
							$("#gasoline").text("가솔린(휘발유) 기준 : " + CMSV1(Math.round(L * gasoline))+ "원")
							$("#diesel").text("디젤(경유) 기준 : " + CMSV1(Math.round(L * diesel))+"원")
							$("#LPG").text("LPG기준 : " + CMSV1(Math.round(L * LPG)) + "원")
							$("#CNG").text( "CNG기준 : " + CMSV1(Math.round(L * CNG)) +  "원")
						})
					} else {
						alert("주소를 확인해주세요")
					}
				})
				
				if(HotelExpense == null) HotelExpense = 0; 
				if(foodExpense == null) foodExpense = 0;
				if(activityExpense == null) activityExpense = 0;
				
				HotelExpenseMax = HotelExpense;
				foodExpenseMax = foodExpense;
				activityExpenseMax = activityExpense;
				
				SumExpense = HotelExpense + foodExpense + activityExpense;
				
				$("#HotelIndiv").text("숙박비 : " + CMSV1(HotelExpense) + "원 (최대 " + CMSV1(HotelExpenseMax) + "원)")
				$("#FoodIndiv").text("식비 : " + CMSV1(foodExpense) + "원 (최대 " + CMSV1(foodExpenseMax) + "원)")
				$("#ActiveIndiv").text("활동비 : " + CMSV1(activityExpense) + "원 (최대 " + CMSV1(activityExpenseMax) + "원)")
				var PlDayLen = PlObjArr.length;
				
				if(PlDayLen == 2) PlDayLen = 3;
				
				averActivity = Math.round(activityExpense / (PlDayLen - 1))

				averFood = Math.round(foodExpense / (PlDayLen -1))

				averHotel = Math.round(HotelExpense / (PlDayLen - 2))

				averSumExpense = averFood + averActivity + averHotel;
				
				Hotel_max = Math.round(averHotel)
				Hotel_min = Math.round(averHotel)
				
				Activity_max = Math.round(averActivity)
				Activity_min = Math.round(averActivity)
				
				Food_max = Math.round(averFood)
				Food_min = Math.round(averFood)
				
				HotelArr.length = PlDayLen - 2;
				FoodArr.length = PlDayLen - 2;
				ActivityArr.length = PlDayLen - 3;
				
				$("#HotelDetailAver").text("1박 평균 금액 : " + CMSV1(averHotel) + "원")
				$("#HotelDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(averHotel) + "원")
				$("#HotelDetailLow").text("일일 최소 소비 금액 : " + CMSV1(averHotel) + "원")
				
				$("#FoodDetailAver").text("하루 평균 금액 : " + CMSV1(averFood) + "원")
				$("#FoodDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(averFood) + "원");
				$("#FoodDetailLow").text("일일 최소 소비 금액 : " + CMSV1(averFood) + "원");
				
				$("#ActiveDetailAver").text("하루 평균 금액 : " + CMSV1(averActivity) + "원")
				$("#ActiveDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(averActivity) + "원");
				$("#ActiveDetailLow").text("일일 최소 소비 금액 : " + CMSV1(averActivity) + "원");

				$("#detailSet-rows").empty();
				
				var tempDate = new Date(StartDay);
				
				for(var i = 1;i < PlObjArr.length; i++){
					$("#detailSet-rows").append("<div class='detailSet-row' id='DSW" + i + "'></div>")
					$("#DSW" + i).append("<div class='detailSetDate'>" + (tempDate.getMonth() + 1) + "/" + tempDate.getDate() + "</div>")
					$("#DSW" + i).append("<div class='detailSetSum'>" + CMSV1(averSumExpense) + "원</div>")
					$("#DSW" + i).append("<div class='detailSet-scroll'></div>");
					$("#originSetDetail").clone().removeAttr("id").addClass('SetDetail').appendTo("#DSW" + i)
				
					$(".Food_Detail_input").val(averFood)
					$(".Activity_Detail_input").val(averActivity)
					$(".Hotel_Detail_input").val(averHotel)			
					
					HotelArr[i-1] = Math.round(averHotel);
					FoodArr[i-1] = Math.round(averFood);
					ActivityArr[i-1] = Math.round(averActivity);
					
					if(i == (PlObjArr.length-1) && PlObjArr.length != 2){
						$("#DSW" + i + ">.SetDetail>.SetDetail-Hotel>.Hotel_Detail_input").val("0");
						$("#DSW" + i + ">.SetDetail>.SetDetail-Hotel>.Hotel_Detail_input").attr("disabled",true)
						$("#DSW" + i + ">.detailSetSum").text(CMSV1(averFood + averActivity)+ "원")
						HotelArr[i-1] = 0;
					}
					
					
					tempDate.setDate(tempDate.getDate() + 1)
				}
				
				$(".SetDetail").slideUp(0);
				
				$("#setting").hide();

				$("#moneySum>p").text(CMSV1(SumExpense))
				$(".ShowDetail").slideUp(0);
				$("#result").show();
			}else{
				
				alert("존재하지 않는 주소입니다");
			}
			////////////////
		})
		
		$('#Reset>a').click(function(){
			
			$("#hotel>input").val()
			
			$(".statusDown").siblings(".ShowDetail").slideUp(0)
			
			$(".statusDown").removeClass("statusDown")
			
			$("#setting").show();
			$("#result").hide();
		})
		
		
		$(document).on('keyup','input',function(e){
			if(e.keyCode == 38 || e.keyCode == 40){
				$(this).val(0)
			}
		})
		
		$(document).on('keyup','input[class=Hotel_Detail_input]',function(e){
			
			$(this).val(toVaildNumber($(this).val(),e));
			
			var thisDSWID = $(this).parent().parent().parent().attr("id").substring(3);
			
			var HotelSum = 0;

			for(var i =0; i < HotelArr.length; i++){
				if((i+1) != thisDSWID){
					HotelSum = HotelSum + HotelArr[i]
				}
			}
			HotelSum = HotelSum + Number($(this).val())
			if(HotelSum > HotelExpenseMax){
				alert("최대 금액을 초과하였습니다");
				$(this).val(HotelArr[thisDSWID])
			}else{
				
				HotelArr[thisDSWID-1] = Number($(this).val());
				
				var tempHotelArr = [];
				if(HotelArr.length != 1){
					tempHotelArr = HotelArr.slice(0,HotelArr.length-1)
						
				}else{
					tempHotelArr = HotelArr;
				}
				
				Hotel_max = Math.max.apply(null,tempHotelArr);
				$("#HotelDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(Hotel_max) + "원")
				
				Hotel_min = Math.min.apply(null,tempHotelArr);
				$("#HotelDetailLow").text("일일 최소 소비 금액 : " + CMSV1(Hotel_min) + "원")
			
				
				HotelExpense = 0;
				for(var i = 0; i < HotelArr.length;i++){
					HotelExpense = HotelExpense + HotelArr[i]
				}
				averHotel = Math.round(HotelExpense / HotelArr.length);
			
				SumExpense = HotelExpense + foodExpense + activityExpense;
				
				$("#HotelDetailAver").text("1박 평균 금액 : " + CMSV1(averHotel) + "원")
				
				$("#HotelIndiv").text("숙박비 : " + CMSV1(HotelExpense) + "원 (최대 " + CMSV1(HotelExpenseMax) + "원)")
			
				$("#moneySum>p").text(CMSV1(SumExpense))
				
				var tempDetailSetSumExpense = HotelArr[thisDSWID-1] + FoodArr[thisDSWID -1] + ActivityArr[thisDSWID -1]
				$("#DSW" + thisDSWID).children('.detailSetSum').text(CMSV1(tempDetailSetSumExpense) + "원")
			}
		})
		$(document).on('keyup','input[class*=Activity_Detail_input]',function(e){
			$(this).val(toVaildNumber($(this).val(),e));
			
			var thisDSWID = $(this).parent().parent().parent().attr("id").substring(3);
			
			var ActivitySum = 0;

			for(var i =0; i < ActivityArr.length; i++){
				if((i+1) != thisDSWID){
					ActivitySum = ActivitySum + ActivityArr[i]
				}
			}
			ActivitySum = ActivitySum + Number($(this).val())
			
			if(ActivitySum > activityExpenseMax){
				alert("최대 금액을 초과하였습니다");
				$(this).val(ActivityArr[thisDSWID])
			}else{
				
				ActivityArr[thisDSWID-1] = Number($(this).val());
				
				var tempActivityArr = [];
				if(ActivityArr.length != 1){
					tempActivityArr = ActivityArr.slice(0,HotelArr.length-1)
						
				}else{
					tempActivityArr = ActivityArr;
				}
				
				Activity_max = Math.max.apply(null,tempActivityArr);
				$("#ActiveDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(Activity_max) + "원")
				
				Activity_min = Math.min.apply(null,tempActivityArr);
				$("#ActiveDetailLow").text("일일 최소 소비 금액 : " + CMSV1(Activity_min) + "원")
			
				
				activityExpense = 0;
				for(var i = 0; i < ActivityArr.length;i++){
					activityExpense = activityExpense + ActivityArr[i]
				}
				averActivity = Math.round(activityExpense / ActivityArr.length);
			
				SumExpense = HotelExpense + foodExpense + activityExpense;
				
				$("#ActiveDetailAver").text("하루 평균 금액 : " + CMSV1(averActivity) + "원")
				 
				$("#ActiveIndiv").text("활동비 : " + CMSV1(activityExpense) + "원 (최대 " + CMSV1(activityExpenseMax) + "원)")
			
				$("#moneySum>p").text(CMSV1(SumExpense))
				
								var tempDetailSetSumExpense = HotelArr[thisDSWID-1] + FoodArr[thisDSWID -1] + ActivityArr[thisDSWID -1]
				$("#DSW" + thisDSWID).children('.detailSetSum').text(CMSV1(tempDetailSetSumExpense) + "원")
			}
		})
		$(document).on('keyup','input[class*=Food_Detail_input]',function(e){
			$(this).val(toVaildNumber($(this).val(),e));
			
			var thisDSWID = $(this).parent().parent().parent().attr("id").substring(3);
			
			var FoodSum = 0;

			for(var i =0; i < FoodArr.length; i++){
				if((i+1) != thisDSWID){
					FoodSum = FoodSum + FoodArr[i]
				}
			}
			FoodSum = FoodSum + Number($(this).val())
			
			if(FoodSum > foodExpenseMax){
				alert("최대 금액을 초과하였습니다");
				$(this).val(FoodArr[thisDSWID])
			}else{
				
				FoodArr[thisDSWID-1] = Number($(this).val());
				
				var tempFoodArr = [];
				if(FoodArr.length != 1){
					tempFoodArr = FoodArr.slice(0,HotelArr.length-1)
						
				}else{
					tempFoodArr = FoodArr;
				}
				
				Food_max = Math.max.apply(null,tempFoodArr);
				$("#FoodDetailHeight").text("일일 최고 소비 금액 : " + CMSV1(Food_max) + "원")
				
				Food_min = Math.min.apply(null,tempFoodArr);
				$("#FoodDetailLow").text("일일 최소 소비 금액 : " + CMSV1(Food_min) + "원")
			
				
				foodExpense = 0;
				for(var i = 0; i < FoodArr.length;i++){
					foodxpense = foodExpense + FoodArr[i]
				}
				averFood = Math.round(foodExpense / FoodArr.length);
			
				SumExpense = HotelExpense + foodExpense + activityExpense;
				
				$("#FoodDetailAver").text("하루 평균 금액 : " + CMSV1(averFood) + "원")
				 
				$("#FoodIndiv").text("활동비 : " + CMSV1(foodExpense) + "원 (최대 " + CMSV1(foodExpenseMax) + "원)")
			
				$("#moneySum>p").text(CMSV1(SumExpense))
				
								var tempDetailSetSumExpense = HotelArr[thisDSWID-1] + FoodArr[thisDSWID -1] + ActivityArr[thisDSWID -1]
				$("#DSW" + thisDSWID).children('.detailSetSum').text(CMSV1(tempDetailSetSumExpense) + "원")
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
		
		$(document).on('click','#moneySum>p',function(){
			
			$("#hotel>input").val()
			
			$(".statusDown").siblings(".ShowDetail").slideUp(0)
			
			$(".statusDown").removeClass("statusDown")
			
			$("#setting").show();
			$("#result").hide();
		})
		
		$(document).on('keyup','input[class=Setting_input]',function(e){
			$(this).val(toVaildNumber($(this).val(),e));
		})
		
		$(document).on('click','.HotelPlusSVG',function(){
			if(addPlaceObjArr[SHCID -1]['HotelObj']['placeData'] == null){
				
				$("#aPCB" + SHCID + " .addHotelBody").empty();
				
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addHotelBody")
				$("#aPCB" + SHCID + " .addHotelBody").append('<svg class="HotelselectSVGInBody" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
						
				$(this).parent().append('<svg class="HotelselectSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
						
				$("#aPCB" + SHCID + " .addHotelBody .HotelPlusSVG").remove();
				$("#aPCB" + SHCID + " .addHotelBody .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempPlaceData = dayMarkers[SHCID - 1]['Hotelmarkers'][tempIndex - 1];
					addPlaceObjArr[SHCID -1]['HotelObj']['placeData'] = cre_addHotel(tempPlaceData)
				
				$(this).remove();
				
				$("#aPCB" + SHCID + " .addHotelBody").css("border","solid 1px green")
				
				}
		})
		
		$(document).on('click','svg[class*=HotelselectSVG]',function(){
			$("#aPCB" + SHCID + " .addHotelBody").empty();
			$("#aPCB" + SHCID + " .addHotelBody").html('<div class="Plus">'
					+ '<div class="stripe"></div>'
					+ '<div class="rank"></div>'
				+ '</div>')
			$("#aPCB" + SHCID + " .addHotelBody").css("border","dashed 2px #adb5bd")
			$("#SHC" + SHCID + " .HotelselectSVG").parent().append('<svg class="PlusSVG HotelPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
						+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
					+ '</svg>')
			$("#SHC" + SHCID + " .HotelselectSVG").remove();
			addPlaceObjArr[SHCID -1]['HotelObj']['placeData'] = null;
		})
		
		$(document).on('click','.FoodPlusSVG',function(){
			if(addPlaceObjArr[SHCID -1]['FoodObj']['breakfast'] == null){
			
				$("#aPCB" + SHCID + " .addFoodBody>.breakfast").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addFoodBody>.breakfast")
				$("#aPCB" + SHCID + " .addFoodBody>.breakfast").append('<svg class="FoodselectSVGInBody breakfastSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="FoodselectSVG breakfastSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addFoodBody>.breakfast .FoodPlusSVG").remove();
				$("#aPCB" + SHCID + " .addFoodBody>.breakfast .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempBreakFastData = dayMarkers[SHCID - 1]['Foodmarkers'][tempIndex - 1];
				var tempLunchData = addPlaceObjArr[SHCID - 1]['FoodObj']['lunch'];
				var tempDinnerData = addPlaceObjArr[SHCID - 1]['FoodObj']['dinner'];
				addPlaceObjArr[SHCID -1]['FoodObj'] = cre_addFood(tempBreakFastData,tempLunchData,tempDinnerData)
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addFoodBody>.breakfast").css("border","solid 1px green")
				
			}else if(addPlaceObjArr[SHCID -1]['FoodObj']['lunch'] == null){
				
				$("#aPCB" + SHCID + " .addFoodBody>.lunch").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addFoodBody>.lunch")
				$("#aPCB" + SHCID + " .addFoodBody>.lunch").append('<svg class="FoodselectSVGInBody lunchSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="FoodselectSVG lunchSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addFoodBody>.lunch .FoodPlusSVG").remove();
				$("#aPCB" + SHCID + " .addFoodBody>.lunch .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempBreakFastData = addPlaceObjArr[SHCID - 1]['FoodObj']['breakfast'];
				var tempLunchData = dayMarkers[SHCID - 1]['Foodmarkers'][tempIndex - 1];
				var tempDinnerData = addPlaceObjArr[SHCID - 1]['FoodObj']['dinner'];
				addPlaceObjArr[SHCID -1]['FoodObj'] = cre_addFood(tempBreakFastData,tempLunchData,tempDinnerData)
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addFoodBody>.lunch").css("border","solid 1px green")
				
			}else if(addPlaceObjArr[SHCID -1]['FoodObj']['dinner'] == null){
				$("#aPCB" + SHCID + " .addFoodBody>.dinner").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addFoodBody>.dinner")
				$("#aPCB" + SHCID + " .addFoodBody>.dinner").append('<svg class="FoodselectSVGInBody dinnerSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="FoodselectSVG dinnerSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addFoodBody>.dinner .FoodPlusSVG").remove();
				$("#aPCB" + SHCID + " .addFoodBody>.dinner .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempBreakFastData = addPlaceObjArr[SHCID - 1]['FoodObj']['breakfast'];
				var tempLunchData = addPlaceObjArr[SHCID - 1]['FoodObj']['lunch'];
				var tempDinnerData = dayMarkers[SHCID - 1]['Foodmarkers'][tempIndex - 1];
				addPlaceObjArr[SHCID -1]['FoodObj'] = cre_addFood(tempBreakFastData,tempLunchData,tempDinnerData)
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addFoodBody>.dinner").css("border","solid 1px green")
			}
		})
		
		
		$(document).on('click','.breakfastSVG',function(){
			$("#aPCB" + SHCID + " .addFoodBody>.breakfast").empty();
			$("#aPCB" + SHCID + " .addFoodBody>.breakfast").html('<div class="Plus">'
					+ '<div class="stripe"></div>'
					+ '<div class="rank"></div>'
				+ '</div>')
			$("#aPCB" + SHCID + " .addFoodBody>.breakfast").css("border","dashed 2px #adb5bd")
			$("#SHC" + SHCID + " .breakfastSVG").parent().append('<svg class="PlusSVG FoodPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
						+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
					+ '</svg>')
			$("#SHC" + SHCID + " .breakfastSVG").remove();
			addPlaceObjArr[SHCID -1]['FoodObj']['breakfast'] = null;
		})
		
		$(document).on('click','.lunchSVG',function(){
			$("#aPCB" + SHCID + " .addFoodBody>.lunch").empty();
			$("#aPCB" + SHCID + " .addFoodBody>.lunch").html('<div class="Plus">'
					+ '<div class="stripe"></div>'
					+ '<div class="rank"></div>'
				+ '</div>')
			$("#aPCB" + SHCID + " .addFoodBody>.lunch").css("border","dashed 2px #adb5bd")
			$("#SHC" + SHCID + " .lunchSVG").parent().append('<svg class="PlusSVG FoodPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
						+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
					+ '</svg>')
			$("#SHC" + SHCID + " .lunchSVG").remove();
			addPlaceObjArr[SHCID -1]['FoodObj']['lunch'] = null;
		})
		
		$(document).on('click','.dinnerSVG',function(){
			$("#aPCB" + SHCID + " .addFoodBody>.dinner").empty();
			$("#aPCB" + SHCID + " .addFoodBody>.dinner").html('<div class="Plus">'
					+ '<div class="stripe"></div>'
					+ '<div class="rank"></div>'
				+ '</div>')
			$("#aPCB" + SHCID + " .addFoodBody>.dinner").css("border","dashed 2px #adb5bd")
			$("#SHC" + SHCID + " .dinnerSVG").parent().append('<svg class="PlusSVG FoodPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
						+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
					+ '</svg>')
			$("#SHC" + SHCID + " .dinnerSVG").remove();
			addPlaceObjArr[SHCID -1]['FoodObj']['dinner'] = null;
		})
		
		$(document).on('click','.ActivityPlusSVG',function(){
			if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][0] == null){
				
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act1").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addActivityPlaceBody>.act1")
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act1").append('<svg class="ActselectSVGInBody ActSVG1" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="ActselectSVG ActSVG1" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act1 .ActivityPlusSVG").remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act1 .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempAct1 = dayMarkers[SHCID - 1]['Activitymarkers'][tempIndex - 1]
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][0] = tempAct1;
				
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act1").css("border","solid 1px green")
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			
			}else if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][1] == null){
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act2").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addActivityPlaceBody>.act2")
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act2").append('<svg class="ActselectSVGInBody ActSVG2" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="ActselectSVG ActSVG2" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act2 .ActivityPlusSVG").remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act2 .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempAct1 = dayMarkers[SHCID - 1]['Activitymarkers'][tempIndex - 1]
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][1] = tempAct1;
				
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act2").css("border","solid 1px green")
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			
				
			}else if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][2] == null){
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act3").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addActivityPlaceBody>.act3")
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act3").append('<svg class="ActselectSVGInBody ActSVG3" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="ActselectSVG ActSVG3" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act3 .ActivityPlusSVG").remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act3 .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempAct1 = dayMarkers[SHCID - 1]['Activitymarkers'][tempIndex - 1]
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][2] = tempAct1;
				
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act3").css("border","solid 1px green")
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
				
			}else if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][3] == null){
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act4").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addActivityPlaceBody>.act4")
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act4").append('<svg class="ActselectSVGInBody ActSVG4" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="ActselectSVG ActSVG4" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act4 .ActivityPlusSVG").remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act4 .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempAct1 = dayMarkers[SHCID - 1]['Activitymarkers'][tempIndex - 1]
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][3] = tempAct1;
				
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act4").css("border","solid 1px green")
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			
				
			}else if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][4] == null){
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act5").empty();
				
				$(this).parent().clone().appendTo("#aPCB" + SHCID + " .addActivityPlaceBody>.act5")
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act5").append('<svg class="ActselectSVGInBody ActSVG5" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
						+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
						+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
						+ '</svg>')
				$(this).parent().append('<svg class="ActselectSVG ActSVG5" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
					+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="#84d191"/>'
					+ '<path d="M18.6223 9.71611L11.1223 17.2161C11.057 17.2817 10.9794 17.3337 10.8939 17.3692C10.8084 17.4046 10.7168 17.4229 10.6243 17.4229C10.5317 17.4229 10.4401 17.4046 10.3546 17.3692C10.2692 17.3337 10.1915 17.2817 10.1262 17.2161L6.84497 13.9349C6.77957 13.8695 6.72768 13.7918 6.69229 13.7064C6.65689 13.6209 6.63867 13.5293 6.63867 13.4368C6.63867 13.3443 6.65689 13.2527 6.69229 13.1673C6.72768 13.0818 6.77957 13.0042 6.84497 12.9388C6.91037 12.8734 6.98802 12.8215 7.07348 12.7861C7.15893 12.7507 7.25052 12.7325 7.34302 12.7325C7.43551 12.7325 7.5271 12.7507 7.61256 12.7861C7.69801 12.8215 7.77566 12.8734 7.84106 12.9388L10.6249 15.7226L17.6274 8.72119C17.7595 8.5891 17.9386 8.51489 18.1254 8.51489C18.3122 8.51489 18.4914 8.5891 18.6235 8.72119C18.7556 8.85328 18.8298 9.03243 18.8298 9.21924C18.8298 9.40604 18.7556 9.58519 18.6235 9.71728L18.6223 9.71611Z" fill="white"/>'
					+ '</svg>')
					
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act5 .ActivityPlusSVG").remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act5 .phone").remove();
				
				var tempIndex = Number($(this).siblings(".markerbg").attr("class").substring(16));
				var tempAct1 = dayMarkers[SHCID - 1]['Activitymarkers'][tempIndex - 1]
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][4] = tempAct1;
				
				
				$(this).remove();
				$("#aPCB" + SHCID + " .addActivityPlaceBody>.act5").css("border","solid 1px green")
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			
				
			}
			
		})
		
		$(document).on('click','.ActselectSVG, .ActselectSVGInBody',function(){
			if($(this).attr("class").includes("ActSVG1")){
				$("#aPCB" + SHCID + " .act1").empty();
				$("#aPCB" + SHCID + " .act1").html('<div class="Plus">'
						+ '<div class="stripe"></div>'
						+ '<div class="rank"></div>'
					+ '</div>');

				$("#aPCB" + SHCID + " .act1").css("border","dashed 2px #adb5bd")
				
				$("#SHC" + SHCID + " .ActSVG1").parent().append('<svg class="PlusSVG ActivityPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
				+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
				+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
			+ '</svg>')
			
			$("#SHC" + SHCID + " .ActSVG1").remove();
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][0] = null;
			
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
				
				
			}else if($(this).attr("class").includes("ActSVG2")){
				             
				$("#aPCB" + SHCID + " .act2").empty();
				$("#aPCB" + SHCID + " .act2").html('<div class="Plus">'
						+ '<div class="stripe"></div>'
						+ '<div class="rank"></div>'
					+ '</div>');

				$("#aPCB" + SHCID + " .act2").css("border","dashed 2px #adb5bd")
				
				$("#SHC" + SHCID + " .ActSVG2").parent().append('<svg class="PlusSVG ActivityPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
				+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
				+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
			+ '</svg>')
			
			$("#SHC" + SHCID + " .ActSVG2").remove();
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][1] = null;
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
				
			}else if($(this).attr("class").includes("ActSVG3")){
				                                     
				$("#aPCB" + SHCID + " .act3").empty();
				$("#aPCB" + SHCID + " .act3").html('<div class="Plus">'
						+ '<div class="stripe"></div>'
						+ '<div class="rank"></div>'
					+ '</div>');

				$("#aPCB" + SHCID + " .act3").css("border","dashed 2px #adb5bd")
				
				$("#SHC" + SHCID + " .ActSVG3").parent().append('<svg class="PlusSVG ActivityPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
				+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
				+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
			+ '</svg>')
			
			$("#SHC" + SHCID + " .ActSVG3").remove();
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][2] = null;
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			}else if($(this).attr("class").includes("ActSVG4")){
				
				$("#aPCB" + SHCID + " .act4").empty();
				$("#aPCB" + SHCID + " .act4").html('<div class="Plus">'
						+ '<div class="stripe"></div>'
						+ '<div class="rank"></div>'
					+ '</div>');

				$("#aPCB" + SHCID + " .act4").css("border","dashed 2px #adb5bd")
				
				$("#SHC" + SHCID + " .ActSVG4").parent().append('<svg class="PlusSVG ActivityPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
				+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
				+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
			+ '</svg>')
			
			$("#SHC" + SHCID + " .ActSVG4").remove();
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][3] = null;
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			}else if($(this).attr("class").includes("ActSVG5")){
				
				$("#aPCB" + SHCID + " .act5").empty();
				$("#aPCB" + SHCID + " .act5").html('<div class="Plus">'
						+ '<div class="stripe"></div>'
						+ '<div class="rank"></div>'
					+ '</div>');

				$("#aPCB" + SHCID + " .act5").css("border","dashed 2px #adb5bd")
				
				$("#SHC" + SHCID + " .ActSVG5").parent().append('<svg class="PlusSVG ActivityPlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
				+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
				+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
			+ '</svg>')
			
			$("#SHC" + SHCID + " .ActSVG5").remove();
				addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][4] = null;
				
				var tempcount = 0;
				for(var i = 0; i < addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'].length; i++){
					if(addPlaceObjArr[SHCID - 1]['ActivityObj']['placeDataArr'][i] != null){
						tempcount++;
					}
				}
				
				$("#aPCB" + SHCID +" .CountInfo").text(tempcount + "/5")
			}
		})
		
		
		
		
		
		function toVaildNumber(CheckStr,e){			
			if(e.keyCode == 190 || e.keyCode == 187 || e.keyCode == 189){
				return '0';
			}

			while(CheckStr != '0' && CheckStr.indexOf('0') == 0){
				CheckStr = CheckStr.substring(1)
			}
			
			return CheckStr;

		}

		function getMeter4Arrive(X,Y){
			const apiKey = "a4deef496ca0e06141a54eeea561a0d9";
			
			const startX = X;
			const startY = Y;
			const endX = $("#lng").val();
			const endY = $("#lat").val();
			
			var origin = startX + "," + startY;
			var destination = endX + "," + endY
			
			var Url = "https://apis-navi.kakaomobility.com/v1/directions"
			var apiUrl = Url + "?origin="+origin + "&destination=" + destination
			
			var resultVal;
			
			
			const result = fetch(apiUrl,{
				method : 'GET',
				headers : {
					'Authorization' : 'KakaoAK 75bc99a09ba089741f053c9072142bd7'
				}
			})
				.then(response =>{
					if(!response.ok){
						throw new Error("네트워크 오류 : " + response.status)
					}
					return response.json()
				})
				.then(data =>{
					if(data.routes[0]['result_code'] != 0){
						alert("길찾기 과정중 오류가 발생했습니다.\n 오류의 내용은 다음과 같습니다\n " + data.routes[0]['result_msg'])
						return 0
					}else{
						var summary = data.routes[0].summary;
						return summary['distance'];	
					}
				})
				
				return result;
					
			
		}
	})

	function goPopup() {
		// 주소검색을 수행할 팝업 페이지를 호출합니다.
		// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		var pop = window.open("jusoPopup", "pop",
				"width=570,height=420, scrollbars=yes, resizable=yes");

		// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
		//var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
	}

	function jusoCallBack(roadFullAddr,siNm) {
		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		$("#traffic>input").val(roadFullAddr);
		$("#StartingPoint").html("출발지 : <p>" + siNm + "</p>")

	}
</script>
<link href="<c:url value="/resources/css/Creating.css" />"
	rel="stylesheet">
</head>


<body>
	<main>
		<div id="cover">
			<div id="modal">

				<div id="tH2">여행 일자가 어떻게 되시나요?</div>
				<div id="tP">
					* 최대 10일까지 설정할 수 있으며, 과거는 <b>설정 불가능</b>합니다.
				</div>
				<div id="calendar">
					<div id="leftMonth">
						<div class="Day">
							<div id="goPrev"></div>
							<div id="leftY" class="y"></div>

							<div id="leftD" class="d">
								<div class="sun">일</div>
								<div class="mon">월</div>
								<div class="tus">화</div>
								<div class="wen">수</div>
								<div class="thu">목</div>
								<div class="fri">금</div>
								<div class="sat">토</div>
							</div>
						</div>
						<div id="Ldate" class="date"></div>
					</div>

					<div id="rightMonth">
						<div class="Day">
							<div id="goNext"></div>
							<div id="rightY" class="y"></div>

							<div id="rightD" class="d">
								<div class="sun">일</div>
								<div class="mon">월</div>
								<div class="tus">화</div>
								<div class="wen">수</div>
								<div class="thu">목</div>
								<div class="fri">금</div>
								<div class="sat">토</div>
							</div>
						</div>
						<div id="Rdate" class="date"></div>
					</div>
				</div>
				<div id="submit">
					<button id="sub-btn">완료</button>
				</div>
			</div>
		</div>
		<div id="timeSetCover"></div>
		<div id="timeSet">
			<div id="hour">

				<div id="HListTitle">시간</div>
				<div id="HList">
					<c:forEach var="hour" begin="1" end="24" varStatus="index">
						<div class="HSel" id="H${index.index }">${hour }</div>
					</c:forEach>
				</div>

			</div>
			<div id="min">
				<div id="MListTitle">분</div>
				<div id="MList">
					<c:forEach var="min" begin="0" end="59" varStatus="index">
						<div class="MSel" id="M${index.index }">${min }</div>
					</c:forEach>
				</div>
			</div>
			<div id="apply">
				<div id="apply-btn">적용</div>
			</div>
		</div>
		<div id="Use">
			<div id="steps">
				<div id="step1" class="select">
					<a>STEP 1<br>날짜 설정
					</a>
				</div>
				<div id="step2" class="noSel">
					<a>STEP 2<br>예산 설정
					</a>
				</div>
				<div id="step3" class="noSel">
					<a>STEP 3<br>장소 설정
					</a>
				</div>

				<div id="next">다음</div>
			</div>
			<div id="StepImplOutPut">
				<div id="StepImplList">
					<div id="ChDate">
						<p id="localName">${local.getKoreanName() }</p>
						<div id="period"></div>
						<p id="TravelTime">여행시간</p>
						<div id="sumTime"></div>
						<div id="notice">
							날짜별로 일정 시작시간과 종료시간을 설정할 수 있습니다.<br> 기본값은 <b>오전 10시부터
								오후10시까지 입니다</b>
						</div>
						<div id="TravelDays">
							<div id="columns">
								<div class="text day" id="cDay">일자</div>
								<div class="text week" id="cWeek">요일</div>
								<div class="text stT" id="cSt">일정시작</div>
								<div class="text fnT" id="cFn">일정종료</div>
							</div>
							<div id="PlanDetail"></div>
						</div>
					</div>
					<div id="Chcash">
						<div id="setting">

							<div class="expense" id="hotel">
								<div class="exTitle">숙박비</div>
								<input placeholder="숙박비를 입력해주세요" type="number" value="0" min="0"
									class="Setting_input">
								<div class="won">원</div>
								<div class="feeNotice">숙박비로 사용할 최대 금액을 적어주세요</div>
							</div>
							<div class="expense" id="traffic">
								<div class="exTitle">출발지 및 자동차 종류</div>
								<input placeholder="주소를 검색해주세요" disabled>
								<button id="addr-search" onclick="goPopup()">검색</button>
								<select>
									<option>승용차</option>
									<option>승합차</option>
								</select>
								<div class="feeNotice">
									출발지는 정확하지 않아도 됩니다.<br> 10인승이하는 승용, 11인승 이상은 승합으로 분류됩니다
								</div>
							</div>

							<div class="expense" id="food">
								<div class="exTitle">식사비용</div>
								<input placeholder="식비를 입력해주세요" type="number" value="0" min="0"
									class="Setting_input">
								<div class="won">원</div>
								<div class="feeNotice">식비로 사용할 최대 금액을 적어주세요</div>
							</div>

							<div class="expense" id="activity">
								<div class="exTitle">활동 비용</div>
								<input placeholder="활동비를 입력해주세요" type="number" value="0" min="0"
									class="Setting_input">
								<div class="won">원</div>
								<div class="feeNotice">기타 활동비로 사용할 금액을 적어주세요</div>
							</div>

							<div id="SetFinish">
								<div id="SetFinish-btn">분석 및 상세조정하기</div>
							</div>
						</div>


						<div id="result">
							<div id="moneySum">
								총 합계 :
								<p></p>
								원
							</div>
							<div id="moneyIndiv">
								<div id="IndivWarn">교통비는 총 합계에 포함되지 않습니다</div>

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
								<div id="TrafficDetail" class="DetailExpense">
									<div id="TrafficDetailTitle">교통비</div>
									<div class="scroll-btn"></div>

									<div id="TrafficShowDetail" class="ShowDetail">
										<div id="gasoline" class="TrafficShowDetails"></div>
										<div id="diesel" class="TrafficShowDetails"></div>
										<div id="LPG" class="TrafficShowDetails"></div>
										<div id="CNG" class="TrafficShowDetails"></div>
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
									숙박비 : <input type="number" min="0" class="Hotel_Detail_input">
								</div>
								<div class="SetDetail-Food">
									식사비 : <input type="number" min="0" class="Food_Detail_input">
								</div>
								<div class="SetDetail-Activity">
									활동비 : <input type="number" min="0"
										class="Activity_Detail_input">
								</div>
							</div>
							<!-- End For Clone -->
							<div id="detailSet">
								<div id="detailSet-header">
									<div id="detailSet-Date">일자</div>
									<div id="detailSet-Sum">사용금액</div>
								</div>
								<div id="detailSet-rows"></div>


							</div>
							<div id="CR-btn">
								<div id="detailSet-complete">세부설정 완료</div>
								<div id="Reset">
									<a>예산 재설정</a>
								</div>
							</div>
						</div>
					</div>
					<div id="addPlace">
						<!-- addPlace Clone origin -->
						<div id="addPlaceOrigin">

							<div class="addPlaceColumnBody">
								<div class="plainInfo">
									<div class="PlDayInfo"></div>
									<div class="CountInfo">0/5</div>
								</div>
								<div class="addPlaceScroll statusDown"></div>
								<div class="detailInfo">
									<div class="HotelExp">
										숙박비 :
										<p></p>
									</div>
									<div class="FoodExp">
										식사비 :
										<p></p>
									</div>
									<div class="ActivityExp">
										활동비 :
										<p></p>
									</div>

									<div class="addHotel">
										<div class="addHotelTitle">숙소</div>
										<div class="addHotelBody">
											<div class="Plus">
												<div class="stripe"></div>
												<div class="rank"></div>
											</div>
										</div>
									</div>
									<div class="addFood">
										<div class="addFoodTitle">식당</div>
										<div class="addFoodBody">
											<div class="breakfast">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="lunch">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="dinner">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>

										</div>
									</div>
									<div class="addActivityPlace">
										<div class="addActivityPlaceTitle">관광</div>
										<div class="addActivityPlaceBody">
											<div class="act1">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="act2">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="act3">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="act4">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
											<div class="act5">
												<div class="Plus">
													<div class="stripe"></div>
													<div class="rank"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- end addPlace Clone origin -->


						<div id="showLeft">

							<div id="addPlace_Title">숙소 및 장소 설정</div>
							<div id="TravelPlace">${local.getKoreanName() }</div>
							<div id="Plperiod"></div>

							<div id="addPlace-warn">* 숙소와 여행지를 예산에 맞게 설정해주세요</div>
							<div id="PlanDays">
								<div id="addPlaceHeader">
									<div id="PLDay">날짜</div>
									<div id="PlaceCount">선택된 관광지 수</div>
								</div>
								<div id="addPlaceColumns"></div>
							</div>
						</div>
						<div id="showRight">
							<div id="ShowPlaceOrigin">
								<!--  for Clone -->
								<div class="ShowHotel">
									<div class="ShowHotelTitle">숙소 선택</div>
									<div class="ShowPlaceDate"></div>
									<div class="HotelSearch">
										<input class="search">
										<svg
											class="searchIcon w-4 h-4 fill-current text-lightScheme-primary md:w-5 md:h-5"
											xmlns="http://www.w3.org/2000/svg" version="1.1" id="Capa_1"
											viewBox="0 0 56.966 56.966">
											<path
												d="M55.146,51.887L41.588,37.786c3.486-4.144,5.396-9.358,5.396-14.786c0-12.682-10.318-23-23-23s-23,10.318-23,23 s10.318,23,23,23c4.761,0,9.298-1.436,13.177-4.162l13.661,14.208c0.571,0.593,1.339,0.92,2.162,0.92 c0.779,0,1.518-0.297,2.079-0.837C56.255,54.982,56.293,53.08,55.146,51.887z M23.984,6c9.374,0,17,7.626,17,17s-7.626,17-17,17 s-17-7.626-17-17S14.61,6,23.984,6z"></path></svg>
										<button class="CheckaddPlaceObjArr">확인</button>
									</div>

									<div class="HotelSearchResult"></div>

								</div>
								<div class="ShowFood">
									<div class="ShowFoodTitle">식당 선택</div>
									<div class="ShowPlaceDate"></div>
									<div class="FoodSearch">
										<input class="search">
										<svg
											class="searchIcon w-4 h-4 fill-current text-lightScheme-primary md:w-5 md:h-5"
											xmlns="http://www.w3.org/2000/svg" version="1.1" id="Capa_1"
											viewBox="0 0 56.966 56.966">
											<path
												d="M55.146,51.887L41.588,37.786c3.486-4.144,5.396-9.358,5.396-14.786c0-12.682-10.318-23-23-23s-23,10.318-23,23 s10.318,23,23,23c4.761,0,9.298-1.436,13.177-4.162l13.661,14.208c0.571,0.593,1.339,0.92,2.162,0.92 c0.779,0,1.518-0.297,2.079-0.837C56.255,54.982,56.293,53.08,55.146,51.887z M23.984,6c9.374,0,17,7.626,17,17s-7.626,17-17,17 s-17-7.626-17-17S14.61,6,23.984,6z"></path></svg>
										<button class="CheckaddPlaceObjArr">확인</button>

									</div>

									<div class="FoodSearchResult"></div>
								</div>


								<div class="ShowActivity">
									<div class="ShowActivityTitle">관광 선택</div>
									<div class="ShowPlaceDate"></div>
									<div class="ActivitySearch">
										<input class="search">
										<svg
											class="searchIcon w-4 h-4 fill-current text-lightScheme-primary md:w-5 md:h-5"
											xmlns="http://www.w3.org/2000/svg" version="1.1" id="Capa_1"
											viewBox="0 0 56.966 56.966">
											<path
												d="M55.146,51.887L41.588,37.786c3.486-4.144,5.396-9.358,5.396-14.786c0-12.682-10.318-23-23-23s-23,10.318-23,23 s10.318,23,23,23c4.761,0,9.298-1.436,13.177-4.162l13.661,14.208c0.571,0.593,1.339,0.92,2.162,0.92 c0.779,0,1.518-0.297,2.079-0.837C56.255,54.982,56.293,53.08,55.146,51.887z M23.984,6c9.374,0,17,7.626,17,17s-7.626,17-17,17 s-17-7.626-17-17S14.61,6,23.984,6z"></path></svg>
										<button class="CheckaddPlaceObjArr">확인</button>
									</div>

									<div class="ActivitySearchResult"></div>
								</div>
							</div>



							<div id="showList"></div>
						</div>

						<div id="slideToLeft">
							<div id="slideCircle">
								<svg class="slideSVG" onclick="slideSVG()">
										<path d="M38 15 l -15 15 l 15 15" fill="transparent"
										stroke="white" stroke-width="3"></path>
									</svg>
							</div>
						</div>


					</div>
				</div>
			</div>
		</div>
		<div id="Map" style="height: 100vh; width: 100vw;"></div>
		<input type="hidden" id="lng" value="${local.getLng() }"> <input
			type="hidden" id="lat" value="${local.getLat() }">
	</main>
</body>
<script>
	var mapContainer = document.getElementById('Map'); // 지도를 표시할 div 
	var SearchCategoryCode = 'AD5'; // 검색 결과 필터
	var dayMarkers = [];
	var showMarkers = [];
	
	var Foodmarkers = [];
	var Hotelmarkers = [];
	var Activitymarkers = [];
	
	var resultData = [];
	
	function dayMarkerObj(){
		var Foodmarkers = [];
		var Hotelmarkers = [];
		var Activitymarkers = [];
	}
	
	function cre_dayMarkers(FoodMarkers, HotelMarkers, ActivityMarkers){
		var tempDayMarkers = new dayMarkerObj();
		tempDayMarkers.Foodmarkers = FoodMarkers;
		tempDayMarkers.Hotelmarkers = HotelMarkers;
		tempDayMarkers.Activitymarkers = ActivityMarkers;
		
		return tempDayMarkers;
	}
	
	var addPlaceObjArr = [];
	
	
	$(document).on('click','button[class=CheckaddPlaceObjArr]',function(){
		console.log(addPlaceObjArr)
		console.log(dayMarkers)
		console.log(SearchCategoryCode)
		console.log(showMarkers)
		console.log(SHCID)
	})
	
	function slideSVG(){
		if($("#showRight").css("display") != 'none'){
			$("#showRight").hide();
			$(".slideSVG>path").attr("d","M23 15 l 15 15 l -15 15");
			$("#addPlace").css("width","500px")
		}else{
			$("#showRight").show();
			$(".slideSVG>path").attr("d","M38 15 l -15 15 l 15 15");
			$("#addPlace").css("width","950px")
		}
	}
	
	
	
	function addPlaceFoodObj(){
		var breakfast, lunch, dinner;
	}
	
	function cre_addFood(breakfast, lunch, dinner){
		var resultObj = new addPlaceFoodObj();
		resultObj.breakfast = breakfast;
		resultObj.lunch = lunch;
		resultObj.dinner = dinner;

		return resultObj;
	};
	
	function addPlaceHotelObj(){
		var placeData;
	}
	
	function cre_addHotel(placeData){
		var resultObj = new addPlaceHotelObj();
		resultObj.placeData = placeData;
	
		return resultObj;
	}
	
	function addPlaceActivityObj(){
		var placeDataArr = [];
	}
	
	function cre_addActivity(placeData){
		var result = new addPlaceActivityObj();
		result.placeDataArr = placeData;
		
		return result;
	}
	
	function addPlaceObj(){
		var date;
		var index;
		var FoodObj, HotelObj,ActivityObj;
	}
	
	function cre_addPlaceObj(date, index, breakfast, lunch, dinner, HotelPlace, activityPlaceArr){
		var ResultPlaceObj = new addPlaceObj();
		ResultPlaceObj.date = date;
		ResultPlaceObj.index = index;
		
		ResultPlaceObj.FoodObj = cre_addFood(breakfast,lunch,dinner)
		ResultPlaceObj.HotelObj = cre_addHotel(HotelPlace)
		ResultPlaceObj.ActivityObj = cre_addActivity(activityPlaceArr);
		
		return ResultPlaceObj
	}
	
	
	
	var SHCID = 1;
	
	
	
	let CenterLng = $("#lng").val();
	let CenterLat = $("#lat").val();
	mapOption = {
		center : new kakao.maps.LatLng(CenterLat, CenterLng), // 지도의 중심좌표
		level : 9
	// 지도의 확대 레벨
	};
	
	var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_red.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
    imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
    markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	var markerPosition  = new kakao.maps.LatLng(CenterLat, CenterLng); 

	// 마커를 생성합니다
	var Centermarker = new kakao.maps.Marker({
	    position: markerPosition
	});
	
	Centermarker.setMap(map)
	
	var ps = new kakao.maps.services.Places();  

	$(document).on('click','svg[class*=searchIcon]',function(){
		
		var keyword = $(this).siblings('input').val();
		
	    if (!keyword.replace(/^\s+|\s+$/g, '')) {
	        alert('키워드를 입력해주세요!');
	    }else{
			searchPlaces(keyword);
	    }
	})
	
	$(document).on('keyup','input[class="search"]',function(e){
		if(e.keyCode == 13){
			var keyword = $(this).val();
			
		    if (!keyword.replace(/^\s+|\s+$/g, '')) {
		        alert('키워드를 입력해주세요!');
		    }else{
				searchPlaces(keyword);
				SHCID = $(this).parent().parent().parent().attr("id").substring(3);
		    }
		}
	})
	
	
	function searchPlaces(keyWord){
		
		var searchOption = {
				location : new kakao.maps.LatLng(CenterLat,CenterLng),
				radius : 12000 // 반지름 12km
		};
		
		ps.keywordSearch(keyWord,placeSearchCB, searchOption)
	}
	
	
	function placeSearchCB(data, status, pagination){
		if(status == kakao.maps.services.Status.OK){
			resultData = [];
			for(var i = 0; i < data.length; i++){
				if(data[i].category_group_code == SearchCategoryCode || SearchCategoryCode == 'anything'){
					resultData.push(data[i])
				}
			}
			
			if(resultData.length != 0 ){
				displayPlaces(resultData)	
			}else{
				alert("현재 검색 설정에 맞는 검색결과가 없습니다. + 버튼을 눌러 숙소, 식당, 관광지중 올바른 검색 설정 후 다시 시도해주세요\n"
						+ "* 관광지의 경우 모든 검색이 포함됩니다")
			}

		}else if(status == kakao.maps.services.Status.ZERO_RESULT){
				alert("검색결과가 없습니다")
		}
	}
	
	function displayPlaces(data){
		
		removeMarkerAndEle();
		for(var i = 0; i < data.length; i++){
			var pos = new kakao.maps.LatLng(data[i].y,data[i].x)
			addMarker(pos,i)
			addElement(data[i],i)
		}
	}
	
	function removeMarkerAndEle(){
		var CategoryCodeKor;
		switch (SearchCategoryCode){
			case 'AD5':
				CategoryCodeKor = 'Hotelmarkers'
				break;
			case 'FD6':
				CategoryCodeKor = 'Foodmarkers'
				break;
			case 'anything' : 
			CategoryCodeKor = 'Activitymarkers'
		}	
		for(var i = 0; i < dayMarkers[SHCID - 1][CategoryCodeKor].length; i++){
			dayMarkers[SHCID - 1][CategoryCodeKor][i].setMap(null)
		}
		
		dayMarkers[SHCID -1][CategoryCodeKor] = [];
		showMarkers = [];
		
		
		if(SearchCategoryCode == 'AD5'){
			$("#SHC" + SHCID).children(".ShowHotel").children(".HotelSearchResult").empty();
			
		}else if(SearchCategoryCode == 'FD6'){
			$("#SHC" + SHCID).children(".ShowFood").children(".FoodSearchResult").empty();			
		}else{
			$("#SHC" + SHCID).children(".ShowActivity").children(".ActivitySearchResult").empty();
		}
		
	}
	
	function LoadMarker(type){
		
		for(var i = 0; i < showMarkers.length;i++){
			showMarkers[i].setMap(null)
		}
		
		showMarkers = [];
		if(dayMarkers[SHCID - 1][type].length){
			for(var i = 0; i < dayMarkers[SHCID - 1][type].length;i++){
				dayMarkers[SHCID - 1][type][i].setMap(map);
				showMarkers.push(dayMarkers[SHCID - 1][type][i])
			}
		}else{
			if(type == 'Hotelmarkers'){
				
				searchPlaces('숙소')
			}else if(type == 'Foodmarkers'){
				
				searchPlaces('식당')
			}else{
				
				searchPlaces('관광')
			}
		}
	}
	
	function addElement(data,index){
		
		var SearchType;
		switch(SearchCategoryCode){
			case 'AD5' :
				SearchType = 'Hotel'
				break;
			case 'FD6' : 
				SearchType = 'Food'
				break;
			case 'anything' :
				SearchType = 'Activity'
				break;
		}
		var targetDOM = $("#SHC" + SHCID).children(".Show" + SearchType).children("." + SearchType + "SearchResult");
		
		var eleStr;
		
		itemStr = "<span class='markerbg marker_" + (index+1) + "'></span>"
					+ "<div class='placeName'><a href='" + data.place_url + "' target='_blank'>" + data.place_name + "</a></div>"
					
					if(data.road_address_name){
						itemStr += "<span class='jibun'>" + data.road_address_name + "</span>"
					}else{
						itemStr += "<span class='jibun'>" + data.address_name + "</span>"
					}
		itemStr += "<div class='phone'>" + data.phone + "</div>"
		
		itemStr += '<svg class="PlusSVG ' + SearchType + 'PlusSVG" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none">'
			 			+ '<path d="M0 12.5C0 8.30236 0 6.20354 0.768086 4.57956C1.55942 2.90642 2.90642 1.55942 4.57956 0.768086C6.20354 0 8.30236 0 12.5 0C16.6976 0 18.7965 0 20.4204 0.768086C22.0936 1.55942 23.4406 2.90642 24.2319 4.57956C25 6.20354 25 8.30236 25 12.5C25 16.6976 25 18.7965 24.2319 20.4204C23.4406 22.0936 22.0936 23.4406 20.4204 24.2319C18.7965 25 16.6976 25 12.5 25C8.30236 25 6.20354 25 4.57956 24.2319C2.90642 23.4406 1.55942 22.0936 0.768086 20.4204C0 18.7965 0 16.6976 0 12.5Z" fill="black" fill-opacity="0.2"/>'
						+ '<path d="M16.25 11.5625H13.4375V8.75C13.4375 8.40488 13.1576 8.125 12.8125 8.125H12.1875C11.8424 8.125 11.5625 8.40488 11.5625 8.75V11.5625H8.75C8.40488 11.5625 8.125 11.8424 8.125 12.1875V12.8125C8.125 13.1576 8.40488 13.4375 8.75 13.4375H11.5625V16.25C11.5625 16.5951 11.8424 16.875 12.1875 16.875H12.8125C13.1576 16.875 13.4375 16.5951 13.4375 16.25V13.4375H16.25C16.5951 13.4375 16.875 13.1576 16.875 12.8125V12.1875C16.875 11.8424 16.5951 11.5625 16.25 11.5625Z" fill="white"/>'
					+ '</svg>' 
		
		eleStr = "<div class='SearchItem'>" + itemStr + "</div>";
		
		targetDOM.append(eleStr)
	
	}
	
	function addMarker(position,index){
		var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (index*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
        marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });
		
		marker.setMap(map)
		var CategoryCodeKor;
		switch (SearchCategoryCode){
			case 'AD5':
				CategoryCodeKor = 'Hotelmarkers'
				break;
			case 'FD6':
				CategoryCodeKor = 'Foodmarkers'
				break;
			case 'anything' : 
				CategoryCodeKor = 'Activitymarkers'
		}
		
		dayMarkers[SHCID -1][CategoryCodeKor].push(marker)
		showMarkers.push(marker)
	}
	
</script>
</html>