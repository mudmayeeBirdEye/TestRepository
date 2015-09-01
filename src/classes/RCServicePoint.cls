//-------------As/Simplion/03/09/2015---------------------------
//-------------This class is to provide common use methods for development-------
public with sharing class RCServicePoint {
	//---------As/Simplion/03/09/2015---------------------------
	//This method provides describe inofrmation for provided sobject name
	public static Schema.DescribeSObjectResult getDescribeInfoOfSobject(String sobectName){
		SObjectType soType = Schema.getGlobalDescribe().get(sobectName);
		Schema.DescribeSObjectResult result = soType.getDescribe();
		return result;
	}
	

}