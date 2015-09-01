public with sharing class CSForce_SearchController {

  public List <CustomerStory__c> CSStories          {get; set;}
  public CustomerStory__c csSearch                  {get; set;}
  public List <CSForce_SearchHelper> csHelperList   {get; set;}
  public String tSearch                             {get; set;}
  public list <Selectoption>  productsSelect        {get; set;}
  public String productSelected                     {get; set;}
  public list <Selectoption>  competitorsSelect     {get; set;}
  public String competitorSelected                  {get; set;}
  public String  listLink                           {get; set;}
  
  
  //setup in constructor. Used if 'All' is selected
  private String allProducts;
  private String allCompetitors;
  
  //search values
  private String storyType;
  private String title;
  private String salesRef;
  private String sharingRes;
  private String product;
  private String competitor;
  
  public CSForce_SearchController(){
  	setupListLink();
  	csSearch = new CustomerStory__c();
    setProductsFieldInfo();
    setCompetitorsFieldInfo();
  }

  private void setupListlink(){
  	Schema.Describesobjectresult r = CustomerStory__c.sObjectType.getDescribe();
  	String keyPref = r.getKeyPrefix();
  	listLink = '/'+keyPref+'/o';
  }
  
  private void setProductsFieldInfo(){
  	Schema.DescribeFieldResult F = CustomerStory__c.Products__c.getDescribe();
  	list <Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
    
    productsSelect = new list<Selectoption>();
    productsSelect.add(new Selectoption('All', 'All'));
  	allProducts = '';
  	
  	for (Schema.Picklistentry ple : plSchemaList){
  		productsSelect.add(new Selectoption(ple.getValue(), ple.getValue()));
  		allProducts += ple.getValue()+';';
  	}
  }

  private void setCompetitorsFieldInfo(){
    Schema.DescribeFieldResult F = CustomerStory__c.Win_Against__c.getDescribe();
    list <Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
    
    competitorsSelect = new list<Selectoption>();
    competitorsSelect.add(new Selectoption('All', 'All'));
    allCompetitors = '';
    
    for (Schema.Picklistentry ple : plSchemaList){
      competitorsSelect.add(new Selectoption(ple.getValue(), ple.getValue()));
      allCompetitors += ple.getValue()+';';
    }
  }


 /* static testmethod void testConstructor(){
  	CSForce_testingutil tu = new CSForce_testingutil();
  	tu.addData();
  	CSForce_SearchController sc = new CSForce_SearchController();
  	System.assert(sc.productsSelect != null);
  	System.assert(sc.competitorsSelect != null);
  }*/
  
  
  public void doSearch(){
    setupSearchFields();
    
    if(tSearch != null && tSearch.length()>2)
      soslSearch();
    else
      soqlSearch();
    
    csHelperList = new List<CSForce_SearchHelper>();
    if(CSStories != null){
    	for(CustomerStory__c cs : CSStories){
        csHelperList.add(new CSForce_SearchHelper(cs));
      }
    }
  }
  
  private void soslSearch(){
  	String searchString;
  	searchString = 'Find :tSearch IN ALL Fields ';
  	searchString += 'RETURNING CustomerStory__c ';
  	searchString += '(Name, Id, Synopsis__c, Story_Type__c, Win_Against__c, ';
  	searchString += 'Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, ';
  	searchString += 'callRef__c, sharingR__c ';
  	searchString += ' WHERE '; 
  	searchString += ' Story_Type__c Like :storyType ';
    searchString +=  ' AND Status__c = \'Available\' ';
    searchString +=  ' AND Sales_Reference__c Like :salesRef ';
    searchString +=  ' AND Sharing_Restriction__c Like :sharingRes ';
    if(product != null)
     searchString += ' AND Products__c INCLUDES (:product)';
    if(competitor != null)
     searchString += ' AND Win_Against__c INCLUDES (:competitor) ';
  	searchString += ') limit 150';
  	LIST<LIST<SObject>> soList = search.query(searchString);
    CSStories = soList[0];
  }
  
  private void soqlSearch(){
  	String searchString = 'select Name, Id, Synopsis__c, Story_Type__c, Win_Against__c, ';
  	searchString += 'Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, ';
  	searchString += 'callRef__c, sharingR__c ';
  	searchString += 'from CustomerStory__c ';
  	searchString += 'WHERE ';
  	searchString += 'Story_Type__c Like :storyType ';
    searchString +=  'AND Status__c = \'Available\' ';
    searchString +=  'AND Sales_Reference__c Like :salesRef ';
    searchString +=  'AND Sharing_Restriction__c Like :sharingRes ';
    if(product != null)
     searchString += ' AND Products__c INCLUDES (:product) ';
    if(competitor != null)
     searchString += ' AND Win_Against__c INCLUDES (:competitor) ';
    searchString += ' limit 150';
  	CSStories = Database.query(searchString);
  }
  
  private void setupSearchFields(){
  	if(csSearch.Story_Type__c != null)
  	 storyType = csSearch.Story_Type__c;
  	else
  	 storyType ='%';
  	
  	if(csSearch.Name != null)
  	 title = '%'+csSearch.Name+'%';
  	else 
  	 title ='%';
  	
  	if(csSearch.Sales_Reference__c == null)
  	 salesRef = '%';
  	else
  	 salesRef = csSearch.Sales_Reference__c;
  	 
  	if(csSearch.Sharing_Restriction__c == null)
  	 sharingRes = '%';
  	else sharingRes = csSearch.Sharing_Restriction__c;
  	
  	if(productSelected == 'All')
  		product = null;
    else
      product = productSelected+';';
      
    if(competitorSelected =='All')
      competitor = null;
    else 
      competitor = competitorSelected+';';
  }
   	 
  
  /*static testmethod void testSearch(){
    CSForce_testingutil tu = new CSForce_testingutil();
    tu.addData();
    CSForce_SearchController sc = new CSForce_SearchController();
    sc.productSelected = 'All';
    sc.competitorSelected = 'All';
    sc.doSearch();
    System.assert(sc.csHelperList.size()>0);
    sc.tSearch = 'blah';
    sc.doSearch();  
    System.assert(sc.csHelperList!=null);
    
    sc.productSelected = 'test';
    sc.competitorSelected = 'test';
    sc.csSearch.Products__c = 'test';
    sc.csSearch.Win_Against__c = 'Ralph Wiggum';
    sc.csSearch.Story_Type__c = 'test';
    sc.csSearch.Name = 'test';
    sc.csSearch.Sales_Reference__c = 'blah';
    sc.csSearch.Sharing_Restriction__c = 'blah';    
    sc.tSearch = 'blah';
    sc.doSearch();
    sc.tSearch = '';
    sc.doSearch();
  } */
}