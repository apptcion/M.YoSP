package org.myosp.domain;

import java.util.Date;
import java.util.UUID;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class BoardFileDTO {

	
	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date date;
	private String uuid;
	private String fileOriginalName;
	private int Bno;
	
}
