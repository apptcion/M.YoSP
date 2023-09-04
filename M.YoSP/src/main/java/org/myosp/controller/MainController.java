package org.myosp.controller;

import java.security.Principal;
import java.util.List;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.CustomUser;
import org.myosp.domain.MemberDTO;
import org.myosp.service.BoardDAOImpl;
import org.myosp.service.MemberDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MainController {
	
	@Autowired
	private MemberDAOImpl MemberDAO;
	
	@Autowired
	private BoardDAOImpl BoardDAO;
	
	
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
		
		model.addAttribute("userName", userName);
		model.addAttribute("email",Member.getEmail());
		model.addAttribute("Maps","Maps");
		
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
}
