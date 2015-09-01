public class SystemStatusControllerSite{

public System_Status__c objStatus{get;set;}
public Boolean isRecordFound{get;set;}
public Boolean isPublicDescFound{get;set;}
public String strException {get;set;} 
public String strReg{get;set;}

 public SystemStatusControllerSite(){
   isRecordFound=false;
   isPublicDescFound=false;
   RCSiteSetup__c  objSite=getSiteDetail();
   objStatus=new System_Status__c();
   String strRegion='US';
    
     if(objSite.Brand_Filter__c!=null){
         if(objSite.Brand_Filter__c.indexOf('US')>0){
           strRegion='US';
         }else if(objSite.Brand_Filter__c.indexOf('UK')>0){
            strRegion='UK';
         }else if(objSite.Brand_Filter__c.indexOf('CAN')>0){
             strRegion='CAN';
         }
       
      strRegion='%'+strRegion+'%';
      //strReg=strRegion;
     try{
        objStatus=[Select IncidentID__c,Internal_Status__c,Public_Description__c,Region__c,Severity__c,
                   Summary__c,System_Status__c,Name from System_Status__c where Region__c Like:strRegion and Severity__c!=null and Severity__c!='' 
                   order by Severity__c,IncidentID__c DESC limit 1];
        isRecordFound=true;
        if(objStatus.Public_Description__c!=null && objStatus.Public_Description__c!=''){
           isPublicDescFound=true;
        }
     }catch(Exception e){
       strException =e.getMessage();
     }
  }
}

   private RCSiteSetup__c  getSiteDetail(){
       RCSiteSetup__c siteSetup=null;
                try {
                    String siteName = Site.getName();
                     if (siteName == null || siteName.length()==0) {
                       siteName = 'rcsupport';
                      }
                siteSetup = [
                       SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
                       Category1Description__c, Category2Description__c, Category3Description__c,
                       Category4Description__c, Category5Description__c, Category6Description__c,
                       HomeAdText__c, HomeAdTitle__c, Brand_Filter__c
                       FROM RCSiteSetup__c
                       WHERE RCSiteName__c = :siteName];
                       //WHERE RCSiteName__c = :'rcsupport'];
                  } catch (QueryException  e) {
                     siteSetup = new RCSiteSetup__c();
                    }
      return siteSetup;
    }
    
/* static testMethod void testSystemStatusControllerSite(){
        SystemStatusControllerSite objSystemStatusControllerSite =new SystemStatusControllerSite();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
       upsert objRCSiteName;
     
     objSystemStatusControllerSite =new SystemStatusControllerSite();
     objRCSiteName.Brand_Filter__c='Brand:US';
     upsert objRCSiteName;
     objSystemStatusControllerSite =new SystemStatusControllerSite();
     
      objRCSiteName.Brand_Filter__c='Brand:UK';
     upsert objRCSiteName;
     objSystemStatusControllerSite =new SystemStatusControllerSite();
     
      objRCSiteName.Brand_Filter__c='Brand:CAN';
     upsert objRCSiteName;
     objSystemStatusControllerSite =new SystemStatusControllerSite();
     
     objRCSiteName.Brand_Filter__c='Brand:US';
     upsert objRCSiteName;
    
    System_Status__c obj=(System_Status__c)SmartFactory.createSObject('System_Status__c', true);
    obj.Region__c='US';
    upsert obj;
    
    objSystemStatusControllerSite =new SystemStatusControllerSite();
    obj.Public_Description__c='test';
    upsert obj;
     objSystemStatusControllerSite =new SystemStatusControllerSite();
    }*/
    
}