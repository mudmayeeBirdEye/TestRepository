public class OpportunityController{
	public Opportunity oppObj{get;set;}
	public String BrandName{get;set;}
	public OpportunityContactRole oppContactRole{get;set;}
	public String proposalDate{get;set;}
	public List<ProductsWrapper> ProductServiceList{get;set;}
	public List<ProductsWrapper> ProductHardwareList{get;set;}
	
	public List<Boolean> isBlankServiceList{get;set;}
	public List<Boolean> isBlankHardwareList{get;set;}
	
	public Decimal serviceTotalPrice{get;set;}
	public Decimal hardwareTotalPrice{get;set;}
		
	public OpportunityController(ApexPages.StandardController controller) {
		// ProductList = new List<ProductsWrapper>();
		ProductServiceList = new List<ProductsWrapper>();
		ProductHardwareList = new List<ProductsWrapper>();
		
		isBlankServiceList = new List<Boolean>();
		isBlankHardwareList = new List<Boolean>();
		
		serviceTotalPrice = Decimal.valueOf(0);
		hardwareTotalPrice = Decimal.valueOf(0);
		
		proposalDate = formatDate(Datetime.now());
		BrandName = 'RingCentral'; 
		this.oppObj = (Opportunity)controller.getRecord();
		oppObj = [SELECT Id, Name, OwnerId, Brand_Name__c,CurrencyISOCode, Owner.Name, Term__c, Owner.Email, Proposal_Expiration_Date__c, Owner.Phone, owner.Title, 
					(SELECT Id, ContactId, Contact.Name, Contact.Email, Contact.Phone From OpportunityContactRoles WHERE IsPrimary=true LIMIT 1),
					(SELECT PricebookEntryId,UnitPrice, CurrencyISOCode, TotalPrice, Quantity, ListPrice FROM OpportunityLineItems) FROM Opportunity WHERE Id=: oppObj.Id];
		Map<Id, List<OpportunityLineItem>> priceBookLineItem = new Map<Id, List<OpportunityLineItem>>(); 
		if(oppObj.OpportunityLineItems != null) {
			List<OpportunityLineItem> oppLineItems = oppObj.OpportunityLineItems;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'items='+oppLineItems.size()));
			Set<Id> priceBookIds = new Set<Id>();
			for(OpportunityLineItem oppLineItemObj : oppLineItems) {
				if(oppLineItemObj.PricebookEntryId != null) {
					priceBookIds.add(oppLineItemObj.PricebookEntryId);
					/*List<OpportunityLineItem> tempItem = new List<OpportunityLineItem>();
					if(priceBookLineItem.get(oppLineItemObj.PricebookEntryId) != null) {
						tempItem = priceBookLineItem.get(oppLineItemObj.PricebookEntryId); 
					}
					tempItem.add(oppLineItemObj);
					priceBookLineItem.put(oppLineItemObj.PricebookEntryId, tempItem);
					*/
				}
			}
			/*
			if(priceBookIds.size() != 0) {
				getLineItems(priceBookIds, priceBookLineItem);
			}
			*/
			// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'pricebook='+priceBookIds.size()));
			if(oppLineItems != null && oppLineItems.size() != 0) {
				getLineItems(priceBookIds, oppLineItems);
			}
		}
		if(oppObj.Proposal_Expiration_Date__c != null) {
			Datetime foundDate = Datetime.newInstance(oppObj.Proposal_Expiration_Date__c, Time.newInstance(0, 0, 0, 0));
			proposalDate =  formatDate(foundDate);
		}
		//Date.parse(foundDate.month()+'/'+foundDate.day()+'/'+foundDate.year());     		
	      if(!String.isBlank(oppObj.Brand_Name__c) && oppObj.Brand_Name__c.containsIgnoreCase('Canada')) {
	      		BrandName = 'RingCentral Canada';
	      } else if(!String.isBlank(oppObj.Brand_Name__c) && oppObj.Brand_Name__c.containsIgnoreCase('UK')) {
	      		BrandName = 'RingCentral UK';
	      } else {
				BrandName = 'RingCentral';      	
	      }
		try {
			if(oppObj.OpportunityContactRoles != null) {
				oppContactRole = oppObj.OpportunityContactRoles;
  			}
		} catch(Exception e) {}
	}
	private String superScript(String day) {
		Integer lastIndex = day.length()-1;
		if(day.lastIndexOf('0') == lastIndex)
			return 'th';
		if(day.lastIndexOf('1') == lastIndex)
			return 'st';
		if(day.lastIndexOf('2') == lastIndex)
			return 'nd';
		if(day.lastIndexOf('3') == lastIndex)
			return 'rd';
		return 'th';
	}
	private String getMonthName(Datetime d){
       return d.format('MMMMM');
    }
	// private void getLineItems(Set<Id> priceBookIds, Map<Id, List<OpportunityLineItem>> priceBookLineItem) {
	private void getLineItems(Set<Id> priceBookIds, List<OpportunityLineItem> oppLineItems) {
		Map<Id, PricebookEntry> priceBookMap = new Map<Id, PricebookEntry>([SELECT id, name, Product2.productcode, Product2.Name, 
		productcode, Product2.Tier_Family__c, Product2.description, UnitPrice FROM PricebookEntry WHERE Id IN:priceBookIds AND isActive=true]);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'pricebook='+priceBookMap.size()));
		for(OpportunityLineItem oppLineItem : oppLineItems) {
			Decimal unitP = oppLineItem.UnitPrice;
			Decimal totalP = oppLineItem.TotalPrice;
			Double quantityP = oppLineItem.quantity;
			String tierFamily = 'SERVICE';
			PricebookEntry priceBookObj = priceBookMap.get(oppLineItem.PricebookEntryId);
			if(priceBookObj != null) {
				if(!String.isBlank(priceBookObj.Product2.Tier_Family__c) && priceBookObj.Product2.Tier_Family__c.contains('Device') ) {
					tierFamily = 'DEVICE';
				}
				ProductsWrapper productObj = new ProductsWrapper(priceBookObj.Product2.Name, priceBookObj.Product2.description, 
				unitP, totalP, quantityP, tierFamily, oppLineItem.CurrencyISOCode);
				if(tierFamily == 'DEVICE') {
					ProductHardwareList.add(productObj);
					hardwareTotalPrice += totalP;
				} else {
					serviceTotalPrice += totalP;
					ProductServiceList.add(productObj);
				}
				// ProductList.add(productObj);
			}
		}
		if(ProductHardwareList.size() == 0) {
			isBlankHardwareList.add(true);
		}
		if(ProductServiceList.size() == 0) {
			isBlankServiceList.add(true);
		}
	}
	private String formatDate(Datetime foundDate) {
		return getMonthName(foundDate) + ' ' + String.valueOf(foundDate.day()) + '<sup>'+ superScript(String.valueOf(foundDate.day())) +'</sup>'+', '+ String.valueOf(foundDate.year());
		// return foundDate.month()+'/'+foundDate.day()+'/'+foundDate.year();
	}
	
	/*public PageReference sendEmail() {
		if(oppContactRole != null) {
			String docName = 'US';
			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		    /*PageReference pageRef = new PageReference('/apex/RCO_Sales_Proposal_US_2012');*/
		    /*PageReference pageRef =  Page.RC_Product_Overview_US;
			if(BrandName.contains('Canada')) {
				pageRef =  Page.RC_Product_Overview_CA;
				docName = 'CA';
			}
			if(BrandName.contains('UK')) {
				pageRef =  Page.RC_Product_Overview_UK;
				docName = 'UK';
			}
		    efa.setFileName('RCO_Sales_Proposal_'+ docName +' - ' + DateTime.now().format()+ '.pdf');
		    pageRef.getParameters().put('id',(String)oppObj.id); 
		    pageRef.setRedirect(true);
		  	Blob content; 
		  		
		  	if(!Test.isRunningTest()) {
		  		content = pageRef.getContent();
		  	} else if(Test.isRunningTest()) {
		  		content = EncodingUtil.base64Decode('Test');
		  	}
			efa.setBody(content);
	        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			// String[] toAddresses = new string[]{'virendra.singh@simplion.com'};
			email.setSubject( 'RCO_Sales_Proposal_'+ docName +' - ' + DateTime.now().format()); 
			// email.setToAddresses(toAddresses);
			Id emailAddId = (oppContactRole != null ? oppContactRole.ContactId : oppObj.ownerId);
			email.setTargetObjectId(emailAddId);
			email.setPlainTextBody('PFA');
			email.setSaveAsActivity(false);
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
		    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		}
	    return new PageReference('/'+oppObj.Id);
	}*/
	/*public PageReference attachContent() {
		/*PageReference pageRef = new PageReference('/apex/RCO_Sales_Proposal_US_2012');*/
		/*String docName = 'US';
		PageReference pageRef =  Page.RC_Product_Overview_US;
		if(BrandName.contains('Canada')) {
			pageRef =  Page.RC_Product_Overview_CA;
			docName = 'CA';
		}
		if(BrandName.contains('UK')) {
			pageRef =  Page.RC_Product_Overview_UK;
			docName = 'UK';
		}
	    // PageReference pageRef = Page.GeneratePDF;
	    pageRef.getParameters().put('id',(String)oppObj.id); 
	    pageRef.setRedirect(true);
	  	Blob content;
	  	
	  	if(!Test.isRunningTest()) {
	  		content = pageRef.getContent();
	  	} else if(Test.isRunningTest()) {
	  		content = EncodingUtil.base64Decode('Test');
	  	}
		Attachment attachObj = new Attachment();
		attachObj.ContentType = 'pdf';
		attachObj.Name = 'RCO_Sales_Proposal_'+ docName +' - ' + DateTime.now().format()+ '.pdf';
		attachObj.ParentId = oppObj.id;
		attachObj.IsPrivate = false;
		attachObj.Description = 'RCO_Sales_Proposal_'+docName+' - ' + DateTime.now().format();
		attachObj.Body = content;
		attachObj.OwnerId = UserInfo.getUserId();
		insert attachObj;	
		return new PageReference('/'+oppObj.Id);
	}*/
	public class ProductsWrapper {
		public Decimal unitPrice{get;set;}
		public Decimal extendedPrice{get;set;}
		public String productName{get;set;}
		public String description{get;set;}
		public Double quantity{get;set;}
		public String tierFamily{get;set;}
		public String CurrencyISOCode{get;set;}
		public ProductsWrapper(String productName, String description,Decimal unitPrice, Decimal extendedPrice, 
		Double quantity, String tierFamily, String CurrencyISOCode) {
			this.productName = productName;
			this.description = description;
			this.unitPrice = unitPrice;
			this.extendedPrice= extendedPrice;
			this.quantity = quantity;
			this.tierFamily = tierFamily;
			this.CurrencyISOCode = CurrencyISOCode;
		}
	}
	
/*	@isTest(seeAllData = true)
	private static void myUnitTest() {
		try {
    		Campaign camptest = new Campaign();
			camptest.Name = 'TestCampaign';
			camptest.Protected_Campaign__c = true;
			insert camptest;
		        		
			Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'test123@test.com';
	        contactObj.LastName = 'TestLast';
	        insert contactObj;
		                
	        Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp';
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtu';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
	        Test.startTest(); 
	        
	        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
	        oppLineItemObj.OpportunityId = Oppval.id;
	        oppLineItemObj.Quantity = 10;
	        oppLineItemObj.PricebookEntryId = [select id from PricebookEntry where IsActive = true and CurrencyIsoCode = 'USD' limit 1].id;
	        oppLineItemObj.TotalPrice = 100; 
	        insert oppLineItemObj;
	        
	        
	        
	        ApexPages.currentPage().getParameters().put('Id',Oppval.Id);
	        OpportunityController oppContObj = new OpportunityController(new ApexPages.StandardController(Oppval));
	        
	        Test.stopTest();
	        //oppContObj.attachContent();
	 		
    	} catch(Exception ex) {}	
	}*/
	
	/*@isTest(seeAllData = true)
	private static void myUnitTest1() {
		try {
    		
    		Campaign camptest = new Campaign();
			camptest.Name = 'TestCampaign';
			camptest.Protected_Campaign__c = true;
			insert camptest;
		        		
			Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        acctest.RC_Brand__c = 'UK';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'test123@test.com';
	        contactObj.LastName = 'TestLast';
	        insert contactObj;
		    
		    Test.startTest(); 
		                
	        Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp';
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtu';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
	        OpportunityContactRole oppContactRoleObj = new OpportunityContactRole();
	        oppContactRoleObj.OpportunityId = Oppval.Id;
	        oppContactRoleObj.ContactId = contactObj.id;
	        oppContactRoleObj.IsPrimary = true;
	        oppContactRoleObj.Role = 'Decision Maker';
	        insert oppContactRoleObj;
	        
	        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
	        oppLineItemObj.OpportunityId = Oppval.id;
	        oppLineItemObj.Quantity = 10;
	        oppLineItemObj.PricebookEntryId = [select id from PricebookEntry where IsActive = true and CurrencyIsoCode = 'USD' limit 1].id;
	        oppLineItemObj.TotalPrice = 100; 
	        insert oppLineItemObj;
	        
	        
	        ApexPages.currentPage().getParameters().put('Id',Oppval.Id);
	        OpportunityController oppContObj = new OpportunityController(new ApexPages.StandardController(Oppval));
	   		//oppContObj.sendEmail();	
	 		oppContObj.formatDate(System.now());
	 		oppContObj.getMonthName(System.now()); 
	 		oppContObj.superScript('10');     
	 		oppContObj.superScript('11');
	 		oppContObj.superScript('12');
	 		oppContObj.superScript('13');
	 		oppContObj.superScript('14');
	 		Test.stopTest();
    	} catch(Exception ex) {}	
	}*/
}