@isTest
private class Test_Lead_Mktows {

    static testMethod void TestConvertLead() {
    	ConvertLead convertObj = new ConvertLead();
    }
    static testMethod void testMarketoLeadActivityTypeFilter() {
	 	MarketoLeadActivityTypeFilter.getAllAvailableActivityFilter();
	 	MarketoLeadActivityTypeFilter.getDefaultActivityFilter();
	 	MarketoLeadActivityTypeFilter.getDefaultSelectedActivityFilter();
 	}
 	static testMethod void TestMarketoLead() {
		MarketoLeadRecord obj=new MarketoLeadRecord ();
		Mktows.ArrayOfAttribute obj2=new Mktows.ArrayOfAttribute();
		try{
			 MarketoLeadRecord.getLeadAttributeMap(obj2);
		}catch(Exception e){}
    }
     static testMethod void TestMktows() {
        
     	    
     	    Mktows.MktowsApiSoapPort obj =new Mktows.MktowsApiSoapPort();

			Mktows.LeadKey leadKey= new Mktows.LeadKey();
			Mktows.ActivityTypeFilter activityFilter=new Mktows.ActivityTypeFilter();
			Mktows.StreamPosition startPosition=new Mktows.StreamPosition();
			Integer batchSize=10;
			
				try{
			    obj.getLeadActivity(leadKey,activityFilter,startPosition, batchSize);
				}catch(Exception e){}
			
			obj =new Mktows.MktowsApiSoapPort();
			String listOperation='';
			Mktows.ListKey listKey =new Mktows.ListKey();
			Mktows.ArrayOfLeadKey listMemberList=new Mktows.ArrayOfLeadKey();
			Boolean strict=true;
			
			try{
			  obj.listOperation(listOperation,listKey,listMemberList,strict);
			}catch(Exception e){}
			
			obj =new Mktows.MktowsApiSoapPort();
			String objectName='Lead';
			
			try{
			  obj.describeMObject(objectName);
			}catch(Exception e){}
			
			obj =new Mktows.MktowsApiSoapPort();
			DateTime lastUpdatedAt=Date.today();
			//String streamPosition='';
			batchSize=10;
			Mktows.ArrayOfString includeAttributes=new Mktows.ArrayOfString();
			
			try{
			  obj.getMultipleLeads(lastUpdatedAt,null,batchSize,includeAttributes);
			}catch(Exception e){}
			
			obj =new Mktows.MktowsApiSoapPort();
			leadKey =new Mktows.LeadKey();
			
			try{
			  obj.getLead(leadKey);
			}catch(Exception e){}
			
			obj =new Mktows.MktowsApiSoapPort();
			String objTypeName='Lead';
			//String streamPosition='';
			batchSize=10;
			Mktows.ArrayOfAttribute customObjKeyList=new Mktows.ArrayOfAttribute();
			includeAttributes=new Mktows.ArrayOfString();
			
			try{
			   obj.getCustomObjects(objTypeName,null,batchSize,customObjKeyList,includeAttributes);
			}catch(Exception e){}
			 obj =new Mktows.MktowsApiSoapPort();
			try{
			  obj.listMObjects();
			}catch(Exception e){}
			try{
			   Mktows.SyncCustomObjStatus obj1=new Mktows.SyncCustomObjStatus();
			}catch(Exception e){}
			
			 obj =new Mktows.MktowsApiSoapPort();
			 Mktows.ArrayOfLeadKey leadList=new Mktows.ArrayOfLeadKey();
			 try{
			   obj.requestCampaign(null,123,leadList);
			 }catch(Exception e){}
           obj =new Mktows.MktowsApiSoapPort();
           try{
           obj.getLeadChanges(startPosition,activityFilter,10);
           }catch(Exception e){}
        try{
          obj.getCampaignsForSource(null,null,true);
        }catch(Exception e){}
		Mktows.MObjFieldMetadata w112=new	Mktows.MObjFieldMetadata();
		Mktows.MergeStatus w3111=new Mktows.MergeStatus();
		Mktows.ParamsSyncLead obj2=new Mktows.ParamsSyncLead();
		Mktows.ActivityTypeFilter obj3=new Mktows.ActivityTypeFilter();
		Mktows.SuccessListMObjects obj4=new Mktows.SuccessListMObjects();
		Mktows.ArrayOfKeyList obj5=new Mktows.ArrayOfKeyList();
		Mktows.ResultMergeLeads obj6=new Mktows.ResultMergeLeads();
		Mktows.ResultDescribeMObject obj7=new Mktows.ResultDescribeMObject();
		Mktows.SuccessSyncLead obj8=new Mktows.SuccessSyncLead();
		Mktows.LeadChangeRecord obj9=new Mktows.LeadChangeRecord();
		Mktows.SuccessGetLead obj10=new Mktows.SuccessGetLead();
		Mktows.ArrayOfCustomObj obj11=new Mktows.ArrayOfCustomObj();
		Mktows.ArrayOfBase64Binary obj12=new Mktows.ArrayOfBase64Binary();
		Mktows.ParamsGetMultipleLeads o1=new Mktows.ParamsGetMultipleLeads();
		Mktows.CustomObj o2=new Mktows.CustomObj();
		Mktows.ResultGetCustomObjects o3=new Mktows.ResultGetCustomObjects();
		Mktows.ArrayOfAttribute o4=new Mktows.ArrayOfAttribute();
		Mktows.ParamsListOperation o5=new Mktows.ParamsListOperation();
		Mktows.ResultGetLeadChanges o6=new Mktows.ResultGetLeadChanges();
		Mktows.MObjectMetadata o7=new Mktows.MObjectMetadata();
		Mktows.ResultDeleteCustomObjects o8=new Mktows.ResultDeleteCustomObjects();
		Mktows.Attribute o9=new Mktows.Attribute();
		Mktows.VersionedItem o10=new Mktows.VersionedItem();
		Mktows.SuccessSyncMultipleLeads a1=new Mktows.SuccessSyncMultipleLeads();
		Mktows.AuthenticationHeaderInfo a2=new Mktows.AuthenticationHeaderInfo();
		Mktows.ResultSyncLead a3=new Mktows.ResultSyncLead();
		Mktows.ArrayOfCampaignRecord a4=new Mktows.ArrayOfCampaignRecord();
		Mktows.ArrayOfLeadChangeRecord a5=new Mktows.ArrayOfLeadChangeRecord();
		Mktows.CampaignRecord a6=new Mktows.CampaignRecord();
		Mktows.SuccessGetLeadChanges a7=new Mktows.SuccessGetLeadChanges();
		Mktows.ArrayOfActivityRecord a8=new Mktows.ArrayOfActivityRecord();
		Mktows.ActivityRecord a9=new Mktows.ActivityRecord();
		Mktows.SuccessGetCustomObjects a10=new Mktows.SuccessGetCustomObjects();
		Mktows.ParamsSyncCustomObjects b1=new Mktows.ParamsSyncCustomObjects();
		Mktows.MktowsContextHeaderInfo b2=new Mktows.MktowsContextHeaderInfo();
		Mktows.ArrayOfString b3=new Mktows.ArrayOfString();
		Mktows.SuccessRequestCampaign b4=new Mktows.SuccessRequestCampaign();
		Mktows.ResultSyncMultipleLeads b5=new Mktows.ResultSyncMultipleLeads();
		Mktows.SuccessGetMultipleLeads b6=new Mktows.SuccessGetMultipleLeads();
		Mktows.SuccessGetCampaignsForSource b7=new Mktows.SuccessGetCampaignsForSource();
		Mktows.SuccessGetLeadActivity s1=new Mktows.SuccessGetLeadActivity();
		Mktows.ArrayOfVersionedItem s2=new Mktows.ArrayOfVersionedItem();
		Mktows.ResultListOperation s3=new Mktows.ResultListOperation();
		Mktows.ResultListOperation s4=new Mktows.ResultListOperation();
		Mktows.ArrayOfMObjFieldMetadata s5= new Mktows.ArrayOfMObjFieldMetadata();
		Mktows.ResultGetLead s6=new Mktows.ResultGetLead();
		Mktows.ParamsDeleteCustomObjects s7=new Mktows.ParamsDeleteCustomObjects();
		Mktows.ParamsGetCampaignsForSource s8=new Mktows.ParamsGetCampaignsForSource();
		Mktows.ArrayOfSyncCustomObjStatus s9=new Mktows.ArrayOfSyncCustomObjStatus();
		Mktows.ParamsGetLeadActivity d1=new Mktows.ParamsGetLeadActivity();
		Mktows.ResultSyncCustomObjects d2=new Mktows.ResultSyncCustomObjects();
		Mktows.ParamsGetLeadChanges d3 =new Mktows.ParamsGetLeadChanges();
		Mktows.ParamsDescribeMObject d4=new Mktows.ParamsDescribeMObject();
		Mktows.SuccessDescribeMObject d5=new Mktows.SuccessDescribeMObject();
		Mktows.ParamsGetCustomObjects d6=new Mktows.ParamsGetCustomObjects();
		Mktows.ArrayOfInteger d7=new Mktows.ArrayOfInteger();
		Mktows.LeadRecord d8=new Mktows.LeadRecord();
		Mktows.ParamsGetLead d9=new Mktows.ParamsGetLead();
		Mktows.ResultRequestCampaign w1=new Mktows.ResultRequestCampaign();
		Mktows.ResultGetCampaignsForSource w2=new Mktows.ResultGetCampaignsForSource ();
		Mktows.ParamsListMObjects w3=new Mktows.ParamsListMObjects();
		Mktows.ListKey w4=new Mktows.ListKey();
		//SuccessMergeLeads w5=new SuccessMergeLeads();
    }
    public static testmethod void testMSE(){
    	MultiSheetExcelController mse = new MultiSheetExcelController();
    	mse.dModel  = new DataModel();
   		mse.endfile ='none';
   		mse.xmlheader ='xml';
    }
}