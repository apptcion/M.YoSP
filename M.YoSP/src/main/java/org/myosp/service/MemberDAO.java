package org.myosp.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.myosp.domain.MemberDTO;
import org.myosp.domain.MyPageMapDTO;

public interface MemberDAO {

	public boolean inUse(String id);
	
	public void exeJoin(String id, String password, String email);
	
	public MemberDTO read(String id);
	
	public boolean sendMail(String id, String email,String key);
	
	public void changePw(String id, String Pw);
	
	public void resign(String userName);
	
	public void modifyEmail(String userName, String email);
	
	public List<MyPageMapDTO> readMaps(String userName);

}
