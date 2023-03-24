package com.portfolio.yosp;

import java.util.Locale;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.portfolio.dao.boardDAOImpl;
import com.portfolio.dao.memberDAOImpl;
import com.portfolio.mail.CreateRandKey;
import com.portfolio.vo.memberVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	memberDAOImpl memberDAO;
	
	
	@Autowired
	boardDAOImpl boardDAO;
	
	
	private Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	//////////////////////////////메인화면 페이지/////////////////////////////////////
	
	@RequestMapping(value = "/")
	public String home() throws Exception {
		
		logger.info("/home");
		
		return "home";
	}
	
	///////////////////////////////계획화면 페이지////////////////////////////////////
	
	@RequestMapping("planner")
	public String planner() throws Exception{
		
		logger.info("/planner");
		
		return "planner";
	}
	
	///////////////////////////로그인 통과//////////////////////////////////////////
	
	@RequestMapping(value="/isPass")
	@ResponseBody
	public String idCheck(memberVO vo,HttpServletRequest request) throws Exception {
		
		logger.info("isPass");
		
		String password = request.getParameter("password");
		vo = memberDAO.select(vo);
		if(vo.getId().equals("isNotAppear")) {
			return "-1";
		}else if(vo.getPassword().equals(password)){
			HttpSession session = request.getSession();
			session.setAttribute("id", vo.getId());
			return "1";
		}else {
			return "0";
		}
	}
	
	/////////////////////////////로그인 페이지////////////////////////////////////////
	
	@RequestMapping(value = "/login")
	public String login(HttpServletRequest request) {
		
		logger.info("/login");
		
		HttpSession session = request.getSession();
		
		if(session.getAttribute("id") != null) {
			return "home";
		}
		
		return "login";
	}
	
	////////////////////////////회원가입 페이지////////////////////////////////////////
	
	@RequestMapping("/join")
	public String join() throws Exception{
		
		logger.info("/join");
		
		return "join";
	}
	
	////////////////////////////회원가입 적용/////////////////////////////////////////
	
	@RequestMapping("/joinMemberShip")
	@ResponseBody
	public void joinMemberShip(HttpServletRequest request,memberVO vo) throws Exception{
		
		logger.info("joinMemberShip");
		
		memberDAO.joinMemberShip(vo);
	}
	
	////////////////////////////아이디 사용중인지 확인////////////////////////////////////
	
	@RequestMapping("/isUsing")
	@ResponseBody
	public String isUsing(HttpServletRequest request,memberVO vo)throws Exception{
		
		logger.info("isUsing");
		
		int result  = memberDAO.idCheck(vo);
		if(result == 1) {
			return "0";
		}else {
			return "1";
		}
		
	}
	
	///////////////////////////비밀번호 복구 페이지///////////////////////////////////////
	
	@RequestMapping("/FindPW")
	public String FindPW() throws Exception{
		
		logger.info("/FindPW");
		
		return "FindPW";
	}
	
	///////////////////////////회원탈퇴 페이지//////////////////////////////////////////
	
	@RequestMapping("/secession")
	public String seccsion() throws Exception{
		
		logger.info("/secession");
		
		return "secession";
	}
	
	
	@RequestMapping("/doSecession")
	@ResponseBody
	public void doSecession(memberVO vo,HttpServletRequest request) throws Exception{
		
		logger.info("/doSecession");
		
		memberDAO.decessionMemberShip(vo);
		
		HttpSession session = request.getSession();
		
		session.invalidate();
	}
	
	
	////////////////////////////로그아웃 처리///////////////////////////////////////////////
	
	@RequestMapping("/logout")
	public String createSession(HttpServletRequest request,memberVO vo) throws Exception{
		
		logger.info("logout");
		
		HttpSession session = request.getSession();
		
		session.invalidate();
		  if (request.getHeader("Referer") != null) {
			    return "redirect:" + request.getHeader("Referer");
			  } else {
			    return "redirect:/";
			  }


	}
	
	////////////////////////////이메일 전송////////////////////////////////////////////////
	
	@RequestMapping("/mailSend")
	@ResponseBody
	public String mailSend(HttpServletRequest request, memberVO vo) throws Exception{
		
		logger.info("mailSend");
		
		String id = vo.getId();
		String email = vo.getEmail();
		
		vo = memberDAO.select(vo);
		
		if(id.equals(vo.getId()) && email.equals(vo.getEmail())) {
			CreateRandKey key = new CreateRandKey();
			String keyNumber = key.getKey(6, false);
			
			
			String addr = "yosp.findpw@gmail.com";
			
			String subject = "YoSP 보안요청";
			
			String body = "해당 이메일로 비밀번호 복구 요청이 전송되었습니다"
						+ "\n비밀번호는  " + keyNumber + "입니다"
						+ "\n 비밀번호 복구를 요청하지 않았다면 이 이메일을 무시하셔도 됩니다";
			
			sendMail(email, addr, subject, body);
			
			HttpSession session = request.getSession();
			
			session.setAttribute("keyNumber", keyNumber);
			System.out.println("이메일 : " + email + ", 비밀번호 : " + keyNumber);
			
			return "1";
		}
		
		return "";
	}
	
	
	
	
	@Autowired
	private MailSender mailSender;
	
	public void sendMail(String toAddress, String fromAddress,
			String subject, String msgBody) {
		
		logger.info("mailSender Class");
	
		SimpleMailMessage smm = new SimpleMailMessage();
		smm.setFrom(fromAddress);
		smm.setTo(toAddress);
		smm.setSubject(subject);
		smm.setText(msgBody);
		
		mailSender.send(smm);
		
	}
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////
	
	
	
	@RequestMapping("/codeCheck")
	@ResponseBody
	public String codeCheck(HttpServletRequest request) throws Exception{
		
		logger.info("codeCheck");
		
		HttpSession session = request.getSession();
		
		String inputCode = request.getParameter("inputCode");
		if(inputCode.equals(session.getAttribute("keyNumber")))	 {
			session.removeAttribute("keyNumber");
			return "1";
		}else {
			return "0";
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	
	
	@RequestMapping("/equalsIaM")
	@ResponseBody
	public String equalsIaM(memberVO vo) throws Exception{
		
		logger.info("equalsIaM");
		
		String email = vo.getEmail();
		vo = memberDAO.select(vo);
		if(email.equals(vo.getEmail())) {
			return "1";
		}
		return "0";
	}
	
	////////////////////////////////////////////////////////////////////////////////

	@RequestMapping("/find")
	@ResponseBody
	public String find(memberVO vo) throws Exception{
		
		logger.info("find");
		
		String pw = memberDAO.select(vo).getPassword();
		return pw;
	}

////////////////////////////////////////////////////////////////////////////////////
	
	
	@RequestMapping("/explain")
	public String explain() throws Exception{
		
		logger.info("/explain");
		
		return "explain";
	}

	///////////////////////////////////////////////////////////////////////////////////////
	
	@RequestMapping("/board")
	public String board(Model model) throws Exception{
		
		logger.info("/board");
		boardDAO.selectAll();
		
		model.addAttribute("list",boardDAO.selectAll());
		return "board";
	}


/*	@RequestMapping("/test")
	public String test() throws Exception{
		
		logger.info("/test");
		
		return "test";
	}
*/

	/////////////////////////////////////////////////////////////////////////////////////////


	@RequestMapping("/insert")
	@ResponseBody
	public String insert() throws Exception{
		return "";
	}

	@RequestMapping("/selectOne")
	@ResponseBody
	public String selectOne() throws Exception{
		return "";
	}
	
	@RequestMapping("/selectList")
	@ResponseBody
	public String selectList() throws Exception{
		return "";
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete() throws Exception{
		return "";
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update() throws Exception{
		return "";
	}

}
