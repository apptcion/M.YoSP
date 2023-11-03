package org.myosp.service;

import java.util.List;

import org.myosp.domain.BudgetArr;
import org.myosp.domain.StoreMapDTO;

public interface StoreMapDAO {

	public void store(StoreMapDTO mapDTO);
	
	public void storeBudget(String parameter, String HotelArr, String FoodArr, String ActivityArr);
	
	public void registeration(String userName,String parameter ,String StartDay, String EndDay, String LocalKoreanName);
	
	public BudgetArr readBudget(String parameter);
	
	public String readMap(String parameter);
	
}
