package org.myosp.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.myosp.domain.AreaDTO;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.Criteria;
import org.myosp.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class BoardDAOImpl implements BoardDAO {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;

	@Override
	public List<BoardDTO> readAll() {
		// List<BoardDTO> list = mapper.readAll();
		return null;
	}

	@Override
	public BoardDTO readOne(int board_id) {
		BoardDTO dto = mapper.readOne(board_id);

		mapper.addView(dto);

		dto = mapper.readOne(board_id);

		return dto;
	}

	public List<BoardDTO> getListWithPaging(Criteria cri, String order,String local) {
		List<BoardDTO> resultList = new ArrayList();
		
		List<BoardDTO> list = mapper.readAll(local);
		
		int Count = list.size();
		
		System.out.println(Count);
		
		switch (order) {
		case "byViewsDesc": // 조회 내림차순 정렬 DESC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto2.getViews() - dto1.getViews(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			break;
		case "byViewsAsc": // 조회 오름차순 정렬 ASC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto1.getViews() - dto2.getViews(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			break;
		case "byLike": // 추천수 정렬 DESC
			Collections.sort(list, new Comparator<BoardDTO>() {

				@Override
				public int compare(BoardDTO dto1, BoardDTO dto2) {
					return dto2.getGood() - dto1.getGood(); 
				}

			});
			
			for(int i = 1; i < cri.getPageNum() * cri.getAmount(); i++) {
				if(i > (cri.getPageNum()-1) * cri.getAmount()) {
					try {
						resultList.add(list.get(i-1));
					}catch(Exception e) {
						break;
					}
				}
			}
			
			
			break;
		case "byTime": // 시간순 정렬 
			break;

		}
		return resultList;
	}
	
	public int Count(String local) {
		List<BoardDTO> list = mapper.readAll(local);
		int count = list.size();
		
		return count;
	}

	@Override
	public List<AreaDTO> getAreaList() {
		List<AreaDTO> areaName = mapper.getAreaList();
		return areaName;
	}
}
