public  class XmlParser
{
    //xml string
    public String xmlstring{get;set;}
   
    //display xml string
    public String outxmlstring{get;set;}
   
    //rootelement
    public String rootElement{get;set;}
   
    //
    public String filename{get;set;}
   
    public blob body{get;set;}
      
    //constructor
    public XmlParser()
    {
    
    }
   
    
//Parsing xml what you entered in the left text area
    public pagereference Parsexml()
    {
       DOM.Document xmlDOC = new DOM.Document();
       xmlDOC.load(xmlstring);
       DOM.XMLNode rootElement = xmlDOC.getRootElement();
       outxmlstring=String.valueof(xmlDOC.getRootElement().getName());
       for(DOM.XMLNode xmlnodeobj:xmlDOC.getRootElement().getChildElements())
       //.getChildren())
       {        
         
         
          loadChilds(xmlnodeobj);         
       }      
       return null;
    }
   
    //loading the child elements
    public void loadChilds(DOM.XMLNode xmlnode)
    {
        for(Dom.XMLNode child : xmlnode.getChildElements())
        {
          if(child.getText()!= null)
          {
          outxmlstring+='\n'+child.getName()+': '+child.getText();
       
          }
          loadChilds(child);       
        }
    }
   
   
//This is for parsing xml file what you selected
  public pagereference Parsexmlfile()
  {
       DOM.Document xmlDOC = new DOM.Document();
       xmlstring=body.tostring();         
       xmlDOC.load(xmlstring);
       DOM.XMLNode rootElement = xmlDOC.getRootElement();
       outxmlstring=String.valueof(xmlDOC.getRootElement().getName());//gives you root element Name
       for(DOM.XMLNode xmlnodeobj:xmlDOC.getRootElement().getChildElements())
       {        
                  
          loadChilds(xmlnodeobj); 
       }      
      return null;
    }
}