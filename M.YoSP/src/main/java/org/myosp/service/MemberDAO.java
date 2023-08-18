package org.myosp.service;

import javax.servlet.http.HttpServletRequest;

import org.myosp.domain.MemberDTO;

public interface MemberDAO {

	public boolean inUse(String id);
	
	public void exeJoin(String id, String password, String email);
	
	public MemberDTO read(String id);
	
	public boolean sendMail(String id, String email,String key);
	
	public void changePw(String id, String Pw);
	
}
