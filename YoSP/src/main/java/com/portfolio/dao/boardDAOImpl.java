package com.portfolio.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.portfolio.vo.boardVO;


@Repository
public class boardDAOImpl implements boardDAO{
	 
	@Inject
	private SqlSession sqlsession;
	
	@Override
	public List<boardVO> selectAll() throws Exception{
		
		System.out.println(sqlsession.selectList("board.selectAll").get(0));
		System.out.println(sqlsession.selectList("board.selectAll").get(1));
		 return null;
	 };
	
	
}
