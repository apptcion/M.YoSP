package org.myosp.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml" })
@Log4j
public class CreateBoardTestData {
	
	
	@Setter(onMethod_ = @Autowired)
	private DataSource ds;

	
	@Test
	public void test(){
		String sql = 
		"insert into comments (board_id, member_id, comments_id,comments,userName) values (121,?,comments_seq.NEXTVAL,'test Content test Content',?)";
		
		for(int i = 1; i < 10; i++ ) {

			Connection con = null;
			PreparedStatement pstmt = null;
			
			try {
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql);
				
				
				pstmt.setInt(1, i);
				pstmt.setString(2, "member" + i);
				
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)
					try {
						pstmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				if(con != null)
					try {
						con.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}
		}
	}
}
