public class CheckOnAgreement{

   /* public static Boolean nonexistingAgreement(ID account_id){
    try{
          Account acc = [SELECT Active_Sales_Agreement__c FROM Account WHERE ID=:account_id];              
        if(acc.Active_Sales_Agreement__c == null ){
                return true;
        }else{
                return false;
        }
    }catch(Exception e){return false;}
           return false;   
    } */
    
    public static Integer nonexistingAgreement(ID account_id){
    Integer count = 0;
       count = [SELECT count() FROM Account WHERE ID=:account_id AND  Active_Sales_Agreement__r.Status ='Active' limit 1 ]; 
       System.debug('----------------------->'+count);
      
        return count;
    
            
    } 
    
    

}