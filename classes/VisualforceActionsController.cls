public with sharing class VisualforceActionsController {

    public VisualforceActionsController() {
        Displaying1 = true;
        Displaying2 = true;
        Displaying3 = true;
    }

    //Task 1
    public String RetMessageForVF { get; set; }

    public String getMessageTask1() {
        return RetMessageForVF;
    }

    public void task1() {
        RetMessageForVF = ApexPages.currentPage().getParameters().get('message');
    }

    //Task 2
    public String objectName { get; set; }
    public static List<SObject> ListRecordsForSObjects { get; set; }

    @RemoteAction
    public static List<SObject> getSObjectList(String objectName) {
        ListRecordsForSObjects = Database.query(
                'SELECT Id, ' +
                'Name, ' +
                'CreatedDate ' +
                'FROM ' + objectName +
                ' LIMIT 5'
        );
        return ListRecordsForSObjects;  //Add Created Date
    }

    //task 3

    public String ParamString { get; set; }
    public Integer ParamInteger { get; set; }
    public Date ParamDate { get; set; }

    public PageReference PutParam() {
        PageReference page = Page.VisualforceActions;

        page.getParameters().put('PS',ParamString);
        page.getParameters().put('PI',String.valueOf(ParamInteger));
        page.getParameters().put('PD',String.valueOf(ParamDate));
        page.setRedirect(true);
        return page;
    }

    public PageReference page1() {
        PageReference ApexPage = Page.VisualforceActions;
        ApexPage.setRedirect(true);
        return ApexPage;
    }
    public PageReference page2() {
        PageReference ApexPage = Page.ComponentsPage;
        ApexPage.setRedirect(true);
        return ApexPage;
    }
    public PageReference page3() {
        PageReference ApexPage = Page.ComponentsPageComposition;
        ApexPage.getParameters().put('Id','0036F00002u9fsfQAA');
        ApexPage.setRedirect(true);
        return ApexPage;
    }
    public PageReference page4() {
        PageReference ApexPage = new PageReference('https://yandex.by/');
        ApexPage.setRedirect(true);
        return ApexPage;
    }
    public PageReference page5() {
        PageReference ApexPage = new PageReference('http://www.google.com');
        ApexPage.setRedirect(true);
        return ApexPage;
    }
    public PageReference page6() {
        PageReference ApexPage = new PageReference('https://vk.com');
        ApexPage.setRedirect(true);
        return ApexPage;
    }

    //Task 4
    public Boolean Displaying1 { get; set; }
    public Boolean Displaying2 { get; set; }
    public Boolean Displaying3 { get; set; }

    public void ViewTask1() {
        Displaying1 = !Displaying1;
    }
    public void ViewTask2() {
        Displaying2 = !Displaying2;
    }
    public void ViewTask3() {
        Displaying3 = !Displaying3;
    }








}