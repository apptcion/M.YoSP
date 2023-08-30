package org.myosp.controller;

import java.security.Principal;

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
	
	@RequestMapping("/test")
	public String test(){
		
		return "test";
	}
	
	
	@RequestMapping("/CreateMap")
	public void CreateMap(Model model) {
	
		log.info("CreateMaps");
		
		model.addAttribute("area", BoardDAO.getAreaList());
	}
}
