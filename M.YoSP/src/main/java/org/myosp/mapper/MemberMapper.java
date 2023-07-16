package org.myosp.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.MemberDTO;


@Mapper
public interface MemberMapper {

	
	@Select("select * from author_member")
	public String getTime();
	
	public MemberDTO read(String userName);
}
