package com.portfolio.vo;

import java.util.Date;

import lombok.Data;



@Data
public class boardVO {
	private int Pid;
	private String writer;
	private String title;
	private String content;
	private Date date;
	private String location;
	private String resource;
	private String positive;
	private boolean modified;
	private String type;
	private int recommended;
	private int dislike;
	private int views;
}
