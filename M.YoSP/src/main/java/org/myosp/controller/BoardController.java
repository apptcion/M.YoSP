package org.myosp.controller;

import java.io.File;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.BoardFileDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.CustomUser;
import org.myosp.domain.MemberDTO;
import org.myosp.domain.PageDTO;
import org.myosp.service.BoardDAOImpl;
import org.myosp.service.MediaUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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
		}catch(Exception e) { userId = 0; }
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
						dao.addView(dto); } } }
			if(!foundIsVisit) {
				Cookie NewCookie = new Cookie("isVisit","_" + dto.getBoard_id() + "_");
				NewCookie.setMaxAge(60 * 60 * 24);
				response.addCookie(NewCookie);
				dao.addView(dto); }
		// 좋아요 눌러져있는지 여부
		boolean isLike = dao.isLike(dto,Integer.toString(userId));
		model.addAttribute("board", dto);
		model.addAttribute("isLike",isLike);
		//댓글
		List<CommentDTO> comments = dao.readComments(id);
		model.addAttribute("comments",comments);
		model.addAttribute("ComSize",comments.size());
		List<BoardFileDTO> fileList = dao.readFiles(id);
		model.addAttribute("files", fileList);
		return "/board/view";
	}

	@RequestMapping("/display")
	public ResponseEntity<byte[]> displayFile(@RequestParam("fileName")String fileName
			,@RequestParam("uuid")String uuid
			,@RequestParam("date")String dateStr) throws Exception{
		
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = format.parse(dateStr);
		
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		String uploadPath = "C:\\Users\\mojan\\Downloads\\upload\\";
		uploadPath = uploadPath + format.format(date).replace("-", File.separator) + File.separator;

		try {
		
			String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders header = new HttpHeaders();
			in = new FileInputStream(uploadPath + uuid +"_"+fileName);
		
			if(mType != null) {
				header.setContentType(mType);
			}else {
				header.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				String FileName = new String(fileName.getBytes(StandardCharsets.UTF_8), "ISO-8859-1");
				header.add("Content-Disposition","attachment; filename=\"" + FileName +"\"");
				
			}
			
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),header,HttpStatus.CREATED);
			
		}catch(Exception e) {
			log.info(e.getStackTrace());
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			in.close();
		}
		
		
		return entity;
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
			model.addAttribute("local", dto.getLocal());
			model.addAttribute("area",dao.getAreaList());
			
			List<BoardFileDTO> fileDTO = dao.readFiles(BoardId);
			
			model.addAttribute("fileList", fileDTO);
			
			return "board/modify";
		}else {
			return "redirect:" + request.getHeader("REFERER");
		}
	}
	
	
	@PostMapping("/exeModify")
	@ResponseBody
	public void exeModify(@RequestParam("BoardId")int BoardId
			,@RequestParam("title")String title
			,@RequestParam("content")String content
			,@RequestParam("area")String local
			,MultipartFile[] uploadFile
			,@RequestParam(value="delList",required = false)String[] delArray) {
		
			List<String> delList = new ArrayList<String>();
		
			try {
			delList = new ArrayList<String>(Arrays.asList(delArray));
				
			}catch(Exception e) {
			// 지울게 없음
			}
			
			List<BoardFileDTO> fileDTOs = dao.readFiles(BoardId);
		
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			String uploadFolder = "C:\\Users\\mojan\\Downloads\\upload\\";	
			
		log.info(BoardId);
		log.info(title);
		log.info(content);
		log.info(local);
		log.info(uploadFile);
		log.info(delArray);
			
			
		for(BoardFileDTO boardfiledto : fileDTOs) {
			String fileName = boardfiledto.getUuid() + "_" + boardfiledto.getFileOriginalName();
			for(String delName : delList) {
				if(fileName.equals(delName)) {
					dao.deleteFile(boardfiledto);
					String uploadPathstr = uploadFolder + format.format(boardfiledto.getDate()).replace("-",File.separator);
					Path filepath = Paths.get(uploadPathstr +  File.separator + fileName);
					
					try {
						Files.delete(filepath);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
		
			List<BoardFileDTO> fileDtos = dao.readFiles(BoardId);
			
			
			File uploadPath = new File(uploadFolder,getFolder());
			
			if(uploadPath.exists() == false) {
				uploadPath.mkdirs();
			}
			
			for(MultipartFile files : uploadFile) {
				
				String uploadFileName = files.getOriginalFilename();
				
				//IE 파일 경로 조정
				uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("/") + 1);
				
				UUID uuid = UUID.randomUUID();
				
				uploadFileName = uuid.toString() + "_" + uploadFileName;
				
				File file = new File(uploadPath,uploadFileName);
				try {
					files.transferTo(file);
					
					BoardFileDTO fileDTO = new BoardFileDTO();
					
					fileDTO.setBno(BoardId);
					fileDTO.setDate(new Date());
					fileDTO.setFileOriginalName(files.getOriginalFilename());
					fileDTO.setUuid(uuid.toString());
					
					dao.addFile(fileDTO);
				}catch(Exception e){
					log.info(e.getStackTrace());
				}
			}
		
		dao.modify(BoardId,title,content,local);
		
	}
	
	
	@GetMapping("/exeDel")
	@ResponseBody
	public void exeDel(@RequestParam("")int BoardId) {
		dao.exeDel(BoardId);
	}
	
	@PostMapping("/posting")
	@ResponseBody
	public boolean enrol(@RequestParam("content")String content
			,@RequestParam("title")String title
			,@RequestParam("area")String area
			,MultipartFile[] uploadFile) {
		
		Object principal2 = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		CustomUser user = (CustomUser)principal2;
		
		String Username = user.getUsername();
		int UserId = user.getMember().getUser_id();
		
		int bno = dao.posting(title,content,area,Username,UserId);
		
		String uploadFolder = "C:\\Users\\mojan\\Downloads\\upload";
		File uploadPath = new File(uploadFolder,getFolder());
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile files : uploadFile) {
			
			String uploadFileName = files.getOriginalFilename();
			
			//IE 파일 경로 조정
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("/") + 1);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			File file = new File(uploadPath,uploadFileName);
			try {
				files.transferTo(file);
				
				BoardFileDTO fileDTO = new BoardFileDTO();
				
				fileDTO.setBno(bno);
				fileDTO.setDate(new Date());
				fileDTO.setFileOriginalName(files.getOriginalFilename());
				fileDTO.setUuid(uuid.toString());
				
				
				dao.addFile(fileDTO);
			}catch(Exception e){
				log.info(e.getStackTrace());
			}
		}
		
		
		return true;
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		return str.replace("-",File.separator);
	}
	
	
	@GetMapping("/turn")
	@ResponseBody
	public boolean turn(@RequestParam("board_id") int board_id, @RequestParam("UserId")int UserId,
			@RequestParam("now") boolean isLike) {
		
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
	public void exUploadPost(MultipartFile[]  multipartFiles,Model model) {
		String uploadFolder = "C:\\Users\\mojan\\Downloads\\upload";
		
		for(MultipartFile file : multipartFiles) {
			File saveFile = new File(uploadFolder,file.getOriginalFilename());
			
			try {
				file.transferTo(saveFile);
				
			}catch(Exception e) {
				log.info(e.getStackTrace());
			}
		}
		
	}
	
	
	@PostMapping("/uploadAjaxAction")
	@ResponseBody
	public void uploadAjaxPost(MultipartFile[] uploadFile) {
		String uploadFolder = "C:\\Users\\mojan\\Downloads\\upload";
		
		for(MultipartFile file : uploadFile) {
			File saveFile = new File(uploadFolder,file.getOriginalFilename());
			
			try {
				file.transferTo(saveFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@RequestMapping("/insert")
	public void insert() {
		log.info("너 대체 누구야");
	}
	
}
