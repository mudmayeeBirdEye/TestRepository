public class MultiSheetExcelController {
    public string xmlheader {get;set;}
    public DataModel dModel {get;set;}
    public string endfile{get;set;}
    public MultiSheetExcelController(){
        //VF page gives some issues directly using the below code there, so wrap up in variable
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        //Dont know why i did this :) , But xml was not generating without it.
        endfile = '</Workbook>';
    }
    
 /* Test Method*/   
    
    
   /* public static testmethod void testMSE(){
    	MultiSheetExcelController mse = new MultiSheetExcelController();
    	mse.dModel  = new DataModel();
   		mse.endfile ='none';
   		mse.xmlheader ='xml';
    }*/
    
}