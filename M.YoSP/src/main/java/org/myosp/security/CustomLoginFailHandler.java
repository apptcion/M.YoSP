package org.myosp.security;

import java.io.IOException;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Log4j
@Service("loginFailHandler")
public class CustomLoginFailHandler extends SimpleUrlAuthenticationFailureHandler {

	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException{
		
			
		String Error = URLEncoder.encode("아이디 또는 비밀번호가 잘못되었습니다", "UTF-8");
		setDefaultFailureUrl("/login?error=" + Error);
		
		super.onAuthenticationFailure(request, response, exception);
	}

}
