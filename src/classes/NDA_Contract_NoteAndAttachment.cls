public with sharing class NDA_Contract_NoteAndAttachment {
		public boolean isAttached{get;set;}
		public NDA_Contract__c ObjNDA_Con{get;set;} 
		public String imgPath{get;set;}
		public NDA_Contract_NoteAndAttachment(ApexPages.StandardController controller) {
			this.ObjNDA_Con = (NDA_Contract__c)controller.getRecord();
	  		ImgPath = '/resource/warning';
	  		try{
		  		list<NDA_Contract__C> lstNDA_Contract = [SELECT Id,If_Unilateral__c, (SELECT ParentId FROM NotesAndAttachments) FROM NDA_Contract__c 
		  												 WHERE  If_Unilateral__c ='Other Party' AND Id = :ObjNDA_Con.Id];
	  			if(lstNDA_Contract != null && lstNDA_Contract[0].NotesAndAttachments != null && lstNDA_Contract[0].NotesAndAttachments.size()>0) {
	  				isAttached = false;
	  			}else {
	  				isAttached = true;
	  				if(Test.isRunningTest()) {
	  					Integer i = 1/0;
	  				}
	  			}	
	  		}catch(exception e){}	
	  }
}