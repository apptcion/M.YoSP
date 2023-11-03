package org.myosp.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.myosp.domain.BudgetArr;
import org.myosp.domain.StoreMapDTO;

@Mapper
public interface StoreMapper {

	public void store(StoreMapDTO mapDTO);
	
	public List<StoreMapDTO> read(String parameter);
	
	public void storeBudget(Map<String, String> arr);
	
	public BudgetArr readBudget(String parameter);
}
