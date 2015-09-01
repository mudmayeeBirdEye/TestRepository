public class HelperCaseDispatch {
	//Constructor
	static String caseOwnerId;
	static List<Case_Dispatch__c> caseDispatchObjList;
	static{
		caseDispatchObjList = [SELECT c.Name, c.Product_Assistance__c,c.Operator__c, c.Brand__c, 
										c.Total_Account_DL_s__c, c.Queue__c, c.Tier__c, c.VIP__c, c.VIP_Queue__c FROM Case_Dispatch__c c order by Name];
	}
	public HelperCaseDispatch(){}
	
	//Function to assign Queue on basis of Tier, Total Account DLs and Brand
	public static Case assignQueue(Case caseObj,User loginUser){	
		try{	
				caseOwnerId='';
				String accountTier;
				String productAssistance = caseObj.Product_Assistance__c != null ? caseObj.Product_Assistance__c.trim() : '';
				Double accountDLS;
				String accountBrand;
				String accountVIP;
				if(caseObj.Account != null){
					accountTier = caseObj.Account.RC_Tier__c;
					accountDLS = caseObj.Account.Total_Account_DL_s__c;
					accountBrand = caseObj.Account.RC_Brand__c;
					accountVIP = caseObj.Account.VIP_Account_Indicator__c;
				}else{
					accountTier = loginUser.Contact.Account.RC_Tier__c;
					accountDLS = loginUser.Contact.Account.Total_Account_DL_s__c;
					accountBrand = loginUser.Contact.Account.RC_Brand__c;
					accountVIP = loginUser.Contact.Account.VIP_Account_Indicator__c;
				}
				
				accountTier = String.isBlank(accountTier) ? '':accountTier.trim();
				accountDLS = accountDLS == null ? 0.0:accountDLS;
				accountBrand = String.isBlank(accountBrand) ? '' : accountBrand;
				
				Map<String, String> groupIdMap = getAllGroups(caseDispatchObjList);
				
				if(accountTier != ''){
						// Added by Virendra					
						for(Case_Dispatch__c caseSettingobj :caseDispatchObjList){
							String customSettingTier = String.isNotBlank(caseSettingobj.Tier__c) ? caseSettingobj.Tier__c.trim() : '';
							String customSettingBrands = String.isNotBlank(caseSettingobj.Brand__c) ? caseSettingobj.Brand__c.trim() : '';
							List<String> csTiers = spiltTiers(customSettingTier);
							Boolean checkResult = checkTierValueInAccTier(csTiers,accountTier);
							Boolean isVIP = caseSettingobj.VIP__c && String.isNotBlank(accountVIP) ? true : false;
							List<String> csBrands = spiltTiers(customSettingBrands);
							Set<String> csBrandsSet = new Set<String>();
							for(String str : csBrands){
								If(String.isNotBlank(str)){
									csBrandsSet.add(str.trim().toLowerCase());
								}
							}
							csBrandsSet.addAll(csBrands);
							Boolean checkForBrand = csBrandsSet.contains(accountBrand.trim().toLowerCase()) ? true : false;
							String productAssistanceCS = String.isBlank(caseSettingobj.Product_Assistance__c) ? '' : caseSettingobj.Product_Assistance__c.trim();
							if((productAssistanceCS).containsIgnoreCase(productAssistance) 
								&& checkResult && checkForBrand){
								if((caseSettingobj.Tier__c).containsIgnoreCase('Fax') || (caseSettingobj.Tier__c).containsIgnoreCase('Pro')){
									if(isVIP){
										caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
									}else{
										caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
									}
									break;
								}else if((caseSettingobj.Tier__c).containsIgnoreCase('Office')){
									String strOperator= String.isNotBlank(caseSettingobj.Operator__c) ? caseSettingobj.Operator__c.trim() : '';
									if((strOperator).equals('<=')){
										if(accountDLS <= caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}else if((strOperator).equals('<')){
										if(accountDLS < caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}else if((strOperator).equals('>=')){
										if(accountDLS >= caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}else if((strOperator).equals('>')){
										if(accountDLS > caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}else if((strOperator).equals('==')){
										if(accountDLS == caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}else if((strOperator).equals('!=')){
										if(accountDLS != caseSettingobj.Total_Account_DL_s__c){
											if(isVIP){
												caseOwnerId = getGroupId_VIP(caseSettingobj,groupIdMap);
											}else{
												caseOwnerId = getGroupId(caseSettingobj,groupIdMap);
											}
											break;
									 	}
									}
								}else{
									caseOwnerId = getDefaultQueue(groupIdMap,caseDispatchObjList);
									break;
								}
							} 						
						}
			} else {
				caseOwnerId = getDefaultQueue(groupIdMap,caseDispatchObjList);
			}
			if(String.isBlank(caseOwnerId)) {
				caseOwnerId = getDefaultQueue(groupIdMap,caseDispatchObjList);
			}
			if(caseOwnerId.trim()!=''){
				caseObj.OwnerId = caseOwnerId;
			}
			return caseObj;
		}catch(Exception ex){
			System.debug('Exception============'+ex.getMessage());
			System.debug('Exception============'+ex.getStackTraceString());
			return caseObj;
		}
	}
	
	public static String[] spiltTiers(String tier){
		List<String> tierArray = null;
		tier = (tier==null) ? '' : tier;
		if(tier.containsIgnoreCase(',')){
			tierArray = tier.split(',');
		}else{
			tierArray = new List<String>();
			tierArray.add(tier);
		}
		return tierArray;
	}
	
	public static boolean checkTierValueInAccTier(List<String> csTiers,String accTier){
		for(String tier : csTiers){
			if(accTier.containsIgnoreCase(tier)){
				return true;
			}
		}
		return false;
	}
		
	private static String getGroupId(Case_Dispatch__c csObject, Map<String, String> groupIdMap) {
		return (groupIdMap.size() != 0 && groupIdMap.get((csObject.Queue__c).trim()) != null ?  groupIdMap.get((csObject.Queue__c).trim()) : '');
	}
	
	private static String getGroupId_VIP(Case_Dispatch__c csObject, Map<String, String> groupIdMap) {
		return (groupIdMap.size() != 0 && groupIdMap.get((csObject.VIP_Queue__c).trim()) != null ?  groupIdMap.get((csObject.VIP_Queue__c).trim()) : '');
	}
	
	private static Map<String, String> getAllGroups(List<Case_Dispatch__c> displatchList) {
		Map<String, String> groupIdMap = new Map<String, String>();
		Set<String> groups = new Set<String>();
		for(Case_Dispatch__c dispatchObj : displatchList) {
			groups.add(dispatchObj.Queue__c);
			groups.add(dispatchObj.VIP_Queue__c);
		}
		for(Group groupObj : [SELECT Id,Name FROM Group WHERE Name IN:groups]) {
			groupIdMap.put(groupObj.name,groupObj.id);	
		}
		return groupIdMap;
	}
	private static String getDefaultQueue(Map<String, String> groupIdMap, List<Case_Dispatch__c> displatchList) {
		for(Case_Dispatch__c dispatchObj : displatchList) {
			if((dispatchObj.Name).equalsIgnoreCase('DEFAULT_QUEUE')) {
				return groupIdMap.get(dispatchObj.Queue__c);
			}
		}
		return '';
	}
}