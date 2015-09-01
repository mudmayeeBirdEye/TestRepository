public class MarketoControllerNew {

	public String sfdcLeadId = ApexPages.currentPage().getParameters().get('sfdcId');
	public String contactId = ApexPages.currentPage().getParameters().get('contactId');
	public String email = ApexPages.currentPage().getParameters().get('email');

	public String sfdcLeadId1 {get;set;}
	public String contactId1 {get;set;}
	public String email1 {get;set;}
	public Mktows.LeadKey objLeadKey1 {get;set;}

	public Integer iActivityListSize {get;set;}
	public Integer iListSize{get;set;}
	public List < MarketoLeadRecord > searchResults {get;set;}
	public ApexPages.StandardSetController con {get;set;}
	public Boolean isContact {get;set;}
	public Boolean isLead {get;set;}

	private final Integer PAGE_SIZE = 5;
	private final Integer FILTER_QUANTITY = 4;
	private final String PROFILE = 'System Administrator';
	public Integer recordCount {get;set;} // Final Count

	// Constructor
	public MarketoControllerNew() {

		iActivityListSize = 0;
		objMultiRows = new List < MarketoLeadActivityTypeFilter > ();
		MarketoLeadActivityTypeFilter objMarketoLeadActivityTypeFilter = new MarketoLeadActivityTypeFilter();
		objMarketoLeadActivityTypeFilter.listLeftFilter = new List < SelectOption > ();
		objMarketoLeadActivityTypeFilter.listRightFilter = new List < SelectOption > ();
		objMarketoLeadActivityTypeFilter.listLeftFilter = MarketoLeadActivityTypeFilter.getAllAvailableActivityFilter();
		objMarketoLeadActivityTypeFilter.listRightFilter = MarketoLeadActivityTypeFilter.getDefaultActivityFilter();

		objMultiRows.add(objMarketoLeadActivityTypeFilter);

		email1 = email;
		Mktows.LeadKey objLeadKey = new Mktows.LeadKey();
		Mktows.ActivityTypeFilter filter = new Mktows.ActivityTypeFilter();

		if (sfdcLeadId != '' && sfdcLeadId != null) {
			objLeadKey.keyType = 'SFDCLEADID';
			objLeadKey.keyValue = sfdcLeadId;
			//objLeadKey.keyValue='00Q8000000oaFYYEA2';
			sfdcLeadId1 = sfdcLeadId;
			isContact = false;
			isLead = true;
		} else if (contactId != null && contactId != '') {
			objLeadKey.keyType = 'SFDCCONTACTID';
			objLeadKey.keyValue = contactId;
			contactId1 = contactId;
			isContact = true;
			isLead = false;
		}
		objLeadKey1 = objLeadKey;

		Mktows.ArrayOfActivityType obj11 = new Mktows.ArrayOfActivityType();
		obj11.activityType = MarketoLeadActivityTypeFilter.getDefaultSelectedActivityFilter();
		filter.includeTypes = obj11;

		getLeadActiVity(objLeadKey, filter);
	}

	public void getLeadActiVity(Mktows.LeadKey objLeadKey, Mktows.ActivityTypeFilter filter) {

		try {
			searchResults = new List < MarketoLeadRecord > ();
			MkTows.MktowsApiSoapPort port = new MkTows.MktowsApiSoapPort();
			port = MkTowsClient_new.getPort();

			Mktows.StreamPosition posHolder = new Mktows.StreamPosition();
			// Date lastestCreatedAt = Date.today()+5;
			// DateTime lastestCreatedAt= System.now();
			// posHolder.latestCreatedAt=lastestCreatedAt;

			// Mktows.ActivityTypeFilter filter = new Mktows.ActivityTypeFilter(); 
			//Mktows.ArrayOfActivityType obj11=new  Mktows.ArrayOfActivityType();
			//List<String> liActivityType=new List<String>();
			// liActivityType.add('NewLead');
			// obj11.activityType=liActivityType;
			// filter.includeTypes=obj11;
			//Mktows.ArrayOfActivityType includeTypes=new Mktows.ArrayOfActivityType();

			Mktows.LeadActivityList result = new Mktows.LeadActivityList();
			result = port.getLeadActivity(objLeadKey, filter, posHolder, 1000);

			iActivityListSize = 0;
			if (result != null) {
				List < Mktows.ActivityRecord > leadRecords = new List < Mktows.ActivityRecord > ();
				leadRecords = result.activityRecordList.activityRecord;
				iActivityListSize = leadRecords.size();

				Map < String, String > attrMap = null;
				Map < String, String > mapUser = new Map < String, String > ();
				for (Mktows.ActivityRecord item: leadRecords) {
					MarketoLeadRecord objLead = new MarketoLeadRecord();

					//String wsdlTS =''+item.ActivityDateTime;
					//Date localDT =  MktowsUtil.w3cDateToDateObject(item.getActivityDateTime());
					//  DateFormat fmt = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss');
					// String localTS = fmt.format(localDT);
					// System.debug('Activity: ' + item.ActivityType + ',  WSDL Timestamp: ' + wsdlTS + ',  LOCAL Timestamp: ' +item.ActivityDateTime );

					objLead.ActivityID = '' + item.Id;
					objLead.strEmailId = email;
					objLead.strSfdcId = sfdcLeadId;
					objLead.activityDateTime = '' + item.activityDateTime;
					objLead.Activity = item.activityType;
					String compaignName = '';
					compaignName = item.campaign;

					Mktows.ArrayOfAttribute aoAttribute = item.activityAttributes;

					if (aoAttribute != null) {
						attrMap = MarketoLeadRecord.getLeadAttributeMap(aoAttribute);
						if (attrMap != null && !attrMap.isEmpty()) {
							Set < String > keySet = attrMap.keySet();
							try {
								// objLead.Activity= attrMap.get('Activity');
								objLead.Source = attrMap.get('Source');
								(objLead.NewValue) = attrMap.get('New Value');
								objLead.AttributeName = attrMap.get('Attribute Name');
								objLead.OldValue = attrMap.get('Old Value');
								objLead.Reason = attrMap.get('Reason');
								objLead.LeadID = attrMap.get('Lead ID');

								if (item.activityType == 'Sync Lead to SFDC') {
									objLead.Reason = 'SFDC Action: update';
									if (compaignName != null && compaignName != '') {
										objLead.Reason = objLead.Reason + '(' + compaignName + ')';
									}
								}

								if (item.activityType == 'Change Owner') {
									try {
										if (attrMap.get('Owner Id') != null && attrMap.get('Owner Id') != '') {
											mapUser.put(attrMap.get('Owner Id'), attrMap.get('Owner'));
										}
										objLead.Reason = attrMap.get('Owner');
										objLead.OldValue = attrMap.get('Old Owner') == '<null>' ? '' : attrMap.get('Old Owner');
										objLead.NewValue = attrMap.get('Owner') == null ? '' : attrMap.get('Owner');
									} catch (Exception e) {

									}
								}

								try {
									if (attrMap.get('Attribute Name') != null && attrMap.get('Attribute Name') != '' && attrMap.get('Attribute Name').equalsIgnoreCase('Sales Lead Owner')) {
										// System.debug('map@@@@@@@@@@@@@@'+mapUser.keySet());
										objLead.OldValue = mapUser.get(attrMap.get('Old Value') == null ? 'none' : attrMap.get('Old Value'));
										objLead.NewValue = mapUser.get(attrMap.get('New Value') == null ? 'none' : attrMap.get('New Value'));
									}
								} catch (Exception e) {
									objLead.OldValue = attrMap.get('Old Value');
									objLead.NewValue = attrMap.get('New Value');
								}

								try {
									if (item.activityType == 'New Lead') {
										objLead.Source = attrMap.get('Lead Source');
										objLead.Reason = 'Lead Name:' + item.mktgAssetName + ',source:' + attrMap.get('Source Type');
									}
								} catch (Exception e) {}

								try {
									if (objLead.Reason == null || objLead.Reason == '') {
										objLead.Reason = item.mktgAssetName;
									}

								} catch (Exception e) {}

							} catch (Exception e) {
								System.debug('Exception in getLeadActiVity ' + e.getMessage());
							}


							/* for (String key : keySet) {
                             System.debug('   Attribute name: ' + key + ', value: ' + attrMap.get(key));
                        }*/
						}
					}
					searchResults.add(objLead);
				}
			}

		} catch (Exception e) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'No Record Found ');
			ApexPages.addMessage(myMsg);
			return;

		}
		if (searchResults == null || searchResults.size() == 0) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'No Record Found');
			ApexPages.addMessage(myMsg);
		}

		return;
	}

	public List < MarketoLeadActivityTypeFilter > objMultiRows {get;set;}
	public String SelectedRow{get;set;}
	
	public Pagereference MoveRight() {

		for (MarketoLeadActivityTypeFilter tempRow: objMultiRows) {
			//Move to Right
			for (String s: tempRow.SelectedOptionsLeft) {
				for (SelectOption selOp: tempRow.listLeftFilter) {
					if (selOp.getValue() == s) {
						tempRow.listRightFilter.add(new SelectOption(s, selOp.getLabel()));

						break;
					}
				}
			}
			//Remove from Left
			List < SelectOption > TempOptions = tempRow.listLeftFilter;
			tempRow.listLeftFilter = new List < SelectOption > ();
			for (SelectOption selOpTemp: TempOptions) {
				boolean isSelected = false;
				for (String sTemp: tempRow.SelectedOptionsLeft) {
					if (sTemp == selOpTemp.getValue()) {
						isSelected = true;
						break;
					}
				}
				if (isSelected == false) tempRow.listLeftFilter.add(selOpTemp);
			}
			break;
		}
		return null;
	}
	public Pagereference MoveLeft() {
		system.debug('##########objMultiRows.size ' + objMultiRows.size());
		for (MarketoLeadActivityTypeFilter tempRow: objMultiRows) {
			//Move to Left
			for (String s: tempRow.SelectedOptionsRight) {
				for (SelectOption selOp: tempRow.listRightFilter) {
					if (selOp.getValue() == s) {
						tempRow.listLeftFilter.add(new SelectOption(s, selOp.getLabel()));
						break;
					}
				}
			}
			//Remove from Right
			List < SelectOption > TempOptions = tempRow.listRightFilter;
			tempRow.listRightFilter = new List < SelectOption > ();
			for (SelectOption selOpTemp: TempOptions) {
				boolean isSelected = false;
				for (String sTemp: tempRow.SelectedOptionsRight) {
					if (sTemp == selOpTemp.getValue()) {
						isSelected = true;
						break;
					}
				}
				if (isSelected == false) tempRow.listRightFilter.add(selOpTemp);
			}
			break;
		}
		return null;
	}

	public Pagereference showLeadActivityWithFilter() {
		List < String > liActivityType = new List < String > ();
		for (MarketoLeadActivityTypeFilter tempRow: objMultiRows) {
			for (SelectOption selOp: tempRow.listRightFilter) {
				String activityFilter = selOp.getValue();
				liActivityType.add(activityFilter);
			}
		}
		Mktows.ActivityTypeFilter filter = new Mktows.ActivityTypeFilter();
		Mktows.ArrayOfActivityType obj11 = new Mktows.ArrayOfActivityType();
		obj11.activityType = liActivityType;
		filter.includeTypes = obj11;
		getLeadActiVity(objLeadKey1, filter);
		return null;
	}
}