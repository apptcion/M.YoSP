package org.myosp.security;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.myosp.domain.CustomUser;
import org.myosp.domain.MemberDTO;
import org.myosp.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;



@Log4j
public class CustomUserDetailsService implements UserDetailsService{

	
	@Setter(onMethod_=@Autowired)
	public MemberMapper mapper;

	
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		log.warn("Load User By UserName : " + username);
		
		
		MemberDTO dto = mapper.read(username);
		
		if(dto == null) {
			throw new UsernameNotFoundException(username);
		}
		
		return new CustomUser(dto);
	}

}
