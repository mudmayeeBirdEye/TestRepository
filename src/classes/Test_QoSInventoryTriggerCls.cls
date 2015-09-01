public with sharing class Test_QoSInventoryTriggerCls {
	static testMethod void Test_QoSInventoryTriggerCls() {
		try {			
			Case objCase = new Case();
			insert objCase;
			Contact con = new Contact();
			con.lastName = 'test';
			con.Email = 'test@test.com';
			insert con;
			List < QoS_Probe_Inventory__c > lstQoSProbeInventory = new List < QoS_Probe_Inventory__c > ();
			QoS_Probe_Inventory__c testObjQosInventory = new QoS_Probe_Inventory__c(name = 'test00156', Probe_Name__c = 'Test Number 1256', Model__c = 'M2056', Assigned_Case__c = objCase.Id);
			testObjQosInventory.Customer_Contact_Name__c = con.id;
			lstQoSProbeInventory.add(testObjQosInventory);
			insert lstQoSProbeInventory;
			QoS_Probe_Inventory__c test2 = new QoS_Probe_Inventory__c(name = 'test00145', Probe_Name__c = 'Test Number00245', Model__c = 'M2045');
			insert test2;
			
			QoS_Probe_Inventory__c test3 = new QoS_Probe_Inventory__c(name = 'test00123', Probe_Name__c = 'Test Number00223', Model__c = 'M2023');
			insert test3;
			test3.Status__c = 'Available';
			update test3;
			
		} catch (Exception ex) {}
	}
}