/**
 *  Description     :   This class is for the business card records to be saved in Account and Contact Object
 * 
 *  Created By      :   Bhavi Sharma 
 * 
 *  Created Date    :   03/1/2013
 * 
 *  Revision Logs   :   V_1.0 - Created
 *       
 **/
public without sharing class AccountWithContactFormController {

    //Account and Contact Instances
    public Account account { get; set; }
    public Contact contact { get; set; }

    //Map to hold the potential duplicate accounts and contacts
    public Map<Id, Account> mapAccounts { get; set; }
    public Map<Id, Contact> mapContacts { get; set; }
                
    //Account and Contact for Merging
    public Account mergingAccount {get; set;}
    public Contact mergingContact {get; set;}
           
    //User Selection
    public Id selectedAccountId { get; set; }
    public String accountActionType { get; set; }
    public Id selectedContactId { get; set; }
    public String contactActionType { get; set; }
    public Boolean duplicateAccounts {get; set;}
    public Boolean duplicateContacts {get; set;}
    public boolean message{get;set;}
    public String accOwner{get;set;}
    public String accountName{get; set;}
    public Id accountId {get; set;}
    public String error {get;set;}
    public String step{get;set;}
    public String accID;
    public String conId;
    
    
    //Constructor
    public AccountWithContactFormController() {
        
        //InIt
        contact  = new Contact();
        inIt();
    }
    
    //Init Method
    private void inIt() {
                 
        //initializa data
        account = new Account();
        Id ownerId = contact.OwnerId;
        contact  = new Contact(OwnerId = ownerId);
        mergingAccount = new Account();
        mergingContact = new Contact();
        mapAccounts = new Map<Id, Account>();
        mapContacts = new Map<Id, Contact>();
        duplicateAccounts = false;
        duplicateContacts = false;
        accountName ='';
        accountId = null;
        step = '1';
     }
    
    /**
     * @Description  :  Method to search selected account for merge.
     *
     * @args         :  
     *
     * @return       :  void
     *  
    **/   
    public PageReference getSelectedMergeAccount() {
        
        //Check for null  
        if(selectedAccountId != null) {
            
            //Query to get account record
            List<Account> accountsForMerging = [Select Id, Name, Website, OwnerId, BillingCity, BillingCountry From Account Where Id =: selectedAccountId];
            
            //Check for size
            if(accountsForMerging.size() > 0) {
                mergingAccount = accountsForMerging[0];
                account.Id = mergingAccount.Id;
                account.Website = account.Website == '' ? '':account.Website;
                duplicateAccounts = true;
            }
        }   
        return null;
    }
                
    /**
     * @Description  :  Method to search selected account for merge.
     *
     * @args         :  
     *
     * @return       :  void
     *
    **/   
    public PageReference getSelectedMergeContact() {
        
        //Check for null  
        if(selectedContactId != null) {
            
            //Query to get contact record
            List<Contact> contactsForMerging = [Select Id, LastName, Account.Name, AccountId, OwnerId, Owner.Name, FirstName, Email, Phone, MobilePhone, Title,HasOptedOutOfEmail,Academic_TItle__c ,Note__c , OtherPhone, Business_Phone__c, Email_Opt_Out__c, Gender__c, Skype__c, MailingStreet, MailingCity, MailingCountry, Mailingpostalcode, MailingState From Contact Where Id =: selectedContactId];
    
            //Check for size
            if(contactsForMerging.size() > 0) {
                mergingContact = contactsForMerging[0];
                contact.Id = mergingContact.Id;
                /*contact.AccountId = contact.AccountId== null ? null:contact.AccountId;
                contact.FirstName = contact.FirstName == '' ? '':contact.FirstName;
                contact.HasOptedOutOfEmail = contact.HasOptedOutOfEmail == false ? false : contact.HasOptedOutOfEmail;
                contact.Gender__c = contact.Gender__c == '' ? '' : contact.Gender__c;
                contact.Title = contact.Title == '' ? '' : contact.Title;
                contact.Skype__c = contact.Skype__c == '' ? '' : contact.Skype__c;
                contact.Academic_TItle__c = contact.Academic_TItle__c == '' ? '' : contact.Academic_TItle__c;
                contact.MailingStreet = contact.MailingStreet == '' ? '' : contact.MailingStreet;
                contact.MailingCity = contact.MailingCity == '' ? '' : contact.MailingCity;
                contact.Business_Phone__c = contact.Business_Phone__c == '' ? '' : contact.Business_Phone__c;
                contact.MailingCountry = contact.MailingCountry == '' ? '' : contact.MailingCountry;
                contact.MobilePhone = contact.MobilePhone == '' ? '' : contact.MobilePhone;
                contact.MailingPostalCode = contact.MailingPostalCode == '' ? '' : contact.MailingPostalCode;
                contact.OtherPhone = contact.OtherPhone == '' ? '' : contact.OtherPhone;
                contact.Note__c = contact.Note__c == '' ? '' : contact.Note__c;
                contact.AccountId = mergingContact.AccountId;*/
                duplicateContacts = true;
            }
        }
        return null;
    }
    
    /**
     *  @description    :   This method is to check 
                                1. If there is any  existing account with the same information as entered on UI
                                2. If nothing exists already, insert directly
     * 
     *  @args           :   
     * 
     *  @return         :   void        
     * 
     **/
     public PageReference validateAccountInsert() {
        
        try {
            
            //Set the boolean variable false to show for successs message 
            message = false;
            
            //Get Account record type
            RecordType rType = [Select Id, Name From RecordType Where SObjectType =: 'Account' AND DeveloperName =: 'Non_Investee_Accounts' LIMIT 1];
            
            //Set default record type for account
            account.RecordTypeId = rType.Id;
            
            //Set account owner
            account.OwnerId = contact.OwnerId;
            
            //Get Account Owner
            accOwner = [Select Id ,Name From User Where Id =: account.OwnerId LIMIT 1].Name;
            
            //Upsert account
            upsert account;
            
            //Account Properties
            accountName = account.Name;
            accountId = account.Id;
            contact.AccountId = accountId;
            
            //String
            Step = '3';
            
            return page.ContactFormPage;
            
        }catch (Exception e) {
            
            //Set the step value in  page    
            step='2';
            
            message = false;
            
            //to show error
            error= 'Potential duplicates found. You can update existing Account using "Override All/Override Blank/Merge" functionality. Please click on help link to get more information about each action in detail.';
             
            //String to hold the error
            String str = e.getMessage();
            
            //String to get the id of dupliacte record
            List<String> dupes = str.split('href="/');
            
            //Contact Ids
            Set<String> accountIds = new Set<String>();
            
            //Populate contact set
            for(String aId : dupes)
                accountIds.add(aId.left(18));
            
            //String to get the id of dupliacte record
            //accId = str.subString(str.indexOf('href=')+7, str.indexOf('href=') +25);
            
            //Call the method
            mapAccounts = getMapAccounts(accountIds);
            
            return null;
            
        }
    }
 
    
    /**
     *  @description    :   This method is to check 
                                1. If there is any  existing contact with the same information as entered on UI
                                2. If nothing exists already, insert directly
     * 
     *  @args           :   
     * 
     *  @return         :   void        
     * 
     **/
    public PageReference validateContactInsert() {
        
        try {
             
            message = false;
            contact.AccountId = contact.AccountId;
                    
            //Get Contact record type
            RecordType rType = [Select Id, Name From RecordType Where SObjectType =: 'Contact' AND DeveloperName =: 'General' LIMIT 1];
            
            //Set default record type for contact
            contact.RecordTypeId = rType.Id;
            
            //upsert contact
            upsert contact;
           
            //pageRefence to redirect the page
            PageReference accountPage = new PageReference('/apex/AccountWithContactFormPage');
            
            //redirect the page
            accountPage.setRedirect(false);
            
            message = true;
            
            init();
            
            return accountPage; 
            
        } catch(Exception e) {
            
            //Set the step value in  page
            step='4';
            
            //String to hold the error
            error= 'Potential duplicates found. You can update existing Contact using "Override All/Override Blank/Merge" functionality. Please click on help link to get more information about each action in detail.'; 
            
            //String to hold the error
            String str = e.getMessage();  
            
            //String to get the id of dupliacte record
            System.debug('str:::::' + str);
            List<String> dupes = str.split('href="/');
            
            //Contact Ids
            Set<String> contactIds = new Set<String>();
            
            //Populate contact set
            for(String cId : dupes)
                contactIds.add(cId.left(18));
            
            //Call the method
            mapContacts = getMapContacts(contactIds);
            
            return null;    
        }
    }
    
    /**
     *  @description    :   This method is to insert/update data in database when duplicates were found
     * 
     *  @args           :   
     * 
     *  @return         :   void
     * 
     **/
    public PageReference manualAccountSubmit() {
        //List to hold dupblocker scenario records
        List<CRMfusionDBR101__Scenario__c> dupeBlockerScenarios = [Select Id ,CRMfusionDBR101__Deployed__c from CRMfusionDBR101__Scenario__c 
                                                              Where CRMfusionDBR101__Deployed__c = true AND CRMfusionDBR101__Scenario_Type__c = 'Account']; 
             
              
            //Loop through dupblocker scenario records
            for(CRMfusionDBR101__Scenario__c dupeBlockerScenario : dupeBlockerScenarios) {
             
                //Set deployed status to false
                dupeBlockerScenario.CRMfusionDBR101__Deployed__c = false;                                   
            }
            
         //Update Scenarios 
         update dupeBlockerScenarios;
          
        //Validate user action
        updateRecordAccountInstance();
        
        //Save data
        validateAccountInsert();
        
        //Loop through dupblocker scenario records
        for(CRMfusionDBR101__Scenario__c dupeBlockerScenario : dupeBlockerScenarios) {
         
            //Set deployed status to false
            dupeBlockerScenario.CRMfusionDBR101__Deployed__c = true;                                    
        }
        
        //Update Scenarios 
        update dupeBlockerScenarios;
        
        //String to hold the stpe no.
        Step = '3';
        message = false;
        
        return page.ContactFormPage; 
       
    }
      /**
     *  @description    :   This method is to insert/update data in database when duplicates were found
     * 
     *  @args           :   
     * 
     *  @return         :   void
     * 
     **/
    public PageReference manualContactSubmit() {
        
        //List to hold dupblocker scenario records
        List<CRMfusionDBR101__Scenario__c> dupeBlockerScenarios = [Select Id ,CRMfusionDBR101__Deployed__c from CRMfusionDBR101__Scenario__c 
                                                          Where CRMfusionDBR101__Deployed__c = true AND CRMfusionDBR101__Scenario_Type__c = 'Contact']; 
         
        //Loop through dupblocker scenario records
        for(CRMfusionDBR101__Scenario__c dupeBlockerScenario : dupeBlockerScenarios) {
         
            //Set deployed status to false
            dupeBlockerScenario.CRMfusionDBR101__Deployed__c = false;                                   
        }
        
        //Update Scenarios 
        update dupeBlockerScenarios;

        //Validate user action
        updateRecordContactInstance();
         
        //Save data
        validateContactInsert();
        
        //Loop through dupblocker scenario records
        for(CRMfusionDBR101__Scenario__c dupeBlockerScenario : dupeBlockerScenarios) {
         
            //Set deployed status to false
            dupeBlockerScenario.CRMfusionDBR101__Deployed__c = true;                                    
        }
        
        //Update Scenarios 
        update dupeBlockerScenarios;

        //To redirect the page
        PageReference accountPage= new PageReference('/apex/AccountWithContactFormPage');
        
        accountPage.setRedirect(false);
        
        init();
        return accountPage;
         
    }
    /**
     *  @description    :   This method is to search the exisitng accounts
     * 
     *  @args           :   String
     * 
     *  @return         :   Map of accounts
     * 
     **/     
    private Map<Id, Account> getMapAccounts(Set<String> accountIds) {
        
        //Account Map
        Map<Id, Account> mapPDAccounts = new Map<Id, Account>();
        duplicateAccounts = false;
        
        //Account Query
        String SOQLQuery = 'Select Site';
        
        //fetch fields from fieldset to support the dynamic behaviour
        for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.Business_Card.getFields())
            SOQLQuery += ', ' + f.getFieldPath();
        SOQLQuery += ' FROM Account Where Id IN: accountIds ORDER BY Id';
            
            //Populate the values in map
            mapPDAccounts = new Map<Id, Account>((List<Account>)database.query(SOQLQuery));
            
            if(mapPDAccounts.size() > 0)
                duplicateAccounts = true;
        
        return mapPDAccounts;
    }
    
    /**
     *  @description    :   This method is to search the exisitng contacts
     * 
     *  @args           :   String
     * 
     *  @return         :   Map of accounts
     * 
     **/
   private Map<Id, Contact> getMapContacts(Set<String> contactIds) {
        
        //Contact Map
        Map<Id, Contact> mapPDContacts = new Map<Id, Contact>();
        duplicateContacts = false;
        
        //Contact Query
        String SOQLQuery = 'Select Fax';
        
        //fetch fields from fieldset to support the dynamic behaviour
        for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.Business_Card.getFields())
            SOQLQuery += ', ' + f.getFieldPath();
        SOQLQuery += ' FROM Contact Where Id IN: contactIds ORDER BY Id';
        
        mapPDContacts = new Map<Id, Contact>((List<Contact>)database.query(SOQLQuery));
            if(mapPDContacts.size() > 0)
                duplicateContacts = true;
        
        return mapPDContacts; 
    }
    /**
     *  @description    :   This method is to update the account instance based on the selected action
     *
     *  @args           :
     *
     *  @return         :   Void
     *
     **/
    private void updateRecordAccountInstance() {
        
        //Check if account record was selected
        if(selectedAccountId != null && !String.IsBlank(accountActionType)) {
            
            //Update the main instance with the user selection
            Account selectedAccount = mapAccounts.get(selectedAccountId);
            
            //override all the existing information if Override All is selected
            if(accountActionType == 'oAll') {
                
                //Override all
                account.Id = selectedAccount.Id;
            } else if(accountActionType == 'oBlank') {
                
                //Override blank
                if(String.IsBlank(selectedAccount.Website))
                    selectedAccount.Website = account.Website;
                    
                //Update account instance
                account = selectedAccount;
            }
            
        }
    
        //Check for account action type
        if(accountActionType == 'unCheck') {
            System.debug('########## : ');    
            //Clone account record
            account = account.clone(false); 
            
            System.debug('########## : ');
        }
    }
    /**
     *  @description    :   This method is to update the contact instance based on the selected action
     *
     *  @args           :
     *
     *  @return         :   Void
     *
     **/
    private void updateRecordContactInstance() {
    
        //Check for contact action type
        if(contactActionType == 'unCheck') {
            
            //Clone contact record
            contact = contact.clone(false);
        }
        
        //Check if Contact record was selected
        if(selectedContactId != null && !String.IsBlank(contactActionType)) {
            
            System.debug('selectedContactId :::::'+selectedContactId);
                
            if(mapContacts.containsKey(selectedContactId)) {
                
                System.debug('This one is inner part of condtion');
                //Update the main instance with the user selection
                Contact selectedContact = mapContacts.get(selectedContactId);
                
                //override all the existing information if Override All is selected
                if(contactActionType == 'oAll') {
                    
                    //Override all
                    contact.Id = selectedContact.Id;
                } else if(contactActionType == 'oBlank') {
                    
                    //Override blank information
                    if(String.IsBlank(selectedContact.FirstName))
                        selectedContact.FirstName = contact.FirstName;
                    if(String.IsBlank(selectedContact.Title))
                        selectedContact.Title = contact.Title;
                    if(String.IsBlank(selectedContact.Academic_TItle__c))
                        selectedContact.Academic_TItle__c = contact.Academic_TItle__c;
                    if(String.IsBlank(selectedContact.Business_Phone__c))
                        selectedContact.Business_Phone__c = contact.Business_Phone__c;
                    if(String.IsBlank(selectedContact.MobilePhone))
                        selectedContact.MobilePhone = contact.MobilePhone;
                    if(String.IsBlank(selectedContact.OtherPhone))
                        selectedContact.OtherPhone = contact.OtherPhone;
                    if(String.IsBlank(selectedContact.Gender__c))
                        selectedContact.Gender__c = contact.Gender__c;
                    if(String.IsBlank(selectedContact.Skype__c))
                        selectedContact.Skype__c = contact.Skype__c;
                    if(String.IsBlank(selectedContact.MailingStreet))
                        selectedContact.MailingStreet = contact.MailingStreet;
                    if(String.IsBlank(selectedContact.MailingCity))
                        selectedContact.MailingCity = contact.MailingCity;
                    if(String.IsBlank(selectedContact.MailingCountry))
                        selectedContact.MailingCountry = contact.MailingCountry;
                    if(String.IsBlank(selectedContact.Mailingpostalcode))
                        selectedContact.Mailingpostalcode = contact.Mailingpostalcode;
                    if(String.IsBlank(selectedContact.Note__c))
                        selectedContact.Note__c = contact.Note__c;
                        
                    //Update account instance
                    contact = selectedContact;
                }
            } 
        }       
    }   
}