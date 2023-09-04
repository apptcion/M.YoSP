package org.myosp.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.MemberDTO;


@Mapper
public interface MemberMapper {

	
	public MemberDTO read(String userName);
	
	
	public int inUse(String id);

	public void JoinMember(Map<String,String> map);
	public void JoinAuth(String username);
	
	public void changePw(Map<String,String> map);
	
	public void resignMember(String userName);
	
	public void resignAuthorMember(String userName);
	
	public void modifyEmail(Map<String,String> map);
}
