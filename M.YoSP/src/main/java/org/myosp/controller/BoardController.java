package org.myosp.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.MemberDTO;
import org.myosp.domain.PageDTO;
import org.myosp.mapper.BoardMapper;
import org.myosp.mapper.MemberMapper;
import org.myosp.service.BoardDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/board/*")
@Log4j
public class BoardController {

	@Autowired
	private BoardDAOImpl dao;

	@GetMapping("")
	public String board(Model model,HttpServletRequest request) {
		
		int page = Integer.parseInt(request.getParameter("page"));
		String order = request.getParameter("order");
		String local = request.getParameter("local");
		String search = request.getParameter("search");
				
		log.info("board Page");
		log.info(order);
		log.info(page);
		log.info(local);

		Criteria cri = new Criteria(page, 13);
		List<BoardDTO> list = dao.getListWithPaging(cri, order, local,search);
		List<AreaDTO> areaList = dao.getAreaList();
		
		model.addAttribute("pageMaker",new PageDTO(cri, dao.Count(local,search)));
		model.addAttribute("list", list);
		model.addAttribute("page",page);
		model.addAttribute("order",order);
		model.addAttribute("local",local);
		model.addAttribute("areaList",areaList);
		model.addAttribute("search",search);

		return "board/board";
	}

	@GetMapping("view")
	public String view(Model model, @RequestParam("id") int id
			,HttpServletRequest request
			,HttpServletResponse response
			,@RequestParam("Username") String Username
			,@RequestParam("search") String search) {
		

		int page = Integer.parseInt(request.getParameter("page"));
		String order = request.getParameter("order");
		String local = request.getParameter("local");
				
		log.info("view Page");

		Criteria cri = new Criteria(page, 12);
		List<BoardDTO> list = dao.getListWithPaging(cri, order, local,search);
		
		model.addAttribute("id", id);
		model.addAttribute("pageMaker",new PageDTO(cri, dao.Count(local,search)));
		model.addAttribute("list", list);
		model.addAttribute("page",page);
		model.addAttribute("order",order);
		model.addAttribute("local",local);
		model.addAttribute("Username",Username);
		BoardDTO dto = dao.readOne(id);
		
		//조회수 로직

		
		
		Cookie[] cookies = request.getCookies();
		boolean foundIsVisit = false;
		
			for(Cookie cookie : cookies) {	
				
				if(cookie.getName().equals("isVisit")) {
					foundIsVisit = true;
					if(!cookie.getValue().contains("_" + dto.getBoard_id() + "_")){
						cookie.setValue(cookie.getValue() + dto.getBoard_id() + "_");
						cookie.setMaxAge(60 * 60 * 24);
						response.addCookie(cookie);
						dao.addView(dto);
					}
				}
			}
			if(!foundIsVisit) {
				Cookie NewCookie = new Cookie("isVisit","_" + dto.getBoard_id() + "_");
				NewCookie.setMaxAge(60 * 60 * 24);
				response.addCookie(NewCookie);
				dao.addView(dto);
			}
			
		// 좋아요 눌러져있는지 여부
		boolean isLike = dao.isLike(dto,Username);
		
		model.addAttribute("board", dto);
		model.addAttribute("isLike",isLike);
		
		
		//댓글
		List<CommentDTO> comments = dao.readComments(id);
		model.addAttribute("comments",comments);
		model.addAttribute("ComSize",comments.size());
		
		return "/board/view";
	}

	@GetMapping("turn")
	@ResponseBody
	public boolean turn(@RequestParam("board_id") int board_id, @RequestParam("Username") String Username,
			@RequestParam("now") boolean isLike) {
		
		log.info(board_id);
		log.info(Username);
		log.info(isLike);
		
		if(isLike) {
			// trun to dislike
			dao.turn(false,board_id,Username);
			return false;
		}else {
			dao.turn(true,board_id,Username);
			return true;
		}

	}
	
	@GetMapping("enroll")
	@ResponseBody
	public void enroll(@RequestParam("board_id") int board_id, @RequestParam("member_id") int member_id,
			@RequestParam("Username") String username,@RequestParam("Content") String Content) {
		
		
		log.info(board_id);
		log.info(member_id);
		log.info(username);
		log.info(Content);
		
		Content = Content.replaceAll("\r|\r\n|\n|\n\r ", "\n");
		log.info(Content);

		dao.enrolComment(board_id,member_id,username,Content);
		
		
	}
	
	
	@GetMapping("Cupdate")
	@ResponseBody
	public void Cupdate(@RequestParam("comment_id")int comment_id,@RequestParam("Con")String con) {
		dao.Cupdate(comment_id,con);
	}
	
	
	@GetMapping("Cdel")
	@ResponseBody
	public void Cdel(@RequestParam("comment_id")int comment_id,HttpServletRequest req) {
		String id = req.getParameter("comment_id");
		
		dao.Cdel(comment_id);
	}
	
	@GetMapping("/ex01")
	public MemberDTO ex01(MemberDTO dto, HttpServletRequest request) {
		log.info("ex01...................");

		log.info(request.getRequestURI());
		return dto;
	}

	@GetMapping("/exUpload")
	public String exUpload(HttpServletRequest request) {
		log.info("/exUpload..................");
		log.info(request.getRequestURI());

		return "board/exUpload";
	}

	@PostMapping("/exUploadPost")
	public void exUploadPost(ArrayList<MultipartFile> files) {
		files.forEach(file -> {
			log.info("-----------------------");
			log.info("name : " + file.getOriginalFilename());
			log.info("size : " + file.getSize());
		});
	}
}
