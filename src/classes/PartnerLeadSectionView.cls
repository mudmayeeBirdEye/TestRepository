public with sharing class PartnerLeadSectionView {
    public List<WRPartnerLeadInfo> listWrPartnerLeadInfo {get;set;} 
    public String strId{get;Set;}
    public List<Account> childPartnerAccountList{get;set;}   
	private Set<string> partnerIDSet;
	private map<string,Account> mapPartnerIdToAccount;
	private Account accObj;
	public Boolean isViewAll{get;set;}

    public PartnerLeadSectionView(ApexPages.StandardController controller) {
        try {
            //string Controller.getId() = [select contact.AccountId from User where Id = :UserInfo.getUserId()].contact.AccountId;
           isViewAll=false;
           String strViewAll=ApexPages.currentpage().getParameters().get('viewAll');
           if(strViewAll!=null && strViewAll!=''){
           	isViewAll=true;
           }
           
            if(Controller.getId() != null) {
            	strId = Controller.getId();
                listWrPartnerLeadInfo = new List<WRPartnerLeadInfo>();
                partnerIDSet = new set<string>();
                mapPartnerIdToAccount = new map<string,Account>();
                accObj = [select Name,Partner_Id__c,RecordType.Name from Account where ID = :Controller.getId() limit 1];
                if(accObj != null && accObj.Partner_Id__c != null && accObj.RecordType.Name == 'Partner Account') {
                    partnerIDSet.add(accObj.Partner_Id__c);
                    mapPartnerIdToAccount.put(accObj.Partner_Id__c,accObj);
                    string strQuery = '%' + (Controller.getId().length()>15 ? Controller.getId().substring(0,15):Controller.getId())+ '%';
                    System.Debug('>>33>>'+strQuery);
                    List<Account> childPartnerAccountList = [SELECT id,Name,Parent_Detail__c ,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c  
                                                            from Account where  RecordType.Name = 'Partner Account' and
                                                            ((parentId != null and Parent_Detail__c Like :strQuery )) order by Name];
                    for(Account accObjchildPartner: childPartnerAccountList) {
                        if(accObjchildPartner.Partner_ID__c != null) {
                            partnerIDSet.add(accObjchildPartner.Partner_ID__c);
                            mapPartnerIdToAccount.put(accObjchildPartner.Partner_Id__c,accObjchildPartner);
                        }
                    }
                    system.Debug('>>11>>'+partnerIDSet); 
                    List<Lead> leadListPartner = new List<Lead>();
                    if(!isViewAll){   
                    	 leadListPartner = [SELECT id,firstname,lastname,email,phone,name,status,Company,Owner.Name,LeadPartnerID__c,CreatedDate,LastModifiedDate 
                                            FROM lead WHERE LeadPartnerID__c IN : partnerIDSet AND RecordType.Name = 'Partner Leads'
                                            AND IsConverted = false AND CreatedDate >= LAST_N_DAYS:14 order by Owner.Name limit 10000];
                    }else{
                    	  leadListPartner = [SELECT id,firstname,lastname,email,phone,name,status,Company,Owner.Name,LeadPartnerID__c,CreatedDate,LastModifiedDate 
                                             FROM lead WHERE LeadPartnerID__c IN : partnerIDSet AND RecordType.Name = 'Partner Leads'
                                             AND IsConverted = false  order by Owner.Name limit 10000];
                    	
                    }
                    system.Debug('>>22>>'+leadListPartner);
                    for(Lead partnerleadObj : leadListPartner) {
                        WRPartnerLeadInfo wrPartnerLeadInfoObj = new WRPartnerLeadInfo();
                        wrPartnerLeadInfoObj.companyName =  partnerleadObj.Company;
                        wrPartnerLeadInfoObj.leadName =  partnerleadObj.Name;
                        wrPartnerLeadInfoObj.email =  partnerleadObj.email;
                        wrPartnerLeadInfoObj.phone =  partnerleadObj.phone;
                        wrPartnerLeadInfoObj.status =  partnerleadObj.status;
                        wrPartnerLeadInfoObj.ownerName =  partnerleadObj.Owner.Name;
                        wrPartnerLeadInfoObj.leadId =  partnerleadObj.id;
                        wrPartnerLeadInfoObj.CreatedDate =  partnerleadObj.CreatedDate;
                        wrPartnerLeadInfoObj.lastModifiedDate =  partnerleadObj.lastModifiedDate;
                        wrPartnerLeadInfoObj.create =  (Integer)((partnerleadObj.CreatedDate).getTime());
                        wrPartnerLeadInfoObj.lastModified =(Integer)((partnerleadObj.lastModifiedDate).getTime());
                        wrPartnerLeadInfoObj.accountName = mapPartnerIdToAccount.get(partnerleadObj.LeadPartnerID__c).Name;
                        wrPartnerLeadInfoObj.partnerId = partnerleadObj.LeadPartnerID__c;
                        listWrPartnerLeadInfo.add(wrPartnerLeadInfoObj);
                    }                                       
                }
            }   
        } catch(Exception ex) {}
    }
    
    public class WRPartnerLeadInfo {
        public string leadName {get;set;}
        public string leadId {get;set;}
        public string email {get;set;}
        public string phone {get;set;}
        public string companyName {get;set;}
        public string status {get;set;}
        public string ownerName {get;set;}
        public string accountName {get;set;}
        public string partnerId {get;set;}
        public DateTime CreatedDate{get;set;}
        public DateTime lastModifiedDate{get;set;}
        public Integer create{get;set;}
        public Integer lastModified{get;set;}
        public WRPartnerLeadInfo() {
            
        }
    }
}