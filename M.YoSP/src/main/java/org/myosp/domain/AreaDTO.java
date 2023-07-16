package org.myosp.domain;

import lombok.Data;

@Data
public class AreaDTO {
	private int area_id;
	private String koreanName;
	private String englishName;
	private String address;
	private String season;
	private int popularity;
	private String introduction;
	
	
}
