package org.myosp.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

		private int startPage;
		private int endPage;
		private boolean prev,next;
		
		private int total;
		private Criteria cri;
		
		private int realEnd;
		
		public PageDTO(Criteria cri,int total) {
			this.cri = cri;
			this.total = total;
			
			this.endPage = (int)(cri.getPageNum() + 2); // 최대
			this.startPage = this.endPage -4; // 최소

			realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
			
			if(realEnd < this.endPage) {
				this.endPage = realEnd;
			}
			if(startPage <= 0) {
				this.startPage = 1;
			}
			
			this.prev = this.startPage > 1;
			this.next = this.endPage < realEnd;
		}
	
}
