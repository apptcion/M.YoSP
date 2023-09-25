package org.myosp.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@org.springframework.web.bind.annotation.RestController
public class RestController {

	@RequestMapping("/restTest")
	public String restTest(@RequestParam String str) {
		return str + " : Rest Test 완료!!";
	}
	
}
