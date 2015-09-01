public class LeadHighlighter{
	public String strCampaignDiscription{get;private set;}
    public Lead objLead1{get;set;}
    public String strLeadSourceDescription{get;private set;}
	public Boolean isBTApproved {get;set;}
    public LeadHighlighter(ApexPages.StandardController controller){
		isBTApproved = false;
	    map<String,String> mapLeadSrcToLeadsrcDescption = new map<String,String> ();
	   	objLead1 = [SELECT Id,LeadSource, Most_Recent_Campaign__c,Most_Recent_Campaign__r.Description,Most_Recent_Campaign__r.Name, PartnerDeal_Status__c  
	   				FROM Lead 
	   				WHERE id= :ApexPages.currentPage().getParameters().get('id')]; 
	     String dealStatus = objLead1.PartnerDeal_Status__c;
if('BT Approved'.equalsIgnoreCase(dealStatus)){
isBTApproved = true;
}
		Lead objLead=(Lead)controller.getRecord();
	    mapLeadSrcToLeadsrcDescption = getDescriptionByLeadSource();
	    system.debug('mapLeadSrcToLeadsrcDescption -----------------------'+mapLeadSrcToLeadsrcDescption);
	    strLeadSourceDescription = mapLeadSrcToLeadsrcDescption.get(objLead1.LeadSource);
	    system.debug('strLeadSourceDescription -----------------------'+strLeadSourceDescription);
	    strCampaignDiscription = objLead1.Most_Recent_Campaign__r.Description;
	    try{
				String  csvbody='';
				List<Document> doc= [Select body, bodyLength, ContentType, Url from Document where Name ='Frandata Franchise Executive List2'];
				if(doc.size()>0){
	                      Blob b = doc[0].body;
	                      csvbody= b.toString().toLowerCase();
				}
				String strDomainName=objLead.email.subString(objLead.email.IndexOf('@')+1);
				String regex = '\\b'+strDomainName+'\\b';
				// Pattern pattern= Pattern.compile(regex);
				Matcher matcher =Pattern.compile(regex).matcher(csvbody);
	       
				if(matcher.find()){
					String strMessage=' This Lead is a franchise Lead. Sales rep should proceed with trying to close the deal.'+
	                           		  ' Reps should attempt to sell with standard pricing. In a competitive situation where discounting is needed,'+
									  ' rep should request manager approval. If contact is Franchisor / Corporate office, rep should engage Franchise '+
									  ' team immediately.<br/><b> E-mail:<a href="mailto:franchise.support@ringcentral.com">franchise.support@ringcentral.com</a></b> ';
	          			//  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'This lead is a franchise lead and not eligible for any discounts/promotions - Please close the deal standard pricing only and contact the national accounts team at <b><a href="mailto:franchise.support@ringcentral.com">franchise.support@ringcentral.com</a></b>'));
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,strMessage));
				}
	        }catch(Exception e){
	           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
	        }
    }
   
    public static Map <String, String > getDescriptionByLeadSource() {
   		map < String, String > rtnLeadSourceMap = new map < String, String > ();
	    try {
	        List <Document> docList = [Select body, bodyLength, ContentType, Url from Document where Name = 'LeadSourceMap'];
	        system.debug('docList----------------------------------------'+docList.size());
	        if (docList != null && docList.size() > 0) {
	            if (docList[0].Body != null) {
	                List <List<String > > parsedCSV = parseCSV(docList[0].Body.toString(), true);
	                system.debug('parsedCSV----------------------------------------'+parsedCSV);
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
	        system.debug('rtnLeadSourceMap------------------------------------'+rtnLeadSourceMap);
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
}