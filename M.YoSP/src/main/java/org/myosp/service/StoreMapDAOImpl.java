package org.myosp.service;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.myosp.domain.BudgetArr;
import org.myosp.domain.StoreMapDTO;
import org.myosp.mapper.BoardMapper;
import org.myosp.mapper.MemberMapper;
import org.myosp.mapper.StoreMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Service
@Log4j
public class StoreMapDAOImpl  implements StoreMapDAO{

	@Setter(onMethod_= @Autowired)
	private StoreMapper Storemapper;
	
	@Setter(onMethod_= @Autowired)
	private MemberMapper memberMapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardMapper boardMapper;
	
	@Override
	public void store(StoreMapDTO mapDTO) {
		
		Storemapper.store(mapDTO);
		
	}

	@Override
	public void storeBudget(String parameter, String HotelArr, String FoodArr, String ActivityArr) {
		
		Map<String, String> arrs = new HashMap<String, String>();
		
		arrs.put("parameter", parameter);
		arrs.put("HotelArr", HotelArr);
		arrs.put("FoodArr", FoodArr);
		arrs.put("ActivityArr", ActivityArr);
		
		Storemapper.storeBudget(arrs);
	}
	
	@Override
	public void registeration(String userName,String parameter ,String StartDay, String EndDay, String LocalKoreanName) {
		Map<String, String> mapRegister = new HashMap<String, String>();
		
		
		
		mapRegister.put("userName",userName);
		mapRegister.put("parameter",parameter);
		mapRegister.put("StartDay",StartDay);
		mapRegister.put("EndDay",EndDay);
		mapRegister.put("LocalKoreanName", LocalKoreanName);
		
		
		mapRegister.put("LocalEnglishName", boardMapper.getAreaEng(LocalKoreanName));
		
		memberMapper.registration(mapRegister);
	}
	
	@Override
	public String readMap(String parameter) {
		List<StoreMapDTO> mapList = Storemapper.read(parameter);
		
		Collections.sort(mapList, new Comparator<StoreMapDTO>() {

			@Override
			public int compare(StoreMapDTO o1, StoreMapDTO o2) {
				
				return o1.getOrder() - o2.getOrder();
			}
		});
		
		String resultStr = "[";
		
		int count = 1;
		
		System.out.println(mapList);
		
		for(StoreMapDTO mapData : mapList) {
			resultStr += "{";
			resultStr += "\"StartPoint\":" + mapData.getStartPoint();
			resultStr += ",";
			resultStr += "\"Acts\":" + mapData.getActs();
			resultStr += ",";
			resultStr += "\"EndPoint\":" + mapData.getEndPoint();
			resultStr += ",";
			resultStr += "\"StartTime\":" + mapData.getStartTime();
			resultStr += ",";
			resultStr += "\"EndTime\":" + mapData.getEndTime();
			
			if(count != mapList.size()) {
				resultStr += "},";
				count++;
			}else {
				resultStr += "}";
			}
			
		}
		
		resultStr += "]";
		return resultStr;
	}
	
	
	@Override
	public BudgetArr readBudget(String parameter) {
		return Storemapper.readBudget(parameter);
	}

}
