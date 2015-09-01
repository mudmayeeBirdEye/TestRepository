jQuery(document).ready(function($) {
//	function() {
	try {
		var Browser = function() {
			var version = 999; // we assume a sane browser
			if(navigator.appVersion.indexOf("MSIE") != -1) {
				// bah, IE again, lets downgrade version number
				version = parseFloat(navigator.appVersion.split("MSIE")[1]);
			}
			return version;
		};
        
		var sendToIframe = function(tmp) {
			var M$ = navigator.appName.indexOf("Microsoft") != -1
			var name = "setter";
			if(M$) {
				if(Browser() >= 9) {
					var func = document[name];
				}
				else {
					var func = (M$ ? window : document)[name];
				}
			}
			else {
				var func = document[name];
			}
            if(typeof func.length == "undefined") {
    			if(typeof func.sendReqFromJS == "undefined") {
    				alert("Please enable Flash");
    			}
    			else {
    				func.sendReqFromJS(tmp);
    			}
            } else {
                var steps = 0;
                for (var i = 0; i < func.length; ++i) {
                    if (typeof func[i].sendReqFromJS != "undefined") {
                        steps += 1;
                        func[i].sendReqFromJS(tmp);
                    }
                }
                if(steps == 0) {
                    alert("Please enable Flash");
                }
            }
		}; 
        
        
        
        
        
        function grepNodes(searchText){
            var matchedNodes = [];
            var regXSearch = [];
            if (typeof searchText == "string") {
                regXSearch.push(searchText);
            }
            else {
                regXSearch = searchText;
            }
            regXSearch = regXSearch.join(" ");
            /*if (typeof searchText === "string") {
                regXSearch = new RegExp(searchText, "g");
            }
            else {
                regXSearch = searchText;
            }*/
            var currentNode = null, matches = null;
            /*if (frameId && !window.frames[frameId]) {
                return null;
            }*/
            var theDoc = document;
            var allNodes = (theDoc.all) ? theDoc.all : theDoc.getElementsByTagName('*');
            
            for (var nodeIdx = 0; nodeIdx < allNodes.length; nodeIdx++) {
                currentNode = allNodes[nodeIdx];
                if (!currentNode.nodeName || currentNode.nodeName === undefined) {
                    break;
                }
                if (("html|script|head|meta|link|object".indexOf(currentNode.nodeName.toLowerCase()) == -1) ) {
                //if (!(currentNode.nodeName.toLowerCase().match(/html|script|head|meta|link|object/)) ) {
                    if(currentNode.innerText != undefined) {
                        //matches = currentNode.innerText.replace(/[^\d* ()]/g, "").match(/^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})( *(x|ext|\*)\d{1,5}){0,1}$/);
                        matches = 0;
                        var text = currentNode.innerText.replace(/[\s]/g, "");
                        if(text != "") {
                            matches += (regXSearch.indexOf(currentNode.innerText.replace(/[\d]/g, "x")) != -1);
                        }
                    } else {
                        matches = 0;
                        var text = currentNode.textContent.replace(/[\s]/g, "");
                        if (text != "") {
                            matches += (regXSearch.indexOf(currentNode.textContent.replace(/[\d]/g, "x")) != -1);
                        }
                    }
                    var totalMatches = 0;
                    if (matches) {
                        var totalChildElements = 0;
                        for (var i = 0; i < currentNode.children.length; i++) {
                            if (("html|script|head|meta|link|object".indexOf(currentNode.children[i].nodeName.toLowerCase()) == -1) ) {
                            //if (!(currentNode.children[i].nodeName.toLowerCase().match(/html|script|head|meta|link|object/))) {
                                totalChildElements++;
                            }
                        }
                        matchedNodes.push({
                            node: currentNode,
                            numMatches: 11,
                            childElementsWithMatch: 0,
                            nodesYetTraversed: totalChildElements
                        });
                    }
                    for (var i = matchedNodes.length - 1; i >= 0; i--) {
                        previousElement = matchedNodes[i - 1];
                        if (!previousElement) {
                            continue;
                        }
                        if (previousElement.nodesYetTraversed !== 0 && previousElement.numMatches !== previousElement.childElementsWithMatch) {
                            previousElement.childElementsWithMatch++;
                            previousElement.nodesYetTraversed--;
                        }
                        else 
                            if (previousElement.nodesYetTraversed !== 0) {
                                previousElement.nodesYetTraversed--;
                            }
                    }
                }
            }
            var processedMatches = [];
            for (var i = 0; i < matchedNodes.length; i++) {
                if (matchedNodes[i].numMatches > matchedNodes[i].childElementsWithMatch) {
                    processedMatches.push(matchedNodes[i].node);
                }
            }
            return processedMatches;
        };
        
		if (window.location.toString().search("Start_Here") == -1) {
            var timer = 0;
            var isWorking = false;
			var checkNumbers = function() {
					var phone2 = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})( *(x|ext|\*)\d{1,5}){0,1}$/;
					var phone = /<div[^>]*>((\+\d{0,3})*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2})</g; 
					var phone3 = />((\+\d{0,3})*\s*(\(\d{3}\)\s*)*\d{3}(-{0,1}|\s{0,1})\d{2}(-{0,1}|\s{0,1})\d{2})/g; 
                    
                    var shablons = ["(xxx)xxx-xxxx", "(xxx) xxx-xxxx", "+xx xxx xxxxxxx", "+xxxxxxxxxxxx", "+x (xxx) xxx-xxxx", "+xx (xxx) xxx-xxxx"];
                    var ext = [];
                    for(var i = 0; i < shablons.length; i++) {
                        ext.push(shablons[i]+" *x");
                        ext.push(shablons[i]+" *xx");
                        ext.push(shablons[i]+" *xxx");
                        ext.push(shablons[i]+" *xxxx");
                    }
                    shablons = shablons.concat(ext);
                    var test = grepNodes(shablons);
                    
                    var insertPhone = function(text, insert){
                        var div = document.createElement("div");
                        div.innerHTML = text.replace(/{{INSERT}}/g, insert);
                        var templateNode = document.createDocumentFragment();
                        while (div.firstChild) {
                            templateNode.appendChild(div.firstChild);
                        }
                        return templateNode;
                    }
                    
                    jQuery(test).each(function(itm) {
                        for(iter in this.childNodes) {
                            var node = this.childNodes[iter];
                            if(node.nodeType == 3) {
                                if (node.data.replace(/[^\d]/g, "").length >= 10 && node.data.match(/[^-() +*\d]/g, "") == null) {
                                    var text = "<span class='ring_to' alt='RingOut' title='RingOut' style='color:green;' value='{{INSERT}}'>\
                                    <img style='border: 0px;' src='/resource/1292328226000/ring__MyPhone'/>\
                                    </span>";
                                    var replacementNode = insertPhone(text, node.data).cloneNode(true);
                                    if (node.parentNode.nodeName == "A") {
                                        node.parentNode.parentNode.appendChild(replacementNode);
                                    }
                                    else {
                                        node.parentNode.appendChild(replacementNode);
                                    }
                                    if (node.data.length > 6) {
                                        var _node = node.splitText(6);
                                        _node.parentNode.insertBefore(insertPhone("<span></span>", ""), _node);
                                    }
                                    node = null;
                                    break;
                                }
                            }
                        }
                        
                        
                    });
                    
                    
					$("#bodyCell").css("visibility", "visible");
                    $("span.ring_to").unbind();
                    $("span.ring_to").css("cursor", "pointer").click(function(){
                        var tmp = $(this).attr('value').toString();
                        tmp = tmp.replace(/[^\d*]*/g, '');
                        setTimeout(function(){
                            sendToIframe(tmp);
                        }, 500);
                    });
                    clearTimeout(timer);
                    isWorking = false;
			};
            $(document).hover(function() {
                if (!isWorking) {
                    isWorking = true;
                    clearTimeout(timer);
                    timer = setTimeout(checkNumbers, 200);
                } 
            }, function() {
                clearTimeout(timer);
                isWorking = false;
            });
            setTimeout(checkNumbers, 100);
		}
	}
	catch(e) {
		alert("Bridge-Error: "+JSON.stringify(e));
	}
});