//--------------------------------
//---------Core Widget Class constructor
//--------------------------------
var rcWidgetCore = function() {
	//Config vars
	var Browser = {
		Version: function() {
			var version = 999; // we assume a sane browser
			if (navigator.appVersion.indexOf("MSIE") != -1) {
				// bah, IE again, lets downgrade version number
				version = parseFloat(navigator.appVersion.split("MSIE")[1]);
			}
			return version;
		}
	}
	this.session = ((jQuery.cookie('sfwssessionid')==null) ? "null" : jQuery.cookie('sfwssessionid'));
	this.sipID = ((jQuery.cookie('sfwssipid')==null) ? "null" : jQuery.cookie('sfwssipid'));
	this.parseFunction = null;
	//Connection vars
	var browser = Browser.Version() ;
	var Url = "https://sfwidget.ringcentral.com:8124";
	//var Port = 8001;
	//var Url = "https://ringcentral3.anything3d.com:8124";
	var Port = 8124; 
	//var Url = "193.104.181.50";
	//var Port = 8124; 
	
	
	var Secure = true;

	
	//var Params = [/*'websocket',*/ 'xhr-multipart', 'flashsocket', 'xhr-polling', 'htmlfile', 'jsonp-polling'];
	
	var Params = ['xhr-polling', 'jsonp-polling'];
	
	
	/*if('XDomainRequest' in window) {
		
		Params = ['xhr-polling', 'flashsocket', 'htmlfile', 'jsonp-polling', 'xhr-multipart'];
	}
	else if(browser == 7 && browser != 999 && browser != 9) {
		
		Params = ['jsonp-polling', 'flashsocket', 'xhr-polling', 'htmlfile'];
	}*/
	
	
	this.socket = io.connect(Url, {transports : Params});
	/*this.socket = new io.Socket(Url, {
								port: Port, 
								rememberTransport: false,
								transports : Params, secure:Secure}); */ //
	this.RequestConf = {};
	this.accountInfo = {};
	this.connectionCount = 0;
	
	//Set handles
	this.setHandles();
	//this.socket.connect();
	
	this.connectionProblem = function() {
		//Show connection error
		jQuery(".shadow").css("display", "none");
		jQuery("#Logout").parent().after("<span id='connectionProblem' class='message-alert' style='color:red; text-align: center; display: block;'>Sorry, cannot establish the connection to the server. Please check your firewall to allow connection to "+Port+" port or request the system administrator.<br/></span>");
	};
	var self = this;
	this.connectStat = setTimeout(function() {
		self.connectionProblem();
	}, 60000);
    this.reconnection = null;
    this.shadowStart = null;
	this._unload = false;
	this._logout = false;
    this.FullDisconnaction = false;
}

jQuery(window).bind('unload', function() {
	rcWidgetCore._unload = true; 
});

//--------------------------------
//------- Common Widget Class methods
//--------------------------------
rcWidgetCore.prototype = {
	setHandles: function() {
		var self = this;
		this.socket.on('connect', function() {self.connect();});
		this.socket.on('message', function(obj) {self.message(obj);});
		this.socket.on('disconnect', function() {self.disconnect();});
        this.socket.on('connect_failed', function(reason) {self.onerror(reason);});
        this.socket.on('reconnect_failed', function(reason) {self.onerror(reason);});
	},
	getResponse: function() {
		this.socket.send(JSON.stringify(this.RequestConf));
	},
    onerror: function(reason) {
        //alert(reason);
        //this.ErrorLog('InCore', this.session.toString(), "On error start");
        //self.socket.connect();
    },
	connect: function() {
		//this.ErrorLog('InCore', this.session.toString(), "Connection start");
		clearTimeout(this.connectStat);
        clearTimeout(this.reconnection);
        clearTimeout(this.shadowStart);
		jQuery("#connectionProblem").remove();
		this.RequestConf = {
			"method" : "isAutorized", 
			"data" : { 
				"sessionId": this.session.toString(),
				"sipId": this.sipID.toString()
			} 
		}
		this.getResponse(); //Send default Request
		/*var self = this;
        var _connect = function() {
            self.socket.connect();
            setTimeout(_connect, 10000);
        }
        setTimeout(_connect, 10000);*/
	},
	disconnect: function() {
		//this.ErrorLog('InCore', this.session.toString(), "Disconnection");
		var self = this;
        if(self.FullDisconnaction) {
            return -1;
        }
        self.shadowStart = setTimeout(function() {
            jQuery(".shadow").css({"display":"block"});
        }, 2000);
        if(this._logout) {
			this._unload = true;
			jQuery(".tabb").hide();
			jQuery(".accinfo").hide();
			//jQuery(".shadow").css({"display":"block"});
			document.location.reload();
		}
		else { 
			if(this._unload==false) {
				//jQuery(".shadow").css({"display":"block"});
                //Try to reconnect
                /*var _reconnect = function() {            
                    self.socket.connect();
                    self.reconnection = setTimeout(_reconnect, 1000);
                }
                self.reconnection = setTimeout(_reconnect, 1000);*/
				self.socket.socket.connect();
                self.connectStat = setTimeout(function() {
					self.connectionProblem();
                    //clearTimeout(self.reconnection);
				}, 60000);
				this._unload = false;
			} else {
                jQuery(".shadow").css({"display":"block"});
                self.socket.socket.connect();
                self.connectStat = setTimeout(function() {
                    jQuery(".shadow").css({"display":"block"});
                }, 2000);
            }
		}
	},
	message: function(obj) {
		try {
			try { //Valid JSON
				mes = JSON.parse(obj);
			} catch(e) {
				return;
			}
			
			//Set session ID
			if(mes.data && mes.data.sessionId != undefined && mes.data.sessionId.length > 0) {
				jQuery.cookie('sfwssessionid', mes.data.sessionId, { expires: 365, path: '/' });
				this.session = mes.data.sessionId;
			} 
			//Set sip ID
			if(mes.data && mes.data.sipId != undefined && mes.data.sipId.length > 0) {
				jQuery.cookie('sfwssipid', mes.data.sipId, { expires: 365, path: '/' });
				this.sipID = mes.data.sipId;
			} 
			//Parse response
			if(mes.method && mes.method != "") {
                if (mes.method == "ControlTab") {
                    this.FullDisconnaction = true;
                    this.socket.disconnect();
                }
                this.parseFn(mes.method, mes.data, mes.error);
			}
		}
		catch(e) {
			var text = e;
			var stack = JSON.stringify(e);
			if(typeof ErrorHolder == "function") {
				ErrorHolder({'code':"Core",'text':text, "stack":stack});
			} else {
				//alert(text);
			}
		}
	},
	parseFn: function(name, mixed, error) {
		if(typeof mixed != "undefined") {
			return this.parseFunction(name, mixed, error);
		} else {
			throw("Got error - {Method: "+name+", Code:"+error.code+", Text:"+error.text+"}");
		}
	},
	unsupportedFunc: function(funcs) {
		var self = this;
		if(funcs != undefined && funcs.length > 0) {
			for (var it = 0; it < funcs.length; it++) {
				if(this[funcs[it]] != undefined) {
					var Name = funcs[it];
					(function(Name) {
						self[Name] = function() {
							var text = "Function "+Name+" is no supported";
							//return false;
							if(typeof ErrorHolder == "function") {
								ErrorHolder({'code':"Core",'text':text});
							} else {
								//alert(text);
							}
                            
						};
                        self[Name+"_check"] = function() {
                            return false;
                        };
					})(Name);
				}
			}
		}
	},
    navigatorPars:function() {
        var fuilds = ["appCodeName", "appMinorVersion", "appName", "appVersion", "cookieEnabled", "cpuClass", "onLine", "opsProfile", "platform", "systemLanguage", "userAgent", "userLanguage"];
        var _nav = {clientVersion: "2.17"};
        for (var i = 0; i < fuilds.length; i++) {
            if(navigator[fuilds[i]] != undefined) {
                _nav[fuilds[i]] = navigator[fuilds[i]];
            } else {
                _nav[fuilds[i]] = "";
            }
        }
        return _nav;
    },
	//--------------------------
	//---Request functions----
	//--------------------------
	//Authenticator API
	getStatus: function() {
		this.RequestConf = {
			"method" : "isAutorized", 
			"data" : { 
				"sessionId": this.session.toString(),
				"sipId": this.sipID.toString(),
			} 
		}
		this.getResponse();
	},
	login: function(login, pin, password) {
		//"sessionId" : "null",//this.session.toString(),
		//"sipId" : "null"//this.sipID.toString()
		this.RequestConf = { 
			"method" : "subscriberLogin" , 
			"data" : { 
				"login" : login.toString(), 
				"pin" : pin.toString(), 
				"password" : password, 
				"sessionId" : this.session.toString(),
				"sipId" : (this.sipID!=null) ? this.sipID.toString() : "null",
                "navigator": this.navigatorPars()
			} 
		}
		this.getResponse();
	},
	logout: function() {
		jQuery.cookie('sfwssessionid', null, { path: '/' });
		jQuery.cookie('sfwssipid', null, { path: '/' });
		this.RequestConf = {
			"method" : "LogOff", 
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.sipID = "null";
		this.session = "null";
		this._logout = true;
		this.getResponse();
	},
	//Messages API
	getMessage: function(messageId) {
		this.RequestConf = {
			"method" : "getMessage", 
			"data" : { 
				"messageId": messageId.replace(/[^\d]/g, ""),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	GetMessage: function(messageId, flag, ext) {
        if (this.GetMessage_check != undefined && !this.GetMessage_check()) {
            this.RequestConf = {
                "method" : "getMessage", 
                "data" : { 
                    "messageId": messageId.replace(/[^\d]/g, ""),
                    "sessionId" : this.session.toString()
                } 
            }
        }
        else {
            this.RequestConf = {
                "method": "GetMessage",
                "data": {
                    "messageType": (flag != undefined && flag == "messageVoice") ? 1 : 2, //1 - voice, 2 - fax
                    "ext": ext.toString(),
                    "messageId": messageId.replace(/[^\d]/g, ""),
                    "sessionId": this.session.toString()
                }
            }
        }
		this.getResponse();
	},
	getList: function() {
        if (this.GetMessagesList_check != undefined && !this.GetMessagesList_check()) {
            this.RequestConf = {
                "method": "listMessages",
                "data": {
                    "folderType": "Inbox",
                    "sessionId": this.session.toString()
                }
            }
        } else {
            this.RequestConf = { 
                "method" : "GetMessagesList" , 
                "data" : { 
                    "sessionId" : this.session.toString()
                } 
            }
        }
		this.getResponse();
	},
    GetMessagesList: function() {
        this.RequestConf = { 
            "method" : "GetMessagesList" , 
            "data" : { 
                "sessionId" : this.session.toString()
            } 
        }
        this.getResponse();
    },
	deleteMessage: function(messageId) {
		this.RequestConf = { 
			"method" : "deleteMessage" , 
			"data" : { 
				"messageId" : messageId.replace(/[^\d]/g, ""),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	DeleteMessage: function(messageId, flag) {
        if (this.DeleteMessage_check != undefined && !this.DeleteMessage_check()) {
            this.RequestConf = { 
                "method" : "deleteMessage" , 
                "data" : { 
                    "messageId" : messageId.replace(/[^\d]/g, ""),
                    "sessionId" : this.session.toString()
                } 
            }
        }
        else {
            this.RequestConf = {
                "method": "DeleteMessage",
                "data": {
                    "messageType": (flag != undefined && flag == "messageVoice") ? 1 : 2, //1 - voice, 2 - fax
                    "messageId": messageId.replace(/[^\d]/g, ""),
                    "sessionId": this.session.toString()
                }
            }
        }
		this.getResponse();
	},
	//RingOut API    
	ringOut: function(number, number_from) {
		number = number.replace(/[^\d*]/g, "");  //Check number
		number = (number.length >= 11) ? number: "1"+number;
		number_from = (number_from.length >= 11) ? number_from: "1"+number_from;
		this.RequestConf = { 
			"method" : "RingOut_callAndGetFirstStatus" , 
			"data" : { 
				"to" : number ,
				"from" : number_from,
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ringCall: function(number) {
		number = number.replace(/[^\d*]/g, "");  //Check number
		number = (number.length >= 11) ? number: "1"+number;
		this.RequestConf = { 
			"method" : "RingOut_call" , 
			"data" : { 
				"to" : number ,
				"prompt" : "0",
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ringOutStat: function(rosessionID) {
		this.RequestConf = { 
			"method" : "RingOut_status" , 
			"data" : { 
				"rosessionId" : rosessionID.replace(/[^\d]/g, ""),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ringOutCancel: function(rosessionID) {
		this.RequestConf = { 
			"method" : "RingOut_cancel" , 
			"data" : { 
				"rosessionId" : rosessionID.replace(/[^\d]/g, ""),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ringOutList: function() {
		this.RequestConf = { 
			"method" : "RingOut_list" , 
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	//iPhone API
	getAccount: function() {
		this.RequestConf = { 
			"method" : "getAccountInfo" , 
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	getMailBox: function() {
		this.RequestConf = { 
			"method" : "getMailboxInfo" , 
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ErrorLog: function(name, number, log) {
		this.RequestConf = { 
			"method" : "ErrorLog" , 
			"data" : { 
				"name" : name.toString(),
				"number" : number.toString(),
				"log" : log,
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	setDND: function(status) {
		this.RequestConf = { 
			"method" : "setDND" , 
			"data" : { 
				"dnd" : status.toString(),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	setAgent: function(status, state) {
		var Status = (status.toString().toUpperCase() == "OFFLINE") ? "Offline" : "Online";
		var State = (state.toString().toUpperCase() == "AGENT") ? "Agent" : "Normal";
		this.RequestConf = { 
			"method" : "setAgent" , 
			"data" : { 
				"agentStatus" : Status,
				"queueState" : State,
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	getGreeting: function() {
		this.RequestConf = { 
			"method" : "getCustomGreeting" , 
			"data" : { 
				"greetingType" : "Introductory",
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	getGreetings: function() {
		this.RequestConf = { 
			"method" : "getGreetingsInfo",
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	setGreeting: function() {
		this.RequestConf = { 
			"method" : "setCustomGreeting",
			"data" : { 
				"greetingType" : "Introductory" , 
				"greetingData" : "Wellcome To RingCentral" , 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	setDefGreeting: function() {
		this.RequestConf = { 
			"method" : "setDefaultGreeting" , 
			"data" : { 
				"greetingType" : "Introductory",
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	//CallLog API
	getCallLog: function(startDate, endDate, phoneNumber, recordStart, recordCount) {
		var _recordStart = (recordStart == undefined || recordStart < 1) ? 0 : recordStart;
		var _recordCount = (recordCount == undefined || recordCount < 1) ? 10 : recordCount;
		var _phoneNumber = (phoneNumber == undefined) ? "" : phoneNumber.replace(/[^\d]/g, "");
		this.RequestConf = { 
			"method" : "getCallLog" , 
			"data" : { 
				"detailView" : "false",
				"startRecord" : _recordStart,
				"recordCount" : _recordCount,
				"startDate" : startDate.toString()+"T00:00:00",
				"endDate" : endDate.toString()+"T23:59:59",
				"phoneNumber" : _phoneNumber,
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	//SIP API
	forwardNumber: function(id, type, phone) {
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id.toString(),
					"action" : "10",
					"type" : (type == undefined || type < 1) ? 1 : parseInt(type),
					"phone" : phone.replace(/[^\d]/g, "")
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	sendToVoiceMail: function(id) {
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id.toString(),
					"action" : "11"
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	SIPRegister: function(id) {
		//{ "method" : "SIPRegister" , "data" : { "sessionId" : "" , "sipId" : "null" } }
		this.RequestConf = { 
			"method" : "SIPRegister" , 
			"data" : { 
				"sipId" : this.sipID.toString(),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	cantGetCall: function(id) {
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id.toString(),
					"action" : "15"
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	rejectCall: function(id) {
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id.toString(),
					"action" : "12"
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	startReply: function(id) {
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id.toString(),
					"action" : "13"
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	replyMethod: function(id, type, time, period, body) {
		var type = (type == undefined || type > 5 || type < 1) ? 3 : parseInt(type);
		var time = (time == undefined || time < 1) ? 10 : parseInt(time);
		var period = (period == undefined || period > 3 || period < 1) ? 1 : parseInt(period);
		var body = body;
		switch(type) {
			case 3:
				time = 0;
				period = 0;
				body = "";
				break
			case 4:
				time = 0;
				period = 0;
				body = "";
				break;
			case 5:
				time = 0;
				period = 0;
				break;
		}
		this.RequestConf = { 
			"method" : "SIPMessage" , 
			"data" : { 
				"notification" : {
					"id": id,
					"action" : "14",
					"type" : type,
					"time" : time,
					"period" : period,
					"body" : body
				},
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	setClientData: function(SFID) {
		this.RequestConf = { 
			"method" : "setClientData" , 
			"data" : { 
				"clientData" : SFID,
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	getClientData: function(id) {
		this.RequestConf = { 
			"method" : "getClientData" , 
			"data" : { 
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	changeMessageStatus: function(messageID, flag) {
		this.RequestConf = { 
			"method" : "changeMessageStatus" , 
			"data" : { 
				"unread" : (flag==undefined)?false:flag,
				"messageId" : messageID.replace(/[^\d]/g, ""),
				"sessionId" : this.session.toString()
			} 
		}
		this.getResponse();
	},
	ChangeMessageReadStatus: function(messageID, flag) {
        if (this.ChangeMessageReadStatus_check != undefined && !this.ChangeMessageReadStatus_check()) {
            this.RequestConf = {
                "method": "changeMessageStatus",
                "data": {
                    "unread": (flag == undefined) ? false : flag,
                    "messageId": messageID.replace(/[^\d]/g, ""),
                    "sessionId": this.session.toString()
                }
            }
        }
        else {
            this.RequestConf = {
                "method": "ChangeMessageReadStatus",
                "data": {
                    "messageType": (flag != undefined && (flag == "messageVoice" || flag == 1)) ? 1 : 2, //1 - voice, 2 - fax
                    "messageId": messageID.replace(/[^\d]/g, ""),
                    "status": "1", //Read
                    "sessionId": this.session.toString()
                }
            }
        }
		this.getResponse();
	}
};
