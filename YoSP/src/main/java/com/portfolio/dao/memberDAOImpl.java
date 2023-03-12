package com.portfolio.dao;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import com.portfolio.vo.memberVO;


@Repository
public class memberDAOImpl implements memberDAO{

	@Inject
	private SqlSession sqlsession;

	
	@Override
	public memberVO select(memberVO vo) throws Exception {
		memberVO vo2 = new memberVO();
		int isAppear = idCheck(vo);
		if(isAppear == 1) {
			vo2 = sqlsession.selectOne("memberDAO.select",vo.getId());
		}else {
			vo2.setId("isNotAppear");
		}
		return vo2;
	}


	@Override
	public int idCheck(memberVO vo) throws Exception {
		int result = sqlsession.selectOne("memberDAO.idCheck",vo.getId());
		return result;
	}


	@Override
	public void joinMemberShip(memberVO vo) throws Exception {
		sqlsession.insert("memberDAO.insert",vo);
	}


	@Override
	public void decessionMemberShip(memberVO vo) throws Exception {
		sqlsession.delete("memberDAO.delete", vo);
		
	}
	
	
	
}
