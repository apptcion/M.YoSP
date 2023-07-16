package org.myosp.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class LoginController {

		@GetMapping("/login")
		public String getLoginView(HttpServletRequest request) {
			
			String uri = (String)request.getHeader("Referer");
			if(uri != null && uri.contains("/login")) {
				request.getSession().setAttribute("prevPage", uri);
			}
			
			return "login/login";
		}
		
		
		@GetMapping("/logout")
		public String getLogoutView() {
			
			
			
			return "login/logout";
		}
}
