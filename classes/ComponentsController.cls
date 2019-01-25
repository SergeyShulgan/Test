public with sharing class ComponentsController {

    public void B() {

    }

    public Id AccountId { get; set; }

    public Contact getCurrentAccount(){
        return [SELECT Id,
                Account.Id ,
                Account.Name,
                Account.AccountNumber,
                Account.BillingAddress,
                Account.Phone,
                Account.Type,
                Account.BillingCountry,
                Account.BillingCity,
                Account.BillingStreet

                FROM Contact WHERE Id =: AccountId LIMIT 1
        ];
    }

}