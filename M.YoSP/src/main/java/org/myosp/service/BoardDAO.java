package org.myosp.service;

import java.util.List;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.BoardFileDTO;
import org.myosp.domain.CommentDTO;
import org.myosp.domain.Criteria;

public interface BoardDAO {

	public List<BoardDTO> readAll();

	
	public void addView(BoardDTO dto);
	public BoardDTO readOne(int board_id);
	
	public List<BoardDTO> getListWithPaging(Criteria cri,String order,String local,String search);
	public int Count(String local,String search);
	
	public List<AreaDTO> getAreaList();
	
	public boolean isLike(BoardDTO dto,String member_id);
	
	public void turn(boolean how,int board_id, int member_id);
	
	public List<CommentDTO> readComments(int board_id);
	
	public void enrolComment(int board_id, int member_id, String Username, String Content);
	
	public void Cupdate(int comment_id, String Con);
	
	public void Cdel(int comment_id);
	
	public int posting(String title, String content, String area,String Username,int UserId);
	
	public void modify(int BoardId, String Title, String content,String local);
	
	public void exeDel(int BoardId);
	
	public void addFile(BoardFileDTO dto);
	
	public List<BoardFileDTO> readFiles(int bno);
	
	public void deleteFile(BoardFileDTO file);
}
