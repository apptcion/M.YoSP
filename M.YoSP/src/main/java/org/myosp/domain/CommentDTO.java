package org.myosp.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;


@Data
public class CommentDTO {

	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date writeDate;
	private int board_id;
	private int member_id;
	private String userName;
	private String content;
	private int comment_id;
	
}
