package org.myosp.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Getter;


@Getter
public class CustomUser  extends User{

	private static final long serialVersionUID = 1L;
	
	private MemberDTO member;
	
	
	public CustomUser(String username, String password, boolean enabled, boolean accountNonExpired,
			boolean credentialsNonExpired, boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities) {
		super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
		
	}
	
	public CustomUser(MemberDTO dto) {
		super(dto.getUsername() ,dto.getPassword(),dto.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuthority())).
				collect(Collectors.toList()));
		
		
		this.member = dto;
	}
	
}
