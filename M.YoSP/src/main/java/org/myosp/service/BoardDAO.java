package org.myosp.service;

import java.util.List;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.Criteria;

public interface BoardDAO {

	public List<BoardDTO> readAll();

	public BoardDTO readOne(int board_id);
	
	public List<BoardDTO> getListWithPaging(Criteria cri,String order,String local);
	public int Count(String local);
	
	public List<AreaDTO> getAreaList();
}
