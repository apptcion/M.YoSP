package org.myosp.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class BoardDTO{
	private int board_id;
	private int MemberId;
	private String writer;
	@DateTimeFormat(pattern = "yyyy/MM/dd/HH/mm")
	private Date writeDate;
	private int views;
	private String title;
	private String content;
	private int good;
	private int dislike;
	private String local;
	private String contentType;
	private String sources;
	private int rownum;
	
}
