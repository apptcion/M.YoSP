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
		var TestJson = {
				"test" : "test",
				"test2" : "test2"
		}
		
		console.log(Object.keys(TestJson))
		
		var sumTime = "총 12시간 0분"

		var CalSelisRun = false;
		var Core;
		var Ass;

		var SE = [ "StartTime", "EndTime" ];
		var HM = [ "Hour", "min" ]

		var PlanSt;
		var PlanLs;

		var CanCheck = false;

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

		var goGraph = false;

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

		$(document).on('click', 'img[id=calImg]', function() {
			CalSelisRun = false;
			Core = 0;
			Ass = 0;

			PlanSt = 0;
			PlanLs = 0;

			CanCheck = false;

			nowDate = new Date();
			LeftDate = new Date();
			RightDate = initRightDate();

			PlObjArr.length = 0;
			PlObjArr[0] = '';

			$("#cover").show();

			$(".pass").removeClass("pass");

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
			var StartTime, EndTime, Sum
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
			var HotelExpense = Number($("#hotel>input").val());
			var StartingPointstr = $("#traffic>input").val();
			var foodExpense = Number($("#food>input").val());
			var activityExpense = Number($("#activity>input").val())

			var StartPointX;
			var StartPointY;
			//값 유효성 검사
			if(HotelExpense == null) HotelExpense = 0; 
			if(foodExpense == null) foodExpense = 0;
			if(activityExpense == null) activityExpense = 0;

			

			var geocoder = new kakao.maps.services.Geocoder();

			
			geocoder.addressSearch(StartingPointstr, function(result, status) {
				if (status == kakao.maps.services.Status.OK) {
					console.log(result[0].x + ", " + result[0].y)
					getTime4Arrive(result[0].x,result[0].y)
					goGraph = true;
				} else {
					alert("주소를 확인해주세요")
					return
				}
			})
			

			var SumExpense = HotelExpense + foodExpense + activityExpense;
			$("#HotelIndiv").text("숙박비 : " + CMSV1(HotelExpense) + "원")
			$("#TrafficIndiv").text(0 + "원")
			$("#FoodIndiv").text("식비 : " + CMSV1(foodExpense) + "원")
			$("#ActiveIndiv").text("활동비 : " + CMSV1(activityExpense) + "원")
			var PlDayLen = PlObjArr.length;
			
			CMSV1(SumExpense);
			
			var averActivity = Math.round(activityExpense / (PlDayLen - 1))

			var averFood = Math.round(foodExpense / (PlDayLen -1))

			var averHotel = Math.round(HotelExpense / (PlDayLen - 2))

			$("#HotelDetailAver").text("1박 평균 금액 : " + CMSV1(averHotel) + "원")
			$("#HotelDetailHeight").text("일일 최고 소비 금액 : ")
			$("#HotelDetailLow").text("일일 최소 소비 금액 : ")
			
			$("#gasoline").text("가솔린(휘발유) 기준 : " + "원")
			$("#diesel").text("디젤(경유) 기준 : " + "원")
			$("#LPG").text("LPG기준 : " + "원")
			$("#CNG").text( "CNG기준 : " + "원")
			$("#electric").text("전기 기준 : " + "원")
			$("#hydrogen").text("수소 기준 : " + "원")
			
			
			
			
			
			
			$("#FoodDetailAver").text("하루 평균 금액 : " + CMSV1(averFood) + "원")
			$("#FoodDetailHeight").text("일일 최고 소비 금액 : ");
			$("#FoodDetailLow").text("일일 최소 소비 금액 : ");
			
			$("#ActiveDetailAver").text("하루 평균 금액 : " + CMSV1(averActivity) + "원")
			$("#ActiveDetailHeight").text("일일 최고 소비 금액 : ");
			$("#ActiveDetailLow").text("일일 최소 소비 금액 : ");
			
			if (goGraph) {
				$("#setting").hide();

				$("#moneySum>p").text(CMSV1(SumExpense))
				$(".ShowDetail").slideUp(0);
				$("#result").show();
			}
			////////////////
		})

		$(document).on('click','div[class*=scroll-btn]',function(){
			console.log("click!!")
			console.log($(this).attr("class"))
			if($(this).attr("class").includes("statusDown")){

				console.log("Down to Up")
				$(this).siblings(".ShowDetail").slideUp(50);
				$(this).parent().css("margin-top","0px")
				$(this).removeClass("statusDown")
			}else{
				console.log("up to Down")
				
				$(this).addClass("statusDown");
				$(this).siblings(".ShowDetail").slideDown(50);
				$(this).parent().css("margin-top","10px")
			}
		})
		
		String.prototype.insertAt = function(index,str){
			return this.slice(0,index) + str + this.slice(index)
		}
		
		String.prototype.reverse = function(){
			var splitString = this.split("");
			var reverseArray = splitString.reverse();
			var joinArray = reverseArray.join("");
			
			return joinArray;
		}
		
		function CMSV1(OriginNum){
			
			var Test = "10000"

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
			
			$("#setting").show();
			$("#result").hide();
		})
		
		$('input[type=number]').keyup(function(){
			var CheckStr = $(this).val();
			
			if(CheckStr.length != 0){
				var FZero = CheckStr.indexOf("0")
				var FNum = CheckStr.indexOf("1")
				
				if(CheckStr.length != 1){
					
					if(FNum < FZero && FNum != -1){
						console.log("유효한 숫자")
					}else{
						$(this).val(CheckStr.substring(1));		
					}
				}
			}else{
				$(this).val(CheckStr.substring(1));
			}
		})

		function getTime4Arrive(X,Y){
			const apiKey = "a4deef496ca0e06141a54eeea561a0d9";
			
			const startX = X;
			const startY = Y;
			const endX = $("#lng").val();
			const endY = $("#lat").val();
			
			var origin = startX + "," + startY;
			var destination = endX + "," + endY
			
			var Url = "https://apis-navi.kakaomobility.com/v1/directions"
			var apiUrl = Url + "?origin="+origin + "&destination=" + destination
			console.log(apiUrl)
			
			
			const distance = fetch(apiUrl,{
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
					var summary = data.routes[0].summary;
					var summaryKey = Object.keys(summary)
					return summary[summaryKey[6]] //summary[distance]
				})
				
				
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

	function jusoCallBack(roadFullAddr) {
		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		$("#traffic>input").val(roadFullAddr);

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
					<div id="Chbudget">
						<div id="setting">

							<div class="expense" id="hotel">
								<div class="exTitle">숙박비</div>
								<input placeholder="숙박비를 입력해주세요" type="number" value="0">
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
								<input placeholder="식비를 입력해주세요" type="number" value="0">
								<div class="won">원</div>
								<div class="feeNotice">식비로 사용할 최대 금액을 적어주세요</div>
							</div>

							<div class="expense" id="activity">
								<div class="exTitle">활동 비용</div>
								<input placeholder="활동비를 입력해주세요" type="number" value="0">
								<div class="won">원</div>
								<div class="feeNotice">기타 활동비로 사용할 금액을 적어주세요</div>
							</div>

							<div id="SetFinish">
								<div id="SetFinish-btn">분석 및 상세조정하기</div>
							</div>
						</div>


						<div id="result">
							<div id="moneySum">
								총 합계 : <p></p>원
							</div>
							<div id="moneyIndiv">
								<ul>
									<li id="HotelIndiv"></li>
									<li id="TrafficIndiv"></li>
									<li id="FoodIndiv"></li>
									<li id="ActiveIndiv"></li>
								</ul>
							</div>
							
							<div id="Usedetail">
								<div id="HotelDetail" class="DetailExpense">
									<div id="HotelDetailTitle">숙박비</div><div class="scroll-btn"></div>
									
									<div id="HotelShowDetail" class="ShowDetail">
										<div id="HotelDetailAver" class="DetailAver"></div>
										<div id="HotelDetailHeight" class="DetailHeight"></div>
										<div id="HotelDetailLow" class="DetailLow"></div>
									</div>
									
								</div>
								<div id="TrafficDetail" class="DetailExpense">
									<div id="TrafficDetailTitle">교통비</div><div class="scroll-btn"></div>
								
									<div id="TrafficShowDetail" class="ShowDetail">
										<div id="gasoline" class="TrafficShowDetails"></div>
										<div id="diesel" class="TrafficShowDetails"></div>
										<div id="LPG" class="TrafficShowDetails"></div>
										<div id="CNG" class="TrafficShowDetails"></div>
										<div id="electric" class="TrafficShowDetails"></div>
										<div id="hydrogen" class="TrafficShowDetails"></div>
									</div>
								
								</div>
								<div id="FoodDetail" class="DetailExpense">
									<div id="FoodDetailTitle">식사비</div><div class="scroll-btn"></div>
								
									<div id="FoodShowDetail" class="ShowDetail">
									
										<div id="FoodDetailAver" class="DetailAver"></div>
										<div id="FoodDetailHeight" class="DetailHeight"></div>
										<div id="FoodDetailLow" class="DetailLow"></div>
									</div>
								
								</div>
								<div id="ActiveDetail" class="DetailExpense">
									<div id="ActiveDetailTitle">활동비</div><div class="scroll-btn"></div>
								
									<div id="ActiveShowDetail" class="ShowDetail">
										<div id="ActiveDetailAver" class="DetailAver"></div>
										<div id="ActiveDetailHeight" class="DetailHeight"></div>
										<div id="ActiveDetailLow" class="DetailLow"></div>
									</div>
								
								</div>

							</div>
							<div id="graph"></div>
							<div>
								<div id="complete-btn"></div>
								<div id="reset-btn"></div>
							</div>
						</div>
					</div>
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