package org.myosp.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MainController {
	
	@RequestMapping("/")
	public String main() {
		
		return "home";
	}
	
	
	@RequestMapping("/accessError")
	public void accessError(Authentication auth, Model model) {
		
		log.info("access Denied : " + auth);
		
		model.addAttribute("msg", "접근이 거부되었습니다");
	};
}
