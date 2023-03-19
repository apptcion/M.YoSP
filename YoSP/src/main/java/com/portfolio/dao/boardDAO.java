package com.portfolio.dao;

import java.util.List;

import com.portfolio.vo.boardVO;

public interface boardDAO {
 public List<boardVO> selectAll() throws Exception;
}
