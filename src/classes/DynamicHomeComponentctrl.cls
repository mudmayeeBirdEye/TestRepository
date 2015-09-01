/**************************************************************************************************
 * Project Name................: Dynamic Component for Partner Portal                             *
 * Class Name .................: DynamicHomeComponentctrl                                         *
 * Created by..................: Simplion Technologies                                            *
 * Last Modified by............: Simplion Technologies                                            *
 * Last Modified Date..........: 19-09-2014                                                       *
 * Description.................: This is VF page for the Partner Portal Home Component            *
 **************************************************************************************************/
public class DynamicHomeComponentctrl {
    /******************** Declare Property *******************/
    public String announcementContent {get;set;}
    public String partnerHomeImageContent {get;set;}
    public Integer rowCount {get;set;}
    public Integer colCount {get;set;}   
    Blob csvbody;
    
    /***************** Constructor ******************/
    public DynamicHomeComponentctrl() {
        List<String> nameIN = new List<String>();
        nameIN.add('PartnerPortalAnnouncement');
        nameIN.add('PartnerPortalHomeCmp');
        nameIN.add('PartnerPortalEventsCSV');
        List<Document> docList = [Select body, Name, bodyLength, ContentType, Url from Document where Name IN :nameIN];                  
        if(docList != null && docList.size()>0){
            for(Document doc : docList){
                if('PartnerPortalEventsCSV'.equalsIgnoreCase(doc.Name)){
                    Blob b = doc.body;          
                    csvbody = b;
                    getResults();
                }else if('PartnerPortalAnnouncement'.equalsIgnoreCase(doc.Name)){
                   announcementContent = doc.body.toString();
                }else if('PartnerPortalHomeCmp'.equalsIgnoreCase(doc.Name)){
                    partnerHomeImageContent = doc.body.toString();
                    system.debug('partnerHomeImageContent'+partnerHomeImageContent);
                }
                
            }   
        }                   
    }
    
     //Method for displaying th Result of CSV Table on Vf page 
    public List<CSVWrapper> getResults() 
    {
        List<CSVWrapper> csvResult = new List<CSVWrapper>();
        List<List<String>> parsedCSV = new List<List<String>>();
        if (csvbody != null){       
            String fileString = csvbody.toString();
            parsedCSV = parseCSV(fileString, False);                                            
        }
        parsedCSV.remove(0);
        for(List<String> lstString : parsedCSV){
        	String eventday = String.isNotBlank(lstString.get(0)) ? lstString.get(0).replaceAll('"','') : '';
        	String eventdate = String.isNotBlank(lstString.get(1)) ? lstString.get(1).replaceAll('"','') : '';
        	String eventtime = String.isNotBlank(lstString.get(2)) ? lstString.get(2).replaceAll('"','') : '';
        	String location = String.isNotBlank(lstString.get(3)) ? lstString.get(3).replaceAll('"','') : '';
        	String webinarevent = String.isNotBlank(lstString.get(4)) ? lstString.get(4).replaceAll('"','') : '';
        	String webinarUrl = String.isNotBlank(lstString.get(5)) ? lstString.get(5).replaceAll('"','') : '';
            csvResult.add(new CSVWrapper(eventday, eventdate, eventtime, location, webinarevent,webinarUrl));
        }
        return csvResult;
    }
    
        //wrapper class  to display Hyperlinks on URL in CSV Table.
        public class CSVWrapper{
            public String eventDay {get;set;}
            public String eventDate {get;set;}
            public String eventTime {get;set;}
            public String eventLocation {get;set;}
            public String webinar {get;set;}
            public String eventUrl {get;set;}
            
            public CSVWrapper(String eventDay, String eventDate, String eventTime, String eventLocation, String webinar,String eventUrl){
                this.eventDay = eventDay;
                this.eventDate = eventDate;
                this.eventTime = eventTime;
                this.eventLocation = eventLocation;
                this.webinar = webinar;
                this.eventUrl= eventUrl;
               
            }
        }
    
        //To parse the CSV file to display 
        public static List<List<String>> parseCSV(String contents,Boolean skipHeaders){
            List<List<String>> allFields = new List<List<String>>();
           contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            contents = contents.replaceAll('""','DBLQT');
            List<String> lines = new List<String>();
            try 
            {
              lines = contents.split('\r'); // using carriage return accomodates windows, unix, and mac files
            }
            catch (System.ListException e) 
            {
                System.debug('Limits exceeded?' + e.getMessage());
            }
            Integer num = 0;
            for(String line: lines) 
            {
               if (line.replaceAll(',','').trim().length() == 0) break;
                List<String> fields = line.split(',');  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field: fields) 
                {
                    if (field.startsWith('"') && field.endsWith('"')) 
                    {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                    }
                    else if (field.startsWith('"')) 
                    {
                        makeCompositeField = true;
                        compositeField = field;
                    }
                    else if (field.endsWith('"')) 
                    {
                        compositeField += ',' + field;
                        cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                        makeCompositeField = false;
                    }
                    else if (makeCompositeField) 
                    {
                        compositeField +=  ',' + field;
                    }
                    else
                    {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                    }
                }
                
                allFields.add(cleanFields);
            }
            if (skipHeaders) allFields.remove(0);
            return allFields;       
         }
}