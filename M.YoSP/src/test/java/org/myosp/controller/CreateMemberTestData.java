package org.myosp.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml" })
@Log4j
public class CreateMemberTestData {

	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	@Setter(onMethod_ = @Autowired)
	private DataSource ds;

	@Test
	public void CreateInsertMember() {
		String sql1 = "insert into member (user_id,userName, password) values (mem_seq.NEXTVAL,?,?)";
		String sql2 = "insert into author_member (userName) values (?)";
		
		for ( int i = 0; i < 100; i++) {
		
			Connection con = null;
			PreparedStatement pstmt = null;
		
			try {
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql2);
				
				pstmt.setString(1, "member" + i);
				
				
				pstmt.executeUpdate();
				
			
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null) {try { pstmt.close(); } catch(Exception e) {}};
				if(con != null) {try {con.close();}catch(Exception e ) {}}
			}
		}
	}
}
