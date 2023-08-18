package org.myosp.controller;

import java.util.List;

import org.junit.Test;




import org.junit.runner.RunWith;
import org.myosp.domain.BoardDTO;
import org.myosp.domain.Criteria;
import org.myosp.domain.MemberDTO;
import org.myosp.mapper.BoardMapper;
import org.myosp.mapper.MemberMapper;
import org.myosp.service.BoardDAOImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

		@Setter(onMethod_=@Autowired)
		public BoardMapper mapper;

		
		@Autowired
		public BoardDAOImpl dao;
		
		@Test
		public void testUserbyUserName() {
			
			log.info(mapper.readComments(121));

		}
}
