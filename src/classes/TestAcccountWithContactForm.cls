/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /**  
  *  Description    :   This class is test class of AccountWithContactFormController
  *
  *  Created By     :    
  *
  *  Created Date   :    05/08/2014
  *
  *  Version        :    V_1.0
  *
  *  Revision Logs  :    V_1.0 - Created 
  *
  **/
@isTest(seeAllData = false)
private class TestAcccountWithContactForm {
    
    /**
      *  @Description    :   This method is for Account dupe cases
      *
      *  @args           :   
      *
      *  @return         :   void
      *
     **/
    static testMethod void dupeBlaockerForAccount() {
        
        //Account duupe scenario                            
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
																							  
		
		//insert 																					  
		insert dupeBlockerAccScenario;
		
		//Rule for dupe account
		CRMfusionDBR101__Scenario_Rule__c ruleOfAccDupeBlocker = new CRMfusionDBR101__Scenario_Rule__c(CRMfusionDBR101__Scenario_Type__c ='Account',
																									CRMfusionDBR101__Match_Field__c ='Account Name',
																									CRMfusionDBR101__Mapping_Type__c ='Exact',
																									CRMfusionDBR101__Scenario__c = dupeBlockerAccScenario.Id);
		insert ruleOfAccDupeBlocker;  

		Test.startTest();  

		//Initialize Controller
		AccountWithContactFormController controller = new AccountWithContactFormController();

		//Assign values in account variable
		controller.account.Name = 'Test Account 1';
		controller.contact.OwnerId = UserInfo.getuserid();

		//Call controller class method to insert(validate) account
		controller.validateAccountInsert();

		//Query through accounts
		List<Account> accounts = [Select Id, Name From Account Where Name = 'Test Account 1'];  
		System.assertEquals(1, accounts.size());

		//reinitialize controller
		controller = new AccountWithContactFormController();

		//Initialize Controller
		controller.account.Name = 'Test Account 1';
		controller.contact.OwnerId = UserInfo.getuserid();
		controller.account.Website ='test.com';

		//Call controller class method to insert(validate) account
		controller.validateAccountInsert();

		//Assert for result
		System.assertEquals('Potential duplicates found. You can update existing Account using "Override All/Override Blank/Merge" functionality. Please click on help link to get more information about each action in detail.',controller.error);                          

		controller.accountActionType = 'oAll';
		controller.selectedAccountId = accounts[0].Id;

		//Call the controller method to overide the record value
		controller.manualAccountSubmit();

		//Query through account
		accounts = [Select Id, Name,WebSite From Account Where Name = 'Test Account 1'];

		//Assert for result
		System.assertEquals('test.com',accounts[0].Website);

		//reinitialize controller
		controller = new AccountWithContactFormController();

		//Initialize Controller
		controller.account.Name = 'Test Account 1';
		controller.contact.OwnerId = UserInfo.getuserid();
		controller.account.Website ='test1.com';

		//Call controller class method to insert(validate) account
		controller.validateAccountInsert();

		controller.accountActionType = 'oBlank';
		controller.selectedAccountId = accounts[0].Id;

		//Call the controller method to overide the record value
		controller.manualAccountSubmit();

		//Query through account
		accounts = [Select Id, Name,WebSite From Account Where Name = 'Test Account 1'];

		//Assert for result
		System.assertEquals('test.com',accounts[0].Website);

		//reinitialize controller
		controller = new AccountWithContactFormController();

		//Initialize Controller
		controller.account.Name = 'Test Account 1';
		controller.contact.OwnerId = UserInfo.getuserid();
		controller.account.Website ='';

		//Call controller class method to insert(validate) account
		controller.validateAccountInsert();
		
		//Controller values	
		controller.selectedAccountId = accounts[0].Id;

		//Call methd to merfe the record
		controller.getSelectedMergeAccount();

		//Call the controller method to overide the record value
		controller.manualAccountSubmit();

		//Query through account
		accounts = [Select Id, Name,WebSite From Account Where Name = 'Test Account 1'];

		//Assert for result
		System.assertEquals(null,accounts[0].Website);
		       
	}
	/**
      *  @Description    :   This method is for cotactd upe cases
      *
      *  @args           :   
      *
      *  @return         :   void
      *
     **/
    static testMethod void dupeBlaockerForContact() {
		
		//Contact Scenario
		CRMfusionDBR101__Scenario__c dupeBlockerConScenario = new CRMfusionDBR101__Scenario__c(Name = 'Contact Name Exact Match',
                                                                                          CRMfusionDBR101__Scenario_Type__c ='Contact',
                                                                                          OwnerId =UserInfo.getUserId(),
                                                                                          CRMfusionDBR101__Match_on_Insert_Action__c = 'Do not insert',
                                                                                          CRMfusionDBR101__Match_on_Update_Action__c = 'Report Duplicate',
                                                                                          CRMfusionDBR101__Create_Task__c ='No',
                                                                                          CRMfusionDBR101__Error_Message__c = 'Testing is going on',
                                                                                          CRMfusionDBR101__Deployed__c = true,
                                                                                          CRMfusionDBR101__Enable_Dual_Filters__c = true,
                                                                                          CRMfusionDBR101__Bypass_Security__c=true,
                                                                                          CRMfusionDBR101__Rebuild_Needed__c=true);
                                                                                          
                                                                                          
		insert dupeBlockerConScenario;
    
		//Contact dupe rule
		CRMfusionDBR101__Scenario_Rule__c ruleOfConDupeBlocker = new CRMfusionDBR101__Scenario_Rule__c(CRMfusionDBR101__Scenario_Type__c ='Contact',
                                                                                                CRMfusionDBR101__Match_Field__c ='Email',
                                                                                                CRMfusionDBR101__Mapping_Type__c ='Exact',
                                                                                                CRMfusionDBR101__Scenario__c = dupeBlockerConScenario.Id);
		insert ruleOfConDupeBlocker; 
    

   
		//Testing starts from here
		Test.startTest();
   
		//Initialize Controller
		AccountWithContactFormController controller = new AccountWithContactFormController();
   
		//Assign values in contact variable
		controller.contact.LastName = 'Test';
		controller.contact.OwnerId = userInfo.getUserId();
		controller.contact.Email = 'Test@test.com';

		//Call controller class method to insert(validate) contact
		controller.validateContactInsert();

		//Query through contacts
		List<Contact> contacts = [Select Id, LastName, Email From Contact Where Email = 'Test@test.com'];    
		System.assertEquals(1, contacts.size());

		//Reinitialize controller
		controller = new AccountWithContactFormController();
		  
		//Assign values in contact variable
		controller.contact.LastName = 'Test 1';
		controller.contact.OwnerId =userInfo.getUserId();
		controller.contact.Email = 'Test@test.com';

		//Call controller class method to insert(validate) account
		controller.validateContactInsert();
			
		//Assert for result
		System.assertEquals('Potential duplicates found. You can update existing Contact using "Override All/Override Blank/Merge" functionality. Please click on help link to get more information about each action in detail.',controller.error);                          
		
		//Overide the values
		controller.contactActionType = 'oAll';
		controller.selectedContactId = contacts[0].Id;

		//Call the controller method to overide the record value
		controller.manualContactSubmit();

		//Query through contact
		contacts = [Select Id, LastName, Email From Contact Where Email = 'Test@test.com'];

		//Assert for result
		System.assertEquals('Test 1',contacts[0].LastName);

		//Reinitialize controller
		controller = new AccountWithContactFormController();

		//Assign values in contact variable
		controller.contact.LastName = 'Test 1';
		controller.contact.OwnerId =userInfo.getUserId();
		controller.contact.FirstName = 'test';
		controller.contact.Email = 'Test@test.com';

		//Call controller class method to insert(validate) contact
		controller.validateContactInsert();
		
		//Overide vales
		controller.contactActionType = 'oBlank';
		controller.selectedContactId = contacts[0].Id;

		//Call the controller method to overide the record value
		controller.manualContactSubmit();

		//Query through contact
		contacts = [Select Id, LastName,FirstName, Email From Contact Where Email = 'Test@test.com'];

		//Assert for result
		System.assertEquals('test',contacts[0].FirstName);

		//Reinitialize controller
		controller = new AccountWithContactFormController();

		//Assign values in contact variable
		controller.contact.LastName = 'Test 1';
		controller.contact.OwnerId =userInfo.getUserId();
		controller.contact.FirstName = '';
		controller.contact.Email = 'Test@test.com';

		//Call controller class method to insert(validate) account
		controller.validateContactInsert();
  
		controller.selectedContactId = contacts[0].Id;

		//Call methd to merfe the record
		controller.getSelectedMergeContact();

		//Call the controller method to overide the record value
		controller.manualContactSubmit();

		//Query through account
		contacts = [Select Id, LastName,FirstName, Email From Contact Where Email = 'Test@test.com'];
		
		//Asset for result
		System.assertEquals(null, contacts[0].FirstName);
      
		Test.stopTest();
         
    }
}