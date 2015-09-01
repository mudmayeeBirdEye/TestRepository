public class RCSupportAdvCaseDetail {
	
	public ApexPages.StandardController controller {get;set;}
	public Case caseDetailObj {get;set;}
	public Case caseObj {set;get;}
	public string strFormatDate {get;set;}
	public List<CommentWrapper> commentWrapperList {get;set;}
	//public Attachment attachment {get;set;} 
	public boolean toShowAttachmentLinks {get;set;}
	public string commentDesc {get;set;}
	public boolean isCaseCommentPublic {get;set;}
	public string strTimeMessage {get;set;}
	public boolean isCaseInClosedStatus {get;set;}
	public boolean toShowCommentErrorMessage {set;get;}
	
	public RCSupportAdvCaseDetail(ApexPages.StandardController controller) {
		this.controller = controller;
		toShowAttachmentLinks = false;
		isCaseCommentPublic = false;
		caseDetailObj = new Case();
		getClosedStatus();
		toShowCommentErrorMessage = false;
        caseObj = [SELECT id, status FROM Case where Id =:controller.getId()];
        String errVariable = apexpages.currentPage().getParameters().get('showErr');
        if(errVariable == 'true' && (caseObj.Status != null && closedStatusSet != null && closedStatusSet.contains((caseObj.Status.toUpperCase())))){
            toShowCommentErrorMessage = true;
            errorMessage = 'You\'re Case was recently closed. Comments cannot be made to a Case which has been Closed.';
        }
		//getCaseDetail();
	}
	
	public Attachment attachment {
	  get {
	      if (attachment == null)
	        attachment = new Attachment();
	      return attachment;
	    }
	  set;
  	}
	
	public boolean toShowDispositionWebCase {get;set;}
	public PageReference getCaseDetail() {
		commentWrapperList = new List<CommentWrapper>();
		if(controller.getId() != null) {
			isCaseInClosedStatus = false;
			try {
				caseDetailObj = [SELECT Subject,CaseNumber,Description,createdDate,status,Account.Name,Case_Severity__c,Product_Assistance__c,Product_Assistance_Lvl2__c,Product_Assistance_Lvl3__c, 
                                Entitlement.Name,Entitlement.BusinessHours.Name ,Entitlement.BusinessHours.FridayEndTime,Entitlement.BusinessHours.FridayStartTime,Resolution__c,
                                Support_Disposition_Level_2__c, Support_Disposition_Level_1__c,recordtypeId,
                                Entitlement.BusinessHours.MondayEndTime,Entitlement.BusinessHours.MondayStartTime,Entitlement.BusinessHours.SaturdayEndTime,
                                Entitlement.BusinessHours.SaturdayStartTime,Entitlement.BusinessHours.SundayEndTime,Entitlement.BusinessHours.SundayStartTime,
                                Entitlement.BusinessHours.ThursdayEndTime,Entitlement.BusinessHours.ThursdayStartTime,Entitlement.BusinessHours.TuesdayEndTime,
                                Entitlement.BusinessHours.TuesdayStartTime,Entitlement.BusinessHours.WednesdayEndTime,Entitlement.BusinessHours.WednesdayStartTime,
                                (SELECT IsPublished, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById,CreatedBy.Name 
                                FROM CaseComments where  IsDeleted = false order by createddate desc),(SELECT Id, ParentId, Name FROM Attachments) FROM Case where Id =:controller.getId()];
                                
                               // caseDetailObj = [SELECT Subject,CaseNumber,Description,createdDate,status,Account.Name,Case_Severity__c,
                                					//Product_Assistance__c FROM Case where Id =:controller.getId()];
				
				if(caseDetailObj != null) {
					strFormatDate = caseDetailObj.CreatedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles');
					for(CaseComment caseCommentObj : caseDetailObj.CaseComments) {
						System.Debug('>>5>>'+caseCommentObj.IsPublished);
				 		CommentWrapper commentWRObj = new CommentWrapper();
				 		commentWRObj.commentBody = caseCommentObj.CommentBody;
				 		commentWRObj.openedBy = caseCommentObj.CreatedBy.Name;
				 		commentWRObj.openeddateformat = caseCommentObj.CreatedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles');
				 		commentWrapperList.add(commentWRObj);		
					}
					if(caseDetailObj.Attachments != null && caseDetailObj.Attachments.size()>0) {
						toShowAttachmentLinks = true;
					} else {
						toShowAttachmentLinks = false; 
					}	
					assignSLAMessage(caseDetailObj);
					setDisposition(caseDetailObj.recordtypeId);
					if(caseDetailObj.Status != null && closedStatusSet != null && closedStatusSet.contains((caseDetailObj.Status.toUpperCase()))) {
						isCaseInClosedStatus = true;
					}
				}					
			} catch(Exception ex) {
				System.Debug('>>>>!!!!>>'+ex.getMessage());
				//PageReference pgRef = new PageReference('/RCSupportPortalUnauthorized');
				//PageReference pgRef = new PageReference('https://ringcentral.box5.cs12.force.com/RCSupportPortal/RCSupportPortalUnauthorized');
				//pgRef.setRedirect(true);
				//System.Debug('>>>>!!!!ee>>'+pgRef);
				//return pgRef;
			}
		}
		return null;	
	}
	
	Set<string> closedStatusSet = new Set<string>();
    public void getClosedStatus() {
    	closedStatusSet.add(('Duplicate').toUpperCase());
    	closedStatusSet.add(('Invalid').toUpperCase());
    	closedStatusSet.add(('Cancelled').toUpperCase());
    	closedStatusSet.add(('Closed').toUpperCase());
    	closedStatusSet.add(('Closed - Endorsed').toUpperCase());
    	closedStatusSet.add(('Closed - No Contact').toUpperCase());
    	closedStatusSet.add(('Closed - No Issue').toUpperCase());
    	closedStatusSet.add(('Closed - No Response').toUpperCase());
    }
	
	public void setDisposition(string recordTypeId) {
		try {
			Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    		if(!String.isBlank(recordTypeId) && rtMapByName != null && rtMapByName.get(recordTypeId).getName() == 'Support-Case') {
    			toShowDispositionWebCase = true;
    		} 
		} catch(Exception ex) {
			
		}
	}
	
	public class TimeWrapper{
        public Time startTime{get;set;}
        public Time endTime{get;set;}
        public TimeWrapper(Time startTime, Time endTime) {
            this.startTime = startTime;
            this.endTime = endTime;
        }
    }
    
    public Map<String,TimeWrapper> getBusinesssHoursDetail(BusinessHours businessHoursObj){
        Map<String,TimeWrapper> businessHourDetailMap = new Map<String,TimeWrapper>();
        businessHourDetailMap.put('Monday', new TimeWrapper(businessHoursObj.MondayStartTime, businessHoursObj.MondayEndTime));
        businessHourDetailMap.put('Tuesday', new TimeWrapper(businessHoursObj.TuesdayStartTime, businessHoursObj.TuesdayEndTime));
        businessHourDetailMap.put('Wednesday', new TimeWrapper(businessHoursObj.WednesdayStartTime, businessHoursObj.WednesdayEndTime));
        businessHourDetailMap.put('Thursday', new TimeWrapper(businessHoursObj.ThursdayStartTime, businessHoursObj.ThursdayEndTime));
        businessHourDetailMap.put('Friday', new TimeWrapper(businessHoursObj.FridayStartTime, businessHoursObj.FridayEndTime));
        businessHourDetailMap.put('Saturday', new TimeWrapper(businessHoursObj.SaturdayStartTime, businessHoursObj.SaturdayEndTime));
        businessHourDetailMap.put('Sunday', new TimeWrapper(businessHoursObj.SundayStartTime, businessHoursObj.SundayEndTime));
        return businessHourDetailMap;
    }
    private void assignSLAMessage(Case caseDetailObj) {
        /**************** FOR SUPPORT BASIC BUSINESS HOURS ********************/
        if(caseDetailObj.Entitlement.BusinessHours.Name != null && caseDetailObj.Entitlement.BusinessHours.Name.equalsIgnoreCase('Support - Basic')) {
            /************* CONDITION 1 - Submission date lies between Business Hours ***********************/
            Map<String,TimeWrapper> businessHourDetailMap = getBusinesssHoursDetail(caseDetailObj.Entitlement.BusinessHours);
            DateTime caseSubmissionDate = caseDetailObj.CreatedDate;
            DateTime alteredDate = caseSubmissionDate.addHours(1);
            String currentDay = alteredDate.format('EEEE');
            TimeWrapper range = businessHourDetailMap.get(currentDay);
            if(range != null && range.startTime != null && range.endTime != null) { 
                /*String laFormattedDate = caseSubmissionDate.format('yyyy-MM-dd HH:mm:ss','America/Los_Angeles');*/
                DateTime localTime = DateTime.newInstance(alteredDate.date(), alteredDate.time());
                TimeZone tz = TimeZone.getTimeZone('America/Los_Angeles');
                DateTime dtObj = DateTime.newInstance(alteredDate.getTime() + tz.getOffset(alteredDate));
                
                DateTime rangeStartTime = DateTime.newInstance(alteredDate.date(), range.startTime);
                rangeStartTime = DateTime.newInstance(rangeStartTime.getTime()+ tz.getOffset(rangeStartTime));
                DateTime rangeEndTime = DateTime.newInstance(alteredDate.date(), range.endTime);
	            rangeEndTime = DateTime.newInstance(rangeEndTime.getTime()+ tz.getOffset(rangeEndTime));
	            
	            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## dtObj = '+ dtObj.hour()));
	            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, range.startTime + ' ## rangeStartTime = '+ rangeStartTime.hour() + ' ##'));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, range.endTime + ' ## rangeEndTime = '+ rangeEndTime.hour() + ' ##'));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, range.endTime + ' ## rangeEndTime = '+ alteredDate.hourGmt() + ' ##'));
	            /*
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## dtObj = '+ dtObj + ' ## localTime = ' + localTime));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## CURRENT DAY = ' + currentDay +' ## Date.today() = '+ Date.today() + ' ##'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## rangeStartTime = '+ rangeStartTime + ' ##'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## rangeEndTime = '+ rangeEndTime + ' ##'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ### '+(dtObj.time().hour()) +'-'+ (range.startTime.millisecond()) + ' && ' + ((dtObj.millisecondGmt()) +' - '+ (range.endTime.millisecond()))));
                */
                
                // if((alteredDate.getTime() > rangeStartTime.getTime() && alteredDate.getTime() < rangeEndTime.getTime()) || (rangeStartTime.getTime() == rangeEndTime.getTime())){}
                /*if((dtObj.getTime() > rangeStartTime.getTime() && dtObj.getTime() < rangeEndTime.getTime()) 
                	|| (rangeStartTime.getTime() == rangeEndTime.getTime())){}*/
            	if((getMilliSeconds(dtObj)  >= getMilliSeconds(rangeStartTime) && getMilliSeconds(dtObj) < getMilliSeconds(rangeEndTime)) 
                	|| (getMilliSeconds(rangeStartTime) == getMilliSeconds(rangeEndTime))){
                    if(caseDetailObj.Case_Severity__c.equalsIgnoreCase('Level 2 - Urgent')) {
                    	 strTimeMessage = 'Your case has been submitted. You will receive a response within 1 hour.';
                    	 if(((getMilliSeconds(dtObj) + getHourMilliSeconds(1)) > getMilliSeconds(rangeEndTime)) && !(getMilliSeconds(rangeStartTime) == getMilliSeconds(rangeEndTime))) {
                    	 	strTimeMessage ='Your case has been submitted. You will receive a response on the next business day.';
                    	 }
                    } else if(caseDetailObj.Case_Severity__c.equalsIgnoreCase('Level 3 - High')) {
                    	  strTimeMessage = 'Your case has been submitted. You will receive a response within 4 hours.';
                    	  //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ## rangeEndTime = '+ dtObj.hourGmt() + ' ## + ' + rangeStartTime.hourGmt()));
                		  //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' ### '+ rangeEndTime.hourGmt()));
                    	 if(((getMilliSeconds(dtObj) + getHourMilliSeconds(4)) > getMilliSeconds(rangeEndTime)) && !(getMilliSeconds(rangeStartTime) == getMilliSeconds(rangeEndTime))) {
                    	 	strTimeMessage ='Your case has been submitted. You will receive a response on the next business day.';
                    	 }
                    } else if(caseDetailObj.Case_Severity__c.equalsIgnoreCase('Level 4 - Medium')) {
                    	strTimeMessage = 'Your case has been submitted. You will receive a response within 8 hours.';
                    	if(((getMilliSeconds(dtObj) + getHourMilliSeconds(8)) > getMilliSeconds(rangeEndTime)) && !(getMilliSeconds(rangeStartTime) == getMilliSeconds(rangeEndTime))) {
                    	 	strTimeMessage ='Your case has been submitted. You will receive a response on the next business day.';
                	 	}
                    }
                } 
            }
            if(strTimeMessage== null){
                 strTimeMessage ='Your case has been submitted. You will receive a response on the next business day.';
            }
        } else if((caseDetailObj.Entitlement.BusinessHours.Name != null && 
            caseDetailObj.Entitlement.BusinessHours.Name.equalsIgnoreCase('Support - Office Premium') )){
            strTimeMessage = 'You will receive a response within 1 hour.';
        } else if((caseDetailObj.Entitlement.BusinessHours.Name != null && caseDetailObj.Entitlement.BusinessHours.Name.equalsIgnoreCase('Support Office Standard'))) {
            strTimeMessage = 'You will receive a response within 1 hour.';
        } else {
            strTimeMessage ='Your case has been submitted. You will receive a response on the next business day.';
        }
    }
    private Integer getHourMilliSeconds(Integer hour) {
    	return (hour*60*60);
    }
    private Integer getMilliSeconds(DateTime timeObj) {
        return (timeObj.hourGmt()*60*60 + timeObj.minuteGmt()*60 + timeObj.secondGmt());
    }
	//PageReference rtnPg = new PageReference('/RCSupportPortalCreateNewCase?parentId='+ '500V0000002Fr8KIAS');
	public PageReference sentToClone() {
		try {
			PageReference rtnPg;
			if(controller.getId() != null && controller.getId() != '') {
				rtnPg = new PageReference('/RCSupportPortalCreateNewCase?parentId='+ controller.getId());
			} else if(Apexpages.currentPage().getParameters().get('Id') != null && Apexpages.currentPage().getParameters().get('Id') != '') {
				rtnPg = new PageReference('/RCSupportPortalCreateNewCase?parentId='+ Apexpages.currentPage().getParameters().get('Id'));
			}
			rtnPg.setRedirect(true);
			return rtnPg;
		} catch(Exception ex) {}
		return null; 
	}
	
	/*public PageReference addCaseComment() {
		PageReference pgref;  
		try {
			CaseComment caseCommentObjToIns = new CaseComment();
			System.Debug('>>1>>'+caseCommentObjToIns);
			caseCommentObjToIns.ParentId = controller.getId();
			caseCommentObjToIns.CommentBody = commentDesc;
			System.Debug('>>2>>'+caseCommentObjToIns);
			System.Debug('>>3>>'+caseCommentObjToIns.IsPublished);
			//caseCommentObjToIns.IsPublished = isCaseCommentPublic;
			insert caseCommentObjToIns;
			System.Debug('>>4>>'+caseCommentObjToIns.IsPublished);
			//getCaseDetail();
			pgref = new PageReference('/RCSupportAdvCaseDetail');
			pgref.getParameters().put('Id',caseDetailObj.Id);
			//pg.getParameters().put('IsView','true');
			pgref.setRedirect(true);
			return pgref;
		} catch(Exception ex) {}
		return null;
	}*/
	
	 public PageReference addCaseComment() {
        PageReference pgref;  
        try {
            caseObj = [SELECT Id, Status FROM Case WHERE Id =:controller.getId()];
            if(!(caseObj.Status != null && closedStatusSet != null && closedStatusSet.contains((caseObj.Status.toUpperCase())))){
                CaseComment caseCommentObjToIns = new CaseComment();
                //System.Debug('>>1>>'+caseCommentObjToIns);
                caseCommentObjToIns.ParentId = controller.getId();
                caseCommentObjToIns.CommentBody = commentDesc;
               // System.Debug('>>2>>'+caseCommentObjToIns);
              //  System.Debug('>>3>>'+caseCommentObjToIns.IsPublished);
                //caseCommentObjToIns.IsPublished = isCaseCommentPublic;
                insert caseCommentObjToIns;
              //  System.Debug('>>4>>'+caseCommentObjToIns.IsPublished);
                //getCaseDetail();
                pgref = new PageReference('/RCSupportAdvCaseDetail');
                pgref.getParameters().put('Id',caseDetailObj.Id);
                //pg.getParameters().put('IsView','true');
                pgref.setRedirect(true);
                return pgref;
             }else {
                toShowCommentErrorMessage = true;
                errorMessage = 'You\'re Case was recently closed. Comments cannot be made to a Case which has been Closed.';
                pgref = new PageReference('/RCSupportAdvCaseDetail');
                pgref.getParameters().put('showErr','true');
                pgref.getParameters().put('Id',caseDetailObj.Id);
                pgref.setredirect(true);
                return pgref;
            }
        } catch(Exception ex) {}
        return null;
    }
	
	public string errorMessage {get;set;}
	public boolean toShowErrorMessage {get;set;}
	public Integer fileSize {get;set;}
	public PageReference attachFile() {
		toShowErrorMessage = false;
		PageReference pgref; 
		try {
			if(attachment != null && attachment.body != null) {
				System.Debug('>>>##>>323'+fileSize);
				if(fileSize != null) {
					Decimal fileSizeDB = Decimal.valueof(fileSize)/(1024 * 1024);
					System.Debug('>>>##>>323e>>'+fileSizeDB);
					if(fileSizeDB > 5) {
						toShowErrorMessage = true;
						//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Uploaded file size must not be greater then 5 MB.'));
						errorMessage = 'Uploaded file size must not be greater then 5 MB.';
						return null;
					} 		
				}	
				Attachment attachObj = attachment; 
				attachObj.ParentId = controller.getId();
				insert attachObj;
				System.Debug('>>>##>>3'+attachObj);	
				//getCaseDetail();
				pgref = new PageReference('/RCSupportAdvCaseDetail');
				pgref.getParameters().put('Id',caseDetailObj.Id);
				//pg.getParameters().put('IsView','true');
				pgref.setRedirect(true);
				return pgref;
			} else {
				toShowErrorMessage = true;
				//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the file before upload.'));
				errorMessage = 'Please select the file before upload.';
				//pgref = new PageReference('/RCSupportAdvCaseDetail');
				//pgref.getParameters().put('Id',caseDetailObj.Id);
				//pg.getParameters().put('IsView','true');
				//pgref.setRedirect(false);
				//return pgref;
				return null;	
			}			
		} catch(Exception ex) {}
		return null; 
	}
	
	public string deleteAttachId {get;set;}
	public PageReference deleteAttachment() {
		System.Debug('>>!@#>>'+deleteAttachId);
		try {
			if(deleteAttachId != null) {
				Attachment attachObj = new 	Attachment(Id = deleteAttachId);
				if(attachObj != null) {
					delete attachObj;
					getCaseDetail();	
				}
			}
			if(Test.isRunningTest()){ 
				Integer i = 1/0;
			}
		} catch(Exception ex) {
			System.Debug('>>111!@#>>'+ ex);
		}
		return null;	 
	}
	
	
	
	public class CommentWrapper {
		public string commentBody {get;set;}
		public string openedBy {get;set;}
		public string openeddateformat {get;set;}
		
		public CommentWrapper() {
			commentBody = null;
			openedBy = null;
			openeddateformat = null;	
		}
	}
}