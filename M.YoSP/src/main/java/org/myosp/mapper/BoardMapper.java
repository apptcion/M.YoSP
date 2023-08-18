package org.myosp.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.LikeDTO;
import org.myosp.domain.MemberDTO;


@Mapper
public interface BoardMapper {
		
		public MemberDTO getTime2();
		
		public List<BoardDTO> readAll(Map<String,String> map);
		
		public BoardDTO readOne(int board_id);
		
		public void addView(BoardDTO dto);
		
		
		public List<AreaDTO> getAreaList();
		
		public List<LikeDTO> readLike(int board_id);
		
		public void toGood(Map<String,Object> map);
		
		public void UpCount(int board_id);
		public void DownCount(int board_id);
		
		
		public void toBad(Map<String, Object> map);
		
		public List<CommentDTO> readComments(int board_id);
		
		public void enrolComment(Map<String,Object> map);
		
		public void Cupdate(Map<String,Object> map);
		
		public void Cdel(int comment_id);
		
}
