package org.myosp.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
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
				
		log.info("basic....");
		log.info(order);
		log.info(page);
		log.info(local);

		Criteria cri = new Criteria(page, 15);
		List<BoardDTO> list = dao.getListWithPaging(cri, order, local);
		List<AreaDTO> areaList = dao.getAreaList();
		
		
		log.info(areaList);
		
		model.addAttribute("pageMaker",new PageDTO(cri, dao.Count(local)));
		model.addAttribute("list", list);
		model.addAttribute("page",page);
		model.addAttribute("order",order);
		model.addAttribute("local",local);
		model.addAttribute("areaList",areaList);

		return "board/board";
	}

	@GetMapping("view")
	public String view(Model model, @RequestParam("id") int id) {
		model.addAttribute("id", id);

		BoardDTO dto = dao.readOne(id);
		model.addAttribute("board", dto);
		return "/board/view";
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
