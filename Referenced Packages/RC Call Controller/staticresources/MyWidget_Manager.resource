/*
 * Widget Manager Class   
 */

var Config = {
	root: window.location.protocol+"//"+window.location.host+"/", //"https://na7.salesforce.com/",
	RC_service: "https://service.ringcentral.com/",
	create_contact: window.location.protocol+"//"+window.location.host+"/003/e?retURL=/home/home.jsp",
	create_lead: window.location.protocol+"//"+window.location.host+"/00Q/e?retURL=/home/home.jsp",
	
	html_tags: {svetofor:   ".rc-menu .svetofor",
				dndBtnChild: "#rc-panel .dnd a:first span", 
				dndBtn:     "#rc-panel .dnd a:first"}
};

//--------------------------------
//---------Manager Widget Class constructor
//--------------------------------
var rcWidgetMN = function(widgetCore) {
	//Config vars
	this.data = null;
	this.error = null;
	this.contacts = []; //id,number,name
	this.loginFields = {};
	this.SFDataBaseName = "ring__RingCentral__c";
	this.SFID = null;
	this.callerID = null;
	this.callerIDArr = [];
	this.sipID = null;
	this.mailboxInfo = null;
	this.isAuth = false;
	this.log_off = true;
	this.unsupport = false;
	this.lCall = null;
	this.callFlag = null;
    this.number_href = [];
	
	this.widgetCore = widgetCore;
	//Init Core
	var self = this;
	this.GUI = new rcWidgetUI(self);
	this.widgetCore.parseFunction = function(name, data, error) {self.getFun(name, data, error);};
	
	//this.mp3Tmpl = '<object type="application/x-shockwave-flash" data="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" width="170" height="20"><param name="movie" value="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" /><param name="bgcolor" value="#FFFFFF" /><param name="FlashVars" value="mp3={{FILE}}&showslider=0" /><embed src="/resource/1290525209000/ring__player_mp3_mini" bgcolor="#FFFF" width="170" height="20" name="hidden_mp3_player" quality="high" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash" /></object>';
	//this.hidden_mp3Tmpl = '<object id="hidden_mp3_player" type="application/x-shockwave-flash" data="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" width="0" height="0"><param name="movie" value="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" /><param name="bgcolor" value="#666666" /><param name="FlashVars" value="mp3={{FILE}}&autoplay=1" /></object>';
	
    var haxe = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="165" height="27" id="haxe" align="middle">\
                    <param name="movie" value="/resource/1290189999000/ring__WavPlayer?gui=full&h=20&w=100"/>\
                    <param name="allowScriptAccess" value="always" />\
                    <param name="quality" value="high" />\
                    <param name="scale" value="noscale" />\
                    <param name="salign" value="lt" />\
                    <param name="bgcolor" value="#F3F3F3"/>\
                    <param name="wmode" value="opaque"/>\
                    <embed src="/resource/1290189999000/ring__WavPlayer?gui=full&h=20&w=100" wmode="opaque" bgcolor="#F3F3F3" width="165" height="27" name="haxe" quality="high" align="middle" scale="noscale" allowScriptAccess="always" type="application/x-shockwave-flash" />\
                </object>';
                
    var haxe_mp3 = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="165" height="27" id="haxe_mp3" align="middle">\
                    <param name="movie" value="/resource/1294665344000/ring__MyMP3Player"/>\
                    <param name="allowScriptAccess" value="always" />\
                    <param name="quality" value="high" />\
                    <param name="scale" value="noscale" />\
                    <param name="salign" value="lt" />\
                    <param name="bgcolor" value="#F3F3F3"/>\
                    <param name="wmode" value="opaque"/>\
                    <embed src="/resource/1294665344000/ring__MyMP3Player" wmode="opaque" bgcolor="#F3F3F3" width="165" height="27" name="haxe_mp3" quality="high" align="middle" scale="noscale" allowScriptAccess="always" type="application/x-shockwave-flash" />\
                </object>';
                
    var haxe_pdf = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="100" height="27" id="haxe_pdf" align="middle">\
                    <param name="movie" value="/resource/1291201132000/ring__pdfSaver"/>\
                    <param name="allowScriptAccess" value="always" />\
                    <param name="quality" value="high" />\
                    <param name="scale" value="noscale" />\
                    <param name="salign" value="lt" />\
                    <param name="bgcolor" value="#F3F3F3"/>\
                    <param name="wmode" value="opaque"/>\
                    <embed src="/resource/1291201132000/ring__pdfSaver" wmode="opaque" bgcolor="#F3F3F3" width="100" height="27" name="haxe_pdf" quality="high" align="middle" scale="noscale" allowScriptAccess="always" type="application/x-shockwave-flash" />\
                </object>';
    
	this.message_flag = {
		"wav":{"id":"haxe",     "show_name":".haxe_wav#num1",   "method_name":"sendFromJS",         "stop_name":"sendFromJS",         "src":"/resource/1290189999000/ring__WavPlayer?gui=full&h=20&w=100", "width":165},
		"mp3":{"id":"haxe_mp3", "show_name":".haxe_wav#num2",   "method_name":"sendMP3DataFromJS",  "stop_name":"sendMP3DataFromJS",  "src":"/resource/1294665344000/ring__MyMP3Player",      "width":165},
		"pdf":{"id":"haxe_pdf", "show_name":".haxe_pdf",        "method_name":"sendPDFFromJS",                                        "src":"/resource/1291201132000/ring__pdfSaver",         "width":85},
        "tif":{"id":"haxe_pdf", "show_name":".haxe_pdf",        "method_name":"sendPDFFromJS",                                        "src":"/resource/1291201132000/ring__pdfSaver",         "width":85}
	};
}

//--------------------------------
//------- Tools
//--------------------------------
//Global action timer (empty function)
var GlobalTimer = "";
var GlobalDefaultTimer = "";
var GlobalErrorTimer = "";
var ErrorNumber = 0;

//Error Alert
var relogin = false;
var ErrorHolder = function(error) {
    Manager.widgetCore.ErrorLog(error.code, ErrorNumber++, error.text+"--||--"+error.stack);
	//var silence = true;
	//User friendly Errors
	if(error.code != undefined) {
		switch(error.code) {
			case '109':
				//Do nothing
				break;
			case '007':
				alert("Your account was logged in at different location. You will be logged out");
				break;
			case 'relogin':
                error.text = (typeof error.text == "undefined" || error.text == "") ? "Please, refresh page to continue work with RingCentral Controller": error.text;
                relogin = (relogin == false) ? (alert(error.text), true) : true ;
				//alert(error.text);
				break;
			case '702':
				error.text = "Username or password is incorrect";
            case '027':
			case 'PFRF':
			case 'Call':
			case 'CR_SF':
			//default:
			    //Check if this error is already visible 
                var isIn = false;
                jQuery(".message-alert").each(function() {
                    if(jQuery(this).hasClass(error.code))  {
                        isIn = true;
                    }
                });
                if (!isIn) {
                    //message-alert
                    jQuery("#Logout").parent().after("<span class='message-alert " + error.code + "' style='color:red' >" + error.text + "<br/></span>");
                    clearTimeout(GlobalErrorTimer);
                    GlobalErrorTimer = setTimeout(function(){
                        jQuery(".message-alert").each(function(){
                            jQuery(this).animate({
                                opacity: .0
                            }, 5000, "linear", function(){
                                jQuery(this).slideUp("slow", function(){
                                    jQuery(this).remove();
                                });
                            });
                        });
                    }, 5000);
                }
				break;
		}
	}
}
//Save option to cookie
var CheckBox = function(flag, name, value) {
	if(jQuery.cookie("widget_options") == null) {
		jQuery.cookie("widget_options", JSON.stringify({options:{}}), { path: '/' , expires: 365*100});
	}
	if(flag == "save") {
		var option = JSON.parse(jQuery.cookie("widget_options"));
		option[name] = value;
		jQuery.cookie("widget_options", JSON.stringify(option), { path: '/' , expires: 365*100});
		return true;
	}
	else if(flag == "get") {
		var option = JSON.parse(jQuery.cookie("widget_options"));
		return (typeof option[name] != "undefined") ? option[name] : null;
	}
	else if(flag == "getAll") {
		return JSON.parse(jQuery.cookie("widget_options"));
	}
}

//--------------------------------
//------- Common Widget Class methods
//--------------------------------
rcWidgetMN.prototype = {
	getFun: function(name, data, error) {
		if(this.checkFun(name)) {  //Check is function exist
			this.data = data;
			this.error = error;
			if(this.error.code == undefined) {
				this[name]();
			}
			else {
				if(this[name+"_error"] == undefined) {
					this.common_error();
				}
				else {
					this[name+"_error"]();
				}
			}
		} 
	},
	checkFun: function(name) {
		if(this[name] == undefined) { //Check is function exist
			throw("Function {"+name+"} is not yet implemented");
		} 
		return true;
	},
	common_error: function() {
		ErrorHolder(this.error);
	},
	//--------------------------------
	//-------- Common functions
	init: function() {
        this.log("init");
		var self = this;
		self.GUI.init();
        self.GUI.saveButtonAction(); //Save button
        //Clear redirect cookie
        var clearCookie = function() {
            if ((self.callFlag == undefined || self.callFlag != "call") &&  jQuery.cookie('reloaded') != null) {
                jQuery.cookie('reloaded', null);
            } else {
                setTimeout(clearCookie, 5000);
            }
        };
        setTimeout(clearCookie, 10000);
        //Gear button
        jQuery(".settings a").unbind();
        jQuery(".settings a").bind("click", function(event){
            if (jQuery.cookie('sfwssessionid') != null) {
                self.GUI.dndButton(false);
            } else {
                return false;
            }
            self.GUI.flashDisabler();
            if (jQuery("#rc-panel .stattus").is(":hidden") && jQuery("#rc-panel .mainn").is(":hidden") && (self.callFlag == undefined || self.callFlag != "call")) {
                if (jQuery("#rc-panel .noactivecalls").is(":hidden")) {
                    if (jQuery.cookie('sfwssessionid') != null) {
                        jQuery("#Logout").parent().css({
                            "display": "none"
                        });
                        self.GUI.showMessages();
                        //Save settings
                        self.updateSFAccount();
                    }
                }
                else {
                    self.GUI.showAccinfo();
                    if (jQuery("#rc-panel .accinfo").is(":visible") && jQuery("#rc-panel .accinfo .slide:first").is(":hidden")) {
                        jQuery("#Logout").parent().css({
                            "display": "block"
                        });
                    }
                }
                jQuery("#rc-panel").click();
            }
            return false;
        }); 
        this.log("init");
	},
	//--------------------------------
	//-------- Callback functions
	isAutorized: function() {
        this.log("isAutorized");
		if(!this.isAuth && this.GUI.checkFlash()) {
			if(jQuery.cookie('sfwssessionid')!=null) {
				this.isAuth = true;
				this.GUI.hideSlide(1);
				this.GUI.showMessages();
                
                this.loginFields.ringnum = (typeof this.data.number != "undefined") ? this.data.number : "";
				
				this.widgetCore.getList();
				this.widgetCore.getAccount();
				this.GUI.parsePhoneNumbers();
				GTimerFunc();   //Init Global action timer
			
				var self = this;
                var query = "SELECT Id, ring__Settings__c FROM "+self.SFDataBaseName+" WHERE ring__SessionID__c = '"+jQuery.cookie('sfwssessionid')+"'";
    		    sforce.connection.query(query, self.emptyRespons(self.parseSFLogin, "isAutorized: " + query));
			}
		}
		else {
			this.GUI.shadowVisibility(false);
		}
        this.log("isAutorized END");
	},
	isAutorized_error: function() {
        this.log("isAutorized_error");
        if(!this.GUI.checkFlash()) {
            this.log("isAutorized_error");
            return;
        }
		this.GUI.showButtonSave();
        
		this.isAuth = false;
		if(jQuery.cookie('sfwssessionid')!=null && this.error.code != "007") {
			var self = this;
			var query = "SELECT Id, ring__SessionID__c, ring__Extension__c, ring__Password__c, ring__Settings__c, Name FROM "+self.SFDataBaseName+" WHERE ring__SessionID__c = '"+jQuery.cookie('sfwssessionid')+"'";
			sforce.connection.query(query, self.emptyRespons(self.parseSFLogin, "isAutorized_error: " + query));
		}
		else {
			this.GUI.notLogged();
		}
        this.log("isAutorized_error");
		return;
	},
	ErrorLog: function() {
		return;
	},
	ErrorLog_error: function() {
		return;
	},
	subscriberLogin: function () {
        this.log("subscriberLogin");
		
        this.GUI.hideSlide(1);     
		this.GUI.showMessages();
		jQuery(".stop").hide();
		
		//Check UserId in SF DB
		if(jQuery.cookie('sfwssessionid')!=null) {
            var self = this;
            var query = "SELECT Id, ring__SessionID__c, ring__Extension__c, ring__Password__c, ring__Settings__c, Name FROM "+self.SFDataBaseName+" WHERE Name = '"+self.loginFields.ringnum+"'";
    		sforce.connection.query(query, self.emptyRespons(self.updateSFLogin, "subscriberLogin: " + query));
		}
		this.log_off = true;
        
		this.GUI.logoutButtonAction();
		
		this.widgetCore.getList(); 
		this.widgetCore.getAccount();
		this.GUI.parsePhoneNumbers();
		
        this.log("subscriberLogin");
		return this;
	},
	subscriberLogin_error: function() {
		this.GUI.notLogged();
		ErrorHolder(this.error); //Global error holder
	},
    GetMessagesList : function() {
        this.log("GetMessagesList");
        
        jQuery(".status-bgr .calls").html("");   //jQuery(".active-calls tbody")
        var self = this;
        self.contacts = new Array();
        
        var size = this.data['return'].MESSAGESLISTHDR.MsgNumber.content;  
        
        var tmpResult = [];
        if(this.data['return'].MESSAGEHDR == undefined) {
            this.data['return'].MESSAGEHDR = [];
        } else if(size == 1) {
            this.data['return'].MESSAGEHDR = [this.data['return'].MESSAGEHDR];
        }
        
        self.listHolder = [];
        
        var func = function(self, arr, start, stop){
            for (var i = start; i < stop; ++i) {
                var element = arr[i];
                if (element != null) {
                    tmpResult = {
                        addr: {
                            'content': (function(){
                                var tmp = (element.FromPhone != undefined && element.FromPhone.content != undefined) ? element.FromPhone.content.replace(/[\D]*/g, "") : undefined;
                                return (tmp != undefined && tmp[0] == "1") ? tmp.slice(1) : tmp;
                            })()
                        },
                        dateTime: (function(){
                            var tmp = element.CreateDate.content.split(",");
                            jQuery.each(tmp, function(ind, elem){
                                tmp[ind] = (tmp[ind].length == 1) ? "0" + tmp[ind] : tmp[ind];
                            });
                            return {
                                'content': tmp[0] + "-" + tmp[1] + "-" + tmp[2] + "T" + (tmp[3]) + ":" + tmp[4] + ":GMT"
                            };
                        })(),
                        fileExtension: element.FileExt,
                        messageId: element.MsgID,
                        name: (element.FromName.content != undefined) ? element.FromName : undefined,
                        priority: (element.Urgent.content == 0) ? {
                            'content': "Normal"
                        } : {
                            'content': "Urgent"
                        },
                        size: element.Duration,
                        type: (element.MsgType.content == 1) ? {
                            'content': "messageVoice"
                        } : element.MsgType,
                        unread: (element.Status.content == 1) ? {
                            'content': "false"
                        } : {
                            'content': "true"
                        }
                    };
                    
                
                element = tmpResult;
                //Check for deleted message
                if (element != null) {
                    var type = 'call';
                    var size_type = ' sec';
                    var size = parseInt(parseInt(element.size.content) / 60) + ":" + ("0"+parseInt(element.size.content)%60).slice(-2);
                    if (element.type.content != "messageVoice") {
                        type = 'fax';
                        size = element.size.content + ' pp';
                    }
                    var date = element.dateTime.content.match(/^[\d]{2}([\d]{2})\-([\d]{2})\-([\d]{2})T([\d]{2}):([\d]{2})/).slice(1); //1:20pm
                    var GMT = (element.dateTime.content.search(/GMT/) != -1);
                    var fileExt = (typeof element.fileExtension != "undefined") ? element.fileExtension.content : "wav";
                    //Save contacts in inner array
                    var contact = {
                        "ID": element.messageId.content,
                        "Name": null,
                        "Ext": fileExt,
                        "Type": element.type.content,
                        "Number": null,
                        "Unread": element.unread.content
                    };
                    if (typeof element.addr != "undefined" && element.addr.content && element.addr.content != undefined) {
                        var name_number = element.addr.content.match(/([\d]{3})([\d]{3})([\d]{4})$/);
                        if (name_number != null && name_number != undefined && name_number.length == 4) {
                            contact["Name"] = (element.name != undefined) ? element.name.content : "(" + name_number[1] + ") " + name_number[2] + "-" + name_number[3];
                        }
                        else {
                            contact["Name"] = (element.name != undefined) ? element.name.content : (element.addr.content);
                        }
                        contact["Number"] = (element.addr.content != undefined) ? element.addr.content : "Unknown";
                    }
                    else {
                        contact["Name"] = (element.name != undefined) ? element.name.content : "Unknown";
                    }
                    self.contacts.push(contact);
                    
                    if (element.unread.content == "false") {
                        jQuery(".status-bgr .calls").append('<div class="' + type + ' gray" id="c_' + (self.contacts.length - 1) + '"><p><strong>' + contact["Name"] + '</strong></p><div class="date"><u>' + date[3] + ':' + date[4] + ((GMT) ? " GMT<br/>" : "") + ' (' + size + ')</u><span>' + date[1] + '/' + date[2] + '/' + date[0] + '</span></div></div><div class="clear"></div>');
                    }
                    else {
                        jQuery(".status-bgr .calls").append('<div class="' + type + '" id="c_' + (self.contacts.length - 1) + '"><p><strong>' + contact["Name"] + '</strong></p><div class="date"><u>' + date[3] + ':' + date[4] + ((GMT) ? " GMT<br/>" : "") + ' (' + size + ')</u><span>' + date[1] + '/' + date[2] + '/' + date[0] + '</span></div></div><div class="clear"></div>');
                        }
                    }
                }
            }
        }
        
        var data = this.data['return'].MESSAGEHDR.reverse();
        this.lazy_load(this, func, data, 0, 10, 10, function() {
            //jQuery(".status-bgr .calls").append(self.listHolder.join(""));
            self.SFIntegration();
            jQuery(".shadow").css({
                "display": "none"
            });
        });
        this.log("GetMessagesList");
    },
    listMessages: function () {
        this.log("listMessages");
		if(this.data['return'] && typeof this.data['return'].result != "undefined") {
			if (jQuery.isArray(this.data['return'].result)) {
				var list = this.data['return'].result;
			}
			else {
				var list = new Array(this.data['return'].result);
			}
			jQuery(".status-bgr .calls").html("");   //jQuery(".active-calls tbody")
			var self = this;
			self.contacts = new Array();

			jQuery.each(list, function(index, element) {
                //Check for deleted message
                if (element != null) {
                    var type = 'call';
                    var size_type = ' sec';
                    var size = parseInt(parseInt(element.size.content) / 60) + ":" + (parseInt(element.size.content) % 60);
                    if (element.type.content != "messageVoice") {
                        type = 'fax';
                        size = element.size.content + ' pp';
                    }
                    var date = element.dateTime.content.match(/^[\d]{2}([\d]{2})\-([\d]{2})\-([\d]{2})T([\d]{2}):([\d]{2})/).slice(1); //1:20pm
                    var GMT = (element.dateTime.content.search(/GMT/) != -1);
                    var fileExt = (typeof element.fileExtension != "undefined") ? element.fileExtension.content : "wav";
                    //Save contacts in inner array
                    var contact = {
                        "ID": element.messageId.content,
                        "Name": null,
                        "Ext": fileExt,
                        "Type": element.type.content,
                        "Number": null,
                        "Unread": element.unread.content
                    };
                    if (typeof element.addr != "undefined" && element.addr.content && element.addr.content != undefined) {
                        var name_number = element.addr.content.match(/([\d]{3})([\d]{3})([\d]{4})/);
                        if (name_number.length == 4) {
                            contact["Name"] = (element.name != undefined) ? element.name.content : "("+name_number[1]+") "+name_number[2]+"-"+name_number[3];
                        }
                        else {
                            contact["Name"] = (element.name != undefined) ? element.name.content : (element.addr.content);
                        }
                        contact["Number"] = (element.addr.content != undefined) ? element.addr.content : "Unknown";
                    }
                    else {
                        contact["Name"] = (element.name != undefined) ? element.name.content : "Unknown";
                    }
                    self.contacts.push(contact);
                    
                    if (element.unread.content == "false") {
                        jQuery(".status-bgr .calls").append('<div class="' + type + ' gray" id="c_' + (self.contacts.length-1) + '"><p><strong>' + contact["Name"] + '</strong></p><div class="date"><u>' + date[3] + ':' + date[4] + ((GMT)?" GMT<br/>":"") + ' (' + size + ')</u><span>' + date[1] + '/' + date[2] + '/' + date[0] + '</span></div></div><div class="clear"></div>');
                    }
                    else {
                        jQuery(".status-bgr .calls").append('<div class="' + type + '" id="c_' + (self.contacts.length-1) + '"><p><strong>' + contact["Name"] + '</strong></p><div class="date"><u>' + date[3] + ':' + date[4] + ((GMT)?" GMT<br/>":"") + ' (' + size + ')</u><span>' + date[1] + '/' + date[2] + '/' + date[0] + '</span></div></div><div class="clear"></div>');
                    }
                }
			});

			this.SFIntegration();
            jQuery(".shadow").css({"display":"none"});
		}
		else {
			jQuery(".shadow").css({"display":"none"});
		}
		return this;
	},
	synchronization: function() {
        this.log("synchronization");
		//Check for synchronization
		//Save info into SF table   2011-02-28T07:03:33-08:00
		var only_SF = CheckBox("get", "accinfo_chdsca");
		var self = this;
		if (only_SF == undefined || !only_SF) {
			var syncVar = function() {
                self.log("synchronization syncVar");
				if (self.callFlag != undefined && self.callFlag == "call") {
					setTimeout(syncVar, 1000);
				}
				else {
					var synchronization = CheckBox("get", "synchronization");
					var StartEndDate = self.GUI.getStartEndDate("Month", 1);
					if (synchronization != undefined) {
						var time = (new Date(synchronization)).getTime();
						
						var Starttime = (new Date(StartEndDate.endDate)).getTime();
						var days = (Starttime - time) / 1000 * 60 * 60 * 24;
						if (days > 30) {
							self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, "", "1", "10000");
						}
						else {
							self.widgetCore.getCallLog(synchronization, StartEndDate.endDate, "", "1", "10000");
						}
						CheckBox("save", "synchronization", StartEndDate.endDate);
					}
					else {
						self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, "", "1", "10000");
						CheckBox("save", "synchronization", StartEndDate.endDate);
					}
					//Save settings to SF
					if(typeof self.loginFields.SFID != "undefined") {
						var account = new sforce.SObject(self.SFDataBaseName);
						account.Id = self.loginFields.SFID;
						account.ring__Settings__c = jQuery.cookie('widget_options');
						sforce.connection.update([account], self.emptyRespons(undefined, "isAutorized Sync"));
					}
				}
                self.log("synchronization syncVar");
			}
			setTimeout(syncVar, 1000);
		}
        this.log("synchronization");
	}, 
	reLogin: function() {
		//this.widgetCore.socket.disconnect();
		return;
	},
	reLogin_error: function() {
		//this.widgetCore.socket.disconnect();
		//Show account info tab
		this.GUI.notLogged();
		this.widgetCore.session = "null";
		ErrorHolder(this.error);
	},
	callStatus: function(nameID) {
		var nameArray = {"csSuccess":"Success", 
						 "csInProgress":"In Progress", 
						 "eSuccess": "Success",
						 "eInProgress": "In Progress",
						 "eBusy": "Busy",
						 "eNoAnswer": "No Answer",
						 "eRejected": "Rejected",
						 "eGenericError": "Generic Error",
						 "eFinished": "Finished",
						 "eInternationalDisabled": "International Disabled",
						 "eDestinationBlocked": "Destination Blocked",
						 "eNotEnoughFunds": "Not Enough Funds",
						 "eNoSuchUser": "No Such User"
						 };  
		if(nameArray[nameID] != undefined) {
			return nameArray[nameID];
		}
		else {
			return nameID;
		}
	},
	getForwardingNumber: function(Manager, number_from) {
        this.log("getForwardingNumber");
		//Check forvarding number
		var forwardingNumbers = false;
		if(typeof Manager.accountInfo == "undefined" && typeof Manager.accountInfo.forwardingNumbers == "undefined") {
			ErrorHolder({
					code: "Manager",
					text: "Please enable Forwarding Numbers"
				});
		}
		else {
			forwardingNumbers = Manager.accountInfo.forwardingNumbers;
		}
		//If number_form not set
		var Name = "" 
		if (number_from != undefined) {
			if (number_from.search(/Phone/) != -1) { //Remove 'Phone' word
				number_from = number_from.replace(/Phone [\d]{1,3}/g, "");
			}
			number_from = number_from.replace(/[^\d*]/g, "");
		}
		if (number_from == undefined || number_from == "None" || number_from == "" || number_from.length < 11) {
			number_from = "";
			if (forwardingNumbers) {
				if (typeof forwardingNumbers[0] != "undefined") {
					Name = forwardingNumbers[0].name.content;
                    this.log("getForwardingNumber");
					return {"Name":Name,"number_from":forwardingNumbers[0].number.content};
				}
				else {
					Name = forwardingNumbers.name.content;
                    this.log("getForwardingNumber");
					return {"Name":Name,"number_from":forwardingNumbers.number.content};
				}
			}
			else {
                this.log("getForwardingNumber");
				return {"Name":"","number_from":""};
			}
		}
		
		//Else return
		if (forwardingNumbers) {
			if (typeof forwardingNumbers[0] != "undefined") {
				jQuery.each(forwardingNumbers, function(item, i){
					if (this.number.content.replace(/[^\d*]/g, "") == number_from.replace(/[^\d*]/g, "")) {
						Name = this.name.content;
					}
				});
			}
			else {
				if (forwardingNumbers.number.content.replace(/[^\d*]/g, "") == number_from.replace(/[^\d*]/g, "")) {
					Name = forwardingNumbers.name.content;
				}
			}
		}
        this.log("getForwardingNumber");
		return {"Name":Name,"number_from":number_from};
	},
	RingOut_callAndGetFirstStatus: function() {
		var self = this;
		
		//Set status info
		var number_from = "";
		if (self.data.inputData != undefined && self.data.inputData.from != undefined) {
			number_from = self.data.inputData.from;
		}
		var tmp = self.getForwardingNumber(self, number_from);
		if(tmp["number_from"].replace(/[^\d*]/g, "") == "") {
			return;
		}
		var Name = tmp["Name"];
		number_from = tmp["number_from"];
		
		this.GUI.showStatus();
		this.GUI.flashDisabler();
		
		var Num_arr = number_from.replace(/[^\d*]/g, "").match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})(\*|$|.)/);
		var To = [null, null, null, null];
		if(this.data.inputData != undefined && this.data.inputData.to != undefined) {
            //BEGIN Kastill
            this.notification_number = this.data.inputData.to;
            //END Kastill
			To = this.data.inputData.to.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})(\*|$|.)/);
            if(To == null) {
                To = this.data.inputData.to;
            }
		}
		this.GUI.changeStatus({"name": Name, "number": Num_arr, "status": this.callStatus(this.data["return"].ringOutStatus.userStatus.content)}, 
					 {"name": null, "number": To,      "status": this.callStatus(this.data["return"].ringOutStatus.partyStatus.content)});
		
		clearTimeout(GlobalTimer);
		clearTimeout(GlobalDefaultTimer);
		jQuery("#rc-panel").unbind();
		
		
		//Call status
		GlobalTimer = setTimeout(function() { 
            (function(data) {
			     if (typeof data != undefined && typeof data["return"] != undefined && typeof data["return"] != null && typeof data["return"].sessionId != "undefined") {
				    self.widgetCore.ringOutStat(data["return"].sessionId.content);
			     }
            })(self.data);
		}, 1000);
		
		var rosessionID = null;
		if(typeof self.data["return"].sessionId.content != "undefined") {
			rosessionID = self.data["return"].sessionId.content;
		}
		jQuery(".stattus #butcRing").html("Cancel");
		jQuery(".stattus #butcRing").unbind();
		jQuery(".stattus #butcRing").bind("click", function(event) {
			if(rosessionID != null) {
				if(Manager.sipID != null) {
					self.widgetCore.ringOutCancel(rosessionID);
				}
			}
			self.GUI.showMessages();
		});
	}, 
	RingOut_callAndGetFirstStatus_error: function() {
		if(this.error.code == "004") {
			this.GUI.notLogged();
		}
        delete this.notification_number;
		return;
	},
	unsupportedMethods: function() {
        this.log("unsupportedMethods");
		this.unsupport = true;
		this.widgetCore.unsupportedFunc(this.data["return"].split(","));
        this.log("unsupportedMethods");
		return;
	},
	RingOut_list: function() {
		return;
	},
	RingOut_cancel: function() {
		ErrorHolder({"code":"Call","text":"You have canceled call"});
		this.data["return"].ringOutStatus = undefined;
		clearTimeout(GlobalTimer);
		return;
	},
	RingOut_status: function() {
		clearTimeout(GlobalTimer);
		var self = this;
        var stopSending = false;
		if (this.data["return"].ringOutStatus.callState != undefined && 
			(this.data["return"].ringOutStatus.callState.content == "csNoSessionFound" || 
			 this.data["return"].ringOutStatus.callState.content == "eNoAnswer")) {
			GTimerFunc("start");
			return;
		}
		else {
			if (this.data["return"].ringOutStatus.userStatus != undefined && (this.data["return"].ringOutStatus.userStatus.content == "eGenericError" || this.data["return"].ringOutStatus.partyStatus.content == "eGenericError")) {
				ErrorHolder({
					"code": "Call",
					"text": "Can't RingOut"
				});
				this.GUI.showMessages();
				return;
			} 
		} 
		//Check statuses and change botton action
		if (this.data["return"].ringOutStatus.userStatus != undefined) {
			if (this.data["return"].ringOutStatus.userStatus.content == "eSuccess" ||
				this.data["return"].ringOutStatus.partyStatus.content == "eSuccess") {
					//GTimerFunc("start");
					jQuery(".stattus #butcRing").html("Close");
					jQuery(".stattus #butcRing").unbind();
					jQuery(".stattus #butcRing").bind("click", function(event){
						clearTimeout(GlobalTimer);
						self.GUI.showMessages();
						return;
					});
					GTimerFunc("start");
			}
			this.GUI.changeStatus({
				"status": this.callStatus(this.data["return"].ringOutStatus.userStatus.content)
			}, {
				"status": this.callStatus(this.data["return"].ringOutStatus.partyStatus.content)
			});
		}
        
        if (this.data["return"].ringOutStatus.userStatus != undefined) {
            if (this.data["return"].ringOutStatus.userStatus.content == "eFinished" ||
                this.data["return"].ringOutStatus.partyStatus.content == "eFinished") {
                    clearTimeout(GlobalTimer);
                    stopSending = true;
                    var StartEndDate = self.GUI.getStartEndDate();
                    if (typeof self.notification_number != "undefined") {
                        setTimeout(function() {
                            self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, self.notification_number, "1", "10000");
                        }, 2000);
                    }         
            }
        }
        
		if(!stopSending && self.data != undefined && self.data["return"] != undefined && self.data["return"].sessionId != undefined) {
			var sessionId = self.data["return"].sessionId.content;
			GlobalTimer = setTimeout(function() { 
					self.widgetCore.ringOutStat(sessionId);
			}, 1000);
		}
	},
	clearCaller: function() {
		this.callerIDArr = [];
		this.callerID = null;
	},
	SIPMessage: function() {
        this.log("SIPMessage");
		var self = this;
        
        var showFunc = function(self) {
            //Find last call
            var StartEndDate = self.GUI.getStartEndDate();
            self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, self.data["notification"]["number"], "1", "1");
            //Get information about caller
            self.contactSFinfo(self.data["notification"]["number"]);
            
            
            self.GUI.flashDisabler();
            self.GUI.showMainn();
            self.callFlag = "call";
            
            
            self.GUI.showCallInfo(self.data["notification"]["number"], CheckBox("get", "accinf_select_ringtones"));
            
                               
            jQuery(".mainn .greyt:first").html(self.data["notification"]["name"]);
            //Open contact if checked
            var open_contact = CheckBox("get", "accinfo_chocinc");
            if (open_contact != undefined && open_contact) {
                setTimeout(function() {
                    if (jQuery.cookie('reloaded') == null) {
                        jQuery.cookie('reloaded', 'true');
                        jQuery("#openCallingContact a").click();
                    } 
                  }, 100);
            }
        }
		
		if (this.callerID != this.data["notification"]["id"] || this.data["notification"]["status"] == "cancel") {
			//Check in parallel call take place
			if (this.data["notification"]["status"] != "cancel" && jQuery.inArray(this.data["notification"]["id"], this.callerIDArr) == -1) {
				this.callerIDArr.push(this.data["notification"]["id"]);
				if (this.callerID != null) {
					if(this.data["notification"]["status"] != "cancel" && typeof this.data["notification"]["id"] != undefined) {
						self.widgetCore.cantGetCall(this.data["notification"]["id"]);
                        this.log("SIPMessage");
						return;
					}
				}
			} 
			
			switch (this.data["notification"]["type"]) {
				case "call":
					if (this.data["notification"]["status"] == "cancel") {
						this.callFlag = "cancel";
						this.clearCaller();
						jQuery.cookie('reloaded', null);
						
						//Find last call for syncronisation
                        setTimeout(function() {
                            try {
                                if (typeof self.data["notification"] != "undefinded" && typeof self.data["notification"]["number"] != "undefinded") {
                                    var StartEndDate = self.GUI.getStartEndDate();
                                    self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, self.data["notification"]["number"], "1", "10000");
                                }
                            } catch(e) {
                                //Kastil for IE
                            }
                        }, 2000);
				
						this.GUI.showMessages();
						this.log("SIPMessage");
						return;
					}
					
                    showFunc(this);
                    break;
                    
                    //---------------------Old variation
					this.GUI.showMainn();
					this.callFlag = "call";
                    
					
                    this.GUI.flashDisabler();
					this.GUI.showCallInfo(this.data["notification"]["number"], CheckBox("get", "accinf_select_ringtones"));
					
					
					
					jQuery(".mainn .greyt:first").html(this.data["notification"]["name"]);
					//Open contact if checked
					var open_contact = CheckBox("get", "accinfo_chocinc");
					if (open_contact != undefined && open_contact) {
						setTimeout(function() {
							if (jQuery.cookie('reloaded') == null) {
								jQuery.cookie('reloaded', 'true');
								jQuery("#openCallingContact a").click();
							} 
						  }, 100);
					}
					//Find last call
					var StartEndDate = this.GUI.getStartEndDate();
					self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, this.data["notification"]["number"], "1", "1");
					//Get information about caller
					this.contactSFinfo(this.data["notification"]["number"]);
                    //END---------------------Old variation
					break;
				case "message": //Update message list
					this.widgetCore.getList();
					this.GUI.showMessages();
					break;
			}
            //If this is new call (after page refresh) save last caller ID
            if (this.callerID == null) {
                this.callerID = this.data["notification"]["id"]; //Current caller ID
            }
		}
		else if(this.data["notification"]["type"] == "message") {
			this.widgetCore.getList();
			this.GUI.showMessages();
		} 
        else {
            if(jQuery("#rc-panel .mainn").is(":hidden")) { //Kakogoto x-a zakrilo!
                this.callerID = null;
                showFunc(this);
            }
        }
        this.log("SIPMessage");
	},
	Browser : function() {
		var version = 999; // we assume a sane browser
		if (navigator.appVersion.indexOf("MSIE") != -1) {
			// bah, IE again, lets downgrade version number
			version = parseFloat(navigator.appVersion.split("MSIE")[1]);
		}
		return version;
	},
	getFunc: function(name) {
		var MjQuery =  navigator.appName.indexOf("Microsoft")!=-1;
		if(MjQuery) {
			if(this.Browser() >= 9) {
				return document[name];
			} else {
				return (MjQuery ? window : document)[name];
			}
		}
		else {
			return (MjQuery ? window : document)[name];
		}
	},
	/* temporary fix */
	getMessage: function() {
		var message_flag = this.message_flag;
		//Add Flash
		if(message_flag[this.data["inputData"].ext] != undefined) {
			var flag = message_flag[this.data["inputData"].ext];
			var self = this;
			var wavData = this.data["return"].result.content;
			
			jQuery(".haxe_pdf, .haxe_wav#num1, .haxe_wav#num2").removeClass("show");
			
			jQuery(flag["show_name"]).addClass("show");
			//var MjQuery =  navigator.appName.indexOf("Microsoft")!=-1;
			if(self.data["return"] != undefined && self.data["inputData"].ext != undefined) {
				var realExtension = self.data["inputData"].ext;
			}
			setTimeout(function() {
				var func = self.getFunc(flag["id"]);

				if(typeof func[flag["method_name"]] == "undefined") {
					if(typeof ErrorHolder == "function") {
						ErrorHolder({"code":"flash_GM", "text":"Problem with Flash bridge"});
					}
					else {
						//alert(text);
					}
					
				}
				else {
                    try {
                        func[flag["method_name"]](wavData);
                        if (self.currentExt != undefined && self.currentExt != "" && realExtension != undefined && realExtension != self.currentExt) {
                            //var func = (MjQuery ? window : document)[message_flag[self.currentExt]["id"]];
                            var func = self.getFunc(message_flag[self.currentExt]["id"]);
                            if (message_flag[self.currentExt]["stop_name"] != undefined && func[message_flag[self.currentExt]["stop_name"]] != undefined) {
                                func[message_flag[self.currentExt]["stop_name"]]("Stop");
                            }
                        }
                        
                        
                        self.currentData = wavData;
                        if (realExtension != undefined) {
                            self.currentExt = realExtension;
                        }
                        //Save for flash disabler
                        self.GUI.flashDisabler();
                        self.GUI.flash_holder.push({
                            'flash_name': flag["id"],
                            'method_name': message_flag[self.currentExt]["stop_name"]
                        });
                    } catch(e) {
                        //Do nothing
                    }
				}
				if(self.data.inputData != undefined && self.data.inputData.messageId != undefined) {
                    self.GUI.restoreID = self.data.inputData.messageId; //Local global variable
					self.widgetCore.ChangeMessageReadStatus(self.data.inputData.messageId, self.data['inputData'].messageType);
                    (function(ID) {
    					jQuery("a.stop").show().unbind();
    					jQuery("a.stop").bind("click", function() {
                            if (confirm("Delete this message?")) {
                                self.GUI.flashDisabler();
                                self.widgetCore.DeleteMessage(ID);
                            }
    						return false;
    					});
                    })(self.data.inputData.messageId);
				}
				jQuery(".shadow").css({"display":"none"});
			}, 2000);
			return;
		} else {
            ErrorHolder({"code":"flash_GM2", "text":"New or Undefined message type"});
        }
		//----End Flash
		return;
	},
	GetMessage: function() {
        this.log("GetMessage");
        var message_flag = this.message_flag;
        //Add Flash
        if(message_flag[this.data["inputData"].ext] != undefined) {
            var flag = message_flag[this.data["inputData"].ext];
            var self = this;
            var wavData = this.data["return"].MsgBody.content.replace(/\*/g, "/");
            
            //self.GUI.messageFlash("hide");
            jQuery(".haxe_pdf, .haxe_wav#num1, .haxe_wav#num2").removeClass("show");
            if (window.navigator.userAgent.indexOf("Mozilla") != -1) {
                jQuery(flag["show_name"]).addClass("show");  
            }

            //var MjQuery =  navigator.appName.indexOf("Microsoft")!=-1;
            if(self.data["return"] != undefined && self.data["inputData"].ext != undefined) {
                var realExtension = self.data["inputData"].ext;
            }
            var pushData = function() {
                var showSWF = function() {
                    //clearTimeout(self._timer);
                    //Check if this is right func
                    if(jQuery(".status-bgr .calls div.fax, .status-bgr .calls").find(".current").hasClass("fax") && flag["id"].indexOf("pdf") == -1) {
                        jQuery(".haxe_wav#num1, .haxe_wav#num2").removeClass("show");
                        return;
                    } else if(jQuery(".status-bgr .calls div.fax, .status-bgr .calls").find(".current").hasClass("call") && flag["id"].indexOf("pdf") != -1) {
                        jQuery(".haxe_pdf").removeClass("show");
                        return;
                    }
                    
                    var func = self.getFunc(flag["id"]);
    
                    if(typeof func[flag["method_name"]] == "undefined") {
                        if(typeof ErrorHolder == "function") {
                            ErrorHolder({"code":"flash_GM", "text":"Problem with Flash bridge"});
                        }
                        else {
                            //alert(text);
                        }   
                    }
                    else {
                        try {
                            jQuery(flag["show_name"]).addClass("show");  
                            func[flag["method_name"]](wavData);
                            if(self.currentExt != undefined && self.currentExt != "" && realExtension != undefined && realExtension != self.currentExt) {
                                //var func = (MjQuery ? window : document)[message_flag[self.currentExt]["id"]];
                                var func = self.getFunc(message_flag[self.currentExt]["id"]);
                                if(message_flag[self.currentExt]["stop_name"] != undefined && func[message_flag[self.currentExt]["stop_name"]] != undefined) {
                                    func[message_flag[self.currentExt]["stop_name"]]("Stop");
                                }
                            }
                            
                                
                            self.currentData = wavData;
                            if (realExtension != undefined) {
                                self.currentExt = realExtension;
                            }
                            //Save for flash disabler
                            self.GUI.flashDisabler();
                            self.GUI.flash_holder.push({
                                'flash_name': flag["id"],
                                'method_name': message_flag[self.currentExt]["stop_name"]
                            });
                        } catch(e) {
                            //Do nothing
                        }
                    }
                    //self.GUI.messageFlash("show");
                    if(self.data.inputData != undefined && self.data.inputData.messageId != undefined) {
                        self.GUI.restoreID = self.data.inputData.messageId; //Local global variable
                        //Find this contact
                        if (Manager.currentUser.ID == self.data.inputData.messageId && Manager.currentUser.Unread == "true") {
                            self.widgetCore.ChangeMessageReadStatus(self.data.inputData.messageId, self.data['inputData'].messageType);
                        }
                        (function(ID) {
                            jQuery("a.stop").show().unbind();
                            jQuery("a.stop").bind("click", function() {
                                if (confirm("Delete this message?")) {
                                    self.GUI.flashDisabler();
                                    self.widgetCore.DeleteMessage(ID);
                                }
                                return false;
                            });
                        })(self.data.inputData.messageId);
                    }
                    jQuery(".shadow").css({"display":"none"});
                };
                self._timer = setTimeout(showSWF, 2000);
                
            };
            swfobject.embedSWF(flag["src"], flag["id"], flag["width"], "27", "9", null, null, {
                "quality": "high",
                "wmode": "opaque",
                "salign": "lt",
                "allowScriptAccess": "always",
                "bgcolor": "#F3F3F3",
                "scale": "noscale"
            }, null, pushData);
            this.log("GetMessage");
            return;
        } else {
            ErrorHolder({"code":"flash_GM2", "text":"New or Undefined message type"});
        }
        //----End Flash
        this.log("GetMessage");
        return;
    },
	changeMessageStatus: function() {
	   return true;  
	},
	ChangeMessageReadStatus: function() {
        Manager.contacts[Manager.currentUser.CurID].Unread = "false";
		this.GUI.beenRead();
		return true;
	},
	deleteMessage: function() {
		this.widgetCore.getList(); 
		//kastill
        jQuery(".status-bgr .calls div.fax, .status-bgr .calls div.call").removeClass("current");
        this.GUI.showMessages();
	},
    DeleteMessage: function() {
        this.widgetCore.getList(); 
        //kastill
        jQuery(".status-bgr .calls div.fax, .status-bgr .calls div.call").removeClass("current");
        this.GUI.showMessages();
        
    },
	checkLastCall:function(flag) {
        this.log("checkLastCall");
		var self = this;
		if (flag != undefined && flag == 1) {
			if (typeof this.getCallLog_flag == "undefined" || this.getCallLog_flag) {
				var StartEndDate = this.GUI.getStartEndDate();
				this.getCallLog_flag = false;
				setTimeout(function(){
					var rec_start = (self.callFlag != null && self.callFlag == "call") ? self.lCall.recordCount.content - 1 : self.lCall.recordCount.content;
                    //var rec_start = self.lCall.recordCount.content - 4;
					self.callFlag = null;
					self.widgetCore.getCallLog(StartEndDate.startDate, StartEndDate.endDate, (self.data["inputData"] != undefined) ? self.data["inputData"]["phoneNumber"] : "", rec_start, "1");
				}, 1000);
			}
			else if(typeof this.getCallLog_flag != "undefined" && !this.getCallLog_flag) {
				this.getCallLog_flag = true;
			}
		}
		else if(flag != undefined && flag == 2) {
			if(typeof this.getCallLog_flag != "undefined" && !this.getCallLog_flag) {
				this.getCallLog_flag = true;
                if(self.lCall.result[0] != undefined) {
                    var result = self.lCall.result[0];
                } else {
                    var result = self.lCall.result;
                }
				
				var data = result.callStartTime.content;
				var time = data.match(/[\d]{4}.([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2})/);
				jQuery(".mainn .last-call").html("Last call, "+time[1]+"/"+time[2]+", "+time[3]+":"+time[4]);
				var number = result.number.content.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})/);
				var Name = "";
				for(var i = 0; i < self.contacts.length; i++) {
					if(result.number.content.search(self.contacts[i]["Number"] ) != -1) {
						Name = self.contacts[i].Name;
						break;
					}
				}
				
				if (this.data["inputData"]["recordCount"] != this.data["inputData"]["startRecord"]) {
					if(number == null) {
						//Hide disposition select
						jQuery(".tabb.noactivecalls .rc-content .select.sel").css("display", "none");
						jQuery(".tabb.noactivecalls .rc-content .buttonn").css("display", "none");
						return;
					}
					jQuery("#rc-panel .noactivecalls .rc-content .blacktext").html(Name + " (" + number[1] + ") " + number[2] + "-" + number[3] + "<br>" + time[1] + "/" + time[2] + ", " + time[3] + ":" + time[4]);
					
					self.despositionSFinfo({
						"Number": number[1] + number[2] + number[3]
					});
				}
			}
			else if(typeof this.getCallLog_flag != "undefined" && this.getCallLog_flag) {
				this.getCallLog_flag = false;
			}
		}
        this.log("checkLastCall");
	},
	getCallLog: function() {
        this.log("getCallLog");
		jQuery(".mainn .greyt.last").css("display", "none");
        if (this.data["return"][0] != undefined) {
            var lastCall = this.data["return"][0];
        }
        else {
            var lastCall = this.data["return"];
        }
		this.lCall = lastCall;
		
		if(lastCall.recordCount.content != 0) {
			var self = this;
			if(this.data["inputData"]["recordCount"] == this.data["inputData"]["startRecord"]){
				this.checkLastCall(1);
			}
			else  {
				try {
					if (this.data["inputData"]["recordCount"] == "10000") {
						//Create SF query  self.widgetCore.ErrorLog("syncLog0", 0, lastCall.result);
						if (where == undefined) 
							var where = [];
						if (jQuery.isArray(lastCall.result)) {
							var where = [];
							jQuery.each(lastCall.result, function(itm){
                                //Make MD5 id
                                var sessionID = hex_md5(this.number.content+this.callStartTime.content+this.sessionId.content)
								where.push("ring__ID__c = '" + sessionID + "'");
                                //where.push("'"+sessionID+"'");
							});
						}
						else if (typeof lastCall.result.sessionId != "undefined") {
                            var sessionID = hex_md5(this.number.content+this.callStartTime.content+this.sessionId.content)
							where.push("ring__ID__c = '" + sessionID + "'");
                            //where.push("'"+sessionID+"'");
						}
						//Make request
						if (where.length > 0) {
                            //var result = sforce.connection.query("SELECT ring__Task_ID__c, ring__ID__c FROM ring__Disposition__c WHERE ring__ID__c IN ("+where.join(",")+")");
							var result = self.getMultyQueryRes("SELECT ring__Task_ID__c, ring__ID__c FROM ring__Disposition__c WHERE ", 70, where);
							//var sql = "SELECT ring__Task_ID__c, ring__ID__c FROM ring__Disposition__c WHERE " + where.join(" OR ");
							//var result = sforce.connection.query(sql);
						}
						//Check result
						var newRecords = [];
						if (typeof result != "undefined" && result.done == "true" && typeof result.records != "undefined") {
							var ret = 0;
							//Save result in Array
							var resultID = [];
							jQuery.each(result.records, function(itm){
								resultID.push(this["ring__ID__c"]);
							});
							//Compare result with lastCall    self.widgetCore.ErrorLog("syncLog0", 1, resultID);
							var tmp = [];
							if (jQuery.isArray(lastCall.result)) {
								jQuery.each(lastCall.result, function(itm){
                                    this.number.content = (this.number.content != undefined) ? this.number.content : "";
                                    var sessionID = hex_md5(this.number.content+this.callStartTime.content+this.sessionId.content)
									if (jQuery.inArray(sessionID, resultID) == -1 && this.number.content.length > 10) {
                                        tmp.push({
											direction: this.direction.content,
											number: this.number.content,
											time: this.callStartTime.content,
											sessionID: sessionID
										});
									}
								});
							}
							else if (typeof lastCall.result.sessionId != "undefined") {
                                var sessionID = hex_md5(lastCall.result.number.content+lastCall.result.callStartTime.content+lastCall.result.sessionId.content)
									if (jQuery.inArray(sessionID, resultID) == -1 && this.number.content.length > 10) {
										tmp.push({
											direction: lastCall.result.direction.content,
											number: lastCall.result.number.content,
											time: lastCall.result.callStartTime.content,
											sessionID: sessionID
										});
									}
								}
							self.saveDespositionSF(tmp, "SalesForce"); //self.widgetCore.ErrorLog("syncLog0", 2, tmp);
						}
					}
					else {
						//2010-10-21T04:25:12-07:00
						this.checkLastCall(2);
						
						//Save info into SF table   2011-02-28T07:03:33-08:00
						//Check this record
                        this.log("getCallLog_SF");
						var _saveCall = function(self, result) {
    						var ret = 0;
                            var lastCall = self.lCall; 
                            self.log("getCallLog_SF_in");
    						if (result.done == "true" && typeof result.records != "undefined") {
    						    if(result.records.length == undefined) {
    						        //var _tmp = result.records;
    						        result.records = [result.records];
                                }
    							jQuery.each(result.records, function(itm){
    								if (lastCall.result != undefined && lastCall.result.sessionId != undefined && this["ring__ID__c"] == lastCall.result.sessionId.content) {
                                        ret += 1;
                                        return false;
                                    }
    							})
    						}
                            self.log("getCallLog_SF_in");
    						if (ret == 0) {
    							if (typeof self.AddDisp == "undefined" || self.AddDisp == false) {
    								self.AddDisp = true;
    								self.saveDespositionSF([{
    									direction: lastCall.result.direction.content,
    									number: lastCall.result.number.content,
    									time: lastCall.result.callStartTime.content,
    									sessionID: lastCall.result.sessionId.content
    								}], "SalesForce");
    							}
    						}
                        };
                        var sql = "SELECT ring__Task_ID__c, ring__ID__c, Owner.Name FROM ring__Disposition__c";
                        sforce.connection.query(sql, this.emptyRespons(_saveCall, "_saveCall"));
                        this.log("getCallLog_SF");
					}
				} catch(e) {
					var stack = JSON.stringify(e);
					if(typeof ErrorHolder == "function") {
						ErrorHolder({'code':"SF004",'text':e, "stack":stack});
					}
					else {
						//alert("SF Error");
					}
				}
			}
		}
        this.log("getCallLog");
	},
	LogOff: function() {
		//this.widgetCore.socket.disconnect();
		this.log_off = false;
		this.unsupport = false;
		//this.GUI.notLogged();
		this.widgetCore.session = "null";  
		jQuery(".status-bgr .calls").html(""); 
		jQuery("#Logout").parent().hide();
		this.GUI.setStopLight("red");
        this.GUI.dndButton(false);
		jQuery("#rc-panel .tabb.accinfo #busave").css({"display":"none"});
	},
	getMailboxInfo: function() {
        this.log("getMailboxInfo");
		var self = this;
		var tags = Config.html_tags;
		var DNDoff = "DND Off";
		var DNDon = "DND On";
		this.mailboxInfo = this.data["return"];
		//Check for DND status
		if(this.mailboxInfo.mailboxInfo.queueState.content == "Agent") {
			var AgentStat = (this.mailboxInfo.mailboxInfo.agentStatus != undefined) ? this.mailboxInfo.mailboxInfo.agentStatus.content : false;
			if(this.accountInfo.dnd.content == "true") {
				jQuery(tags.dndBtnChild).html(DNDon).parent().attr("title", DNDon).attr("class", "red");
			}
			else {
				jQuery(tags.dndBtnChild).html(DNDoff).parent().attr("title", DNDoff).attr("class", ((AgentStat == "Online") ? "" : "orange"));
			}
		}
		else {    //Not an Agent - Simply set DND stat
			if(this.accountInfo.dnd.content == "true") {
				jQuery(tags.dndBtnChild).html(DNDon).parent().attr("title", DNDon).attr("class", "red");
			}
			else {
				jQuery(tags.dndBtnChild).html(DNDoff).parent().attr("title", DNDoff).attr("class", "");
			}
		}
		//Bind DND menu button 
		jQuery(tags.dndBtn).unbind();
		jQuery(tags.dndBtn).bind("click", function(event) {
			if(jQuery.cookie('sfwssessionid')!=null) {
				if(jQuery("#rc-panel .dnd .drop-down").is(':hidden')) {
					self.GUI.dndButton(true);		
					jQuery('#rc-panel, #rc-panel th.header, #rc-panel a.down, #rc-panel a.up, #rc-panel div.select.sel a, #rc-panel .audio').bind('click', function(event) {
					   var t = jQuery('#rc-panel div').closest('div.drop-down');
					 
						if(jQuery.cookie('sfwssessionid')!=null) {
							self.GUI.dndButton(false);
						}
						return false;
					});
				}
				else {
					self.GUI.dndButton(false);
				} 
			}
			return false;
		});
		//DND statuses
		var Agent = this.mailboxInfo.mailboxInfo.queueState.content;
		var status = [ {"name":DNDoff,   
						"inClass":"",         
						"fun":function(){
							self.widgetCore.setDND(false); 
							if(Agent == "Agent") {
								self.widgetCore.setAgent("Online","Agent");
							}
						}}, 
					   {"name":DNDon,  
						"inClass":"red",      
						"fun":function(){
							self.widgetCore.setDND(true);
							if(Agent == "Agent") {
								self.widgetCore.setAgent("Offline","Agent");
							}
						}}
					 ];
		//Bind DND drop-down list
		jQuery("#rc-panel .dnd .drop-content a").each(function(index) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function(event) {
				jQuery(tags.dndBtnChild).html(status[index].name).parent().attr("title", status[index].name).attr("class", status[index].inClass);
				self.GUI.dndButton(false);
				status[index].fun();
				return false;
			});
		});
        this.log("getMailboxInfo");
	},
	setDND: function() {
		return;
	},
	setAgent: function() {
		return;
	},
	getAccountInfo: function() {
        this.log("getAccountInfo");
		if(this.accountInfo == undefined || JSON.stringify(this.accountInfo).length != JSON.stringify(this.data["return"]).length) {
			this.accountInfo = this.data["return"];
            //If only one forfarding number
            if(this.accountInfo.forwardingNumbers != undefined && this.accountInfo.forwardingNumbers.length == undefined) {
                var tmp = this.accountInfo.forwardingNumbers;
                this.accountInfo.forwardingNumbers = [];
                this.accountInfo.forwardingNumbers.push(tmp);
            } 
            if(this.accountInfo.forwardingNumbers == undefined) {
                var fNumber = {"name":{"content":"Main"}, "number":{"content":this.accountInfo.accountNumber.content}, "orderBy":{"content":"-1"}, "type":{"content":"Work"}};
                this.accountInfo.forwardingNumbers = [fNumber];
            }
			this.GUI.setOptions();  //Init UI
			this.GUI.mainnTab();
			this.widgetCore.getMailBox();
		}
        this.log("getAccountInfo");
	},
	SIPRegister: function() {
        this.log("SIPRegister");
		this.GUI.setStopLight("green");
		if(this.loginFields.SFID != undefined && this.loginFields.SFID != null) {
			var account = new sforce.SObject(this.SFDataBaseName);
			account.Id = this.loginFields.SFID;
			account.ring__SipSession__c = this.data.sipId;
			this.sipID = this.data.sipId;
			sforce.connection.update([account],this.emptyRespons(undefined, "SIPRegister"));
		}
		else {
			this.loginFields.SIP_ID = this.sipID = this.data.sipId;
		}
        var self = this;
        
        //Delayed sync
        setTimeout(function() {
            self.synchronization();
        }, 2000);
        this.log("SIPRegister");
	},
	SIPRegister_error: function() {
        this.log("SIPRegister_error");
		this.GUI.setStopLight("red");
		this.widgetCore.SIPRegister();
		this.GUI.setStopLight("yellow");
		return;
	},
	//--------------------------------
	//-------- SF integration
	LikeNumbers: function(thisNumber, forLike) {
        this.log("LikeNumbers");
		var tmp = thisNumber.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})/);
		if (tmp != null && tmp.length == 4) {
			forLike.push("'%(" + tmp[1] + ") " + tmp[2] + "-" + tmp[3] + "%'");
			forLike.push("'%" + thisNumber.replace(/[^\d]/g, "") + "%'");
		}
        this.log("LikeNumbers");
	},
    EquelNumbers: function(thisNumber, forLike) {
        this.log("EquelNumbers");
        var tmp = thisNumber.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})/);
        if (tmp != null && tmp.length == 4) {
            forLike.push("'(" + tmp[1] + ") " + tmp[2] + "-" + tmp[3] + "'");
            forLike.push("'" + thisNumber.replace(/[^\d]/g, "") + "'");
        }
        this.log("EquelNumbers");
    },
	SFIntegration: function() {
        this.log("SFIntegration");
		var forLike = [];
		var tmpContacts = {};
		var self = this;
        self.lazy_load(self, function(self, arr, start, stop) {
            for(var i = start; i < stop; ++i) {
                var element = arr[i];
                if (element["Number"] != null) {
                    if(tmpContacts[element["Number"]] == undefined) {
                        self.LikeNumbers(element["Number"], forLike);
                    }
                    tmpContacts[element["Number"]] = element;
                }  
            }
        }, this.contacts, 0, 10, 10, function() {
            if (forLike.length != 0) {
                //SF integration
                //var self = this;
                setTimeout(function() {
                     var query = "SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE " + forLike.join(" OR Phone LIKE ") + " LIMIT 20";
                     sforce.connection.query(query, self.emptyRespons(self.parseSFResult, "SFIntegration: " + query));
                }, 2000);
            }
            else {
                self.GUI.userListAction();
            }
        });
        this.log("SFIntegration");
		/*jQuery.each(this.contacts, function(index, element) {
			if (element["Number"] != null) {
				tmpContacts[element["Number"]] = element;
			}
		});
		jQuery.each(tmpContacts, function(index, element) {
			self.LikeNumbers(element["Number"], forLike);
		});*/
		/*if (forLike.length != 0) {
			//SF integration
			var self = this;
            setTimeout(function() {
			     var query = "SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE " + forLike.join(" OR Phone LIKE ") + " LIMIT 20";
			     sforce.connection.query(query, self.emptyRespons(self.parseSFResult, "SFIntegration: " + query));
            }, 2000);
		}
		else {
			self.GUI.userListAction();
		}*/
	},
	parseSFResult: function(self, result) {
        self.log("parseSFResult");
        var it = new sforce.QueryResultIterator(result);
        
        self.number_href = []
		while(it.hasNext()) {
			var record = it.next();
            self.number_href[record.Phone.replace(/[^\d]/g, "")] = Config.root + record.Id;
			/*jQuery.each(self.contacts, function(index, element) {
				if(element["Number"] == record.Phone.replace(/[^\d]/g, "")) {
					self.contacts[index]['href'] = Config.root + record.Id;
				}
			});*/
		}
		self.GUI.userListAction();
        self.log("parseSFResult");
	},
	contactSFinfo: function(number) {
        this.log("contactSFinfo");
		var forLike = [];
		this.LikeNumbers(number, forLike);
		//SF integration
		if (forLike.length > 0) {
			var self = this;//MobilePhone  HomePhone   OtherPhone AssistantPhone
			var query = "SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE " /*Account.Name,*/
			+ forLike.join(" OR Phone LIKE ") 
			+ " OR MobilePhone LIKE " + forLike.join(" OR MobilePhone LIKE ") 
			+ " OR HomePhone LIKE " + forLike.join(" OR HomePhone LIKE ") 
			+ " OR OtherPhone LIKE " + forLike.join(" OR OtherPhone LIKE ") 
			+ " OR AssistantPhone LIKE " + forLike.join(" OR AssistantPhone LIKE ") 
			+ " LIMIT 20";
			sforce.connection.query(query, this.emptyRespons(self.parseSFcontacts, "contactSFinfo: " + query));
            
		}
        this.log("contactSFinfo");
	},
	setOpenContact: function(self, record) {
		jQuery("#openCallingContact").show();
		jQuery("#openCallingContact a").unbind();
		jQuery("#openCallingContact a").bind("click",function() {
            self.GUI.openUrl(Config.root + record.Id);
            self.widgetCore.startReply(self.callerID);
            return false;
		});
		if(record.Account != null) {
			jQuery(".mainn .greyt:eq(1)").html(record.Account.Name);
		}
		else {
			jQuery(".mainn .greyt:eq(1)").hide();
		}
	},
	parseSFcontacts: function(self, result) {
        self.log("parseSFcontacts");
		if (result.size != "0") {
			var it = result;
			if (it.records.length == 0) { //No user 
				jQuery(".mainn .black-text").hide();
				jQuery(".mainn .status:eq(1)").hide();
			}
			else if (result.size == "1") {
					self.setOpenContact(self, it.records);
				}
				else {
					//self.setOpenContact(self, it.records[0]);
					jQuery(".mainn .status:eq(1) .status-bgr").html("").parent().show();
					jQuery.each(it.records, function(item) {
						var record = it.records[item];
						jQuery(".mainn .status:eq(1) .status-bgr").append("<p>" + record.Name + "</p><p>Type:</p><div><a href='#' id='openbut' name='openbut'>Open</a></div><div class='double-border'></div>");
						jQuery(".mainn .status:eq(1) .status-bgr #openbut:last").unbind();
						(function(Id){
							jQuery(".mainn .status:eq(1) .status-bgr #openbut:last").bind("click", function(){
								self.GUI.openUrl(Config.root + Id);
								self.widgetCore.startReply(self.callerID);
								return false;
							});
						})(record.Id);
					});
				}
		}
		else {
			 jQuery(".mainn .black-text").hide();
			 jQuery(".mainn .status:eq(1)").hide();
		}
        self.log("parseSFcontacts");
	},
    /*saveActiveHistory: function() {
        
    },*/
	saveDespositionSF: function(number_time_sess, text) {
        this.log("saveDespositionSF");
		var self = this;
		if (this.mailboxInfo != undefined && this.mailboxInfo.mailboxId) {
			if(number_time_sess != undefined && text != undefined) {  //Save disposition
				var forLike = [];
				jQuery.each(number_time_sess, function(itm) {
					self.EquelNumbers(this["number"], forLike);
				});
				if (forLike.length > 0) {
					try {
                        var result = [];
                        setTimeout(function() {
						    result.push(self.getMultyQueryRes("SELECT Id, LastName, FirstName, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone  FROM Contact WHERE Phone = ", 50, forLike, " OR Phone = "));
                        }, 0);
                        /*setTimeout(function() {
                            result.push(self.getMultyQueryRes("SELECT Id, LastName, FirstName, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone FROM Contact WHERE MobilePhone = ", 50, forLike, " OR MobilePhone = "));
                        }, 0);
                        setTimeout(function() {
                            result.push(self.getMultyQueryRes("SELECT Id, LastName, FirstName, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone FROM Contact WHERE HomePhone = ", 50, forLike, " OR HomePhone = "));
                        }, 0);
                        setTimeout(function() {
                            result.push(self.getMultyQueryRes("SELECT Id, LastName, FirstName, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone FROM Contact WHERE OtherPhone = ", 50, forLike, " OR OtherPhone = "));
                        }, 0);
                        setTimeout(function() {
                            result.push(self.getMultyQueryRes("SELECT Id, LastName, FirstName, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone FROM Contact WHERE AssistantPhone = ", 50, forLike, " OR AssistantPhone = "));
						}, 0);*/
                        
                        var checkResult = function(){
                            if (result.length < 1) {
                                setTimeout(checkResult, 200);
                            }
                            else {
                                var totalResult = {
                                    "done": "true",
                                    "records": []
                                };
                                for (itm in result) {
                                    var elem = result[itm];
                                    if (elem.records != undefined && elem.records.length != 0) {
                                        totalResult.records = totalResult.records.concat(elem.records);
                                    }
                                }
                                saveActiveHistory(self, totalResult, number_time_sess);
                            }
                        }
                        checkResult();
                        
                        var saveActiveHistory = function(self, totalResult, number_time_sess){
                            result = totalResult;
                            
                            if (result.done == "true") {
                                if (result.records == undefined || result.records.length == 0) { //No contacnt - no desposition 
                                //Do nothing
                                }
                                else {
                                    self.GUI.showSButtons();
                                    if (result.records[0] == undefined) {
                                        var record = [result.records];
                                    }
                                    else {
                                        var record = result.records;//temp;
                                    }
                                    if ((typeof self.AddTask == "undefined" || self.AddTask == false)) { //Create new desposition
                                        self.AddTask = true;
                                        var queryObj = [];
                                        var tmp_nt_sess = [];
                                        jQuery.each(number_time_sess, function(itm){
                                            if (number_time_sess[itm].sessionID != undefined) {
                                                jQuery.each(record, function(itm2){
                                                    if (record[itm2].Phone == null) {
                                                        record[itm2].Phone = "";
                                                    }
                                                    if (record[itm2].MobilePhone == null) {
                                                        record[itm2].MobilePhone = "";
                                                    }
                                                    if (record[itm2].HomePhone == null) {
                                                        record[itm2].HomePhone = "";
                                                    }
                                                    if (record[itm2].OtherPhone == null) {
                                                        record[itm2].OtherPhone = "";
                                                    }
                                                    if (record[itm2].AssistantPhone == null) {
                                                        record[itm2].AssistantPhone = "";
                                                    }
                                                    if (number_time_sess[itm].number.indexOf(record[itm2].Phone.replace(/[^\d]/g, "")) != -1 ||
                                                    number_time_sess[itm].number.indexOf(record[itm2].MobilePhone.replace(/[^\d]/g, "")) != -1 ||
                                                    number_time_sess[itm].number.indexOf(record[itm2].HomePhone.replace(/[^\d]/g, "")) != -1 ||
                                                    number_time_sess[itm].number.indexOf(record[itm2].OtherPhone.replace(/[^\d]/g, "")) != -1 ||
                                                    number_time_sess[itm].number.indexOf(record[itm2].AssistantPhone.replace(/[^\d]/g, "")) != -1) {
                                                        var task = new sforce.SObject("Task");
                                                        var this_time = number_time_sess[itm]['time'].match(/([^T]*)T([^-+Z]*)(-|\+|Z)/);
                                                        var year = this_time[1].match(/([\d]{4})-([\d]{2})-([\d]{2})/);
                                                        var number_format = number_time_sess[itm].number.match(/([\d]{0,3})([\d]{3})([\d]{3})([\d]{4})$/);
                                                        if (number_format != null && number_format.length == 5) {
                                                            number_format = "+" + number_format[1] + " (" + number_format[2] + ") " + number_format[3] + "-" + number_format[4];
                                                        }
                                                        else {
                                                            number_format = number_time_sess[itm].number;
                                                        }
                                                        var direction = "";
                                                        if (typeof number_time_sess[itm]["direction"] != "undefined") {
                                                            var tmp = {
                                                                "Inbound": "Incoming",
                                                                "Outbound": "Outgoing"
                                                            };
                                                            direction = tmp[number_time_sess[itm]["direction"]];
                                                        //Incoming RingCentral call +cc (npa)nxx-xxxx mm-dd-yyyy hh:mm:ss?
                                                        }
                                                        task.Description = task.Subject = direction + " RingCentral call " + number_format + " " + year[2] + "-" + year[3] + "-" + year[1] + " " + this_time[2];
                                                        task.Status = "Completed";
                                                        task.ActivityDate = year[1] + "-" + year[2] + "-" + year[3];
                                                        task.ReminderDateTime = number_time_sess[itm]['time'];
                                                        task.WhoId = record[itm2].Id;
                                                        queryObj.push(task);
                                                        tmp_nt_sess.push(number_time_sess[itm]);
                                                    }
                                                });
                                            }
                                        });
                                        
                                        var getDescr = function(arr) {
                                            var query = [];
                                            for (var i = 0; i < arr.length; i++) {
                                                query.push("'"+arr[i].Description+"'");
                                            }
                                            return query.join(", ");
                                        } 
                                        
                                        
                                        
                                        for (var i = 0; i < queryObj.length; i += 100) {
                                            var success = function(creation_result){
                                                //Check inserted ids
                                                if ((creation_result[0] != undefined && creation_result[0].id != undefined) || creation_result.id != undefined) {
                                                    var desp = [];
                                                    jQuery.each(creation_result, function(itm){
                                                        if (tmp_nt_sess[itm].sessionID != undefined) {
                                                        
                                                            //Save ID of task
                                                            var despos = new sforce.SObject("ring__Disposition__c");
                                                            despos.ring__Task_ID__c = creation_result[0].id != undefined ? creation_result[0].id : creation_result.id;
                                                            despos.ring__ID__c = tmp_nt_sess[itm].sessionID;
                                                            desp.push(despos);
                                                        }
                                                    });
                                                    sforce.connection.create(desp, self.emptyRespons(undefined, "createDesposition"));
                                                    self.AddDisp = false;
                                                    self.AddTask = false;
                                                }
                                            }
                                            var curObjects = queryObj.slice(i, i + 99);
                                            var query = "SELECT Id, Subject FROM Task WHERE Subject IN ("+getDescr(curObjects)+")";
                                            var result = sforce.connection.query(query, {
                                                onSuccess : function(result) {
                                                    var DescArr = [];
                                                    if (result.records != undefined || result.size != "0") {
                                                        result.records = (typeof result.records.length == "undefined") ? [result.records] : result.records;
                                                        for(var j = 0; j < result.records.length; j++) {
                                                            DescArr[result.records[j].Subject] = result.records[j].Id;
                                                            DescArr.length += 1;
                                                        }
                                                    }
                                                    if(DescArr.length > 0) {
                                                        var desp = [];
                                                        for (var j = 0; j < curObjects.length; j++) {
                                                            if (typeof DescArr[curObjects[j].Subject] != "undefined") {
                                                                var despos = new sforce.SObject("ring__Disposition__c");
                                                                despos.ring__Task_ID__c = DescArr[curObjects[j].Subject];
                                                                despos.ring__ID__c = tmp_nt_sess[j].sessionID;
                                                                desp.push(despos);
                                                                
                                                                curObjects.splice(j, 1);
                                                            }
                                                        }
                                                        //Save ID of task
                                                        sforce.connection.create(desp, self.emptyRespons(undefined, "createDesposition"));    
                                                    }
                                                    if (curObjects.length > 0) {
                                                        var creation_result = sforce.connection.create(curObjects, {
                                                            onSuccess: success,
                                                            onFailure: function(res){
                                                            }
                                                        });
                                                    }
                                                },
                                                onFailure : function(res) {}
                                            }); 
                                             //, self.emptyRespons(self.parseCreationSF)
                                        }
                                    }
                                }
                            }
                        }
					}
					catch(e) {
						var stack = JSON.stringify(e);
						if(typeof ErrorHolder == "function") {
							ErrorHolder({'code':"SF001",'text':e, "stack":stack});
						}
						else {
							//alert("SF Error");
						}
					}
				}
			}
		}
        this.log("saveDespositionSF");
	},
    getMultyQueryAssin: function(query, step, where, delimeter) {
        this.log("getMultyQueryAssin");
        //Check query
        var end = (typeof step != 'undefined') ? step :100;
        var delimeter = (typeof delimeter != 'undefined') ? delimeter : " OR ";
        var begin = 0;
        var tmpArr = [];
        var counter = {"succ":0, "doloop":0};
        var result = {records:[],done:"true"};
        if(typeof where == 'undefined' || typeof query == 'undefined') {
            this.log("getMultyQueryAssin");
            return result;
        }
        
        var success = function(res) {
            if (res.size != "0") {
                result.records = result.records.concat(res.records);
                result.done = "true";
                counter.succ += 1;   
            }
        }
        var error = function(res) {}
        do {
            tmpArr = where.slice(begin, end);
            var sql = query + where.join(delimeter);
            var tmp_result = sforce.connection.query(sql, {
                onSuccess : success,
                onFailure : error
            }); 
            
            begin = end;
            end += step;
            counter.doloop += 1;
        } while (tmpArr.length >= end);
               
        this.log("getMultyQueryAssin");
        return result;
    },
	getMultyQueryRes: function(query, step, where, delimeter) {
        this.log("getMultyQueryRes");
		//Check query
		var end = (typeof step != 'undefined') ? step :100;
		var delimeter = (typeof delimeter != 'undefined') ? delimeter : " OR ";
		var begin = 0;
		var tmpArr = [];
		var result = {records:[],done:"true"};
		if(typeof where == 'undefined' || typeof query == 'undefined') {
            this.log("getMultyQueryRes");
			return result;
		}
		do {
			tmpArr = where.slice(begin, end);
			var sql = query + where.join(delimeter);
			var tmp_result = sforce.connection.query(sql); 
			if (tmp_result.size != "0") {
				result.records = result.records.concat(tmp_result.records);
				result.done = "true";
			}
			begin = end;
			end += 100;
		} while (tmpArr.length >= end);
        this.log("getMultyQueryRes");
		return result;
	},
	getPickVals: function(table,field) {
		var sql = "SELECT "+field+" FROM "+table;
		try {
			var result = sforce.connection.query(sql);
		}
		catch(e) {
			var stack = JSON.stringify(e);
			if(typeof ErrorHolder == "function") {
				ErrorHolder({'code':"SF002",'text':e, "stack":stack});
			}
			else {
				//alert("SF Error");
			}
			return undefined;
		}
		var ret = [];
		if(result.done == "true") {
			jQuery.each(result.records, function(itm) {
				ret.push(this[field]);
			})
		}
		return ret;
	},
	despositionSFinfo: function(info) {   //number of ID
	    this.log("despositionSFinfo");
		var self = this;
		if(this.mailboxInfo != undefined && this.mailboxInfo.mailboxId) {
			var ID = (info["ID"] != undefined) ? info["ID"] : null;
			var Number = (info["Number"] != undefined) ? info["Number"] : null;
			var userID = this.mailboxInfo.mailboxId.content;
			if(ID != null) {   //
				var sql = "SELECT Id, LastName, FirstName, Phone, Fax, MobilePhone, \
							(SELECT Id, Status, Description, CreatedDate FROM Tasks WHERE Id = '"+ID+"') \
							FROM Contact LIMIT 20";
				sforce.connection.query(sql, this.emptyRespons(self.parseSFdespositions, "despositionSFinfo: " + sql));
			}
			else if(Number != null) {   //Return current number record
				var forLike = [];
				self.LikeNumbers(Number, forLike);
				if(forLike.length > 0) {
                    if(self.lCall.result[0] != undefined) {
                        var result = self.lCall.result[0];
                    } else {
                        var result = self.lCall.result;
                    }
					var sql = "SELECT Id, LastName, FirstName, Phone, Fax, MobilePhone, \
								(SELECT Id, Status, Description, CreatedDate FROM Tasks WHERE ReminderDateTime = "+result.callStartTime.content+") \
								FROM Contact WHERE Phone LIKE "+forLike.join(" OR Phone LIKE ")+"  LIMIT 20";
					sforce.connection.query(sql, this.emptyRespons(self.parseSFdespositions, "despositionSFinfo ID null: " + sql));
				}
			} 
		}
        this.log("despositionSFinfo");
	},
	deleteDespositionSF: function(info) {   //only ID!!
		var self = this;
		if(this.mailboxInfo != undefined && this.mailboxInfo.mailboxId) {
			var ID = (info["ID"] != undefined && info["ID"] != "") ? info["ID"] : null;
			if(ID != null) {   //
				//Clear desposition
				sforce.connection.deleteIds([ID]);
				self.showDespositionSF();
			} 
		}
	},
	parseSFdespositions: function(self, result) {
        self.log("parseSFdespositions");
		var it = new sforce.QueryResultIterator(result);
		if(it.records.length == 0) {    //No contacnt - no desposition 
			//Hide disposition select
			jQuery(".tabb.noactivecalls .rc-content .select.sel").css("display", "none");
			jQuery(".tabb.noactivecalls .rc-content .buttonn").css("display", "none");
		}
		else { 
			jQuery(".tabb.noactivecalls .rc-content .select.sel").css("display", "block");
			jQuery(".tabb.noactivecalls .rc-content .buttonn").css("display", "inline");
			var record = it.records[0];
			if(self.text != undefined && (typeof self.AddTask == "undefined" || self.AddTask == false)) {    //Create new desposition
				self.AddTask = true; 
				var task = new sforce.SObject("Task");
				task.Description = task.Subject = self.text;
				task.Status = "Completed";
				task.ReminderDateTime = self.callStart;
				task.WhoId  = record.Id;
				sforce.connection.create([task],self.emptyRespons(self.parseCreationSF, "parseSFdespositions")); 
				
			}
			else {    //Show or delete desposition
				if(record.Tasks != undefined && record.Tasks.size >= 1) {
					var disposition_clear = CheckBox("get", "disposition_clear");
					var ID = (record.Tasks.records[0] == undefined) ? record.Tasks.records.Id : record.Tasks.records[0].Id;
					var Des = (record.Tasks.records[0] == undefined) ? record.Tasks.records.Description : record.Tasks.records[0].Description;
					if(disposition_clear != null) {
						disposition_clear = disposition_clear.split("__");
						
						if(disposition_clear.length == 2 && disposition_clear[1] == "true" && disposition_clear[0] == ID) {   //ID the same
							//Clear desposition
							sforce.connection.deleteIds([ID]);
							self.showDespositionSF();
						} 
					} 
					self.hideDespositionSF(ID, Des, record.Tasks);
					
				}
				else {
					jQuery("#clear").hide();
					self.showDespositionSF();
				}
			}
		} 
        self.log("parseSFdespositions");
	},
	parseCreationSF: function(self, result) {
        self.log("parseCreationSF");
		if((result[0] != undefined && result[0].id != undefined) || result.id != undefined) {
			self.hideDespositionSF((result[0].id != undefined? result[0].id : result.id), self.text);
		}
		self.text = undefined;
		self.callStart = undefined;
		self.callNumber = undefined;  
		//Save ID of task
		var despos = new sforce.SObject("ring__Disposition__c");
		despos.ring__Task_ID__c = result[0].id != undefined? result[0].id : result.id;
		despos.ring__ID__c = self.lCall.result.sessionId.content;
		sforce.connection.create([despos],self.emptyRespons(undefined, "parseCreationSF"));
		self.AddDisp = false;
		self.AddTask = false; 
        self.log("parseCreationSF");
	},
	hideDespositionSF: function(ID, Des) {
		CheckBox("save", "disposition_clear", ID);
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel a:first").hide();
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel ul").hide();
		jQuery("#rc-panel .noactivecalls .rc-content .buttonn #set").hide();
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel").removeClass("select").css({"margin-left": "4px"}).append("<strong>Desposition: "+Des+"</strong>");
						 
	},
	showDespositionSF: function() {
		jQuery("#rc-panel .noactivecalls .rc-content .buttonn #set").show();
		jQuery("#rc-panel .noactivecalls .rc-content .sel").addClass("select");//.append("<strong>Desposition: "+Des+"</strong>");
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel a:first").show();
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel ul").next().remove();
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel ul").css("display", "");
	},
	createSFAccount: function() {
		var self = this;
		if(typeof self.loginFields.ringnum != 'undefined') {
			var account = new sforce.SObject(self.SFDataBaseName);
			account.ring__SessionID__c = jQuery.cookie('sfwssessionid');
			account.ring__Extension__c = self.loginFields.ringex;
			account.ring__Password__c = self.loginFields.pass;
			account.Name = self.loginFields.ringnum;
			sforce.connection.create([account],self.emptyRespons(self.parseSFid, "createSFAccount"));
		}
		else {
			ErrorHolder({'code' : "CR_SF", 'text' : 'Widget is unable to create new records. Please contact your administrator'});
			//self.GUI.notLogged();
		}
	},
	parseSFid: function(self, result) {
        //if(window.console) console.log(result);
		if((result[0] != undefined && result[0].success=='true') || result.success=='true') {
			self.loginFields.SFID = result.id != undefined && result.id != null? result.id.toString() : (result[0].id != undefined && result[0].id != null? result[0].id.toString() : undefined);
		}
		else {
			ErrorHolder({'code' : "CR_SF", 'text' : 'You had reached the SF Storage Limit. Widget is unable to create new records'});
		}
	},
	updateSFAccount: function() {
        this.log("updateSFAccount");
		var account = new sforce.SObject(Manager.SFDataBaseName);
		if(typeof this.loginFields.SFID != 'undefined' && typeof this.loginFields.SFID != null) {
			account.Id = this.loginFields.SFID;
			account.ring__Settings__c = jQuery.cookie('widget_options');
			sforce.connection.update([account], this.emptyRespons(undefined, "updateSFAccount"));
		}
        this.log("updateSFAccount");
	},
	parseSFLogin: function(self, result) {
        self.log("parseSFLogin");
        var it = new sforce.QueryResultIterator(result);
		if(it.records.length == 0) {    //No user logedin
		    if (jQuery.cookie('sfwssessionid') != null) {
                self.GUI.notLogged();
            }
            else {
                self.createSFAccount();
            }
		}
		else {
			var record = it.next();
			self.loginFields.SFID = record.Id.toString();
			if(record.Name != undefined) {
				self.loginFields.ringnum = record.Name.toString();
				self.loginFields.ringex = (record.ring__Extension__c == null)?"":record.ring__Extension__c.toString();
				self.loginFields.pass = record.ring__Password__c.toString();
				jQuery(".shadow").css({"display":"block"});
                var options = JSON.parse(record.ring__Settings__c);
                if (typeof options.autoLogin != "undefined" && options.autoLogin == true) {
                    self.widgetCore.login(self.loginFields.ringnum, self.loginFields.ringex, self.loginFields.pass);
                } else {
                    self.GUI.notLogged();
                }
			}
			jQuery.cookie("widget_options", record.ring__Settings__c, { path: '/' , expires: 365*100});
			//self.GUI.createDesposition();
			self.GUI.noactiveTab();
			//Delete other with same number
			var ids = new Array();
			while(it.hasNext()) {
				var record = it.next();
				ids.push(record.Id);
			}
			if(ids.length > 0) {
				sforce.connection.deleteIds(ids)
			}
		}
        self.log("parseSFLogin");
	},
	updateSFLogin: function(self, result) {
        self.log("updateSFLogin");
		var it = new sforce.QueryResultIterator(result);
		if(it.records.length == 0) {    //No user logedin
			jQuery.cookie("widget_options", null, { path: '/' });
			self.createSFAccount();
		}
		else {
			var record = it.next();
			var account = new sforce.SObject(self.SFDataBaseName);
			account.Id = record.Id;
			self.loginFields.SFID = record.Id;
			account.ring__SessionID__c = jQuery.cookie('sfwssessionid');
            //Check autoLogin
            var autoLogin = CheckBox("get", "autoLogin");
            var tmp = JSON.parse(record.ring__Settings__c);

            tmp.autoLogin =  (autoLogin!=null && autoLogin) ? true : false;
 
            jQuery.cookie("widget_options", JSON.stringify(tmp), {
                path: '/',
                expires: 365 * 100
            });
                
			self.GUI.createDesposition();
			self.GUI.noactiveTab();
			sforce.connection.update([account],self.emptyRespons(undefined, "updateSFLogin"));
			//Delete other with same number
			var ids = new Array();
			while(it.hasNext()) {
				var record = it.next();
				ids.push(record.Id);
			}
			if(ids.length > 0) {
				sforce.connection.deleteIds(ids)
			}
		}
        self.log("updateSFLogin");
	},
	emptyRespons: function(func, request) {
        this.log("emptyRespons");
		var self = this;
		self.request = request;
		if(func == undefined) {
			var func = function(self, result) {
				if((result[0] != undefined && result[0].success == 'false') || (result.success != undefined && result.success == 'false')) {
					self.displaySFError(self, result);
				}
			};
		}
		var ret = {
			onSuccess : function(result) { return func(self, result); },
			onFailure : function(result) { self.displaySFError(self, result); }
		};
        self.log("emptyRespons");
		return ret;
	},
	displaySFError: function (self, error) {
        self.log("displaySFError");
		if(error.faultcode == "sf:INVALID_SESSION_ID") {
			ErrorHolder({'code' : "relogin", 'text' : "Please, refresh page to continue work with RingCentral Controller"});
			var tmp = document.cookie.match(/sid=([^;]*)/);
			if(typeof tmp[1] != "undefined") {
				__sfdcSessionId = tmp[1];
			}
			self.GUI.userListAction();
		} else if (error.faultcode == "sf:INVALID_TYPE") {
            ErrorHolder({
                'code': "CR_SF",
                'text': "API access for custom objects has not been enabled for the organization or user permissions not set. Contact your salesforce.com administrator."
            });
            self.GUI.notLogged();
        }
		else {
			ErrorHolder({'code' : "SF003", 'text' : self.request + " -||- " + error});
		}
	},
    ControlTab: function() {
        //Do nothing
    },
    ControlTab_error: function() {
        this.GUI.showMaxConnError(this.error);
    },
    log: function(name) {
        /*this.logStor = {};
        var _time = 0;
        if(this.logStor[name] != undefined) {
            _time = this.logStor[name] = ((new Date).getTime()-this.logStor[name]);
            delete this.logStor[name];
        } else {
            this.logStor[name] = (new Date).getTime();
        }
        ErrorHolder({'code' : "TIME_LOG", 'text' : name+" run at "+(new Date).toTimeString() + " ms: " + _time});*/
    },
    lazy_load: function(self, FUNC, ARR, START, STOP ,timeOut, callback) {
        var innerFUNC = (function(self, FUNC, ARR, START, STOP ,timeOut, callback) {
            return function() {
                var step = STOP - START;
                
                if(ARR.length < STOP) {
                    FUNC(self, ARR, START, ARR.length);
                    if(callback != undefined) {
                        callback();
                    }
                    return;
                } else {
                    FUNC(self, ARR, START, STOP);
                    self.lazy_load(self, FUNC, ARR, STOP, STOP+step, timeOut, callback);
                }
            }
        })(self, FUNC, ARR, START, STOP ,timeOut, callback);
        setTimeout(innerFUNC, timeOut);
    }
}

//--------------------------------
//------- Main 
//--------------------------------


var Manager;
var jQuery = $.noConflict();
(function($) {
  var cache = [];
  // Arguments are image paths relative to the current page.
  $.preLoadImages = function() {
    var args_len = arguments.length;
    for (var i = args_len; i--;) {
      var cacheImage = document.createElement('img');
      cacheImage.src = arguments[i]+"?"+(new Date().getTime());
      cache.push(cacheImage);
    }
  }
})(jQuery);
//Preload images
jQuery.preLoadImages("/resource/1304427584000/ring__wrapper_bgr_top",
                     "/resource/1304427540000/ring__wrapper_bgr",
                     "/resource/1304431486000/ring__wrapper_bgr_bottom",
                     "/resource/1289561653000/ring__rc_logo",
                     "/resource/1304427333000/ring__menu",
                     "/resource/1304427333000/ring__menu",
                     "/resource/1304431406000/ring__round_select",
                     "/resource/1289552208000/ring__images",
                     "/resource/1294758212000/ring__drop_top",
                     "/resource/1294758211000/ring__drop_bgr",
                     "/resource/1294758211000/ring__drop_bot",
                     "/resource/1304431545000/ring__status_header",
                     "/resource/1304431630000/ring__status_bgr",
                     "/resource/1304431707000/ring__status_bottom",
                     "/resource/1286806434000/ring__bg_buttons",
                     "/resource/1304514330000/ring__button_green",
                     "/resource/1289552208000/ring__img_fax",
                     "/resource/1304599798000/ring__bgr_li_h",
                     "/resource/1304599676000/ring__bgr_li",
                     "/resource/1304599737000/ring__bgr_ul",
                     "/resource/1308238753000/ring__spinner2",
                     "/resource/1290602106000/ring__img_call_n",
                     "/resource/1286884522000/ring__arr_down",
                     "/resource/1286884483000/ring__arr_up",
                     
                     "/resource/1294665344000/ring__MyMP3Player",
                     "/resource/1290189999000/ring__WavPlayer",
                     "/resource/1291371196000/ring__MyGetter",
                     "/resource/1291201132000/ring__pdfSaver",
                     "/resource/1309438865000/ring__hidden_player",
                     "/resource/1290525209000/ring__player_mp3_mini");
                     
jQuery(document).ready(
	function(){
       //----------------------------------------------------------------------------
	   //Log function for all methods
       /*for(fun in rcWidgetMN.prototype) {
            (function(FUN) {
                rcWidgetMN.prototype[FUN+"_super"] = rcWidgetMN.prototype[FUN];
                rcWidgetMN.prototype[FUN] = (function(fun) {
                    return function() {
                        ErrorHolder({'code' : "TIME_LOG", 'text' : fun+" run at "+(new Date).toTimeString()});
                        return rcWidgetMN.prototype[fun+"_super"].apply(this, arguments);
                    }
                })(FUN);
            })(fun);
        }*/
        //----------------------------------------------------------------------------
       
       
        var widget = new rcWidgetCore();
		Manager = new rcWidgetMN(widget);
		Manager.init();
		
		//--------------
		window.onerror = function(error){        };
		document.oncontextmenu = function() {
			return false; //Block context menu
		} 
		document.onmousedown = function(event) {
			try {
				if(event.button == 1) {
					if(event.preventDefault)
						event.preventDefault();
					else
						event.returnValue = false;
					return false;
				}
			}
			catch(e) {}
		}
		//---------------
});

var GTimerFunc = function(start) {
	jQuery("#rc-panel").bind("click dblclick keypress mouseover", function(){
		clearTimeout(GlobalDefaultTimer);
		if(!Manager.GUI.flagStop && start != undefined && start == "start") {
			/*GlobalDefaultTimer = setTimeout(function() { 
				Manager.GUI.showMessages();
			}, 20000);*/
		} 
		if(!Manager.GUI.flagStop && jQuery("#rc-panel .noactivecalls").is(":hidden") && jQuery.cookie('sfwssessionid')!=null && jQuery("#rc-panel .mainn").is(":hidden")) {
			/*GlobalDefaultTimer = setTimeout(function() { 
				Manager.GUI.showMessages();
			}, 20000);*/
		}
	});
};
//Global function for Flash Bridge
var showNumber = function(arg) {
	if (jQuery.cookie('sfwssessionid') != null && jQuery("#rc-panel .stattus").is(":hidden")) {
		clearTimeout(GlobalTimer);
		var accinf_select_ausl = CheckBox("get", "accinf_select_ausl");
		var tmp = arg.toString();
		tmp = tmp.replace(/[^\d*]*/g, '');
        if(tmp.length < 11 && tmp[0] != "1") {
            tmp = "1"+tmp;
        }
		jQuery(".callusother #auslt").val(tmp);
		
		var number_from = CheckBox("get", "accinf_select_calling");
		if (accinf_select_ausl != null && accinf_select_ausl == "true" && number_from != undefined && number_from.indexOf("None") == -1) {
		
			var tmp_number = Manager.getForwardingNumber(Manager, number_from);
			number_from = tmp_number["number_from"].replace(/[^\d*]/g, "");
			
			if (Manager.sipID != null && number_from != "" && typeof Manager.data["return"].ringOutStatus == "undefined") {
				Manager.widgetCore.ringOut(tmp, number_from.replace(/[^\d*]/g, ""));
			}
		}
		else {
			Manager.GUI.showPlaceCall();
		}
		tmp = '';
	}
}
