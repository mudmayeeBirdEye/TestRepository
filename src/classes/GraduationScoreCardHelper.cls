/********************************************************************************************************
* Project Name..........:                                                                               *
* File..................: GraduationScoreCardHelper.class                                               *
* Version...............: 1.0                                                                           *
* Created by............:                                                                               *
* Created Date..........: 13-08-2014                                                                    *
* Last Modified by......: Simplion Technologies                                                         *
* Last Modified Date....:                                                                               *
* Description...........:                                                                               *
********************************************************************************************************/


public class GraduationScoreCardHelper {
		
		//Completion Rate
	     public static Decimal Completion30D = 0;
	     public static Decimal Completion60D = 0;    
	     public static Decimal Completion90D = 0; 
	    
	    Public Static final String STR_INSERT = 'INSERT';  
	    Public Static final String STR_UPDATE = 'UPDATE';
	    Public Static final String BRAND_TELUS = 'TELUS';
	    //Defined value of implementation checlist.
		Public Static final Decimal ACCREVIEW_VALUE = 1.25;
		Public Static final Decimal ACCREVIEW_VALUE_TELUS = 1.112;
		Public Static final Decimal COMPANYINFO_VALUE = 2.5;
		Public Static final Decimal USERS_VALUE = 2.5;
		Public Static final Decimal PHONE_VALUE = 8.33;
		Public Static final Decimal GROUPS_VALUE = 3.75;
		Public Static final Decimal TOOLS_VALUE = 5;
		
		//Defined value of Account Metric for Adoption.
		Public Static final Decimal ACCOUNT_METRIC_ADOPTION = 25;
		Public Static final Decimal ACCOUNT_METRIC_12DOT50 = 12.50;
		
		
/** ######################################################################################################

	  ++ START OF IMPLEMENTATION PHASE COMPLETION RATE AND COMPLETION DATE CALCULATION ++ 
	  
	######################################################################################################	**/
	
	/** Method is used for calculating Implementation phase over Implementation Object.
	 * @ param objImplementationNew 
	 * @ param objImplementationOld
	 * @ param strInsert
	 * @ return ScoreCardWrapper wraaper object having calculated value of Completion rate and date.
	 */
	public static ScoreCardWrapper getImplementationCompletionDetails(Implementation__c objImplementationNew, Implementation__c objImplementationOld, String strAction){
		
			Decimal IC_ACCReview_Score = 0;
			Decimal IC_CompanyInfo_Score = 0;
			Decimal IC_Users_Score = 0; 
			Decimal IC_Phones_Score = 0;
			Decimal IC_Groups_Score = 0;
			Decimal IC_Tools_Score = 0;
			Decimal IC_Score = 0;
			
			List<string> IC_ACCReview ;
			List<string> IC_CompanyInfo;
			List<string> IC_Users;
			List<string> IC_Phones;
			List<string> IC_Groups;
			List<string> IC_Tools;
			
			ScoreCardWrapper objWrapper = new ScoreCardWrapper();
			objWrapper.bUpdateAcount = false;
			objWrapper.dCompletionRate = 0;
		try{	
			//system.debug('objImplementationOld---->'+objImplementationOld);
			if((objImplementationOld != null 
				&& ((picklistDontHaveSameValue(objImplementationNew.Account_Review__c, objImplementationOld.Account_Review__c) 
        			|| picklistDontHaveSameValue(objImplementationNew.Company_Numbers_and_Info__c,objImplementationOld.Company_Numbers_and_Info__c)
        			|| picklistDontHaveSameValue(objImplementationNew.Users__c, objImplementationOld.Users__c)  
        			|| picklistDontHaveSameValue(objImplementationNew.Phones_Devices__c,objImplementationOld.Phones_Devices__c) 
        			|| picklistDontHaveSameValue(objImplementationNew.Groups__c,objImplementationOld.Groups__c)
        			|| picklistDontHaveSameValue(objImplementationNew.Tools__c,objImplementationOld.Tools__c)
        			|| ((!String.isBlank(objImplementationOld.Brand__c) 
        				&& !String.isBlank(objImplementationNew.Brand__c) 
        				&& !objImplementationOld.Brand__c.equalsIgnoreCase(objImplementationNew.Brand__c))
	        				|| (!String.isBlank(objImplementationNew.Brand__c) && String.isBlank(objImplementationOld.Brand__c))
	        				|| (String.isBlank(objImplementationNew.Brand__c) && !String.isBlank(objImplementationOld.Brand__c))
        				)
        			))
        			)
        		||(STR_INSERT.equalsIgnoreCase(strAction))
        		) {
        				system.debug('******* INSIDE IF *********');
        				objWrapper.bUpdateAcount = true;
        				    //Split Multipicklist        
                            IC_ACCReview = (objImplementationNew.Account_Review__c !=NULL ?  objImplementationNew.Account_Review__c.split(';') : new List<string>());
                            IC_CompanyInfo = (objImplementationNew.Company_Numbers_and_Info__c !=NULL ?  objImplementationNew.Company_Numbers_and_Info__c.split(';') : new List<string>());
                            IC_Users = (objImplementationNew.Users__c !=NULL ?  objImplementationNew.Users__c.split(';') : new List<string>()); 
                            IC_Phones = (objImplementationNew.Phones_Devices__c !=NULL ?  objImplementationNew.Phones_Devices__c.split(';') : new List<string>());
                            IC_Groups = (objImplementationNew.Groups__c !=NULL ?  objImplementationNew.Groups__c.split(';') : new List<string>());
                            IC_Tools = (objImplementationNew.Tools__c !=NULL ?  objImplementationNew.Tools__c.split(';') : new List<string>());
                            Integer TELUS_COUNTER = 0;
        			        try {
                                if(IC_ACCReview.size() > 0){
                                    for(String ICAccReviewValue : IC_ACCReview){
                                    	if(!String.isBlank(objImplementationNew.Brand__c) && objImplementationNew.Brand__c.equalsIgnoreCase(BRAND_TELUS)){
	                                        if(AccountScoreCardHelper.ICACCREVIEWSET_TELUS.contains(ICAccReviewValue)){
                                        		IC_ACCReview_Score = IC_ACCReview_Score+ACCREVIEW_VALUE_TELUS;
                                            	TELUS_COUNTER++;
	                                        }
                                    	}else{
                                    		if(AccountScoreCardHelper.ICACCREVIEWSET.contains(ICAccReviewValue)){
	                                        		IC_ACCReview_Score = IC_ACCReview_Score+ACCREVIEW_VALUE;
	                                        	}
                                    	}
                                    }
                                } 
                            }                      
                            catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}
                            try {
                                if(IC_CompanyInfo.size() > 0){
                                    for(String ICCompanyInfoValue : IC_CompanyInfo){
                                        if(AccountScoreCardHelper.ICCOMPANYINFOSET.contains(ICCompanyInfoValue)){
                                            IC_CompanyInfo_Score = IC_CompanyInfo_Score+COMPANYINFO_VALUE;
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}   
                            try {
                                if(IC_Users.size() > 0){
                                    for(String ICUsersValue : IC_Users){
                                        if(AccountScoreCardHelper.ICUSERSSET.contains(ICUsersValue)){
                                            IC_Users_Score=IC_Users_Score+USERS_VALUE;
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}       
                            try {
                                if(IC_Phones.size() > 0){
                                	Integer counter = 1;
                                    for(String ICPhonesValue : IC_Phones){
                                        if(AccountScoreCardHelper.ICPHONESSET.contains(ICPhonesValue)){
                                            IC_Phones_Score=IC_Phones_Score+PHONE_VALUE;
                                            if(counter == 3){
                                            	IC_Phones_Score = IC_Phones_Score + .01;
                                            }
                                        }
                                        counter++;
                                    }
                                }
                            }                      
                            catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}    
                            try{
                                if(IC_Groups.size() > 0){
                                    for(String ICGroupsValue : IC_Groups){
                                        if(AccountScoreCardHelper.ICGROUPSSET.contains(ICGroupsValue)){
                                            IC_Groups_Score=IC_Groups_Score+GROUPS_VALUE;
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}      

                            try {
                                if(IC_Tools.size() > 0){
                                    for(String ICToolsValue : IC_Tools){
                                        if(AccountScoreCardHelper.ICTOOLSSET.contains(ICToolsValue)){
                                            IC_Tools_Score=IC_Tools_Score+TOOLS_VALUE;
                                        }
                                    }
                                }
                            }  catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage());}  
                            
                       
                        if(!String.isBlank(objImplementationNew.Brand__c) &&  objImplementationNew.Brand__c.equalsIgnoreCase(BRAND_TELUS)){
                        	if(TELUS_COUNTER == 9){
	                       	 IC_ACCReview_Score = IC_ACCReview_Score.setScale(1);
	                       	}else{
	                        	IC_ACCReview_Score = IC_ACCReview_Score.setScale(2);
                        	}
                        }          	
        				IC_Score =(IC_ACCReview_Score+IC_CompanyInfo_Score+IC_Users_Score+IC_Phones_Score+IC_Groups_Score+IC_Tools_Score);
                        Completion30D = (IC_ACCReview_Score+IC_CompanyInfo_Score+IC_Users_Score+IC_Phones_Score+IC_Groups_Score+IC_Tools_Score);
                        //if (IC_Score>=0){Completion30D=Completion30D+((IC_Score*.7)*100);}
                        objWrapper.dCompletionRate = Completion30D;
               }else{
               		objWrapper.dCompletionRate = objImplementationNew.Implementation_Phase_Completion_Rate__c;
               }
			}catch (Exception ex) {system.debug('Exception======>'+Ex.getMessage()+' Line--->'+ex.getLineNumber());}
	    	objWrapper.completionDate = system.now();
		return objWrapper;
	}
	
	/** Method is used for comapring picklist values.
	 * if any value changes then return true.
	 * @ param strNewValue 
	 * @ param strOldValue
	 * @ return boolean 
	 */
	public static Boolean picklistDontHaveSameValue(String strNewValue, String strOldValue){
		boolean bValue = false;
		List<String> listNewValues = strNewValue != NULL ?  strNewValue.split(';') : new List<string>();
		List<String> listOldValues = strOldValue!=NULL ?  strOldValue.split(';') : new List<string>();
		if(strNewValue == null && strOldValue != null){
			bValue = true;
		}
		if(strNewValue != null && strOldValue == null){
			bValue = true;
		}
		List<String> listValuesForLoop = new List<String>();
		Set<String> setCheckValues = new Set<String>();
		Integer intNewListSize = listNewValues.size();
		Integer intOldListSize = listOldValues.size();
		/*
		if(listNewValues.size() ==  listOldValues.size()){
			listValuesForLoop.addAll(listNewValues);
			setCheckValues.addAll(listOldValues);
		}
		*/
		if(intNewListSize >= intOldListSize){
			listValuesForLoop.addAll(listNewValues);
			setCheckValues.addAll(listOldValues);
		}
		if(intNewListSize <  intOldListSize){
			listValuesForLoop.addAll(listOldValues);
			setCheckValues.addAll(listNewValues);
		}
		for(String strValue : listValuesForLoop){
			  system.debug(strValue+' ::::======>'+setCheckValues);
			if(!setCheckValues.Contains(strValue)){
				bValue = true;
				break;
			}
		}
		return bValue;
	}	
	
	/** Method is used for calculating completion Rate after deletion of recent Implementation Records. 
	 * @ param oldList, this is implementation List.
	 */
	public static void updateAccountOnImplementationDeletion(List<Implementation__c> oldList){
		 Set<String> setAccountIds = new Set<String>();
		 Set<Account> setAccounts = new  Set<Account>();
		 Map<Id, Account> mapAccounts = new  Map<Id, Account>();
		 for(Implementation__c oldImp : oldList){
		 	if(oldImp.Account__c!=null){
		 		setAccountIds.add(oldImp.Account__c);
		 	}
		 }
		 	List<Account> updatedAccountList = new List<Account>();
		 	try{
			 	Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsValues(setAccountIds);
			 	if(!accountMap.isEmpty()){
			 		for (Implementation__c imp : oldList) {
			 				if(imp.Account__c != null && accountMap.get(imp.Account__c)!=null){
				 				Account objAccount  = accountMap.get(imp.Account__c);
				 					if(objAccount.Implementations__r.size() == 0){
				 						objAccount.Account_Graduation_Date_0_30__c = System.now();
					 					objAccount.Implementation_Phase_Completion_Rate__c = 0;
					 				} else{
				 						Integer counter = 0;
					 					for(Implementation__c objImp : objAccount.Implementations__r){
					 						if(counter == 0) {
						 						ScoreCardWrapper objScoreCardWrapper = new ScoreCardWrapper();
			        							objScoreCardWrapper = getImplementationCompletionDetails(objImp, null, GraduationScoreCardHelper.STR_INSERT);
					 							if(objScoreCardWrapper!=null && objScoreCardWrapper.bUpdateAcount){
										       		objAccount.Implementation_Phase_Completion_Rate__c = objScoreCardWrapper.dCompletionRate != null ? objScoreCardWrapper.dCompletionRate : 0;
										       		if(objScoreCardWrapper.dCompletionRate == 100){
										       			objAccount.Account_Graduation_Date_0_30__c = objScoreCardWrapper.completionDate != null ? objScoreCardWrapper.completionDate : system.now(); 
										       		}
										       	}
										   }
						 					counter++;
						 				}
				 					}
					 				//system.debug('objAccount===>'+objAccount);
					 				//setAccountGraduationStatus(objAccount);
					 				mapAccounts.put(objAccount.Id, objAccount);
					 				setAccounts.add(objAccount);	
			 				}
				 		}
			 }
			 if(!mapAccounts.isEmpty()){
			 	updatedAccountList.addAll(mapAccounts.values());
			 	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
			 	// update updatedAccountList;
			 }
		 }catch(Exception ex){system.debug('Exception===>'+ex.getMessage());}
	}
	
	
	/** Method is used for setting Account Graduation Status over Account based on different-2 Completion Rate .
	 * @ param objAccount. 
	 */
	/*public static void setAccountGraduationStatus(Account objAccount){
		objAccount.Account_Graduation_Status__c = 'New';
   		if(objAccount.Implementation_Phase_Completion_Rate__c != null && objAccount.Implementation_Phase_Completion_Rate__c == 100){
   			objAccount.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
   		}
   		if(objAccount.Implementation_Phase_Completion_Rate__c != null && (objAccount.Implementation_Phase_Completion_Rate__c >0 && objAccount.Implementation_Phase_Completion_Rate__c<100)){
   			objAccount.Account_Graduation_Status__c = 'Implementation Phase';
   		}
   		if(objAccount.Adoption_Phase_Completion_Rate__c!=null && objAccount.Adoption_Phase_Completion_Rate__c >=75){
   			objAccount.Account_Graduation_Status__c = 'Graduation Phase';
   		}
   		if(objAccount.Graduation_Phase_Completion_Rate__c!=null && objAccount.Graduation_Phase_Completion_Rate__c >=75){
   			objAccount.Account_Graduation_Status__c = 'Done';
   		}
	}*/
/** ######################################## ++ END OF IMPLEMENTATION PHASE ###################################################**/	
	
/** ###########################################################################################################################

	  ++ START OF ADOPTION AND GRADUATION PHASE COMPLETION RATE AND COMPLETION DATE CALCULATION Over ACCOUNT METRIC OBJECT++ 
	  
	###########################################################################################################################	**/
	
	/** Method is used for Calculating completion rate for Graduation and Adoption Phase based on Account Metric Object.
	 * @ param accountMetricNewList, using for new records List of Account metric.
	 * @ param oldMapAccountMetric , using map of existing records that has to be updated.
	 */
	public static void adopGradCompRateOnAccountMetric(List<Account_Metric__c> accountMetricNewList, Map<Id, Account_Metric__c> oldMapAccountMetric){
		Set<String> setAccountIds = new Set<String>();
		Set<Account> setAccounts = new  Set<Account>();
		List<Implementation__c> implementationTobeUpdate = new  List<Implementation__c>();
		map<Id, Account> mapAccounts = new  map<Id, Account>();
		for(Account_Metric__c accountMetric : accountMetricNewList){
			if(accountMetric.Account_ID__c!=null){
				setAccountIds.add(accountMetric.Account_ID__c);
			}
		}
		try{
			List<Account> updatedAccountList = new List<Account>();
			Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsWithAccountMetric(setAccountIds);
			for(Account_Metric__c objAccMetric : accountMetricNewList){
				Decimal dAdoptionCompleteionRate = 0;
				Decimal dGraduationCompleteionRate = 0;
				if(objAccMetric.Account_ID__c != null && accountMap.get(objAccMetric.Account_ID__c) != null){
						/*Adoption phase Completion Rate calculation*/
						Account objAccount = accountMap.get(objAccMetric.Account_ID__c);
						dAdoptionCompleteionRate = getAdoptionCompRateAccountMetric(objAccMetric);
						dGraduationCompleteionRate = getGraduationCompRateAccountMetric(objAccMetric);
						if(objAccount.Cases.size()>0){
							dGraduationCompleteionRate = dGraduationCompleteionRate+ACCOUNT_METRIC_12DOT50;
						}
						dGraduationCompleteionRate = dGraduationCompleteionRate+getGraduationCompRateAccount(objAccount);
						/*Adoption Phase and Graduation Phase Completion Date and Rate on Account Metric object*/
						objAccMetric.Account_Graduation_Status__c = 'New';
						if(objAccount.Implementations__r.size()>0){
							Implementation__c impl =  objAccount.Implementations__r[0];
							if(impl.Account_Graduation_Status__c == 'Done'){
								objAccMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
							}
							if(impl.Account_Graduation_Status__c == 'Implementation Phase'){
								objAccMetric.Account_Graduation_Status__c = 'Implementation Phase';
							}
						}
						Boolean hasAdoptionDifference = true;
						Boolean hasGraduationDifference = true;
						system.debug('oldMapAccountMetric===>'+oldMapAccountMetric);
						if(oldMapAccountMetric != null){
							Account_Metric__c prevAccountMetric = oldMapAccountMetric.get(objAccMetric.Id);
							hasAdoptionDifference = checkValuesAdoption(objAccMetric, prevAccountMetric);
							hasGraduationDifference = checkValuesGraduation(objAccMetric, prevAccountMetric);
						}
						system.debug('hasAdoptionDifference===>'+hasAdoptionDifference);
						system.debug('hasGraduationDifference===>'+hasGraduationDifference);
						//if(hasAdoptionDifference){
							objAccMetric.Adoption_Phase_Completion_Rate__c = dAdoptionCompleteionRate;
							
							if(objAccMetric.Adoption_Phase_Completion_Rate__c >=75){
								objAccMetric.Account_Graduation_Status__c = 'Graduation Phase';
								if(hasAdoptionDifference){
									objAccMetric.Account_Graduation_Date_31_60__c = system.now();
								}
								//hasGraduationDifference = true;
							}
							if(objAccMetric.Adoption_Phase_Completion_Rate__c < 75 && objAccMetric.Adoption_Phase_Completion_Rate__c > 0){
								objAccMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
							}
							/*objAccount.Adoption_Phase_Completion_Rate__c = dAdoptionCompleteionRate;
							if(objAccount.Adoption_Phase_Completion_Rate__c >=75){
								objAccount.Account_Graduation_Date_31_60__c = system.now();
							}
							*/
						//}
						//if(hasGraduationDifference){
							
							objAccMetric.Graduation_Phase_Completion_Rate__c = dGraduationCompleteionRate;
							if(objAccMetric.Graduation_Phase_Completion_Rate__c >=75){
								objAccMetric.Account_Graduation_Date_61_90__c = system.now();
								objAccMetric.Account_Graduation_Status__c = 'Done';	
							}
							/*
							objAccount.Graduation_Phase_Completion_Rate__c = dGraduationCompleteionRate;
							if(objAccount.Graduation_Phase_Completion_Rate__c >=75){
								objAccount.Account_Graduation_Date_61_90__c = system.now();
							}*/
						//} 
						system.debug('objAccMetric.Graduation_Phase_Completion_Rate__c===>'+objAccMetric.Graduation_Phase_Completion_Rate__c);
						system.debug('objAccMetric.Adoption_Phase_Completion_Rate__c===>'+objAccMetric.Adoption_Phase_Completion_Rate__c);
						system.debug('objAccMetric.Account_Graduation_Status__c===>'+objAccMetric.Account_Graduation_Status__c);
						/*setAccountGraduationStatus(objAccount);
						mapAccounts.put(objAccount.Id,objAccount);
						setAccounts.add(objAccount);
						*/
					}
				}
			if(!mapAccounts.isEmpty()){
		     	updatedAccountList.addAll(mapAccounts.Values());
		     	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		    	// update updatedAccountList;
		     }
		}Catch(Exception ex){system.debug('Exception===>'+ex.getMessage());}
	}
	
	/** Method is used for calculating completion rate for Adoption phase over Account Metric object.
	 * @ param objAccMetric, using for new records of Account metric.
	 * @ return decimal. 
	 */
	public static Decimal getAdoptionCompRateAccountMetric(Account_Metric__c objAccMetric){
		Decimal dAdoptionCompleteionRate = 0;
		//dAdoptionCompleteionRate = (objAccMetric.Metric_18_value__c != null ? ((objAccMetric.Metric_18_value__c * ACCOUNT_METRIC_ADOPTION)/100) : 0);
		dAdoptionCompleteionRate = (objAccMetric.Metric_18_value__c != null ? ((objAccMetric.Metric_18_value__c * ACCOUNT_METRIC_ADOPTION)) : 0);
		if(objAccMetric.Metric_23_value__c != null && objAccMetric.Metric_23_value__c > 1){
			dAdoptionCompleteionRate = dAdoptionCompleteionRate+ACCOUNT_METRIC_ADOPTION;
		}
		if(objAccMetric.Metric_27_value__c != null && objAccMetric.Metric_27_value__c >= 0){
			dAdoptionCompleteionRate = dAdoptionCompleteionRate+ACCOUNT_METRIC_ADOPTION;
		}
		if(objAccMetric.Metric_11_value__c != null && objAccMetric.Metric_11_value__c == 1){
			dAdoptionCompleteionRate = dAdoptionCompleteionRate+ACCOUNT_METRIC_ADOPTION;
		}
		return dAdoptionCompleteionRate;
	}
	
	/** Method is used for checking current values to previous values of Account Metric object for Adoption Phase..
	 * @ param objAccMetric, using for new records of Account metric.
	 * @ return boolean, if difference get then return true otherwise false. 
	 */
	public static boolean checkValuesAdoption(Account_Metric__c objAccMetric, Account_Metric__c prevAccountMetric){
			if((objAccMetric.Metric_23_value__c != null && prevAccountMetric.Metric_23_value__c == null)
				|| (objAccMetric.Metric_23_value__c == null && prevAccountMetric.Metric_23_value__c != null)
				|| (objAccMetric.Metric_23_value__c != prevAccountMetric.Metric_23_value__c)){
				return true;
			}
			if((objAccMetric.Metric_18_value__c != null && prevAccountMetric.Metric_18_value__c == null)
				|| (objAccMetric.Metric_18_value__c == null && prevAccountMetric.Metric_18_value__c != null)
				|| (objAccMetric.Metric_18_value__c != prevAccountMetric.Metric_18_value__c)){
				return true;
			}
			if((objAccMetric.Metric_27_value__c != null && prevAccountMetric.Metric_27_value__c == null)
				|| (objAccMetric.Metric_27_value__c == null && prevAccountMetric.Metric_27_value__c != null)
				|| (objAccMetric.Metric_27_value__c != prevAccountMetric.Metric_27_value__c)){
				return true;
			}
			if((objAccMetric.Metric_11_value__c != null && prevAccountMetric.Metric_11_value__c == null)
				|| (objAccMetric.Metric_11_value__c == null && prevAccountMetric.Metric_11_value__c != null)
				|| (objAccMetric.Metric_11_value__c != prevAccountMetric.Metric_11_value__c)){
				return true;
			}
		return false;
	}
	
	/** Method is used for checking current values to previous values of Account Metric object for Graduation Phase..
	 * @ param objAccMetric, using for new records of Account metric.
	 * @ return boolean, if difference get then return true otherwise false. 
	 */
	public static boolean checkValuesGraduation(Account_Metric__c objAccMetric, Account_Metric__c prevAccountMetric){
			if((objAccMetric.Metric_3_value__c != null && prevAccountMetric.Metric_3_value__c == null)
				|| (objAccMetric.Metric_3_value__c == null && prevAccountMetric.Metric_3_value__c != null)
				|| (objAccMetric.Metric_3_value__c != prevAccountMetric.Metric_3_value__c)){
				return true;
			}
			if((objAccMetric.Metric_28_value__c != null && prevAccountMetric.Metric_28_value__c == null)
				|| (objAccMetric.Metric_28_value__c == null && prevAccountMetric.Metric_28_value__c != null)
				|| (objAccMetric.Metric_28_value__c != prevAccountMetric.Metric_28_value__c)){
				return true;
			}
		return false;
	}
	
	/** Method is used for calculating completion rate for Graduation phase over Account Metric object.
	 * @ param objAccMetric, using for new records of Account metric.
	 * @ return decimal. 
	 */
	public static Decimal getGraduationCompRateAccountMetric(Account_Metric__c objAccMetric){
		Decimal dGraduationCompleteionRate = 0;
		if(objAccMetric.Metric_3_value__c != null && objAccMetric.Metric_3_value__c>1){
			dGraduationCompleteionRate = ACCOUNT_METRIC_12DOT50;
		}
		if(objAccMetric.Metric_28_value__c != null && objAccMetric.Metric_28_value__c<1){
			dGraduationCompleteionRate = dGraduationCompleteionRate+50;
		}
		return dGraduationCompleteionRate;
	}
	
	/** Method is used for calculating completion rate for Graduation phase over Account object.
	 * @ param objAccount, using for new records of Account metric.
	 * @ return decimal. 
	 */
	public static Decimal getGraduationCompRateAccount(Account objAccount){
		Decimal dGraduationCompleteionRate = 0;
		system.debug('objAccount.Graduation_Kit__c-->'+objAccount.Graduation_Kit__c);
		if(objAccount.Graduation_Kit__c == true){
			dGraduationCompleteionRate = dGraduationCompleteionRate+ACCOUNT_METRIC_12DOT50;
		}
		if(objAccount.Current_Owner_Email__c != null &&
	            objAccount.Current_Owner_Email__c != 'sfdchelp@ringcentral.com' &&
	            objAccount.Current_Owner_Email__c != 'rcsfsync@ringcentral.com') {
	    	dGraduationCompleteionRate = dGraduationCompleteionRate+ACCOUNT_METRIC_12DOT50;
	    }else if(objAccount.Number_of_DL_s__c<250 && 
	            (objAccount.Current_Owner_Email__c=='sfdchelp@ringcentral.com' ||
	             objAccount.Current_Owner_Email__c=='rcsfsync@ringcentral.com')){
	    	dGraduationCompleteionRate = dGraduationCompleteionRate+ACCOUNT_METRIC_12DOT50;
	    }
	    system.debug('#dGraduationCompleteionRate-->'+dGraduationCompleteionRate);
	    return dGraduationCompleteionRate;
	}
	
	/** Method is used for calculating completion rate for Graduation phase  and Adoption on deletion of Account Metric records.
	 * @ param listAccountMetric, using deleted records list of Account metric.
	 */
	public static void calculateCompletionOnAccountMetricDeletion(List<Account_Metric__c> listAccountMetric){
		Set<String> setAccountIds = new Set<String>();
		Set<Account> setAccounts = new  Set<Account>();
		map<Id, Account> mapAccounts = new  map<Id, Account>();
		for(Account_Metric__c accountMetric : listAccountMetric){
			setAccountIds.add(accountMetric.Account_ID__c);
		}
		List<Account> updatedAccountList = new List<Account>();
		try{
			Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsWithAccountMetric(setAccountIds);
			for(Account_Metric__c objAccMetric : listAccountMetric){
				Decimal dAdoptionCompleteionRate = 0;
				Decimal dGraduationCompleteionRate = 0;
				Decimal dActualAdoptionCompleteionRate = 0;
				Decimal dActualGraduationCompleteionRate = 0;
				if(objAccMetric.Account_ID__c != null && accountMap.get(objAccMetric.Account_ID__c) != null){
					    Account objAccount  = accountMap.get(objAccMetric.Account_ID__c);
						dAdoptionCompleteionRate = getAdoptionCompRateAccountMetric(objAccMetric);
						dGraduationCompleteionRate = getGraduationCompRateAccountMetric(objAccMetric);
						/*Adoption Phase and Graduation Phase Completion Date and Rate on Account Metric object*/
						dActualAdoptionCompleteionRate = objAccount.Adoption_Phase_Completion_Rate__c!=null?objAccount.Adoption_Phase_Completion_Rate__c:0;
						dActualGraduationCompleteionRate = objAccount.Graduation_Phase_Completion_Rate__c!=null?objAccount.Graduation_Phase_Completion_Rate__c:0;
						objAccount.Adoption_Phase_Completion_Rate__c = 0;
						if(objAccount.Adoption_Phase_Completion_Rate__c!=null){
							objAccount.Adoption_Phase_Completion_Rate__c = (dActualAdoptionCompleteionRate-dAdoptionCompleteionRate);
						}
						if(objAccount.Adoption_Phase_Completion_Rate__c >= 75){
							objAccount.Account_Graduation_Date_31_60__c = system.now();
						}
						objAccount.Graduation_Phase_Completion_Rate__c = 0;
						if(objAccount.Graduation_Phase_Completion_Rate__c!=null){
							objAccount.Graduation_Phase_Completion_Rate__c = (dActualGraduationCompleteionRate - dGraduationCompleteionRate);
						}
						if(objAccount.Graduation_Phase_Completion_Rate__c >= 75){
							objAccount.Account_Graduation_Date_61_90__c = system.now();
						}
						//setAccountGraduationStatus(objAccount);
						mapAccounts.put(objAccount.Id,objAccount);
						setAccounts.add(objAccount);
					}
				}
			if(!mapAccounts.isEmpty()){
		     	updatedAccountList.addAll(mapAccounts.Values());
		     	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		    	// update updatedAccountList;
		     }
		}Catch(Exception ex){system.debug('Exception===>'+ex.getMessage()+'===Line=='+ ex.getLineNumber());}
	}
	/** ######################################## ++ END OF ADOPTION AND GRADUATION PHASE OVER ACCOUNT METRIC ###################################################**/
	
	/** ###########################################################################################################################

	  ++ START OF GRADUATION PHASE COMPLETION RATE AND COMPLETION DATE CALCULATION Over ACCOUNT OBJECT ++ 
	  
	###########################################################################################################################	**/	
	
	/** Method is used for calculating completion rate for Graduation phase over Account Object records.
	 * @ param newAccountList, using new records list of Account.
	 * @ param oldMapAccount, using map of Account records old values.
	 */
	public static void calculateGraduationCompletionRate(List<Account> newAccountList, Map<Id, Account> oldMapAccount){
		Set<String> setAccountIds = new Set<String>();
		Set<Account> setAccounts = new  Set<Account>();
		list<Account_Metric__c> accountMetricList = new list<Account_Metric__c>();
		map<Id, Account> mapAccounts = new  map<Id, Account>();
		for(Account account : newAccountList){
			if(account.Id!=null){
				setAccountIds.add(account.Id);
			}
		}
		try{
			Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsWithAccountMetric(setAccountIds);
			for(Account objAccount : newAccountList){
				Decimal dCompletionRate = 0;
				
				if(!accountMap.isEmpty() && accountMap.get(objAccount.Id) != null){
					 Account account  = accountMap.get(objAccount.Id);
					if(account.Cases.size()>0){
						dCompletionRate = dCompletionRate+ACCOUNT_METRIC_12DOT50;
					}
					if(account.Account_Metrics__r.size()>0){
						dCompletionRate = dCompletionRate+getGraduationCompRateAccountMetric(account.Account_Metrics__r[0]);
					}
				}
				dCompletionRate = dCompletionRate+getGraduationCompRateAccount(objAccount);
				/*if(oldMapAccount!=null && oldMapAccount.get(objAccount.Id)!= null){
					Account oldAccount = oldMapAccount.get(objAccount.Id);
					
					if(objAccount.Current_Owner_Email__c != oldAccount.Current_Owner_Email__c
						|| objAccount.Number_of_DL_s__c != oldAccount.Number_of_DL_s__c
						||  objAccount.Graduation_Kit__c !=  oldAccount.Graduation_Kit__c){
						dCompletionRate = dCompletionRate+getGraduationCompRateAccount(objAccount);
						objAccount.Graduation_Phase_Completion_Rate__c = dCompletionRate;
						if(objAccount.Graduation_Phase_Completion_Rate__c >= 75){
							objAccount.Account_Graduation_Date_61_90__c = system.now();
						}
					}
				}else{
					dCompletionRate = dCompletionRate+getGraduationCompRateAccount(objAccount);
					objAccount.Graduation_Phase_Completion_Rate__c = dCompletionRate;
					if(objAccount.Graduation_Phase_Completion_Rate__c >= 75){
						objAccount.Account_Graduation_Date_61_90__c = system.now();
					}
				}*/
				//setAccountGraduationStatus(objAccount);
				if(accountMap!= null && accountMap.get(objAccount.Id) != null && accountMap.get(objAccount.Id).Account_Metrics__r.size()>0){
					Account_Metric__c accountMetric = accountMap.get(objAccount.Id).Account_Metrics__r[0];
					system.debug('@@@@accountMetric--->'+accountMetric);
					if(accountMap.get(objAccount.Id).Implementations__r.size()>0){
						Implementation__c impl =   accountMap.get(objAccount.Id).Implementations__r[0];
						if(impl.Account_Graduation_Status__c == 'Done'){
							accountMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
						}
						if(impl.Account_Graduation_Status__c == 'Implementation Phase'){
							accountMetric.Account_Graduation_Status__c = 'Implementation Phase';
						}
					}
					accountMetric.Graduation_Phase_Completion_Rate__c = dCompletionRate;
					system.debug('@@@@Adoption_Phase_Completion_Rate__c--->'+accountMetric.Adoption_Phase_Completion_Rate__c);
					if(accountMetric.Adoption_Phase_Completion_Rate__c >= 75){
						//accountMetric.Account_Graduation_Date_31_60__c = system.now();
						accountMetric.Account_Graduation_Status__c = 'Graduation Phase';
					}
					if(accountMetric.Graduation_Phase_Completion_Rate__c >= 75){
						accountMetric.Account_Graduation_Date_61_90__c = system.now();
						accountMetric.Account_Graduation_Status__c = 'Done';
					}
					system.debug('@@@@--->'+accountMetric.Account_Graduation_Status__c);
					accountMetricList.add(accountMetric);
				}
			}
			
			if(accountMetricList.size()>0){
				update accountMetricList;
			}
		}Catch(Exception ex){System.debug('Exception====>'+ex.getMessage());}
		
	}
	
	
	/** ######################################## ++ END OF GRADUATION PHASE OVER ACCOUNT OBJECT ###################################################**/
	
	
	/** ###########################################################################################################################

	  ++ START OF GRADUATION PHASE COMPLETION RATE AND COMPLETION DATE CALCULATION Over CASE OBJECT ++ 
	  
	###########################################################################################################################	**/	
	
	/** Method is used for calculating completion rate for Graduation phase over Case Object records.
	 * @ param caseList, using new records list of Case.
	 */
	public static void calculateGraduationCompletionRateOverCase(List<Case> caseList, Map<Id, Case> oldMapCase){
		Set<String> setAccountIds = new Set<String>();
		map<Id, Account> mapAccounts = new  map<Id, Account>();
		list<Account_Metric__c> accountMetricList = new list<Account_Metric__c>();
		for(Case objCase : caseList){
			if(objCase.AccountId != null){
				setAccountIds.add(objCase.AccountId);
			}
		}
		String recTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Support - T3').RecordTypeId ;
		try{
			Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsWithAccountMetric(setAccountIds);
			for(Case objCase : caseList){
				Decimal dCompletionRate = 0;
				if(recTypeId.equalsIgnoreCase(''+objCase.RecordTypeId) || checkCaseRecordType(objCase, oldMapCase, recTypeId))
					{
					if(!accountMap.isEmpty() && objCase.AccountId != null && accountMap.get(objCase.AccountId) != null){
						Account account  = accountMap.get(objCase.AccountId);
						dCompletionRate = dCompletionRate+getGraduationCompRateAccount(account);
						if(account.Cases.size()>0){
							dCompletionRate = dCompletionRate+ACCOUNT_METRIC_12DOT50;
						}
						if(account.Account_Metrics__r.size()>0){
							dCompletionRate = dCompletionRate+getGraduationCompRateAccountMetric(account.Account_Metrics__r[0]);
						}
						account.Graduation_Phase_Completion_Rate__c = dCompletionRate;
						if(account.Graduation_Phase_Completion_Rate__c >= 75){
							account.Account_Graduation_Date_61_90__c = system.now();
						}
						//setAccountGraduationStatus(account);
						mapAccounts.put(account.Id, account);
						
						if(account.Account_Metrics__r.size()>0){
							Account_Metric__c accountMetric = account.Account_Metrics__r[0]; 
							accountMetric.Graduation_Phase_Completion_Rate__c = dCompletionRate;
							if(account.Implementations__r.size()>0){
								Implementation__c impl =   account.Implementations__r[0];
								if(impl.Account_Graduation_Status__c == 'Done'){
									accountMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
								}
								if(impl.Account_Graduation_Status__c == 'Implementation Phase'){
									accountMetric.Account_Graduation_Status__c = 'Implementation Phase';
								}
							}
							if(accountMetric.Adoption_Phase_Completion_Rate__c >= 75){
								accountMetric.Account_Graduation_Date_31_60__c = system.now();
								//accountMetric.Account_Graduation_Status__c = 'Graduation Phase';
							}
							if(accountMetric.Graduation_Phase_Completion_Rate__c >= 75){
								accountMetric.Account_Graduation_Date_61_90__c = system.now();
								accountMetric.Account_Graduation_Status__c = 'Done';
							}
							accountMetricList.add(accountMetric);
						}
					}
				}
				
				
			}
			if(accountMetricList.size()>0){
				update accountMetricList;
			}
			if(!mapAccounts.isEmpty()){
		     	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		    	// update mapAccounts.Values();
		     }
			
		}Catch(Exception ex){System.debug('Exception====>'+ex.getMessage());}
		
	}
	
	/** Method is used for checking recordtypeId and return respecitve boolean.
	 * @ param newCase, using new record of Case.
	 * @ param oldMapCase
	 * @ param recTypeId
	 * @ return boolean.
	 */
	public static boolean checkCaseRecordType(Case newCase,  Map<Id, Case> oldMapCase, String recTypeId){
			if((oldMapCase != null 
				&& (oldMapCase.get(newCase.Id).RecordTypeId != newCase.RecordTypeId)
					&& (oldMapCase.get(newCase.Id).RecordTypeId == recTypeId 
						||  newCase.RecordTypeId == recTypeId)
					)
				){
				return true;
			}
		
		return false;
	}
	
	/** ######################################## ++ END OF GRADUATION PHASE OVER CASE OBJECT ++ ###################################################**/
	
	/** Wrapper class used for wrapping up completion rate and date.*/
	public class ScoreCardWrapper {
		public DateTime completionDate{get;set;}
		public Decimal dCompletionRate{get;set;}
		public Boolean bUpdateAcount{get;set;}
	} 	

}