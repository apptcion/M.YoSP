package org.myosp.controller;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BudgetArr;
import org.myosp.domain.MemberDTO;
import org.myosp.domain.MyPageMapDTO;
import org.myosp.domain.StoreMapDTO;
import org.myosp.mapper.MemberMapper;
import org.myosp.service.BoardDAOImpl;
import org.myosp.service.MemberDAOImpl;
import org.myosp.service.StoreMapDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import net.sf.json.JSONArray;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MainController {
	
	@Autowired
	private MemberDAOImpl MemberDAO;
	
	@Autowired
	private BoardDAOImpl BoardDAO;
	
	@Autowired
	private StoreMapDAOImpl StoreMapDAO;
	
	
	@RequestMapping("/")
	public String main() {
		
		return "home";
	}
	
	
	@RequestMapping("/accessError")
	public void accessError(Authentication auth, Model model) {
		
		log.info("access Denied : " + auth);
		
		model.addAttribute("msg", "접근이 거부되었습니다");
	}
	
	@RequestMapping("/MyPage")
	public String mypage(Model model,Principal principal) {
		
		String userName = principal.getName();
		
		MemberDTO Member = MemberDAO.read(userName);
		
		List<MyPageMapDTO> myMaps = MemberDAO.readMaps(userName);
		
		model.addAttribute("userName", userName);
		model.addAttribute("email",Member.getEmail());
		model.addAttribute("Maps","Maps");
		model.addAttribute("myMaps", myMaps);
		
		log.info("MyPage");
		
		return "/MyPage";
	}
	
	
	@RequestMapping("/resign")
	@ResponseBody
	public void resign(Principal principal) {
		
		MemberDAO.resign(principal.getName());
		
	}
	
	@RequestMapping("/modifyEmail")
	@ResponseBody
	public void modifyEmail(Principal principal
			,@RequestParam("email")String email) {
		
		log.info(principal.getName());
		log.info(email);
		
		MemberDAO.modifyEmail(principal.getName(),email);
		
	}
	
	
	@RequestMapping("/test")
	public String test(){
		
		return "test";
	}
	
	
	@RequestMapping("/test2")
	public void test2() {
	}
	
	
	@RequestMapping("/CreateMap")
	public void CreateMap(Model model) {
	
		log.info("CreateMaps");
		
		model.addAttribute("area", BoardDAO.getAreaList());
	}
	
	@RequestMapping("/Creating")
	public void Creating(Model model,@RequestParam("area")String areaName) {
		
		List<AreaDTO> areas= BoardDAO.getAreaList();
		
		areas.forEach(area ->{
			if(area.getEnglishName().equals(areaName)) {
				model.addAttribute("local",area);
				return;
			}
		});
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/storeMap", method = RequestMethod.POST)
	public void storeMap(@RequestParam("SortedPlan")String PlanStr
			, @RequestParam("userName")String userName
			, @RequestParam("StartDate")String StartDate
			, @RequestParam("EndDate")String EndDate
			, @RequestParam("LocalName")String LocalName
			, @RequestParam("HotelArr")String HotelArr
			, @RequestParam("FoodArr")String FoodArr
			, @RequestParam("ActivityArr")String ActivityArr
			, @RequestParam("PlObjArrStr")String PlObjArrStr){
		
		try {
			/// [  StartPoint,,, : { x : ...........} 
			List<Map<String, Object>> PlanJSON = new ArrayList<Map<String,Object>>();
			PlanJSON = JSONArray.fromObject(PlanStr);
			
			List<Map<String, Object>> PlObjArr = new ArrayList<Map<String,Object>>();
			PlObjArr = JSONArray.fromObject(PlObjArrStr);
			
			String parameter = UUID.randomUUID().toString();
			
			StoreMapDAO.registeration(userName, parameter, StartDate, EndDate, LocalName);
			StoreMapDAO.storeBudget(parameter, HotelArr, FoodArr, ActivityArr);

			for(int i = 0; i < PlanJSON.size(); i++) {
				
				StoreMapDTO mapDTO = new StoreMapDTO();
				
				mapDTO.setParameter(parameter);
				mapDTO.setStartPoint(PlanJSON.get(i).get("StartPoint").toString());
				mapDTO.setEndPoint(PlanJSON.get(i).get("EndPoint").toString());
				mapDTO.setActs(PlanJSON.get(i).get("Acts").toString());
				mapDTO.setUserId(userName);
				mapDTO.setOrder(i);
				mapDTO.setStartTime(PlObjArr.get(i).get("StartTime").toString());
				mapDTO.setEndTime(PlObjArr.get(i).get("EndTime").toString());
				
				StoreMapDAO.store(mapDTO);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/showMap")
	public void showMap(@RequestParam("mapId")String mapId
			,@RequestParam("areaName")String areaName
			,@RequestParam("startDay")String startDay
			,Model model) {
			
		List<AreaDTO> areas= BoardDAO.getAreaList();
		
		areas.forEach(area ->{
			if(area.getEnglishName().equals(areaName)) {
				model.addAttribute("local",area);
				return;
			}
		});
		
		log.info(startDay);
		
		BudgetArr budgets = StoreMapDAO.readBudget(mapId);
		
		model.addAttribute("HotelArr", budgets.getHotelArr());
		model.addAttribute("FoodArr", budgets.getFoodArr());
		model.addAttribute("ActivityArr", budgets.getActivityArr());
		model.addAttribute("StartDay", startDay);
		model.addAttribute("parameter", mapId);
	}
	
	
	@ResponseBody
	@RequestMapping("/getMapData")
	public String getMapData(@RequestParam("parameter")String parameter) {
		return StoreMapDAO.readMap(parameter);
	}
	
	@RequestMapping("/jusoPopup")
	public void popUp(@RequestParam(value= "inputYn",required = false)String inputYn) {
		
	}
	
	@RequestMapping("/Sample")
	public String Sample() {
		return "test/Sample";
	}

}
