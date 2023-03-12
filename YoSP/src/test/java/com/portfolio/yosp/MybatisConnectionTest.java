//package com.portfolio.yosp;
//
//import javax.inject.Inject;
//
//import org.apache.ibatis.session.SqlSession;
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//
//import com.portfolio.dao.memberDAOImpl;
//import com.portfolio.vo.memberVO;
//
//
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
//public class MybatisConnectionTest {
//    @Inject
//    private SqlSessionFactory sqlFactory;
//    
//    
//    @Autowired
//    memberDAOImpl dao;
//    
//    memberVO vo = new memberVO();
//    
//    @Test
//    public void testSession() throws Exception{
//        
//        try(SqlSession session = sqlFactory.openSession()){
//           vo.setId("eric");
//        vo.setId(dao.select(vo).getId());
//        vo.setName(dao.select(vo).getName());
//        vo.setPassword(dao.select(vo).getPassword());
//        System.out.println(vo);
//        //System.out.println(vo);
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}
//