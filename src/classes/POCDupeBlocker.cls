@isTest(seeAllData = false)
private class POCDupeBlocker{

    static testMethod void myUnitTest() {
                                     
       CRMfusionDBR101__Scenario__c dupeBlockerAccScenario = new CRMfusionDBR101__Scenario__c(Name = 'Account Name Exact Match',
                                                                                              CRMfusionDBR101__Scenario_Type__c ='Account',
                                                                                              OwnerId =UserInfo.getUserId(),
                                                                                              CRMfusionDBR101__Match_on_Insert_Action__c = 'Do not insert',
                                                                                              CRMfusionDBR101__Match_on_Update_Action__c = 'Report Duplicate',
                                                                                              CRMfusionDBR101__Create_Task__c ='No',
                                                                                              CRMfusionDBR101__Error_Message__c = 'Testing is going on',
                                                                                              CRMfusionDBR101__Deployed__c = true,
                                                                                              CRMfusionDBR101__Enable_Dual_Filters__c = true,
                                                                                              CRMfusionDBR101__Bypass_Security__c=true,
                                                                                              CRMfusionDBR101__Rebuild_Needed__c=true);
                                                                                              
                                                                                              
        insert dupeBlockerAccScenario;
        
        CRMfusionDBR101__Scenario_Rule__c ruleOfAccDupeBlocker = new CRMfusionDBR101__Scenario_Rule__c(CRMfusionDBR101__Scenario_Type__c ='Account',
                                                                                                    CRMfusionDBR101__Match_Field__c ='Name',
                                                                                                    CRMfusionDBR101__Mapping_Type__c ='Exact',
                                                                                                    CRMfusionDBR101__Scenario__c = dupeBlockerAccScenario.Id);
        insert ruleOfAccDupeBlocker;   
        
        insert new Account(Name = 'Test');
        insert new Account(Name = 'Test');
        
    }
}