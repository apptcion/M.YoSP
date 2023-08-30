package org.myosp.controller;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.CustomUser;
import org.myosp.domain.MemberDTO;
import org.myosp.domain.PageDTO;
import org.myosp.service.BoardDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/board*")
@Log4j
public class BoardController {

	@Autowired
	private BoardDAOImpl dao;

	@GetMapping("")
	public String board(Model model
			,@RequestParam(value="page", required=false, defaultValue="1")int page
			,@RequestParam(value="order", required=false, defaultValue="byTimeDesc")String order
			,@RequestParam(value="local", required=false, defaultValue="etc")String local
			,@RequestParam(value="search", required=false, defaultValue="")String search) {
				
		log.info("board Page");
		log.info(order);
		log.info(page);
		log.info(local);
		log.info(search);

		Criteria cri = new Criteria(page, 13);
		List<BoardDTO> list = dao.getListWithPaging(cri, order, local,search);
		List<AreaDTO> areaList = dao.getAreaList();
		
		
		model.addAttribute("isAjax",false);
		model.addAttribute("pageMaker",new PageDTO(cri, dao.Count(local,search)));
		model.addAttribute("areaList", areaList);
		model.addAttribute("local",local);
		model.addAttribute("order", order);
		model.addAttribute("list", list);
		model.addAttribute("page",page);
		model.addAttribute("search", search);
		
		
		
		return "board/board";
	}

	@GetMapping("/view")
	public String view(Model model, @RequestParam("id") int id //게시판 아이디
			,@RequestParam(value="page",required=false,defaultValue="1")int page
			,HttpServletRequest request
			,HttpServletResponse response) {
		int userId;
		try {
			Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			CustomUser user = (CustomUser)principal;

			userId = user.getMember().getUser_id();
		}catch(Exception e) {
			userId = 0;
		}
				
		log.info("view Page");

		Criteria cri = new Criteria(page, 12);
		List<BoardDTO> list = dao.getListWithPaging(cri, "byTimeDesc", "etc","");
		
		model.addAttribute("id", id);
		model.addAttribute("pageMaker",new PageDTO(cri, dao.Count("etc","")));
		model.addAttribute("list", list);
		model.addAttribute("page",page);
		model.addAttribute("UserId",userId);
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
		boolean isLike = dao.isLike(dto,Integer.toString(userId));
		
		model.addAttribute("board", dto);
		model.addAttribute("isLike",isLike);
		
		
		//댓글
		List<CommentDTO> comments = dao.readComments(id);
		model.addAttribute("comments",comments);
		model.addAttribute("ComSize",comments.size());
		
		return "/board/view";
	}

	@RequestMapping("write")
	public String write(Model model) {
		List<AreaDTO> areaList = dao.getAreaList();
		model.addAttribute("area", areaList);
		return "board/write";
	}
	
	
	@RequestMapping("modify")
	public String modify(@RequestParam("BoardId")int BoardId,Model model,HttpServletRequest request) {
		
		BoardDTO dto = dao.readOne(BoardId);
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		CustomUser user = (CustomUser)principal;
		
		
		if(dto.getMemberId() == user.getMember().getUser_id()) {
			model.addAttribute("BoardId", BoardId);
			model.addAttribute("title",dto.getTitle());
			model.addAttribute("content",dto.getContent());
			model.addAttribute("area",dao.getAreaList());
			
			
			return "board/modify";
		}else {
			return "redirect:" + request.getHeader("REFERER");
		}
	}
	
	
	@GetMapping("/exeModify")
	@ResponseBody
	public void exeModify(@RequestParam("BoardId")int BoardId
			,@RequestParam("Title")String title
			,@RequestParam("Content")String content
			,@RequestParam("local")String local) {
		
		log.info(BoardId);
		log.info(title);
		log.info(content);
		log.info(local);
		
		
		dao.modify(BoardId,title,content,local);
		
	}
	
	
	@GetMapping("/exeDel")
	@ResponseBody
	public void exeDel(@RequestParam("")int BoardId) {
		dao.exeDel(BoardId);
	}
	
	@GetMapping("/posting")
	@ResponseBody
	public boolean enrol(@RequestParam("content")String content
			,@RequestParam("title")String title
			,@RequestParam("area")String area) {
		
		
		Object principal2 = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		CustomUser user = (CustomUser)principal2;
		
		String Username = user.getUsername();
		int UserId = user.getMember().getUser_id();
		
		dao.posting(title,content,area,Username,UserId);
		
		return true;
	}
	
	@GetMapping("/turn")
	@ResponseBody
	public boolean turn(@RequestParam("board_id") int board_id, @RequestParam("UserId")int UserId,
			@RequestParam("now") boolean isLike) {
		
		log.info(board_id);
		log.info(UserId);
		log.info(isLike);
		
		if(isLike) {
			//like  to dislike
			dao.turn(false,board_id,UserId);
			return false;
		}else {
			dao.turn(true,board_id,UserId);
			return true;
		}

	}
	
	@GetMapping("/enroll")
	@ResponseBody
	public void enroll(@RequestParam("board_id") int board_id,@RequestParam("Content") String Content) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		CustomUser user = (CustomUser)principal;
		
		int member_id = user.getMember().getUser_id();
		String username = user.getUsername();

		dao.enrolComment(board_id,member_id,username,Content);
		
		
	}
	
	@GetMapping("/Cupdate")
	@ResponseBody
	public void Cupdate(@RequestParam("comment_id")int comment_id,@RequestParam("Con")String con) {
		dao.Cupdate(comment_id,con);
	}
	
	
	@GetMapping("/Cdel")
	@ResponseBody
	public void Cdel(@RequestParam("comment_id")int comment_id) {

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
