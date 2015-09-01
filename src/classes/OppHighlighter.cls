public class OppHighlighter{
public Boolean isBTApproved {get;set;}
public String strCampaignDiscription{get;private set;}
    public Opportunity objOpp{get;set;}
    public String strLeadSourceDescription{get;private set;}
   	static String strBTBrand;
       
   static{
   	if(!Test.isRunningTest()){
        strBTBrand = RcDealHealper.getBTBrand();
    }else{
        strBTBrand = 'BT Business';
    }
    strBTBrand = strBTBrand.trim();
   }
    public OppHighlighter(ApexPages.StandardController controller){
	isBTApproved = false;
    map<String,String> mapLeadSrcToLeadsrcDescption = new map<String,String> ();
    Opportunity objOpportunity =(Opportunity)controller.getRecord();
    objOpp = [SELECT Id, LeadSource, CampaignId, Campaign.Description, Campaign.Name, Account.RC_Brand__c  
	   		  FROM Opportunity 
	   		  WHERE id= :ApexPages.currentPage().getParameters().get('id')];
	if(objOpp != null){
		String rcBrand = objOpp.Account.RC_Brand__c;
        if(String.isNotBlank(rcBrand) && strBTBrand.equalsIgnoreCase(rcBrand.trim())){
   			isBTApproved = true;
   		}
	}
	mapLeadSrcToLeadsrcDescption = getDescriptionByLeadSource();
	strLeadSourceDescription = mapLeadSrcToLeadsrcDescption.get(objOpp.LeadSource);
	strCampaignDiscription = objOpp.Campaign.Description;
    try{
           String  csvbody='';
           List<Document> doc= [Select body, bodyLength, ContentType, Url from Document where Name ='Frandata Franchise Executive List2'];
           if(doc.size()>0){
                      Blob b = doc[0].body;
                      csvbody= b.toString().toLowerCase();
                      
           }
           Opportunity opp = [SELECT id,(Select Contact.Email From OpportunityContactRoles) From Opportunity WHERE id =:objOpportunity.id];
           List<String> emailDomains = new List<String>();
            
            for(OpportunityContactRole opr: opp.OpportunityContactRoles) {
                emailDomains.add(opr.Contact.Email);
            }
         
         if( isDomainExist(emailDomains,csvbody)){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'This opportunity is a franchise opportunity and not eligible for any discounts/promotions - Please close the deal standard pricing only and contact the national accounts team at <b><a href="mailto:franchise.support@ringcentral.com">franchise.support@ringcentral.com</a></b>'));
              String strMessage=' This opportunity is a franchise opportunity. Sales rep should proceed with trying to close the deal.'+
                           ' Reps should attempt to sell with standard pricing. In a competitive situation where discounting is needed,'+
                           ' rep should request manager approval. If contact is Franchisor / Corporate office, rep should engage Franchise '+
                           ' team immediately.<br/><b> E-mail:<a href="mailto:franchise.support@ringcentral.com">franchise.support@ringcentral.com</a></b> ';
          
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,strMessage));
         }
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
        }
    }

 	private Boolean isDomainExist(List<String> emailDomains,String csvbody){
	    Boolean isExist=false;
	    
	    for(Integer i=0;i<emailDomains.size()&& !isExist ;i++ ){
	    	try{
		    	if(emailDomains[i] != null && emailDomains[i] != ' '){
		    		String strDomainName=emailDomains.get(i).subString(emailDomains.get(i).IndexOf('@')+1);
		            String regex = '\\b'+strDomainName+'\\b';
		            Matcher matcher =Pattern.compile(regex).matcher(csvbody);
		            if(matcher.find()){
		              isExist=true;
		            }
		    	}
	    	}catch(exception Ex){} 
	    }
	    return isExist;
   }
   public static Map <String, String > getDescriptionByLeadSource() {
   		map < String, String > rtnLeadSourceMap = new map < String, String > ();
	    try {
	        List <Document> docList = [Select body, bodyLength, ContentType, Url from Document where Name = 'LeadSourceMap'];
	       // system.debug('docList----------------------------------------'+docList.size());
	        if (docList != null && docList.size() > 0) {
	            if (docList[0].Body != null) {
	                List <List<String > > parsedCSV = parseCSV(docList[0].Body.toString(), true);
	               // system.debug('parsedCSV----------------------------------------'+parsedCSV);
	                if (parsedCSV != null) {
	                    for (List < String > listObj: parsedCSV) {
	                        if (!String.isBlank(listObj[0]) && !String.isBlank(listObj[1])) {
	                            //system.Debug('>>listObj[3]>>>' + listObj[3]);
	                            String formatLeadSourceDescription = listObj[1].replace('$', '').replace('"', '').replace(',', '').trim();
	                            //system.Debug('>>formatAmount>>>' + formatAmount);
	                            rtnLeadSourceMap.put(listObj[0], formatLeadSourceDescription);
	                        }
	                    }
	                }
	            }
	        }
	        //system.debug('parsedCSV-----------------------------------------------'+parsedCSV);
	        //system.debug('rtnLeadSourceMap------------------------------------'+rtnLeadSourceMap);
	        return rtnLeadSourceMap;
	    } catch (Exception ex) {
	        system.Debug('>>ex>>>' + ex.getMessage());
	    }
	    return null;
	}
	
	private static List < List < String >> parseCSV(String contents, Boolean skipHeaders) {
	    List < List < String >> allFields = new List < List < String >> ();
	    contents = contents.replaceAll(',"""', ',"DBLQT').replaceall('""",', 'DBLQT",');
	    contents = contents.replaceAll('""', 'DBLQT');
	    List < String > lines = new List < String > ();
	    try {
	        lines = contents.split('\n');
	    } catch (System.ListException e) {
	        System.debug('Limits exceeded?' + e.getMessage());
	    }
    	Integer num = 0;
	    for (String line: lines) {
	        if (line.replaceAll(',', '').trim().length() == 0) break;
	        List < String > fields = line.split(',');
	        List < String > cleanFields = new List < String > ();
	        String compositeField;
	        Boolean makeCompositeField = false;
	        for (String field: fields) {
	            if (field.startsWith('"') && field.endsWith('"')) {
	                cleanFields.add(field.replaceAll('DBLQT', '"'));
	            } else if (field.startsWith('"')) {
	                makeCompositeField = true;
	                compositeField = field;
	            } else if (field.endsWith('"')) {
	                compositeField += ',' + field;
	                cleanFields.add(compositeField.replaceAll('DBLQT', '"'));
	                makeCompositeField = false;
	            } else if (makeCompositeField) {
	                compositeField += ',' + field;
	            } else {
	                cleanFields.add(field.replaceAll('DBLQT', '"'));
	            }
	        }
	        allFields.add(cleanFields);
	    }
    	if (skipHeaders) allFields.remove(0);
			return allFields;
	}

   
/* public static testMethod void myUnitTest(){
  try{
     Contact objContact =(Contact )SmartFactory.createSObject('Contact', true);
     objContact.Email='test@shuttleexpress.com';
     upsert objContact;
     
     Opportunity objOpportunity =(Opportunity)SmartFactory.createSObject('Opportunity', true);
     objOpportunity.StageName='test';
     objOpportunity.CloseDate=system.Today();
     upsert objOpportunity;
      system.assert(objOpportunity.id!=null);
    
     OpportunityContactRole objCon=(OpportunityContactRole)SmartFactory.createSObject('OpportunityContactRole', true);
     objCon.OpportunityId=objOpportunity.id;
     objCon.ContactId=objContact.Id;
     upsert objCon;
     
     ApexPages.StandardController controller=new ApexPages.StandardController(objOpportunity );
     OppHighlighter obj=new OppHighlighter(controller);
     
       Opportunity objOpportunity2=(Opportunity)SmartFactory.createSObject('Opportunity', true);
       controller=new ApexPages.StandardController(objOpportunity2);
       obj=new OppHighlighter(controller);
   }catch(Exception e){
   
   }
 }*/
}