package org.myosp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.MemberDTO;


@Mapper
public interface BoardMapper {
		
		public MemberDTO getTime2();
		
		public List<BoardDTO> readAll(String local);
		
		public BoardDTO readOne(int board_id);
		
		public void addView(BoardDTO dto);
		
		
		public List<AreaDTO> getAreaList();
		
		
}
