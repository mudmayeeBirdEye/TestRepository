@isTest
private class Test_ATTInternationalratesCsvhnadler {
 public static testmethod void MyUnitTest(){

    try{    
        ATTInternationalratesCsvhnadler obj=new ATTInternationalratesCsvhnadler();
        Test.startTest();
        obj.strSingleWord='A';
        obj.getCountryWiseDetail();
        
        obj.strSelectedCountry='A';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='India';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='A';
        obj.getCountryWiseDetail();
          obj.strSingleWord='';
        obj.getCountryWiseDetail();
        
       // TypeCodeAndPrice obj1=new TypeCodeAndPrice();
        
        obj.getCSVBODY();
        Test.stopTest();
    }catch(Exception e){}
    
}

}