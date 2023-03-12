package com.portfolio.dao;

import com.portfolio.vo.memberVO;

public interface memberDAO {
	public memberVO select(memberVO vo) throws Exception;
	public int idCheck(memberVO vo) throws Exception;
	public void joinMemberShip(memberVO vo) throws Exception;
	public void decessionMemberShip(memberVO vo) throws Exception;
}
