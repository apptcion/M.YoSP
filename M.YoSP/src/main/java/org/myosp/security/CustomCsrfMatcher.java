package org.myosp.security;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.web.util.matcher.RequestMatcher;

public class CustomCsrfMatcher implements RequestMatcher{

	private static final String[] CSRF_DISABLED_METHODS = {"GET","HEAD","TRACE","OPTIONS"};
	private static final String[] CSRF_DISABLED_URI = {"/jusoPopup","/storeMap"};

	@Override
	public boolean matches(HttpServletRequest request) {
	
		String method = request.getMethod();
		String requestURI = request.getRequestURI();
		
		for(String URIToDisable : CSRF_DISABLED_URI) {
			if(requestURI.equalsIgnoreCase(URIToDisable)) {
				return false;
			}
		}
		
		for(String methodToDisable : CSRF_DISABLED_METHODS) {
			if(method.equalsIgnoreCase(methodToDisable)) {
				return false;
			}
		}
		
		return true;
	}
	
	
}
