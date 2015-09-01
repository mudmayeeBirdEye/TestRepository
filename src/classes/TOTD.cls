public class TOTD{

public String strContent{get;set;}
public String strImage{get;set;}
public String strContentType{get;set;}
public String strVideoLink{get;set;}
public String strFlashLink{get;set;}
public String strDayName1{get;set;}
public String strDayName=ApexPages.CurrentPage().getParameters().get('dayName');
public String strDayName2{get;set;}
public  Boolean isExist{get;set;}

public TOTD(){
    isExist=false;
   //strDayName2=(DateTime.now()+1).format('EEEE'); 
  for(TOTD__c obj:[Select Content__c,Image__c,Content_Type__c,VideoLink__c,FlashLink__c from TOTD__c where Day__c=:strDayName]){
     strContent=obj.Content__c;
     strImage=obj.Image__c;
     if(strImage!=null && strImage!=''){
        if(!strImage.startsWith('<img')){
          strImage=null;
        }
     }
     strContentType=obj.Content_Type__c;
     strVideoLink=obj.VideoLink__c;
     strFlashLink=obj.FlashLink__c;
     isExist=true;
  }
  strDayName1=strDayName+''+isExist;
  if(!isExist){
    strContent='No content found for '+strDayName;
  }
}
/*static testMethod void totdTest(){
 
  try{
       TOTD__c objData=new TOTD__c();
       objData.Day__c='Monday';
       objData.Content__c='Test';
       objData.Image__c='<img />';
       insert objData;
       
       ApexPages.currentPage().getParameters().put('dayName','Monday');
       TOTD obj=new TOTD();
       
        objData=new TOTD__c();
        objData.Day__c='Monday';
        objData.Content__c='Test';
        objData.Image__c='test image';
        insert objData;
        
        ApexPages.currentPage().getParameters().put('dayName','Monday');
        obj=new TOTD();
      
	       objData.Day__c='MondayTest';
	       ApexPages.currentPage().getParameters().put('dayName','Monday2');
	       upsert objData;
      
          obj=new TOTD();
  }catch(Exception e){}
}*/

}