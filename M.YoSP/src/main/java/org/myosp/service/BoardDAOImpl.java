package org.myosp.service;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.BoardFileDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.LikeDTO;
import org.myosp.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import oracle.jdbc.driver.parser.Parseable;

@Service
@Log4j
public class BoardDAOImpl implements BoardDAO {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;

	@Override
	public List<BoardDTO> readAll() {
		// List<BoardDTO> list = mapper.readAll();
		return null;
	}

	@Override
	public BoardDTO readOne(int board_id) {
		BoardDTO dto = mapper.readOne(board_id);

		return dto;
	}
	
	@Override
	public void addView(BoardDTO dto) {
		mapper.addView(dto);
	}

	public List<BoardDTO> getListWithPaging(Criteria cri, String order,String local,String search) {
		List<BoardDTO> resultList = new ArrayList();
		
		
		Map<String,String> map = new HashMap<>();
		
		map.put("local",local);
		map.put("search", search);
		List<BoardDTO> list = mapper.readAll(map);
		
		int Count = list.size();
		
		System.out.println(Count);
		
		switch (order) {
		case "byViewsDesc": // 조회 내림차순 정렬 DESC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto2.getViews() - dto1.getViews(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			break;
		case "byViewsAsc": // 조회 오름차순 정렬 ASC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto1.getViews() - dto2.getViews(); 
				}

			});
			
			for(int i = 1; i <= cri.getPageNum() * cri.getAmount(); i++) {
				if(i >= (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			break;
		case "byLikeDesc": // 추천수 정렬 DESC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto2.getGood() - dto1.getGood(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			
			break;
		case "byLikeAsc": // 추천수 오름차순 정렬 ASC
			
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto1.getGood() - dto2.getGood(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			break;
			
			
		case "byTimeDesc":
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					SimpleDateFormat format = new SimpleDateFormat("yyMMddHH");
					String date1 = format.format(dto1.getWriteDate());
					String date2 = format.format(dto2.getWriteDate());
					
					int Ndate1 = Integer.parseInt(date1);
					int Ndate2 = Integer.parseInt(date2);
					
					return Ndate2 - Ndate1;
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			break;
			
		case "byTimeAsc":
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					SimpleDateFormat format = new SimpleDateFormat("yyMMddHH");
					int date1 = Integer.parseInt(format.format(dto1.getWriteDate()));
					int date2 = Integer.parseInt(format.format(dto2.getWriteDate()));
				
					
					return date1 - date2;
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			break;
		}
		return resultList;
	}
	
	@Override
	public int posting(String title,String content,String area, String Username,int UserId) {
		
		content = content.replaceAll("\r|\r\n|\n|\n\r ", "\n");
		content = content.replaceAll("<","&lt;");
		content = content.replaceAll(">","&gt;");
		
		if(!area.equals("etc")) {
			area = area + ", etc";
		}
		
		BoardDTO dto = new BoardDTO();
		
		dto.setTitle(title);
		dto.setContent(content);
		dto.setLocal(area);
		dto.setWriter(Username);
		dto.setMemberId(UserId);
		
		mapper.posting(dto);
		
		return dto.getBoard_id();
	}
	
	@Override
	public void turn(boolean how,int board_id,int member_id) {
		Map<String, Object> map = new HashMap<String,Object>();
		
		map.put("board_id",board_id);
		map.put("member_id", member_id);
		
		
		if(how) {
			mapper.toGood(map);
			mapper.UpCount(board_id);
		}else {
			mapper.toBad(map);
			mapper.DownCount(board_id);
		}
	}
	
	
	
	@Override
	public int Count(String local,String search) {
		
		Map<String,String> map = new HashMap<>();
		
		
		map.put("local",local);
		map.put("search", search);
		
		List<BoardDTO> list = mapper.readAll(map);
		int count = list.size();
		
		return count;
	}

	@Override
	public List<AreaDTO> getAreaList() {
		List<AreaDTO> areaName = mapper.getAreaList();
		return areaName;
	}
	
	
	@Override
	public boolean isLike(BoardDTO dto,String member_id) {
		
		List<LikeDTO> likedto =  mapper.readLike(dto.getBoard_id());
		
		for(LikeDTO like : likedto) {
			System.out.println("from dao.isLike;  " + like);
			if(like.getMember_id().equals(member_id)) {
				return true;
			}
		}
		
		return false;
	}
	
	@Override
	public List<CommentDTO> readComments(int board_id){
		List<CommentDTO> result = mapper.readComments(board_id);
		
		Collections.sort(result, new Comparator<CommentDTO>() {
		
		@Override
		public int compare(CommentDTO dto1, CommentDTO dto2) {
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHH");
			int date1 = Integer.parseInt(sdf.format(dto1.getWriteDate()));
			int date2 = Integer.parseInt(sdf.format(dto2.getWriteDate()));
		
			
			return date2 - date1;
		}
		
		});
			
		return result; 
	}
	
	
	@Override
	public void enrolComment(int board_id, int member_id, String Username, String Content) {
		
		Map<String, Object> map = new HashMap<>();
		Content = Content.replaceAll("\r|\r\n|\n|\n\r ", "\n");
		Content = Content.replaceAll("<","&lt;");
		Content = Content.replaceAll(">","&gt;");
		
		map.put("board_id", board_id);
		map.put("member_id", member_id);
		map.put("Username", Username);
		map.put("Content", Content);
		
		
		mapper.enrolComment(map);
	}
	
	@Override
	public void Cupdate(int comment_id, String Content) {
		
		Content = Content.replaceAll("\r|\r\n|\n|\n\r ", "\n");
		Content = Content.replaceAll("<","&lt;");
		Content = Content.replaceAll(">","&gt;");

		Map<String,Object> map = new HashMap<>();
		map.put("comment_id",comment_id);
		map.put("Con",Content);
		
		mapper.Cupdate(map);
	}
	
	
	@Override
	public void Cdel(int comment_id) {
		mapper.Cdel(comment_id);
	}
	
	
	@Override
	public void modify(int BoardId, String title, String content, String local) {
		
		Map<String,Object> map = new HashMap<>();
		
		content = content.replaceAll("\r|\r\n|\n|\n\r ", "\n");
		content = content.replaceAll("<","&lt;");
		content = content.replaceAll(">","&gt;");
		
		if(!local.equals("etc")) {
			local = local + ", etc";
		}
		
		
		map.put("BoardId",BoardId);
		map.put("title",title);
		map.put("content",content);
		map.put("local",local);
		
		mapper.modify(map);
		
	}
	
	@Override
	public void exeDel(int BoardId) {
		mapper.exeDel(BoardId);
	}

	@Override
	public void addFile(BoardFileDTO dto) {
		mapper.addFile(dto);
		
	}
	
	@Override
	public List<BoardFileDTO> readFiles(int bno){
		return mapper.readFiles(bno);
	}

	@Override
	public void deleteFile(BoardFileDTO file) {
		mapper.deleteFile(file);
		
	}
}