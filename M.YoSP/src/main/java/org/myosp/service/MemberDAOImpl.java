package org.myosp.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.myosp.domain.BoardDTO;
import org.myosp.domain.MemberDTO;
import org.myosp.domain.MyPageMapDTO;
import org.myosp.mapper.MemberMapper;
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
	public void resign(String Username) {
		mapper.resignMember(Username);
		mapper.resignAuthorMember(Username);
	}
	
	@Override
	public boolean sendMail(String id, String email,String key) {
		MemberDTO dto = read(id);
		try { if(dto.getEmail().equals(email)) {
				String title = "Trip 비밀번호 복구 코드";
				String content = "현재 웹 사이트 화면에 " + key + "를 입력해주세요";
				boolean success = exeSendMail(title,content,email);
				if(success) return true;
				return false; } 
		}catch(NullPointerException e){ return false; }
		return false;	
	}
	@Autowired
	private MailSender mailSender;
	public boolean exeSendMail(String title,String content,String email) {
		try {
			SimpleMailMessage smm = new SimpleMailMessage();
			smm.setSubject(title);smm.setText(content);smm.setTo(email);
			mailSender.send(smm);
			return true;
		}catch(Exception e) {
			return false;
		}
	}


	@Override
	public void modifyEmail(String userName, String email) {
		
		Map<String,String> map = new HashMap<>();
		
		map.put("userName",userName);
		map.put("email",email);
		
		System.out.println(map);
		
		mapper.modifyEmail(map);
		
	}


	@Override
	public List<MyPageMapDTO> readMaps(String userName) {
		
		List<MyPageMapDTO> resultMaps = mapper.readMaps(userName);
		
		Collections.sort(resultMaps, new Comparator<MyPageMapDTO>() {
		
			@Override
			public int compare(MyPageMapDTO dto1, MyPageMapDTO dto2) {
				
				SimpleDateFormat Str2Date = new SimpleDateFormat("yyyy.MM.dd");

				SimpleDateFormat Date2Int = new SimpleDateFormat("yyyyMMdd");
				
				int tempDto1Number = 0;
				int tempDto2Number = 0;
				
				
				try {
					tempDto1Number = Integer.parseInt(Date2Int.format(Str2Date.parse(dto1.getStartDay())));
					tempDto2Number = Integer.parseInt(Date2Int.format(Str2Date.parse(dto2.getStartDay())));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
						
				
				return tempDto1Number - tempDto2Number; 
			}
		
		});
		
		return resultMaps;
	}
	

}
