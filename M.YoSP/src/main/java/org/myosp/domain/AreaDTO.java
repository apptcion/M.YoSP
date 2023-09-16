package org.myosp.domain;

import lombok.Data;

@Data
public class AreaDTO {
	private String koreanName;
	private String englishName;
	private String address;
	private String intro;
	private double lat;
	private double lng;
	
	
}
