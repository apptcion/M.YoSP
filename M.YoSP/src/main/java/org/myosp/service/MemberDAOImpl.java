package org.myosp.service;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.util.HashMap;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.myosp.domain.MemberDTO;
import org.myosp.mapper.BoardMapper;
import org.myosp.mapper.MemberMapper;
import org.myosp.security.CreateRandKey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;



@Service
@Log4j
public class MemberDAOImpl implements MemberDAO{

	
	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	
	@Autowired
	private BCryptPasswordEncoder PwEncoder;
	
	@Override
	public boolean inUse(String id) {
		
		int result = mapper.inUse(id);
		
		if(result == 0) {
			return false;
		}
		return true;
	}
	
	
	@Override
	public void exeJoin(String id, String password, String email) {
		
		Map<String,String> map = new HashMap<>();
		
		password = (String)PwEncoder.encode(password);
		
		map.put("username",id);
		map.put("password",password);
		map.put("email",email);
		
		
		mapper.JoinMember(map);
		mapper.JoinAuth(id);
	}
	
	
	@Override
	public MemberDTO read(String id) {
		 return mapper.read(id);
	}
	
	@Override
	public void changePw(String id, String Pw) {
		
		Pw = PwEncoder.encode(Pw);
		
		Map<String,String> map = new HashMap<>();
		
		map.put("username", id);
		map.put("password",Pw);
		
		mapper.changePw(map);
	}
	
	
	@Override
	public boolean sendMail(String id, String email,String key) {
		
		MemberDTO dto = read(id);
		
		try {
			if(dto.getEmail().equals(email)) {
				
				String title = "Trip 비밀번호 복구 코드";
				String content = "현재 웹 사이트 화면에 " + key + "를 입력해주세요";
				
				boolean success = exeSendMail(title,content,email);
				
				if(success) {
					return true;
				}
				return false;
			}
		}catch(NullPointerException e){
			return false;
		}
		return false;
		
	}
	
	
	@Autowired
	private MailSender mailSender;
	
	public boolean exeSendMail(String title,String content,String email) {
		
		try {
			SimpleMailMessage smm = new SimpleMailMessage();
			
			smm.setSubject(title);
			smm.setText(content);
			smm.setTo(email);
			
			mailSender.send(smm);
			
			return true;
		}catch(Exception e) {
			return false;
		}
	}
	

}
