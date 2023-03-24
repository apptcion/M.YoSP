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
		
		System.out.println("?");
		List<boardVO> vo = sqlsession.selectList("board.selectAll");
		System.out.println("????????????");
		 return vo;
	 };
	
	public String test() {
		return "test";
	}
}
