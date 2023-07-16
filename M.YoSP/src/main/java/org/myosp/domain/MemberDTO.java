package org.myosp.domain;
 
import java.util.List;


import lombok.Data;

@Data
public class MemberDTO {

	
	private int user_id;
	private String username;
	private String password;
	private String email;
	private int enabled;
	
	private List<MemberAuthDTO> authList;
}
