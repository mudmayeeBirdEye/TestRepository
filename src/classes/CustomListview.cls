public class CustomListview
{
    private ApexPages.StandardSetController ssc;

    public CustomListview()
    {
        list<Account> accList = [SELECT Name FROM Account];

        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accList);
        ssc.setFilterID('00BV0000000uMFn');
    }

    public list<Account> getAccounts() 
    {
        return (list<Account>)ssc.getRecords();
    }
}