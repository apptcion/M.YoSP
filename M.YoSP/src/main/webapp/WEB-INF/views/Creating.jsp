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
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a4deef496ca0e06141a54eeea561a0d9"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {

		var sumTime = "총 N시간 N분"
		
		var CalSelisRun = false;
		var Core;
		var Ass;
		
		var PlanSt;
		var PlanLs;
		
		var CanCheck = false;
		
		let nowDate = new Date();
		var LeftDate = new Date();
		var RightDate = initRightDate();
		ShowCalendar();
		
		var StartDay = LeftDate.getFullYear() + ". " + (LeftDate.getMonth() + 1) + "." + LeftDate.getDate();
		var EndDay = LeftDate.getFullYear() + ". " + (LeftDate.getMonth() + 1) + ". " + LeftDate.getDate();
		
		
		$("#period").append(StartDay + " - " + EndDay)
		$("#sumTime").append(sumTime)

		$("#steps>div").click(function() {

			$("#steps>div").removeClass();
			$("#steps>div").addClass("noSel");

			if ($(this).attr("id") == 'step1') {

				$(this).removeClass("noSel")
				$(this).addClass("select")
				$("#StepImplList").css("top", "0vh");
			} else if ($(this).attr("id") == 'step2') {

				$(this).removeClass("noSel")
				$(this).addClass("select")
				$("#StepImplList").css("top", "-100vh");
			} else {

				$(this).removeClass("noSel")
				$(this).addClass("select")
				$("#StepImplList").css("top", "-200vh");
			}
			
		})
		
		$("#goPrev").click(function(){
			if(!isMin()){
				RightDate.setFullYear(LeftDate.getFullYear());
				RightDate.setMonth(LeftDate.getMonth());
				
				if(LeftDate.getMonth == 1){
					LeftDate.setFullYear(LeftDate.getFullYear() - 1);
					LeftDate.setMonth(11);
				}else{
					LeftDate.setMonth(LeftDate.getMonth() - 1)
				}
				
				ShowCalendar();
				
				if(isMin()){
					$(this).css("border-color","#cccccc");
				}
				CanSelisRun = false;
				Core = 0;
				Ass = 0;
				PlanSt = 0;
				PlanLs = 0;
			}
			
		})
		
		
		$("#goNext").click(function(){
				LeftDate.setFullYear(RightDate.getFullYear());
				LeftDate.setMonth(RightDate.getMonth());
				
				if(RightDate.getMonth() == 11){
					RightDate.setFullYear(RightDate.getFullYear() + 1);
					RightDate.setMonth(0)
				}else{
					RightDate.setMonth(RightDate.getMonth() + 1);
				}
				
				$("#goPrev").css("border-color","black");
				ShowCalendar();
				
				CanSelisRun = false;
				Core = 0;
				Ass = 0;
				PlanSt = 0;
				PlanLs = 0;
		})
		
		function initRightDate(){
			return new Date(LeftDate.getFullYear(), (LeftDate.getMonth()+1), LeftDate.getDate());
		}
		
		function getKoreanDay(num){
			var result = '';
			switch(num){
			case 0 :
				result = "일요일"
				break;
			case 1:
				result = "월요일"
				break;
			case 2:
				result = "화요일"
				break;
			case 3:
				result = "수요일"
				break;
			case 4:
				result = "목요일"
				break;
			case 5:
				result = "금요일"
				break;
			case 6:
				result = "토요일"
				break;
			}
			return result;
		}
		
		function getEnglishDay(num){
			var result = '';
			switch(num){
			case 0 :
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
		
		function isMin(){
			if(nowDate.getFullYear() == LeftDate.getFullYear()){
				if(nowDate.getMonth() == LeftDate.getMonth()){
					return true;
				}
				return false;
			}
			return false;
		}
		
		function getLast(wDate){
			
			if(wDate.getMonth() == 1){
				if(wDate.getFullYear()%4 == 0){
					if(wDate.getFullYear()%100 == 0){
						if(wDate.getFullYear()%400 == 0){
							return 29;
						}else{
							return 28;
						}
					}else{
						return 29;
					}
				}else{
					return 28;
				}
			}
			
			if(((wDate.getMonth()+1) <= 6 && (wDate.getMonth()+1)%2 == 1) || ((wDate.getMonth()+1) > 6 && (wDate.getMonth()+1)%2 == 0)){
				return 31;
			}
			else{
			
				return 30;
			}
		}
		
		function ShowCalendar(){
			$("#leftY").html(LeftDate.getFullYear() + "년 " + (LeftDate.getMonth() + 1) + "월");
			$("#rightY").html(RightDate.getFullYear() + "년" + (RightDate.getMonth() + 1) + "월");
			var LeftLast = getLast(LeftDate);
			var LeftLine;
			var LeftStart = new Date(LeftDate.getFullYear(),LeftDate.getMonth(),1).getDay();
			
			if(LeftLast == 31){
				
				if(new Date(LeftDate.getFullYear(),LeftDate.getMonth(),1).getDay() == 5 || new Date(LeftDate.getFullYear(),LeftDate.getMonth(),1).getDay() == 6){
					LeftLine = 6;
				}else{
					LeftLine = 5;
				}
				
				
			}else if(LeftLast == 30){
				
				if(new Date(LeftDate.getFullYear(),LeftDate.getMonth(),1).getDay() == 6){
					LeftLine = 6;
				}else{
					LeftLine = 5;
				}
				
				
			}else if(LeftLast == 29){
				LeftLine = 5;
				
			}else{
				if(new Date(LeftDate.getFullYear(),LeftDate.getMonth(),1).getDay() != 1){
					LeftLine = 5;
				}else{
					LeftLine = 4;
				}
			}
			
			$("#Ldate").empty();
			var LeftDayNum = 1;
			
			$("#Ldate").append("<div class='Lweek' id='Lweek1'></div>")
			for(var First = 1; First <= 7; First++){
				if(First > LeftStart){
					
					if(First == 1){
						$("#Lweek1").append("<div class='DayDiv sun normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");
					}else if(First == 7){
						$("#Lweek1").append("<div class='DayDiv sat normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");						
					}else{
						$("#Lweek1").append("<div class='DayDiv normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");	
					}
					LeftDayNum++;
				}else{
					$("#Lweek1").append("<div class='DayDiv'></div>")
				}
			}
			
			
			for(var week = 2; week < (LeftLine); week++){
				$("#Ldate").append("<div class='Lweek' id='Lweek" + week+ "'></div>")
				for(var fromTwo = 1; fromTwo <= 7; fromTwo++){
					if(fromTwo == 1){
						$("#Lweek" + week).append("<div class='DayDiv sun normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum+ "</div>")
					}else if(fromTwo == 7){
						$("#Lweek" + week).append("<div class='DayDiv sat normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");
					}else{
						$("#Lweek" + week).append("<div class='DayDiv normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");
					}
					LeftDayNum++;
				}
			}
			
			$("#Ldate").append("<div class='Lweek' id='Lweek" + LeftLine+ "'></div>")
			for(var last = 1;LeftDayNum <= LeftLast; last++){
				if(last == 1){
					$("#Lweek" + LeftLine).append("<div class='DayDiv sun normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum+ "</div>")
				}else if(last == 7){
					$("#Lweek" + LeftLine).append("<div class='DayDiv sat normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");
				}else{
					$("#Lweek" + LeftLine).append("<div class='DayDiv normal L' id='L" + LeftDayNum + "' name='" + CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,LeftDayNum)) + "'>" + LeftDayNum + "</div>");
				}
				LeftDayNum++;
			}
			
			var RightLast = getLast(RightDate);
			var RightLine;
			var RightStart = new Date(RightDate.getFullYear(),RightDate.getMonth(),1).getDay();
			
			if(RightLast == 31){
				
				if(new Date(RightDate.getFullYear(),RightDate.getMonth(),1).getDay() == 5 || new Date(RightDate.getFullYear(),RightDate.getMonth(),1).getDay() == 6){
					RightLine = 6;
				}else{
					RightLine = 5;
				}
				
				
			}else if(RightLast == 30){
				
				if(new Date(RightDate.getFullYear(),RightDate.getMonth(),1).getDay() == 6){
					RightLine = 6;
				}else{
					RightLine = 5;
				}
				
				
			}else if(RightLast == 29){
				RightLine = 5;
				
			}else{
				if(new Date(RightDate.getFullYear(),RightDate.getMonth(),1).getDay() != 1){
					RightLine = 5;
				}else{
					RightLine = 4;
				}
			}
			
			$("#Rdate").empty();
			var RightDayNum = 1;
			
			$("#Rdate").append("<div class='Rweek' id='Rweek1'></div>")
			for(var First = 1; First <= 7; First++){
				if(First > RightStart){
					
					if(First == 1){
						$("#Rweek1").append("<div class='DayDiv sun normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");
					}else if(First == 7){
						$("#Rweek1").append("<div class='DayDiv sat normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");						
					}else{
						$("#Rweek1").append("<div class='DayDiv normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");	
					}
					RightDayNum++;
				}else{
					$("#Rweek1").append("<div class='DayDiv'></div>")
				}
			}
			
			
			for(var week = 2; week < RightLine; week++){
				$("#Rdate").append("<div class='Rweek' id='Rweek" + week+ "'></div>")
				for(var fromTwo = 1; fromTwo <= 7; fromTwo++){
					if(fromTwo == 1){
						$("#Rweek" + week).append("<div class='DayDiv sun normal R' id='R" + RightDayNum + "'  name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum+ "</div>")
					}else if(fromTwo == 7){
						$("#Rweek" + week).append("<div class='DayDiv sat normal R' id='R" + RightDayNum + "'  name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");
					}else{
						$("#Rweek" + week).append("<div class='DayDiv normal R' id='R" + RightDayNum + "'  name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");
					}
					RightDayNum++;
				}
			}
			
			
			$("#Rdate").append("<div class='Rweek' id='Rweek" + RightLine+ "'></div>")
			for(var last = 1;RightDayNum <= RightLast; last++){
				if(last == 1){
					$("#Rweek" + RightLine).append("<div class='DayDiv sun normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>")
				}else if(last == 7){
					$("#Rweek" + RightLine).append("<div class='DayDiv sat normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");
				}else{
					$("#Rweek" + RightLine).append("<div class='DayDiv normal R' id='R" + RightDayNum + "' name='" + CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,RightDayNum)) + "'>" + RightDayNum + "</div>");
				}
				RightDayNum++;
			}
			
			if(LeftDate.getFullYear() == nowDate.getFullYear() && LeftDate.getMonth() == nowDate.getMonth()){
				for(var i  = 1; i < nowDate.getDate();i++){
					$("#L" + i).addClass("AbsNoSel");
					$("#L" + i).removeClass("normal")
				}
			}
		}
		
		$(document).on('click','div[class*=normal]',function(){
				if($(".SelCore").length == 0){
					$(this).addClass("dirSel SelCore Sel")
					$(this).removeClass("normal")
					var CanSelSt = Number($(this).attr("id").substring(1)) - 9;
					var CanSelLs = Number($(this).attr("id").substring(1)) + 9;
					var OverFlowSel = 0;
					var DownFlowSel = getLast(LeftDate) + 1;
					
					if($(this).attr("class").includes("L")){
						var site = "L";
						Core = CNL(new Date(LeftDate.getFullYear(),LeftDate.getMonth()+1,$(this).attr("id").substring(1)));
					}else{
						var site = "R";
						Core = CNL(new Date(RightDate.getFullYear(),RightDate.getMonth()+1,$(this).attr("id").substring(1)));
					}
					
					
					if(site == "L"){
						if(CanSelSt < $(".AbsNoSel").length){
							CanSelSt = nowDate.getDate();
						}	
					}else{
						if(CanSelSt <10){
							if(CanSelSt < 1){
								CanSelSt = 1;
							}
							DownFlowSel = getLast(LeftDate) - (9 - Number($(this).attr("id").substring(1)));
						}
						
						if(CanSelLs > getLast(RightDate)){
							CanSelLs = getLast(RightDate);
						}
					}
					
					if(site == "L"){
						if(CanSelLs > getLast(LeftDate)){

							OverFlowSel = CanSelLs - getLast(LeftDate)
							CanSelLs = getLast(LeftDate);
						}	
					}else{
						if(CanSelLs > getLast(RightDate)){
							
							OverFlowSel = CalSelLs - getLast(RightDate)
							CanSelLs = getLast(RightDate);
						}
						
					}
					//---------------------------------------------------------------------------
					
					if(site == "L"){
						for(var i = CanSelLs+1; i <= getLast(LeftDate); i++){
							$("#L" + i).addClass("RelNoSel");
						}// 선택 후
						
						for(var i = OverFlowSel+1; i <= getLast(RightDate);i++){
							$("#R" + i).addClass("RelNoSel");
						}//다음달;
						
						for(var i = $(".AbsNoSel").length +1; i < CanSelSt;i++){
							$("#L" + i).addClass("RelNoSel")
						} //선택 전
					}else{
						for(var i = CanSelLs+1; i <= getLast(RightDate); i++){
							$("#R" + i).addClass("RelNoSel");
						} // 선택 후
						for(var i = 1;i < CanSelSt; i++){
							$("#R" + i).addClass("RelNoSel")
						}// 선택 전
						for(var i = 1; i < DownFlowSel;i++){
							$("#L" + i).addClass("RelNoSel")
						}
						
						$(".RelNoSel").removeClass("normal")	
					}
					CalSelisRun = true;
					$(".RelNoSel").removeClass("normal")
				}
		})
		
		
		
		$(document).on(
				'mouseover','div[class*=normal]', function(){
					if(CalSelisRun){
						var assD = Number($(this).attr("name"));
						if(Core - assD > 0){
							PlanSt = assD;
							PlanLs = Core;
						}else if(Core - assD <= 0){
							PlanSt = Core;
							PlanLs = assD;
						}	
						CreateIndir();	
					}
				})
		
		$(document).on('mouseleave','div[class*=indirSel]',function(){
			console.log("mouseLeave")
				if(CalSelisRun){
					DelIndir();	
				}
		})
		
		
		$(document).on('click','div[class*=SelCore]',function(){
			if(!CalSelisRun){
				$(".indirSel").addClass("normal")
				$(".indirSel").removeClass("Sel indirSel")
				
				$(".SelCore").addClass("normal")
				if(!$(this).attr("class").includes("SelAss")){
					$(".SelCore").removeClass("SelCore")
				}
				
				$(".SelAss").addClass("normal");
				$(".SelAss").removeClass("SelAss")
				
				$(".RelNoSel").addClass("normal")
				$(".RelNoSel").removeClass("RelNoSel")
				
				$(".Sel").removeClass("Sel")	
				$(".dirSel").removeClass("dirSel")
				
				$("#sub-btn").removeClass("pass")
				
			}else{
				$(this).addClass("SelAss");
				PlanSt = Core;
				PlanLs = Core;
				CalSelisRun = false;
				
				$("#sub-btn").addClass("pass")
			}
		})
		
		$(document).on('click','div[class*=SelAss]',function(){
			DelIndir();
			console.log($(this).attr("class"))
			if($(this).attr("class").includes("SelCore")){
				console.log("SelCore 포함됨")
				$(this).addClass("normal")
				$(this).removeClass("Sel SelAss dirSel SelCore");
				Core = 0;
				PlanSt = 0;
				PlanLs = 0;
				
				CalSelisRun = false;
			}else{
				$(this).addClass("normal")
				$(this).removeClass("SelAss dirSel Sel")
				CalSelisRun = true;
				CreateIndir();
			}
			$("#sub-btn").removeClass("pass")
		})
		
		$(document).on('click','div[class*=indirSel]',function(){
			CalSelisRun = false;
			$(this).addClass("dirSel SelAss");
			$(this).removeClass("indirSel")
			$("#sub-btn").addClass("pass")
		})
		
		
		$(document).on('click','button[id=sub-btn]',function(){
			
			if($(this).attr("class").includes("pass")){
				$("#cover").hide();
				$("#modal").hide();
				
				console.log(PlanSt)
				console.log(PlanLs)
				
				PlanSt = String(PlanSt)
				PlanLs = String(PlanLs)
				
				console.log(typeof PlanSt)
				console.log(typeof PlanLs)
				
				if(PlanSt[6] == '0'){
					StartDay = PlanSt.substring(0,4) + "." + PlanSt.substring(4,6) + "." + PlanSt.substring(7)
				}else{
					StartDay = PlanSt.substring(0,4) + "." + PlanSt.substring(4,6) + "." + PlanSt.substring(6,8)
				}
				
				if(PlanLs[6] == '0'){
					EndDay = PlanLs.substring(0,4) + "." + PlanLs.substring(4,6) + "." + PlanLs.substring(7);
				}else{
					EndDay = PlanLs.substring(0,4) + "." + PlanLs.substring(4,6) + "." + PlanLs.substring(6,8);
				}
				
				$("#period").text(StartDay + " - " + EndDay)
			}else{
				alert("날짜를 선택해주세요")
			}
		})
		
		
		function compar(Date1,Date2){
			if(Date1.getFullYear() > Date2.getFullYear()){
				return 1;
			}else if(Date1.getFullYear() == Date2.getFullYear()){
				if(Date1.getMonth() > Date2.getMonth()){
					return 1;
				}else if(Date1.getMonth() == Date2.getMonth()){
					if(Date1.getDate() > Date2.getDate()){
						return 1
					}else if(Date1.getDate() == Date2.getDate()){
						return 0;
					}else{
						return -1;
					}
				}else{
					return -1;
				}
			}else{
				return -1;
			}
		}
		
		function CNL(Date){
			var year = String(Date.getFullYear());
			var month = String(Date.getMonth());
			var date = String(Date.getDate());
			
			if(month.length == 1){
				month = "0" + month;
			}
			
			if(date.length == 1){
				date = "0" + date;
			}
			return year + month + date;
		}
		
		function CreateIndir(){
			for(var i = PlanSt; i <= PlanLs; i++){
				if($("div[name=" + i  + "]").attr("class")){
					if($("div[name=" + i  + "]").attr("class").includes("normal")){

						$("div[name=" + i  + "]").addClass("indirSel Sel")	
					}
				}
			}
			$(".indirSel").removeClass("normal")
		}
		
		function DelIndir(){
			$(".indirSel").addClass("normal");
			$(".indirSel").removeClass("indirSel Sel")
		}
		
		
	})
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
					</div>
					<div id="ChPlace">ChMoney</div>
					<div id="ChLodging">ChPlace</div>
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
	let CenterLng = $("#lng").val();
	let CenterLat = $("#lat").val();
	mapOption = {
		center : new kakao.maps.LatLng(CenterLat, CenterLng), // 지도의 중심좌표
		level : 9
	// 지도의 확대 레벨
	};

	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

	//지도를 클릭한 위치에 표출할 마커입니다
	var marker = new kakao.maps.Marker({
		// 지도 중심좌표에 마커를 생성합니다 
		position : map.getCenter()
	});

	//지도에 마커를 표시합니다
	marker.setMap(map);

	//지도에 클릭 이벤트를 등록합니다
	//지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
	kakao.maps.event.addListener(map, 'click', function(mouseEvent) {

		// 클릭한 위도, 경도 정보를 가져옵니다 
		var latlng = mouseEvent.latLng;

		// 마커 위치를 클릭한 위치로 옮깁니다
		marker.setPosition(latlng);

		var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
		message += '경도는 ' + latlng.getLng() + ' 입니다';

		console.log(message)
	});
	kakao.maps.event.addListener(map, 'zoom_changed', function() {

		// 지도의 현재 레벨을 얻어옵니다
		var level = map.getLevel();

		console.log(level)
	});
</script>
</html>