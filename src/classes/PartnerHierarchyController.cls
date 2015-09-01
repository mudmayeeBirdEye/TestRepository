public with sharing class PartnerHierarchyController {

public Map<id,Account> mapAccountDetail{get;set;}
public Map<Id,List<Account>> mapAccountList{get;set;}
public Map<String,String> lst2;
public String strTreeView{get;set;} 
public String strJson{get;set;}

public String strURLPrefix{get;set;}


public Map<Id,AccountDetail> mapDigitalLines{get;set;}
private RecordType  objRecordType2;
private   Map<String,ID> mapPartnerId;
public PartnerHierarchyController(){
	strURLPrefix='';
	if(Site.getPrefix()!=null && Site.getPrefix()!=''){
		strURLPrefix='';
		strURLPrefix=strURLPrefix+Site.getPrefix();
	}
		strURLPrefix=strURLPrefix+'/';
	
	
	
	 RecordType  objRecordType1 = [SELECT id,Name FROM RecordType where Name='Partner Account' ]; 
	
	 mapAccountDetail=new Map<id,Account>();
	 mapAccountDetail=new Map<Id,Account>([SELECT id,Name,Parent_Detail__c,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c  from Account where RecordTypeId=:objRecordType1.id order by Name]);
    
     mapAccountList=new  Map<Id,List<Account>>();
  
     strTreeView='';
     mapDigitalLines=new  Map<Id,AccountDetail>();
    
     Set<String> setPartnerId=new Set<String>(); 
      mapPartnerId=new Map<String,ID>();
   
     for(ID objAccId:mapAccountDetail.keySet()){
     	if(mapAccountDetail.get(objAccId).Partner_ID__c!=null){
     	   setPartnerId.add(mapAccountDetail.get(objAccId).Partner_ID__c);
     	   mapPartnerId.put(mapAccountDetail.get(objAccId).Partner_ID__c,objAccId);
     	}
     }
     Set<String> setCustomerId=new Set<String>();
        objRecordType2 = [SELECT id,Name FROM RecordType where Name='Customer Account' ];  
       for(Account objAcc:[Select id from Account where RecordTypeId=:objRecordType2.id and Partner_ID__c IN:setPartnerId]){
       	  String strId=objAcc.id;
       	  setCustomerId.add(strId.subString(0,15));
       	  
       	}
      
   
         
     for(Account objAccount:[Select id,Name,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c,RecordTypeId,Parent_Detail__c 
                             from Account where ((RecordTypeId=:objRecordType1.id) 
                             OR ((Ultimate_Parent_Account_ID__c IN:setCustomerId))) order by RecordType.Name desc]){
                             	
           if(objAccount.parentId==null && mapAccountList.get(objAccount.id)==null && objAccount.RecordTypeId!=objRecordType2.id){
             	 mapAccountList.put(objAccount.id,new List<Account>());
             }else{
             	if((objAccount.parentId!=null && objAccount.RecordTypeId==objRecordType1.id) 
             	    || (objAccount.parentId!=null && objAccount.RecordTypeId==objRecordType2.id && objAccount.Partner_ID__c==null )){
	             	 if(mapAccountList.get(objAccount.parentId)==null){
	             	 	mapAccountList.put(objAccount.parentId,new List<Account>{objAccount});
	             	 }else{
	             	 		mapAccountList.get(objAccount.parentId).add(objAccount);
	             	 }
             	}
              } 
            if(objAccount.Partner_ID__c!=null && objAccount.RecordTypeId==objRecordType2.id){
             ID accId=mapPartnerId.get(objAccount.Partner_ID__c);
	             if(mapAccountList.get(accId)!=null){
	             	 mapAccountList.get(accId).add(objAccount);
	             }else{
	             	mapAccountList.put(accId,new List<Account>{objAccount});
	             }
	         }      
              
             //mapAccountList.put(objAccount.id,objAccount.Accounts__r);     
             mapAccountDetail.put(objAccount.id,objAccount);           	
         }
       
         
     /*for(Account objAcc:[Select id,Name,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c from Account where Partner_ID__c IN:setPartnerId and RecordTypeId=:objRecordType2.id]){
     	ID accId=mapPartnerId.get(objAcc.Partner_ID__c);
         if(mapAccountList.get(objAcc.id)==null){
             mapAccountList.put(objAcc.id,new List<Account>());
             if(mapAccountList.get(accId)!=null){
             	 mapAccountList.get(accId).add(objAcc);
             }else{
             	mapAccountList.put(accId,new List<Account>{objAcc});
             }
          }
           mapAccountDetail.put(objAcc.id,objAcc);     
      }*/
     
         
         
 lst2=new Map<String,String>();
 try{
 	if(UserInfo.getUserType()!='Standard'){
 	 User objUser=[Select Contact.AccountId from User where Id=:UserInfo.getUserId()];
 		 createTree(new Map<ID,List<Account>>{objUser.Contact.AccountId=>mapAccountList.get(objUser.Contact.AccountId)},null,'parent');
 	}else{
      createTree(mapAccountList,null,'parent');
 	}
     //createTree(mapAccountList,null,'parent');
    // createTree(new Map<ID,List<Account>>{'001S000000cqaIUIAY'=>mapAccountList.get('001S000000cqaIUIAY')},null,'parent');
   
 }catch(Exception ex){
 	ApexPages.addMessage(new Apexpages.Message(ApexPages.SEVERITY.ERROR,ex.getMessage()+ex.getLineNumber()));
 }
}


public void createTree(Map<Id,List<Account>> nextMapPass,String strId,String strStatus){
	
	 Set<Id> strSet=new Set<ID>();
       if(strId==null){
          strSet=nextMapPass.keySet();
       }else{
          strSet.add(strId);
        }
      
        for(Id str:strSet){
         // if(strStatus=='parent' && mapAccountDetail.get(str).ParentId!=null ){
      
         //}else{ 
         if(lst2.size()==0 || lst2.get(str)==null){
         	if(mapDigitalLines.get(str)==null){
         		
         		mapDigitalLines.put(str,new AccountDetail(mapAccountDetail.get(str).Number_of_DL_s__c,mapAccountDetail.get(str).PartnerMrr__c,mapAccountDetail.get(str).Number_of_DL_s__c,mapAccountDetail.get(str).PartnerMrr__c));
         		setAccountDetail(str, mapAccountDetail.get(str));
         	}else{
         		//mapDigitalLines.put(str,mapDigitalLines.get(str)+mapAccountDetail.get(str).Number_of_DL_s__c);
         		mapDigitalLines.get(str).dDLs=mapDigitalLines.get(str).dDLs+mapAccountDetail.get(str).Number_of_DL_s__c;
         		mapDigitalLines.get(str).dMRR=mapDigitalLines.get(str).dDLs+mapAccountDetail.get(str).PartnerMrr__c;
         		
         		setAccountDetail(str, mapAccountDetail.get(str));
         		/*if(mapAccountDetail.get(str).ParentId!=null){
         			if(mapDigitalLines.get(mapAccountDetail.get(str).ParentId)==null){
         				mapDigitalLines.put(mapAccountDetail.get(str).ParentId,mapAccountDetail.get(str).Number_of_DL_s__c);
         			}else{
         				mapDigitalLines.put(mapAccountDetail.get(str).ParentId,mapDigitalLines.get(str)+mapAccountDetail.get(str).Number_of_DL_s__c);
         			}
         		}*/
         	}
         	
             if(strStatus=='child'){
             //strTreeView=strTreeView+'<ul><li>';
             }
             
             
             if(strStatus=='parent'){
                //strTreeView=strTreeView+'<td valign=\'top\'><li>';
                strTreeView=strTreeView+'<li class=\''+str+ ' parent\'>';
                 if(nextMapPass.get(str)!=null && nextMapPass.get(str).size()==0){
                 // strTreeView=strTreeView+'<span class=\'formattextcon\'>';
                 }
                strTreeView=strTreeView+'';
                                
                // strTreeView=strTreeView+'<a  href=/rcpartner/'+mapAccountDetail.get(str).id+' rel=\'employeeDetailsNew1?id='+mapAccountDetail.get(str).id+'\' onmouseover=\'showEmployeeDetails(\"'+mapAccountDetail.get(str).id+'\");\'>'+mapAccountDetail.get(str).Name;
                 //strTreeView=strTreeView+'<c:hovercomponent displayname='+mapAccountDetail.get(str).Name+'recordId='+mapAccountDetail.get(str).id+' />';
               strTreeView=strTreeView+'<a href='+strURLPrefix+str+' target="_blank" onblur="LookupHoverDetail.getHover(\''+str+'\').hide();"'+ 
								       'onfocus="LookupHoverDetail.getHover(\''+str+'\', \'/'+str+'/m?retURL=%2F'+str+'&isAjaxRequest=1\').show();"'+ 
								       'onmouseout="LookupHoverDetail.getHover(\''+str+'\').hide();"'+
								       'onmouseover="LookupHoverDetail.getHover(\''+str+'\', \'/'+str+'/m?retURL=%2F'+str+'&isAjaxRequest=1\').show();">';
                 strTreeView=strTreeView+mapAccountDetail.get(str).Name;
                strTreeView=strTreeView+'</a>';
               
                 if(nextMapPass.get(str)!=null && nextMapPass.get(str).size()==0){
                  //strTreeView=strTreeView+'</span>';
                  }
                     if(nextMapPass.get(str)!=null ){
                       strTreeView=strTreeView+'<span id='+mapAccountDetail.get(str).id+'  class='+mapAccountDetail.get(str).Number_of_DL_s__c+'#'+mapAccountDetail.get(str).PartnerMrr__c+'></span>';
                     }
                if(nextMapPass.get(str)!=null && nextMapPass.get(str).size()>0){
                 strTreeView=strTreeView+'<ul>';
                }
               }else{
                  strTreeView=strTreeView+'<span id='+mapAccountDetail.get(str).id+' class='+mapAccountDetail.get(str).Number_of_DL_s__c+'#'+mapAccountDetail.get(str).PartnerMrr__c+'></span>';
                   strTreeView=strTreeView+'<ul><li >';
               }
              if(nextMapPass.get(str)!=null && nextMapPass.get(str).size()>0){
             /* if(strStatus=='parent'){
               strTreeView=strTreeView+'<li><ul>';
               }*/
               //strTreeView=strTreeView+'<li>';
                
            // strTreeView=strTreeView+'</a><ul>';
          
             for(Account obj:nextMapPass.get(str)){
               strTreeView=strTreeView+'<li class=\'parent-'+str+' '+obj.id+'\'>';
              
                //strTreeView=strTreeView+'<li>';
                  // strTreeView=strTreeView+'<span class=\'formattextcon\'>';
                   //strTreeView=strTreeView+'<a target=\'_blank\' title=\'Active User\'  href=/rcpartner/'+obj.id+' rel=\'employeeDetailsNew1?id='+obj.id+'\' onmouseover=\'showEmployeeDetails(\"'+obj.id+'\");\'>';
                      strTreeView=strTreeView+'<a href='+strURLPrefix+obj.id+'  target="_blank" onblur="LookupHoverDetail.getHover(\''+obj.id+'\').hide();"'+ 
								       'onfocus="LookupHoverDetail.getHover(\''+obj.id+'\', \'/'+obj.id+'/m?retURL=%2F'+obj.id+'&isAjaxRequest=1\').show();"'+ 
								       'onmouseout="LookupHoverDetail.getHover(\''+obj.id+'\').hide();"'+
								       'onmouseover="LookupHoverDetail.getHover(\''+obj.id+'\', \'/'+obj.id+'/m?retURL=%2F'+obj.id+'&isAjaxRequest=1\').show();">';
                    
                   // strTreeView=strTreeView+obj.Name+'</span></a>';
                     strTreeView=strTreeView+obj.Name+'</a>';
               
               	
                
               if(nextMapPass.get(obj.id)!=null && nextMapPass.get(obj.id).size()>0){
                    createTree(nextMapPass,obj.id,'child');
                }else if(mapAccountList.get(obj.id)!=null && mapAccountList.get(obj.id).size()>0){
                	createTree(new Map<ID,List<Account>>{obj.id=>mapAccountList.get(obj.id)} ,obj.id,'child');
                }else{
                 strTreeView=strTreeView+'<span id='+obj.id+'  class='+mapAccountDetail.get(str).Number_of_DL_s__c+'#'+mapAccountDetail.get(str).PartnerMrr__c+'></span>';
                 
           if(mapDigitalLines.get(obj.id)==null){
         		
         		//mapDigitalLines.put(obj.id,mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         		mapDigitalLines.put(obj.id,new AccountDetail(mapAccountDetail.get(obj.id).Number_of_DL_s__c,mapAccountDetail.get(obj.id).PartnerMrr__c,mapAccountDetail.get(obj.id).Number_of_DL_s__c,mapAccountDetail.get(obj.id).PartnerMrr__c));
         		
         		if(mapAccountDetail.get(obj.id).ParentId!=null ||(mapAccountDetail.get(obj.id).RecordTypeId==objRecordType2.id && mapAccountDetail.get(obj.id).Partner_ID__c!=null)){
         			/*if(mapDigitalLines.get(mapAccountDetail.get(obj.id).ParentId)==null){
         				mapDigitalLines.put(mapAccountDetail.get(obj.id).ParentId,mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         			}else{
         				mapDigitalLines.put(mapAccountDetail.get(obj.id).ParentId,mapDigitalLines.get(str)+mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         			}*/
         			setAccountDetail(obj.id,mapAccountDetail.get(obj.id));
         		}
         		//setAccountDetail(obj.id);
         	}else{
         		//mapDigitalLines.put(obj.id,mapDigitalLines.get(obj.id)+mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         		mapDigitalLines.get(obj.id).dDLs=mapDigitalLines.get(obj.id).dDLs+(mapAccountDetail.get(obj.id).Number_of_DL_s__c==null?0:mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         		mapDigitalLines.get(obj.id).dMRR=mapDigitalLines.get(obj.id).dDLs+(mapAccountDetail.get(obj.id).PartnerMrr__c==null?0:mapAccountDetail.get(obj.id).PartnerMrr__c);
         		
         		if(mapAccountDetail.get(obj.id).ParentId!=null ||(mapAccountDetail.get(obj.id).RecordTypeId==objRecordType2.id && mapAccountDetail.get(obj.id).Partner_ID__c!=null)){
         			/*if(mapDigitalLines.get(mapAccountDetail.get(obj.id).ParentId)==null){
         				mapDigitalLines.put(mapAccountDetail.get(obj.id).ParentId,mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         			}else{
         				mapDigitalLines.put(mapAccountDetail.get(obj.id).ParentId,mapDigitalLines.get(obj.id)+mapAccountDetail.get(obj.id).Number_of_DL_s__c);
         			}*/
         			setAccountDetail(obj.id,mapAccountDetail.get(obj.id));
         		}
         		//setAccountDetail(obj.id);
         	}
                	
                }
               
                lst2.put(obj.id,obj.id);
               strTreeView=strTreeView+'</li>';
             }
            
           }
            if(strStatus=='parent'){
               //strTreeView=strTreeView+'</td></li>';
               strTreeView=strTreeView+'</li>';
                if(nextMapPass.get(str)!=null && nextMapPass.get(str).size()>0){
                  strTreeView=strTreeView+'</ul>';
                }
               }
            if(strStatus=='child'){
            strTreeView=strTreeView+'</li>';
            strTreeView=strTreeView+'</ul>';
            }
         }
         
        //}
    
    }
	  strJson = JSON.serialize(mapDigitalLines); 
	
}
public void setAccountDetail(String strId,Account objAccountDetail){ 
	setParentId=new Set<String>(); 	
    setParentId.add(strId);	  
	//getParentAccount(objAccountDetail);
	
	for(String str:setParentId){
		String strParentId;
	if((objAccountDetail.ParentId!=null) || (objAccountDetail.RecordTypeId==objRecordType2.id && objAccountDetail.Partner_ID__c!=null )){
		if(objAccountDetail.RecordTypeId==objRecordType2.id && objAccountDetail.Partner_ID__c!=null ){
			strParentId=mapPartnerId.get(objAccountDetail.Partner_ID__c); 
			//strTreeView=strTreeView+','+strParentId;
		  }else{
			 strParentId=objAccountDetail.ParentId;
		}
		
		/*if(mapAccountDetail.get(str).ParentId!=null){
		   strParentId=mapAccountDetail.get(str).ParentId;
		}else{
			strParentId=mapPartnerId.get(objAccountDetail.Partner_ID__c); 
		}*/
		//strParentId=mapAccountDetail.get(str).ParentId;
		Account objAccount=mapAccountDetail.get(strId);
		  			if(mapDigitalLines.get(strParentId)==null){
         				//mapDigitalLines.put(mapAccountDetail.get(str).ParentId,mapAccountDetail.get(str).Number_of_DL_s__c);
         				mapDigitalLines.put(strParentId,new AccountDetail((objAccountDetail.Number_of_DL_s__c==null?0:objAccountDetail.Number_of_DL_s__c),(objAccountDetail.PartnerMrr__c==null?0:objAccountDetail.PartnerMrr__c)));
         			}else{
         				//mapDigitalLines.put(mapAccountDetail.get(str).ParentId,mapDigitalLines.get(str)+mapAccountDetail.get(str).Number_of_DL_s__c);
         			  mapDigitalLines.get(strParentId).dDLs=mapDigitalLines.get(strParentId).dDLs+(objAccountDetail.Number_of_DL_s__c==null?0:objAccountDetail.Number_of_DL_s__c);
         		      mapDigitalLines.get(strParentId).dMRR=mapDigitalLines.get(strParentId).dMRR+(objAccountDetail.PartnerMrr__c==null?0:objAccountDetail.PartnerMrr__c);
         			}
         		}
    }   		
         		
}
Set<String> setParentId;
public Set<String> getParentAccount(Account objAccountDetail){
 setParentId.add(objAccountDetail.id);
   if(objAccountDetail.Parent_Detail__c!=null && objAccountDetail.Parent_Detail__c!=''){
                 String strParentDetail=objAccountDetail.Parent_Detail__c;
                 List<String> lst=strParentDetail.split(','); 
                   for(String objString:lst){
                         if(objString!=null && objString!=''){
                            List<String> lst2=objString.split('-');
                                if(lst2.size()==2){
                                 if(lst2.get(1)!=null){
                                 	setParentId.add(lst2.get(1));
                                 	if(mapAccountDetail.get(lst2.get(1))!=null && mapAccountDetail.get(lst2.get(1)).RecordTypeId==objRecordType2.id
                                 	   &&  mapAccountDetail.get(lst2.get(1)).Partner_ID__c!=null){
                                 		getParentAccount(mapAccountDetail.get(mapPartnerId.get(mapAccountDetail.get(lst2.get(1)).Partner_ID__c)));
                                 	}
                              }
                           }
                         }
                   }
            }else if(objAccountDetail.RecordTypeId==objRecordType2.id &&  objAccountDetail.Partner_ID__c!=null){
            	// strTreeView=strTreeView+mapPartnerId.get(objAccountDetail.Partner_ID__c);
                 		getParentAccount(mapAccountDetail.get(mapPartnerId.get(objAccountDetail.Partner_ID__c)));
                     }
        return setParentId;     
}     
  

public class AccountDetail{
 public Decimal dDLs{get;set;}	
 public Decimal dMRR{get;set;}	
 public Decimal ownDLs{get;set;}	
 public Decimal ownMRR{get;set;}	
 
  public AccountDetail(Decimal dDLs,Decimal dMRR){
 	this.dDLs=(dDLs==null?0:dDLs);
 	this.dMRR=(dMRR==null?0:dMRR);	
  }
 
  public AccountDetail(Decimal dDLs,Decimal dMRR,Decimal ownDLs,Decimal ownMRR){
 	this.dDLs=(dDLs==null?0:dDLs);
 	this.dMRR=(dMRR==null?0:dMRR);	
 	
 	this.ownDLs=(ownDLs==null?0:ownDLs);
 	this.ownMRR=(ownMRR==null?0:ownMRR);	
 	
}	
}

}