var needToSuggest;
var currentObj;


function myaddMouseOver(obj)
{
 obj.getElementsByTagName("div")[0].style.display = "block";
 obj.style.width = "100px";
 obj.style.height = "30px";
 
}

function myaddMouseOut(obj)
{

 obj.getElementsByTagName("div")[0].style.display = "none";
 obj.style.width = "auto";
 obj.style.height = "auto";
 
}

/*function manualSearchSelected(item)
 {
 
  document.getElementById("searchArea").style.display = 'block';
  if(document.getElementById("tdBtnRefresh").getElementsByTagName("input").length > 0)
  {
	document.getElementById("tdBtnRefresh").getElementsByTagName("input")[0].disabled = true;
	document.getElementById("tdBtnRefresh").getElementsByTagName("input")[0].className = "btnDisabled";
  }
  document.getElementById("actionSearch").getElementsByTagName("input")[0].disabled = false;
  document.getElementById("actionSearch").getElementsByTagName("input")[0].className="btn";
  
  document.getElementById("actionSearch").getElementsByTagName("a")[0].disabled = false;
  document.getElementById("actionSearch").getElementsByTagName("a")[0].style.display = 'inline';
  document.getElementById("actionSearch").getElementsByTagName("span")[0].style.display = 'none';

  
  isAutoSearch_Comp = false;
  isManualSearch_Comp = true;          
 }
function autoSearchSelected(item)
{
  

  if(document.getElementById("tdBtnRefresh").getElementsByTagName("input").length > 0)
  {
	document.getElementById("tdBtnRefresh").getElementsByTagName("input")[0].disabled = false;
	document.getElementById("tdBtnRefresh").getElementsByTagName("input")[0].className= "btn";
	
  }
  //document.getElementById("searchArea").style.display = 'none';
  document.getElementById("actionSearch").getElementsByTagName("input")[0].disabled = true;
  document.getElementById("actionSearch").getElementsByTagName("input")[0].className="btnDisabled";
  document.getElementById("actionSearch").getElementsByTagName("a")[0].disabled = true;
  document.getElementById("actionSearch").getElementsByTagName("a")[0].style.display = 'none';
  document.getElementById("actionSearch").getElementsByTagName("span")[0].style.display = 'inline';
  
}*/

function showAdvanced(obj)
{
 if(obj.innerHTML == 'Close Advanced Search')
 {
 	obj.innerHTML = 'Advanced Search...';
 	$("tableFilterId").style.display = "none";
 	$("actionSearch").style.display = "none";
 }
 else if(obj.innerHTML == 'Advanced Search...')
 {
 	obj.innerHTML = 'Close Advanced Search';
 	$("tableFilterId").style.display = "block";
 	$("actionSearch").style.display = "block";
 }
 
 SetAdvancedModeSelected();	
}
function doOnLoad(isSuccessLogCreated,selectedObj)
{
   
    suggestManualCreation();
    if(selectedObj == "All" || selectedObj == " " ||selectedObj == "" )
    {
    	$("tableFilterId").style.display = "none";
  		$("advancedOption").style.display = "none";
  		selectValidList("All",false);
    }
    else
    	selectValidList(selectedObj,false);
            
}

function colorRowBg()
{
    if(currentObj!=null)
        currentObj.parentNode.parentNode.style.backgroundColor = "yellow";
}
function setColorRowBg(obj){
    currentObj = obj;
}



function ChangeOptDisabled() 
{
    var element = document.getElementsByTagName("option");
    for ( var i=0 ; i < element.length ; ++i )
    {    
        if (element[i].nodeName=="OPTION" && element[i].disabled) 
        {     
            var option = element[i];    
            var label =  element[i].innerHTML;
            var insertionPoint = element[i].nextSibling; 
            var parent = element[i].parentNode;
            parent.removeChild(option);
            option = document.createElement('optgroup');
            option.setAttribute('label',label);
            option.setAttribute('style','color:graytext;text-align:center;');
            insertionPoint = parent.insertBefore(option,insertionPoint);
        }  
    }   
}

function clearFilters()
{
      
     
      var n = 'TR-Repeat-' + currentObject;
      var items = getElementsByClassName(n);
	  for(var i=0 ; i < items.length ; i++)
	  {
	     $(items[i]).getElementsByTagName('input')[2].value = '';
	     $(items[i]).getElementsByTagName('select')[0].options[0].selected = true;
         $(items[i]).getElementsByTagName('select')[1].options[0].selected = true;
	  }
}

function updateFields(obj)
{
    obj.previousSibling.click();
}
















