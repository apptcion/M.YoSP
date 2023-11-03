package org.myosp.domain;

import java.util.List;

import lombok.Data;

@Data
public class StoreMapDTO {

	private String parameter;
	private int order;
	private String StartPoint;
	private String EndPoint;
	private String acts;
	private String UserId;
	private String StartTime;
	private String EndTime;
}
