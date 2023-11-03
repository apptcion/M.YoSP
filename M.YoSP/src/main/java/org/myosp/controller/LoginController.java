package org.myosp.controller;

import javax.servlet.http.HttpServletRequest;

import org.myosp.domain.MemberDTO;
import org.myosp.security.CreateRandKey;
import org.myosp.service.MemberDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/login*")
public class LoginController {

	@Autowired
	private MemberDAOImpl dao;
	
	
		@GetMapping("")
		public String getLoginView(HttpServletRequest request,
				@RequestParam(value="error", required=false)String error,Model model) {
			
			String uri = (String)request.getHeader("Referer");
			if(uri != null && !uri.contains("/login")) {
				request.getSession().setAttribute("prevPage", uri);
			}
			model.addAttribute("error", error);
			
			log.info("login");
			
			return "login/login";
		}
		
		
		@GetMapping("/logout")
		public String getLogoutView() {
			
			log.info("logout");
			
			return "login/logout";
		}
		
		
		
		@GetMapping("/signup")
		public String signup() {
			
			log.info("signup");
			return "login/join";
		}
		
		
		@GetMapping("/find")
		public String Find(HttpServletRequest request) {
			
			log.info(request.getHeader("REFERER"));
			log.info(request.getSession().getAttribute("prevPage"));
			log.info("find");
			
			
			return "/login/find";
		}
		
		
		@GetMapping("/inUse")
		@ResponseBody
		public boolean inUse(@RequestParam("id") String id) {
			return dao.inUse(id);
		}
		
		@GetMapping("/exeJoin")
		@ResponseBody
		public void exeJoin(@RequestParam("id")String id, 
				@RequestParam("password")String password, @RequestParam("email")String email) {
			dao.exeJoin(id,password,email);
		}
		
		
		
		@GetMapping("/sendMail")
		@ResponseBody
		public boolean sendMail(@RequestParam("id")String id, @RequestParam("email")String email,HttpServletRequest request) {
			CreateRandKey CreateKey = new CreateRandKey();
			String key = CreateKey.getKey(6, false);
			
			boolean result = dao.sendMail(id, email,key);
			
			if(result) {
				request.getSession().setAttribute("key", key);
				request.getSession().setMaxInactiveInterval(60 * 5);
				return true;
			}
			
			return false;
			
		}
		
		@GetMapping("/checkKey")
		@ResponseBody
		public boolean checkKey(@RequestParam("key")String key, HttpServletRequest request) {
			String origin = (String)request.getSession().getAttribute("key");
			if(key.equals(origin)){
				request.getSession().removeAttribute("key");
				return true;
			}
			return false;
		}
		
		@GetMapping("/changePW")
		@ResponseBody
		public void changePw(@RequestParam("id")String id,@RequestParam("newPw")String newPw) {

			dao.changePw(id,newPw);
			
		}
		
}
