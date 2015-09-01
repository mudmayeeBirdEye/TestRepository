/*
 * Widget UI Class   
 */


//--------------------------------
//---------UI Widget Class constructor
//--------------------------------
var rcWidgetUI = function(widgetManager) { 
	//Config vars
	this.Manager = widgetManager;
	//this.mp3Tmpl = '<object style="margin: 0px auto; display: block;" tcancelcallype="application/x-shockwave-flash" data="/resource/1290525209000/ring__player_mp3_mini" width="180" height="20"><param name="movie" value="/resource/1290525209000/ring__player_mp3_mini" /><param name="wmode" value="opaque"/><param name="bgcolor" value="#FFFFFF" /><param name="FlashVars" value="url={{FILE}}" /><embed src="/resource/1290525209000/ring__player_mp3_mini" bgcolor="#FFFFFF" width="180" height="20" name="hidden_mp3_player" quality="high" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash" /></object>';
	//this.hidden_mp3Tmpl = '<object id="hidden_mp3_player" type="application/x-shockwave-flash" data="/resource/1290525209000/ring__player_mp3_mini" width="0" height="0"><param name="movie" value="/resource/1290525209000/ring__player_mp3_mini" /><param name="wmode" value="opaque"/><param name="bgcolor" value="#666666" /><param name="FlashVars" value="mp3={{FILE}}&autoplay=1" /></object>';
	
	this.mp3Tmpl =          '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="185" height="27" id="ring_player"       align="middle"><param name="movie" value="/resource/1290525209000/ring__player_mp3_mini"/><param name="allowScriptAccess" value="always" /><param name="quality" value="high" /><param name="scale" value="noscale" /><param name="salign" value="lt" /><param name="bgcolor" value="#F3F3F3"/><param name="wmode" value="opaque"/><param name="FlashVars" value="url={{FILE}}" />           <embed src="/resource/1290525209000/ring__player_mp3_mini" FlashVars="url={{FILE}}" wmode="opaque" bgcolor="#F3F3F3" width="185" height="27" name="ring_player" quality="high" align="middle" scale="noscale" allowScriptAccess="always" type="application/x-shockwave-flash" /></object>';
	
	this.hidden_mp3Tmpl =   '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="1" height="1" id="hidden_mp3_player" align="middle"><param name="movie" value="/resource/1309438865000/ring__hidden_player"/><param name="allowScriptAccess" value="always" /><param name="quality" value="high" /><param name="scale" value="noscale" /><param name="play" value="true"><param name="autostart" value="1"><param name="salign" value="lt" /><param name="bgcolor" value="#F3F3F3"/><param name="wmode" value="opaque"/><param name="FlashVars" value="url={{FILE}}&autoplay=true" /><embed src="/resource/1309438865000/ring__hidden_player" FlashVars="url={{FILE}}&autoplay=true" wmode="opaque" bgcolor="#F3F3F3" width="1" height="1" name="hidden_mp3_player" quality="high" align="middle" scale="noscale" allowScriptAccess="always" play="true" autoplay="true" autostart="true" type="application/x-shockwave-flash" /></object>';
	
	this.Ringtones = [{"name":"World", "url":"/resource/1290511052000/ring__World"},
					  {"name":"Reggae", "url":"/resource/1290510971000/ring__Reggae"},
					  {"name":"Acoustic", "url":"/resource/1290509530000/ring__Acoustic"},
					  {"name":"Beautiful", "url":"/resource/1290509601000/ring__Beautiful" },                     
					  {"name":"Classical", "url":"/resource/1290509693000/ring__Classical"},
					  {"name":"Corporate", "url":"/resource/1290509890000/ring__Corporate"},
					  {"name":"Country", "url":"/resource/1290510081000/ring__Country"},
					  {"name":"Holiday", "url":"/resource/1290510455000/ring__Holiday"},
					  {"name":"Latin", "url":"/resource/1290510647000/ring__Latin"},
					  {"name":"Modern_Jazz", "url":"/resource/1290510739000/ring__Modern_Jazz"},
					  {"name":"Nature", "url":"/resource/1290510826000/ring__Nature"}];
	//---CONSTANTS
	this.DEC = -1;
	this.INC = +1;
	
	//[{"flash_name":'', 'method_name':'', ...},..]
	this.flash_holder = [];
	
	this.flagStop = false;
    
    this.Error = {
        'UserNumber': "Please enter phone number in international format"//"Please fill in correct number"
    };
}




//--------------------------------
//------- Common Widget Class methods
//--------------------------------
rcWidgetUI.prototype = {
	//--------------------------------
	//-------- Common GUI functions
	init: function() {
		jQuery("#Logout").parent().hide();
		jQuery("#rc-panel .accinfo").hide();
		jQuery("#rc-panel .accinfo .slide:first").addClass("close");
		jQuery(".shadow").css({"display":"block"});
		jQuery(".stop").hide();
		//-----
		
		jQuery(".accinfo #phother").hide();
		
		if(jQuery.cookie('sfwssessionid')!=null) {
			//Logout
			var Manager = this.Manager;
			jQuery("#Logout").click(function(event) {
				if(Manager.log_off == true) {
					jQuery(".shadow").css({"display":"block"});
					Manager.widgetCore.logout();
				}
			})
		}
	},
	checkFlash: function() {
		var flashVers = swfobject.getFlashPlayerVersion();
		if(flashVers.major == 0 && flashVers.minor == 0 && flashVers.release == 0) {
			jQuery("#rc-panel .accinfo").hide();
			jQuery(".shadow").css({"display":"none"});
			jQuery("#Logout").parent().after("<span id='connectionProblem' class='message-alert' style='color:red; text-align: center; display: block;'>Please install or enable Flash.<br/></span>");
			return false;
		}
		return true;  
	},
	openUrl: function(url) {
		window.parent.location = url
	},
	changeOrder: function(index, flag) {
		if(flag == this.INC) {
			var total_inputs = jQuery(".dispositions input[name=butdow]").length;
			var true_flag = (index < total_inputs-1);
		} else {
			var true_flag = (index >= 1);
		}
		if(true_flag) {
			var options = CheckBox("get", "dispositions");
			var tmp = options[index+flag];
			options[index+flag] = options[index];
			options[index] = tmp;
			CheckBox("save", "dispositions", options);
			this.createDesposition();   //Create Desposition
			this.noactiveTab();
		}
	},
	despositionButtons: function() {
		var self = this;
		jQuery(".dispositions input[name=butdel]").each(function(index, element) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				var options = CheckBox("get", "dispositions");
				options.splice(index,1);
				CheckBox("save", "dispositions", options);
				self.createDesposition();   //Create Desposition
				self.noactiveTab();
			});
		});
		jQuery(".dispositions input[name=butdow]").each(function(index, element) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				self.changeOrder(index, self.INC);
				return false;
			});
		});
		jQuery(".dispositions input[name=butup]").each(function(index, element) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				self.changeOrder(index, self.DEC);
				return false;
			});
		});
	},
	createDesposition: function() {
		//Disposition
		var options = CheckBox("getAll");
		options.dispositions = this.Manager.getPickVals("TaskStatus", "MasterLabel");
		if(options.dispositions != undefined && options.dispositions.length > 0) {
			jQuery('.accinfo .dispositions table tr:first td:first').html(options.dispositions[0]);
			jQuery('.accinfo .dispositions table tr:gt(0)').remove();
			jQuery.each(options.dispositions, function(item, i) {
				if(item > 0) {
					jQuery('.accinfo .dispositions table tr:first').clone().insertAfter('.accinfo .dispositions table tr:last');
					jQuery('.accinfo .dispositions table tr:last td:first').html(options.dispositions[item]);
				}   
			});
		} else {    //Default disposition
			jQuery('.accinfo .dispositions table tr:first td:first').html("Good");
			CheckBox("save", "dispositions",["Good"]);
		}
		this.despositionButtons();
	}, 
	setOptions: function() {
        this.Manager.log("GUI_setOptions");
		var self = this;
		var Manager = this.Manager;
		if(jQuery.cookie('sfwssessionid')!=null) {
			var options = CheckBox("getAll");
			//Init Call US
            this.Manager.log("GUI_setOptions_1");
			jQuery(".callusother .option-div").html("");
			jQuery(".mainn .option-div:first").html("");
			jQuery(".accinfo .callstab .option-div").html("");
			if(Manager.accountInfo.forwardingNumbers != undefined && Manager.accountInfo.forwardingNumbers.length > 0) {
				jQuery.each(Manager.accountInfo.forwardingNumbers, function(item, i) {
					var appnd = "<p><a href='javascript:;'>"+this.name.content+": <span>"+this.number.content+"</span></a></p>";
					jQuery(".callusother .option-div").append(appnd);
					jQuery(".mainn .option-div:first").append(appnd);
					jQuery(".accinfo .callstab .option-div").append(appnd);
				});
			} else if(Manager.accountInfo.forwardingNumbers != undefined && Manager.accountInfo.forwardingNumbers.name != undefined){
				var appnd = "<p><a href='javascript:;'>"+Manager.accountInfo.forwardingNumbers.name.content+": <span>"+Manager.accountInfo.forwardingNumbers.number.content+"</span></a></p>";
				jQuery(".callusother .option-div").append(appnd);
				jQuery(".mainn .option-div:first").append(appnd);
				jQuery(".accinfo .select.sel:first ul").append(appnd);
			}
			//Add Tails options
			var Other = "<p><a href='javascript:;' class='Other'><span>Other</span></a></p>";
			var None = "<p><a href='javascript:;' class='None'><span>None</span></a></p><div class='option-div-footer'></div>";
			jQuery(".callusother .option-div").append(Other+"<div class='option-div-footer'></div>");
			jQuery(".accinfo .callstab .option-div").append(Other);
			jQuery(".mainn .option-div:first").append(Other+"<div class='option-div-footer'></div>");
			jQuery(".accinfo .callstab .option-div").append(None);
			jQuery(".accinfo .select.sel:eq(1) ul").append(None);
			this.Manager.log("GUI_setOptions_1");
            
            this.Manager.log("GUI_setOptions_2");
			//Ringtones
			jQuery(".accinfo .generaltab .option-div").html("");
			if(this.Ringtones != undefined && this.Ringtones.length > 0) {
				jQuery.each(this.Ringtones, function(item, i) {
					var appnd = "<p><a href='#' class='"+this.url+"'><span>"+this.name+"</span></a></p>"
					jQuery(".accinfo .generaltab .option-div").append(appnd);
				});
				jQuery(".accinfo .generaltab .option-div").append("<p><a href='#' class='None'><span>None</span></a></p>");
				jQuery(".accinfo .generaltab .option-div").append("<div class='option-div-footer'></div>");
			}
            
			self.accountInfoTabs();  //Create tabs slider
			//Create Desposition
			//self.createDesposition();
			
			self.noactiveTab();
			//self.despositionButtons();
            this.Manager.log("GUI_setOptions_2");
            
            this.Manager.log("GUI_setOptions_3");
			//Add default choise for account info
			if(Manager.accountInfo.forwardingNumbers != undefined) {
				if(Manager.accountInfo.forwardingNumbers[0] != undefined) {
					var fNumber = Manager.accountInfo.forwardingNumbers[0];
				} else {
					var fNumber = Manager.accountInfo.forwardingNumbers;
				}
				jQuery(".callusother .select a:first").html(fNumber.name.content+" "+fNumber.number.content)
				if(options.accinf_select_calling != undefined) {
					if (options.accinf_select_calling.indexOf("Other") != -1) {
						jQuery(".accinfo .callstab .select a").html("Other");
						jQuery(".accinfo #phother input[name=phnum]").val(options.accinf_select_calling.replace(/[^\d*]*/g, ''));
						jQuery(".accinfo #phother").show();
						jQuery(".accinfo #phother input[name=phnum]").change(function() {
                            self.numberCheckConn(".accinfo #phother input[name=phnum]", 
                                function(number) {  //Good
                                    self.flagStop = false;
                                    self.changeRingOut("Other <span>"+number['full']+"</span>");
                                },
                                function(number) {  //Bad
                                    self.flagStop = true;
                                }
                            );

						});
					}
					else {
						jQuery(".accinfo #phother").hide();
						jQuery(".accinfo .callstab .select a").html(options.accinf_select_calling);
					}
				}
			}
			var chbox = ["accinfo_chdsca", "accinfo_chocinc"];
			jQuery.each(chbox, function(index, value){
				if(options[value] != undefined && options[value] == true) {
					jQuery(".accinfo .check #"+value.split("_")[1]).parent().addClass("c");
				} else {
					jQuery(".accinfo .check #"+value.split("_")[1]).parent().removeClass("c");
				}
			});
			this.Manager.log("GUI_setOptions_3");
            this.Manager.log("GUI_setOptions_4");
			//Default ringtone
			if(options.accinf_select_ringtones != undefined) {
				jQuery(".accinfo .generaltab .select a").html(options.accinf_select_ringtones);
			}
			
			//RingOut default options
			var changeFunc = function() {
				jQuery(".callusother .select a:first").html("Other");
						
				jQuery(".callusother #auslt-other").unbind();
				jQuery(".callusother #auslt-other").change(function() {
                    self.numberCheckConn(".callusother #auslt-other", 
                        function(number) {  //Good
                            self.flagStop = false;
                            self.changeRingOut("Other <span>"+number['full']+"</span>");
                        },
                        function(number) {  //Bad
                            self.flagStop = true;
                        }
                    );
				});
			}
			if(options.accinf_select_calling != undefined) {
				if (jQuery(".callusother .option-div p").length > 0) {
					if (options.accinf_select_calling.indexOf("Other") != -1) {
						jQuery(".callusother #auslt-other").val(options.accinf_select_calling.replace(/[^\d*]*/g, '')).parent().parent().parent().show();
						changeFunc();
					}
					else {
						jQuery(".accinfo #phother").hide();
						jQuery(".callusother .select a:first").html(options.accinf_select_calling);
					}
				} else {
					jQuery(".callusother .select a:first").html("None");
				}
			}
			
			jQuery(".callusother .option-div p a").each(function(item) {
				jQuery(this).unbind();
				jQuery(this).bind("click", function() {
					var tmp = jQuery(this).html().replace(/Answer using /, "");
					if (tmp.indexOf("Other") != -1) {
						jQuery(".callusother #auslt-other").parent().parent().parent().show();
						jQuery(".callusother .option-div").css("display", "none");
						
						changeFunc();
					}
					else {
						self.changeRingOut(tmp);
						jQuery(".callusother .option-div").css("display", "none");
					}
					return false;
				}); 
			});
			
			if(options.call_us_loc != undefined) {
				if(options.call_us_loc != undefined && options.call_us_loc == false) {
					jQuery(".callusother .check").removeClass("c");
				} else if(options.call_us_loc != undefined && options.call_us_loc == true) {
					/*if(options.accinf_select_calling != undefined) {
						//jQuery(".callusother .select a strong:first").html(options.call_us_loc_select);
						if (jQuery(".callusother .option-div p").length > 0) {
							jQuery(".callusother .select a").html(options.accinf_select_calling);
						} else {
							jQuery(".callusother .select a").html("None");
						}
					}*/
				}
			}
			
			
			if(options.mainn_select != undefined) {
				jQuery(".mainn .select.answer-using a").html(options.mainn_select);
			}
			if(options.mainn_omw_select != undefined) {
				jQuery(".mainn .select.reply a").html("Reply: "+options.mainn_omw_select);
			}
            this.Manager.log("GUI_setOptions_4");
		}
        this.Manager.log("GUI_setOptions");
	},
	parsePhoneNumbers: function() {
		var self = this;
		var Manager = this.Manager;
		if(jQuery.cookie('sfwssessionid')!=null) {
			//Main number
            setTimeout(function() {
                var number = Manager.loginFields.ringnum.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})\*?([\d]{0,5})/);
                if (number[1] != null && number[2] != null && number[3] != null && number[4] != null) {
                    jQuery("#main_numberID").html("(" + number[1] + ") " + number[2] + "-" + number[3]);
                    if (typeof Manager.loginFields.ringex != "undefined") {
                        jQuery("#extentionID").html((Manager.loginFields.ringex != "") ? Manager.loginFields.ringex : "N/A");
                    }
                    else {
                        jQuery("#extentionID").html((number[4] != null && number[4] != "" && number[4] > 0) ? number[4] : "N/A");
                    }
                }
            }, 1000);
            
			//Select method
			jQuery(".callusother .select a").unbind();
			jQuery(".callusother .select a").bind("click", function(event) {
				jQuery(".callusother .option-div").css("display", function(index, value) {
					return (value == "inline") ? "none" : "inline";
				});
				return false;
			});
			//Checkbox 
			jQuery(".callusother .check").unbind();
			jQuery(".callusother .check").bind("click", function(event) {
				jQuery(this).toggleClass("c");
				//CheckBox("save", "call_us_loc",jQuery(this).hasClass("c"));
				CheckBox("save", "accinf_select_ausl",jQuery(this).hasClass("c"));
				var number_from = jQuery(".callusother .select a").html();
				if (jQuery(this).hasClass("c") && number_from != undefined) {  
					CheckBox("save", "accinf_select_calling", number_from);
					jQuery(".accinfo .select a").html(number_from);
				}
				return false;
			});
			//Cancel action
			jQuery(".callusother #cancelcall").unbind();
			jQuery(".callusother #cancelcall").bind("click", function(event) {
                if (jQuery(".callusother #auslt-other:visible").length > 0) {
                    self.numberCheckConn(".callusother #auslt-other", function(number){ //Good
                        self.flagStop = false;
                        self.changeRingOut("Other <span>" + number['full'] + "</span>");
                        self.showMessages();
                        GTimerFunc(); //Init Global action timer
                    }, function(number){ //Bad
                        self.flagStop = true;
                    });
                } else {
                    self.flagStop = false;
                    self.showMessages();
                    GTimerFunc(); //Init Global action timer
                }
                return false;
			});
			//Call action
			jQuery(".callusother #auslt").unbind();
			jQuery(".callusother #auslt").keypress(function() {
				var self = this;
				setTimeout(function() {
					var t = jQuery(self).val().replace(/[^\d*]*/g, '');
					jQuery(self).val(t);
				}, 10);

			});
			jQuery(".callusother #callBackRing").unbind();
			jQuery(".callusother #callBackRing").bind("click", function(event) {
				if(self.flagStop) {
					ErrorHolder({"code":"PFRF", "text":self.Error["UserNumber"]});
					return false;
				}
				
                var accinf_select_ausl = CheckBox("get", "accinf_select_ausl");
				var accinf_select_calling = CheckBox("get", "accinf_select_calling");
				
                //Check number from
                var res_from = true;
				var number_from = jQuery(".callusother .select a").html();
				if (number_from != undefined) {
					if (number_from.indexOf("Other") != -1) {
                        res_from = self.numberCheckConn(".callusother #auslt-other", 
                            function(number) {  //Good
                                jQuery(".callusother #auslt-other").val(number['full']);
                                self.changeRingOut("Other <span>"+number['full']+"</span>");
                            },
                            function(number) {  //Bad 
                            }
                        );
					} else {
						CheckBox("save", "accinf_select_calling", number_from);
					}
					
				}
                //Check number to
                var res_to = false;
                var number_to = jQuery(".callusother #auslt").val();
                if (number_to != undefined) {
                    res_to = self.numberCheckConn(".callusother #auslt", 
                        function(number) {  //Good
                            jQuery(".callusother #auslt").val(number['full']);
                        },
                        function(number) {  //Bad 
                        }
                    );
                } 
				//Manager.updateSFAccount();
				
				if (res_from && res_to && number_from != "" && number_from.indexOf("None") == -1) {
                    //Get number
                    if (number_from.indexOf("Other") == -1) {
                        var tmp = Manager.getForwardingNumber(Manager, number_from);
                        number_from = tmp["number_from"].replace(/[^\d]/g, "");
                    } else {
                        number_from = jQuery(".callusother #auslt-other").val();
                    }
					if (Manager.sipID != null) {
						Manager.widgetCore.ringOut(jQuery(".callusother #auslt").val().replace(/[^\d*]/g, ""), number_from.replace(/[^\d*]/g, ""));
					}
				} else {
                    ErrorHolder({
                        "code": "PFRF",
                        "text": "Please choose your current location number"
                    });
				}
				return false;
			});
		}
	}, 
	/*
	 * From {name,       number, status}
	 * To   {name= null, number, status}
	 */
	changeStatus: function(From, To) {  
		if(typeof From.name != "undefined" && typeof To.name != "undefined") {
			jQuery(".stattus #FromToFrom").html("<strong>From: </strong>"+From.name+" ("+From.number[1]+") "+From.number[2]+"-"+From.number[3]);
            if (!jQuery.isArray(To.number)) {
                jQuery(".stattus #FromToTo").html("<strong>To: </strong> "+To.number);
            }
            else {
                jQuery(".stattus #FromToTo").html("<strong>To: </strong> " + " (" + To.number[1] + ") " + To.number[2] + "-" + To.number[3]);
            }
		}
		if (typeof From.status != "undefined" && typeof To.status != "undefined") {
			jQuery(".stattus #FromToStat").html("<strong>Status: </strong>" + From.status);
			jQuery(".stattus #FromToStatus").html("<strong>Status: </strong>" + To.status);
		}
	},
	notLogged: function() {
        jQuery("#busave").html("Login");
		jQuery("#rc-panel .accinfo .slide.close input").each(function(index) {
			jQuery(this).val("");
		});
        this.messageFlash("hide");
        jQuery(".status-bgr .calls").html("");
		jQuery("#rc-panel .accinfo .slide").removeClass("close");
		jQuery("#rc-panel .accinfo .slide:first").addClass("close").show();
		jQuery("#Logout").parent().hide();
		jQuery(".settings").removeClass('na');
		this.setStopLight("red");
		jQuery(".shadow").css({"display":"none"});
		this.showAccinfo();
		jQuery.cookie('sfwssessionid', null, { path: '/' });
        if(CheckBox("get", "autoLogin")) {
            jQuery("#autologin").parent().addClass("c");
        }
        jQuery("#autologin").parent().unbind();
        jQuery("#autologin").parent().click(function() {
            jQuery(this).toggleClass("c");
            if(jQuery(this).hasClass("c")) {
                alert("For security reasons, please use this option ONLY if this is NOT a shared computer.");
            }
        });
	},
	showMessages: function() {
		var self = this;
		jQuery("#rc-panel .tabb").hide();
		jQuery("#Logout").parent().hide();
		jQuery("#hidden_mp3_player").remove();
		this.messageFlash("hide");
		
		jQuery("#rc-panel .tabb.accinfo #busave").css("display","block");
		jQuery("#rc-panel .tabb.accinfo #busave_spinner").css("display","none");
		
		//jQuery(".stop").hide();
		jQuery("#rc-panel .noactivecalls").show();
		jQuery("#openCallingContact").hide();
		
		if (typeof this.ringToneURL != "undefined") {
			jQuery(".accinfo .play-stop").html(this.mp3Tmpl.replace(/{{FILE}}/g, "https://na7.salesforce.com" + this.ringToneURL));
		}
		//Kastil fe-e-e
		//this.Manager.data["return"].ringOutStatus = undefined;
		//Kastil fe-e-e second edition :)
		try {
			self.Manager.data['return'].ringOutStatus = undefined;
		}
		catch(e) {}
		
		this.restoreMessage();
        
        self.changeRingOut(CheckBox("get", "accinf_select_calling"));
        self.flagStop = false;
                
		
		jQuery(".pcall").html("Messages");
	},
    showButtonSave: function() {
        jQuery("#busave").css({"display":""});
    },
    hideSlide: function(number) {
        jQuery("#busave").html("Save");
        
        var number = (number == undefined || number == null) ? 1 : number;
        switch(number) {
            case 1:
                jQuery("#rc-panel .accinfo .slide:first").hide();
                break;
            default:
                jQuery("#rc-panel .accinfo .slide:first").hide();
        }        
    },
    shadowVisibility: function(flag) {
        var flag = (flag == undefined || flag == null) ? true : flag;
        if(flag) {
            jQuery(".shadow").css({"display":"block"});
        } else {
            jQuery(".shadow").css({"display":"none"});
        }
    },
    showMaxConnError: function(error) {
        jQuery(".shadow").css("display", "none");
        jQuery("#Logout").parent().after("<span id='connectionProblem' class='message-alert' style='color:red; text-align: center; display: block;'>"+error.text+"<br/></span>");
        jQuery("#rc-panel .tabb").hide();  
        jQuery(".rc-menu.round").hide();
    },
	showAccinfo: function() {
	    if(this.ringToneURL != undefined) {
            var ringName = CheckBox("get", "accinf_select_ringtones");
            if (ringName != undefined && ringName != null && ringName.indexOf("None") == -1) {
                jQuery(".accinfo .play-stop").html(this.mp3Tmpl.replace(/{{FILE}}/g, "https://na7.salesforce.com" + this.ringToneURL));
                jQuery(".accinfo .play-stop").css("visibility", "visible");
            }
        } 
        
		jQuery("#rc-panel .tabb").hide();
		jQuery("#rc-panel .accinfo").show();
		jQuery(".pcall").html("Preferences");
		
		jQuery("#rc-panel .tabb.accinfo #busave").css("display","block");
		jQuery("#rc-panel .tabb.accinfo #busave_spinner").css("display","none");
	},
	showPlaceCall: function() {
		jQuery("#rc-panel .tabb").hide();
		jQuery("#rc-panel .callusother").show();
		jQuery("#Logout").parent().css({"display":"none"});
		jQuery(".pcall").html("Place Call");
        
        this.flagStop = false;
	},
	showStatus: function() {
		jQuery("#rc-panel .tabb").hide();
		jQuery("#rc-panel .stattus").show();
        jQuery("#Logout").parent().css({"display":"none"});
		jQuery(".pcall").html("Status");
	},
	showMainn: function() {
        this.messageFlash("hide");
        jQuery("#rc-panel .tabb").hide();
        this.mainnTab();    //If binding was broken
		jQuery("#rc-panel .mainn .multi-contacts").hide();
		jQuery("#rc-panel .mainn").show();
		jQuery(".pcall").html("Calling");
		
		jQuery(".mainn .input #enteryr").parent().parent().parent().parent().parent().hide();
		jQuery(".mainn .input.time").parent().hide();
		
		jQuery(".mainn .option-div:eq(1)").parent().next().next().hide();
		jQuery(".mainn .option-div:eq(1)").parent().next().hide();
		jQuery(".mainn .option-div:first").parent().next().hide();
        
        this.changeRingOut(CheckBox("get", "accinf_select_calling"));  
        this.flagStop = false;       
	},
    messageFlash: function(flag) {
        if(flag == "hide") {
            jQuery(".haxe_pdf, .haxe_wav#num1, .haxe_wav#num2").removeClass("show");
            jQuery("a.stop").hide();
            jQuery(".noactivecalls #callBack, .noactivecalls #openContact").hide();
        } else if(flag == "show") {
            jQuery("a.stop").css("display","block");
            jQuery(".noactivecalls #callBack, .noactivecalls #openContact").css("display","block");
        }
    },
	beenRead: function() {
		var self = this;
		jQuery(".status-bgr .calls div").each(function(event) {
			if (jQuery(this).hasClass("current")) {
				jQuery(this).addClass("gray");
			}
		});
	},
	restoreMessage: function() {
		var self = this;
		jQuery(".status-bgr .calls div").each(function(event) {
			if (jQuery(this).hasClass("current")) {
				jQuery(".noactivecalls #callBack").css("display", "block");
				jQuery("#openContact").css("display", "block");
				if (self.Manager.currentData != undefined && self.Manager.currentExt != undefined) {
					var flag = self.Manager.message_flag[self.Manager.currentExt];
					var wavData = self.Manager.currentData;
					
					//self.messageFlash("hide");
					if (window.navigator.userAgent.indexOf("Mozilla") != -1) {
                        jQuery(flag["show_name"]).addClass("show");  
                    }
                      
                                        
					//var MjQuery = navigator.appName.indexOf("Microsoft") != -1;
					var resoreFlash = function(){
                        setTimeout(function() {
    						//var func = (MjQuery ? window : document)[flag["id"]];
    						var func = self.Manager.getFunc(flag["id"]);
    						if (typeof func[flag["method_name"]] == "undefined" || func[flag["method_name"]] == null) {
    							ErrorHolder({
    								"code": "flash_RM",
    								"text": "Problem with Flash bridge"
    							});
                            //    
    						}
    						else {
    							try {
                                    jQuery(flag["show_name"]).addClass("show");
    								func[flag["method_name"]](wavData);
    								self.flashDisabler();
    								self.flash_holder.push({'flash_name':flag["id"], "method_name":flag["method_name"]});
    							} catch(e) {
    								var text = e;
    								var stack = JSON.stringify(e);
    								if(typeof ErrorHolder == "function") {
    									ErrorHolder({'code':"UI_flash",'text':text, "stack":stack});
    								} else {
    									//alert(text);
    								}
    							}
    						}
    
    						if (self.Manager.data != undefined && 
    							self.Manager.data.inputData != undefined && 
    							(self.Manager.data.inputData.messageId != undefined || self.restoreID != undefined)) {
    								if (self.Manager.data.inputData.messageId != undefined) {
    									self.restoreID = self.Manager.data.inputData.messageId; //Local global variable
    								}
    								(function(ID) {
    									//self.Manager.widgetCore.ChangeMessageReadStatus(self.Manager.data.inputData.messageId, true);
    									jQuery("a.stop").unbind();
    									jQuery("a.stop").show().bind("click", function(){ 
    										if (confirm("Delete this message?")) {
    											self.flashDisabler();
    											self.Manager.widgetCore.DeleteMessage(ID);
    										}
    										return false;
    									});
    								})(self.restoreID);
    						}
                            
    						jQuery(".shadow").css({
    							"display": "none"
    						});
                        }, 2000);
					};
                    swfobject.embedSWF(flag["src"], flag["id"], flag["width"], "27", "9", null, null, 
                        {"quality":"high",
                         "wmode": "opaque",
                         "salign": "lt",
                         "allowScriptAccess": "always",
                         "bgcolor": "#F3F3F3",
                         "scale": "noscale"}, null, resoreFlash);   
					return;
				}
				return;
			}
		});
		//----End Flash
		return;  
	},
	mainnTab: function() {
		var self = this;
		var Manager = this.Manager;
		//Select method
		jQuery(".mainn .select.answer-using a").unbind();
		jQuery(".mainn .select.answer-using a").click(function(event) {
			jQuery(".mainn .option-div:eq(1)").css("display","none");
			Manager.widgetCore.startReply(Manager.callerID);
			jQuery(".mainn .option-div:first").css("display", function(index, value) {
				return (value == "inline") ? "none" : "inline";
			});
			return false;
		});
		//Select method
		jQuery(".mainn .select.reply a").unbind();
		jQuery(".mainn .select.reply a").click(function(event) {
			jQuery(".mainn .option-div:first").css("display","none");
			Manager.widgetCore.startReply(Manager.callerID);
			jQuery(".mainn .option-div:eq(1)").css("display", function(index, value) {
				return (value == "inline") ? "none" : "inline";
			});
			return false;
		});
		//Send to Voicemail
		jQuery(".mainn .select.stv a").unbind();
		jQuery(".mainn .select.stv a").click(function(event) {
			if(Manager.callerID != null) {
				Manager.widgetCore.sendToVoiceMail(Manager.callerID);
				Manager.clearCaller();
			}
			self.showMessages();
			return false;
		});
		//Ignore
		jQuery(".mainn .select.ignore a").unbind();
		jQuery(".mainn .select.ignore a").click(function(event) {
			if(Manager.callerID != null) {
				Manager.widgetCore.rejectCall(Manager.callerID);
				Manager.clearCaller();
			}
			self.showMessages();
			return false;
		});
		//newlead
		jQuery(".mainn #newlead").unbind();
		jQuery(".mainn #newlead").click(function(event) {
			self.openUrl(Config.create_lead);
			return false;
		});
		//newcon
		jQuery(".mainn #newcon").unbind();
		jQuery(".mainn #newcon").click(function(event) {
			self.openUrl(Config.create_contact);
			return false;
		});
		
		//Checkboxes
		jQuery(".mainn .divtime .check").unbind();
		jQuery(".mainn .divtime .check").bind("click" ,function() {
			jQuery(".mainn .divtime .check").removeClass("c");
			jQuery(this).addClass("c");
		});
	
		jQuery(".mainn .option-div:first p a").each(function(item) {    //Answer On
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				self.type = item+1;
				jQuery(".mainn .option-div:eq(1)").parent().next().next().hide();
				jQuery(".mainn .option-div:eq(1)").parent().next().hide();
				var tmp = jQuery(this).html().replace(/Answer using /, "");
				jQuery(".mainn .select.answer-using a").html(tmp);
				CheckBox("save", "mainn_select",tmp);
				jQuery(".mainn .option-div:first").css("display","none");
				if(jQuery(this).html().indexOf("Other") != -1) {
					jQuery(".mainn .option-div:first").parent().next().next().show().find("#forward").click(function() {
                        var t = jQuery(".mainn .option-div:first").parent().next().next().find("input")[0].value;
                        ErrorHolder({"code":"User", "text":t});
                        var number = self.validatePhone(t);
                        
                        if (!number || number['number'].length < 11) {
                            ErrorHolder({"code":"PFRF", "text":self.Error["UserNumber"]});
                            return false;
                        }
						if (Manager.callerID != null) {
							Manager.widgetCore.forwardNumber(Manager.callerID, self.type, jQuery(".mainn .option-div:first").parent().next().next().find("input")[0].value.replace(/[^\d]/g, ""));
						}
						//Should this be here
						Manager.clearCaller();
						self.showMessages();
					});
					jQuery(".mainn .option-div:first").parent().next().next().find("#cancelfor").click(function() {
						jQuery(".mainn .option-div:first").parent().next().next().hide();
					});
					return false;
				} else {
					if (Manager.callerID != null) {
						Manager.widgetCore.forwardNumber(Manager.callerID, self.type, jQuery(this).html().replace(/[^\d]/g, ""));
					}
					//Should this be here
					Manager.clearCaller();
					self.showMessages();
				}
				return false;
			}); 
		});
		jQuery(".mainn .option-div:eq(1) p a").each(function(item) {  //Reply
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				self.type = item+1;
				//divtime
				jQuery(".mainn .option-div:first").parent().next().hide();
				var tmp = jQuery(this).find("span").html();
				jQuery(".mainn .select.reply a").html(tmp);
				CheckBox("save", "mainn_omw_select",tmp);
				jQuery(".mainn .option-div:eq(1)").css("display","none");
				if(tmp == "Other") {
					jQuery(".mainn .option-div:eq(1)").parent().next().next().hide();
					jQuery(".mainn .option-div:eq(1)").parent().next().show();
                    jQuery("#enteryr").unbind();
                    jQuery("#enteryr").change(function() {
                        jQuery("#enteryr").val(jQuery("#enteryr").val().substr(0,200).replace(/[^\d\s\w]/g, "")); 
                    });
					jQuery(".mainn .option-div:eq(1)").parent().next().find("#sendr").click(function() {
						if (Manager.callerID != null) {
							Manager.widgetCore.replyMethod(Manager.callerID, self.type, 0, 0, jQuery(".mainn #enteryr").val());
						}
						//Should this be here
						Manager.clearCaller();
						self.showMessages();
					});
					jQuery("#cancelsendr").click(function() {
						jQuery(".mainn .option-div:eq(1)").parent().next().next().hide();
						jQuery(".mainn .option-div:eq(1)").parent().next().hide();
					});
					return false;
				}
				if(jQuery(this).hasClass("cmbi") || jQuery(this).hasClass("wcyb")) {
					var types = {"hours":2, "minutes":1, "days":3};
					
					jQuery(".mainn .option-div:eq(1)").parent().next().hide();
					jQuery(".mainn .option-div:eq(1)").parent().next().next().show();
					jQuery(".mainn .option-div:eq(1)").parent().next().next().find("#sendtime").click(function() {
						var time = jQuery(".mainn #time_input").val().replace(/[^\d]*/g, '').substr(0,4);
						if (time == "" || parseInt(time) > 999) {
							ErrorHolder({"code":"TIME", "text":"Value should be digital from 1 to 999"});
						}
						else {
							if (Manager.callerID != null) {
								Manager.widgetCore.replyMethod(Manager.callerID, self.type, parseInt(time), types[jQuery(".mainn .divtime .check.c input").attr("id")]);
							}
							Manager.clearCaller();
							self.showMessages();
						}
					});
					var t = jQuery(".mainn input[name=time_input]");
					//jQuery(".mainn input[name=time_input]").undind();
					jQuery(".mainn input[name=time_input]").keypress(function() {
						var self = this;
						setTimeout(function() {
							var t = jQuery(self).val().replace(/[^\d]*/g, '').substr(0,4);
							jQuery(self).val(t);
						}, 10);

					});
					jQuery("#canceltime").click(function() {
						jQuery(".mainn .option-div:eq(1)").parent().next().hide();
						jQuery(".mainn .option-div:eq(1)").parent().next().next().hide();
					});
					return false;
				}
				if (Manager.callerID != null) {
					Manager.widgetCore.replyMethod(Manager.callerID, self.type, jQuery(".mainn #time_input").val(), 10, 2, "Test");//: function(id, type, time, period, body)
				} 
				//Should this be here
				Manager.clearCaller();
				self.showMessages();
				return false;
			}); 
		});
	},
	noactiveTab: function() {
		var self = this;
		var Manager = this.Manager;
		var options = CheckBox("getAll");
		
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel ul li a").each(function(item) {
			jQuery(this).unbind(); 
			jQuery(this).bind("click", function() {
				var tmp = jQuery(this).children().html();
				jQuery("#rc-panel .noactivecalls .rc-content a:first strong").html(tmp);
				//CheckBox("save", "accinf_select_ringtones",tmp);
				jQuery("#rc-panel .noactivecalls .rc-content a").parent().removeClass("selected");
				return false;
			}); 
		});
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel a:first").unbind();
		jQuery("#rc-panel .noactivecalls .rc-content .select.sel a:first").bind("click", function(event) {
			jQuery(this).parent().toggleClass("selected");
			return false; 
		});
		jQuery("#rc-panel .noactivecalls #set").unbind(); 
		jQuery("#rc-panel .noactivecalls #set").bind("click", function() {
			jQuery(this).hide();
			var number = Manager.lCall.result.number.content.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})/);
			var time = Manager.lCall.result.callStartTime.content.match(/[\d]{4}.([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2})/);
			var text = jQuery("#rc-panel .noactivecalls .rc-content .select.sel a:first strong").html();
			Manager.saveDespositionSF(number[1]+number[2]+number[3], text, Manager.lCall.result.callStartTime.content);
			
			setTimeout(function() {
				jQuery("#clear").show();
			}, 1000);
		});
	},
	accountInfoTabs: function() {
		var self = this;
		//Sliders
		jQuery("#rc-panel .accinfo .slide a.tab-header").each(function(index, value) {
			jQuery(this).unbind(); 
			jQuery(this).bind("click", function(event) {
				if(jQuery.cookie('sfwssessionid')!=null) {   //If login
					jQuery("#rc-panel .accinfo .slide").removeClass("close");
					jQuery(this).parent().addClass("close");
				} 
				return false;
			});
		});
		jQuery("#rc-panel .accinfo .slide .closetab").each(function(index, value) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function(event) {
				if(jQuery.cookie('sfwssessionid')!=null) {   //If login
					//jQuery(this).parent().parent().removeClass("close");
					jQuery("#rc-panel .accinfo .slide").removeClass("close");
				}
				return false;
			});
		});
		//
		jQuery(".moretab.slide #butc").unbind();
		jQuery(".moretab.slide #butc").bind("click", function(events) {
			window.open(Config.RC_service);
			return false;
		});
		//For accinfo div
		jQuery(".accinfo .slide").each(function(index, element) {
            jQuery(this).find(".select a").unbind();
			(function(self, UI){
				jQuery(self).find(".select a").bind("click", function(event){
					jQuery(self).find(".option-div").css("display", function(index, value) {
						return (value == "inline") ? "none" : "inline";
					});
					return false;
				});
			})(this, self);
		});
		//Check buttons
		jQuery(".accinfo .callstab .check").unbind();
		jQuery(".accinfo .callstab .check").bind("click", function(event) {
			jQuery(this).toggleClass("c");
			CheckBox("save", "accinfo_"+jQuery(this).children().attr("id"),jQuery(this).hasClass("c"));
			//CheckBox("save", "accinf_select_ausl",jQuery(this).hasClass("c"));
			var number_from = jQuery(".accinfo .select a").html();
			if (jQuery(this).hasClass("c") && number_from != undefined) { 
				if (number_from.search(/Other/) != -1) {
                    //number_from = "Other " + jQuery(".accinfo #phother input[name=phnum]").val();
                    
                    self.numberCheckConn(".accinfo #phother input[name=phnum]", 
                        function(number){ //Good
                            self.flagStop = false;
                            self.changeRingOut("Other <span>" + number['full'] + "</span>");
                        }, function(number){ //Bad 
                            self.flagStop = true;
                    });
                } else {
                    self.flagStop = false;
                    self.changeRingOut(number_from);
                }
				//self.changeRingOut(number_from);/*
				//CheckBox("save", "accinf_select_calling", number_from);
				//jQuery(".callusother .select a").html(number_from);*/
			}
		}); 
		
		jQuery(".accinfo .callstab .option-div p a").each(function(item) {
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				jQuery(".accinfo .callstab .option-div").css("display","none");
					
				if(jQuery(this).hasClass("Other")) {
					var tmp = jQuery(this).html();
					jQuery(".accinfo .callstab .select a").html(tmp);
					jQuery(".accinfo #phother").show();
					jQuery(".accinfo #phother input[name=phnum]").unbind();
					jQuery(".accinfo #phother input[name=phnum]").change(function() {
                        self.numberCheckConn(".accinfo #phother input[name=phnum]", 
                            function(number) {  //Good
                                self.flagStop = false;
                                self.changeRingOut("Other <span>"+number['full']+"</span>");
                            },
                            function(number) {  //Bad 
                                self.flagStop = true;
                            }
                        );
					});
					
				} else {
					self.flagStop = false;
					var tmp = jQuery(this).html();
					self.changeRingOut(tmp);
					
				}
				return false;
			}); 
		});
		var options = CheckBox("getAll");
		jQuery(".accinfo .generaltab .option-div p a").each(function(item) {
			var ringtone_name = (typeof options.accinf_select_ringtones != "undefined") ? options.accinf_select_ringtones.match(/>([^<]*)</) : "None";
			if(ringtone_name && ringtone_name[1] != undefined) {
				ringtone_name = ringtone_name[1];
			} else {
				ringtone_name = (typeof options.accinf_select_ringtones != "undefined") ? options.accinf_select_ringtones : "None";
			}
			if(jQuery(this).attr("class").indexOf(ringtone_name) != -1 && ringtone_name.indexOf("None") == -1) {
				self.ringToneURL = jQuery(this).attr("class");
				jQuery(".accinfo .play-stop").html(self.mp3Tmpl.replace(/{{FILE}}/g, "https://na7.salesforce.com"+jQuery(this).attr("class")));
			} else if(ringtone_name == "None"){
				jQuery(".accinfo .play-stop").css("visibility", "hidden");
			}
			jQuery(this).unbind();
			jQuery(this).bind("click", function() {
				var tmp = jQuery(this).html();
				jQuery(".accinfo .generaltab .select a").html(tmp);
				CheckBox("save", "accinf_select_ringtones",tmp);
				jQuery(".accinfo .generaltab .option-div").css("display", function(index, value) {
					return (value == "inline") ? "none" : "inline";
				});
				jQuery(".accinfo .generaltab #phother").hide();
				if(!jQuery(this).hasClass("None")) {
                    self.flashDisabler();
					var browser = self.Manager.Browser();
					if (browser >= 7 && browser != 999 && browser != 9) {
						jQuery(".accinfo .play-stop").css("visibility", "visible");
						jQuery(".accinfo .play-stop").html(self.mp3Tmpl.replace(/{{FILE}}/g, "https://na7.salesforce.com"+jQuery(this).attr("class")));
						//self.flashDisabler();
						self.flash_holder.push({'flash_name':"#ring_player"});
					}
					else {
						jQuery(".accinfo .play-stop").css("visibility", "visible");
						var func = self.Manager.getFunc("ring_player");
						
						if (typeof func["sendURLFromJS"] == "undefined") {
							ErrorHolder({
								"code": "flash_RingM",
								"text": "Problem with Flash bridge"
							});
						}
						else {
							func["sendURLFromJS"]("https://na7.salesforce.com" + jQuery(this).attr("class"));
						}
						self.flash_holder.push({'flash_name':"#ring_player", 'func':function() {jQuery(".accinfo .play-stop").css("visibility", "hidden");}});
					}
					
				} else {
					jQuery(".accinfo .play-stop").css("visibility", "hidden");
				}
				return false;
			}); 
		});
		
		if(options.accinf_select_ausl != undefined) {
			if(options.accinf_select_ausl == 'true' && options.accinf_select_calling != 'None') {
				jQuery(".ausl").parent().addClass("c")
			}
			else {
				jQuery(".ausl").parent().removeClass("c")
			}
		}
		else {
			jQuery(".ausl").parent().removeClass("c")
		}
		
		jQuery(".ausl").parent().click(function() {
			if(jQuery(this).hasClass("c")) {
				jQuery(".ausl").parent().addClass("c");
				CheckBox("save", "accinf_select_ausl","true");
			}
			else {
				jQuery(".ausl").parent().removeClass("c");
				CheckBox("save", "accinf_select_ausl","false");
			}
		})
	},
    validatePhone: function(phone) {
        var _tp = phone.replace(/(ext|x)/i, "*").replace(/[^\d*]*/g, '');
        var numberAext = _tp.match(/(([^*]*)\*([\d]*))|([\d]*$)/);
        if(numberAext[4] != undefined && numberAext[4] != "") {    //Simple number without Ext
            return {"number":numberAext[4].substr(0,15),
                    "ext":"",
                    "full":numberAext[4].substr(0,15)}
        } else if(numberAext[2] != undefined && numberAext[2] != "") {
            return {"number":numberAext[2].substr(0,15),
                    "ext":numberAext[3].substr(0,5),
                    "full":numberAext[2].substr(0,15)+"*"+numberAext[3].substr(0,5)}
        }
        return false;
    },
    numberCheckConn: function(selector, goodFun, badFun) {
        var _t = jQuery(selector).val();
        ErrorHolder({"code":"User", "text":_t});
        var number = this.validatePhone(_t);
        
        
        if (!number || number['number'].length < 10) {
            ErrorHolder({"code":"PFRF", "text":this.Error["UserNumber"]});      
            jQuery(selector).css("background-color","#FDD");   
            badFun(number);
            return false;
        }
        else {
            if(number['number'].length == 10) {
                number['number'] = "1"+number['number']
            }
            jQuery(selector).css("background-color","");
            goodFun(number);
            return true;
        }
    },
	changeRingOut: function(number) {
		if(number == undefined) {
			return;
		}
		if (number.indexOf("Other") != -1) {
			//Ring Out
			jQuery(".callusother .select a:first").html("Other");    
			jQuery(".callusother #auslt-other").val(number.replace(/[^\d*]*/g, '')).parent().parent().parent().show();
			jQuery(".callusother #auslt-other").css("background-color","");  
			//Accinfo
			jQuery(".accinfo .callstab .select a").html("Other");
			jQuery(".accinfo #phother").show();
			jQuery(".accinfo #phother input[name=phnum]").val(number.replace(/[^\d*]*/g, ''));   
            jQuery(".accinfo #phother input[name=phnum]").css("background-color","");        
		}
		else {  
			jQuery(".callusother .select a:first").html(number);  
			jQuery(".callusother #auslt-other").parent().parent().parent().hide();
			
			jQuery(".accinfo .callstab .select a").html(number);
			jQuery(".accinfo #phother").hide();
		}
		CheckBox("save", "accinf_select_calling", number);
	},
	colorListAction: function() {
		var Manager = this.Manager;
		jQuery(".status-bgr .calls div").removeClass("current");
		jQuery(".status-bgr .calls div").each(function(index, element) {
			var contID = jQuery(this).attr("id").split("_");
            if(Manager.contacts[contID[1]] && Manager.number_href[Manager.contacts[contID[1]].Number] != undefined) {
                Manager.contacts[contID[1]]["href"] = Manager.number_href[Manager.contacts[contID[1]].Number];
            }
            if(Manager.contacts[contID[1]] && Manager.contacts[contID[1]].Number != null && Manager.number_href[Manager.contacts[contID[1]].Number.slice(1)] != undefined) {
                Manager.contacts[contID[1]]["href"] = Manager.number_href[Manager.contacts[contID[1]].Number.slice(1)];
            }
			if(Manager.contacts[contID[1]] && Manager.contacts[contID[1]]["Unread"] == "true") {
				//jQuery(this).children("td:nth-child(2)").css({"font-weight":"bold"});
			}
			if(Manager.contacts[contID[1]] && Manager.contacts[contID[1]]["href"] != undefined) {
				jQuery(this).addClass("green");
			} else if(Manager.contacts[contID[1]] && Manager.contacts[contID[1]]["Unread"] == "false") {
				jQuery(this).addClass("gray");
			} else {
				//jQuery(this).children().css({"color":"#000"});
			}
		});
	},
	
	userListAction: function() {
		var self = this;
		var Manager = this.Manager;
		self.colorListAction();
		jQuery(".shadow").css({"display":"none"});
        //setTimeout(function() {
		//  Manager.synchronization();
        //}, 10000);
		jQuery(".status-bgr .calls div.fax, .status-bgr .calls div.call").unbind();
		jQuery(".status-bgr .calls div.fax, .status-bgr .calls div.call").bind("click dblclick", function(event) {
			if(jQuery(this).hasClass("current")) {
				return;
			}
            self.messageFlash("hide");
			self.colorListAction();
			jQuery(this).addClass("current");
			//jQuery(this).children().css({"color":"#FFF"});
			var contID = jQuery(this).attr("id").split("_");
			if(Manager.contacts[contID[1]] != undefined && Manager.contacts[contID[1]]["Number"] != undefined) {
				var number = Manager.contacts[contID[1]]["Number"]; 
				jQuery(".noactivecalls #callBack").unbind().attr("style","display:block");
				jQuery(".noactivecalls #callBack").bind("click", function(event) {
                    self.flashDisabler();
                    var _num = number.replace(/[^\d]/g, "");
					var number_from = accinf_select_calling = CheckBox("get", "accinf_select_calling");
                    var accinf_select_ausl = CheckBox("get", "accinf_select_ausl");
					if(accinf_select_ausl == null || accinf_select_ausl == "false" || (number_from != undefined && number_from.indexOf("None") != -1) || number_from == undefined || number_from == "") {
                        
						jQuery(".callusother #auslt").val((_num.length < 11) ? "1"+_num : _num);
						self.showPlaceCall();
						return false;
					}
					if(Manager.sipID != null && number_from != "") {
						Manager.widgetCore.ringOut(((_num.length < 11) ? "1"+_num : _num),number_from.replace(/[^\d]/g, ""));
					}
					return false;
				});
			} else {
				jQuery(".noactivecalls #callBack").attr("style","display:none");
			}
			if(Manager.contacts[contID[1]] && Manager.contacts[contID[1]]["href"]) {
				var href = Manager.contacts[contID[1]]["href"];
				jQuery(".noactivecalls #openContact").html("Open Contact");
				jQuery(".noactivecalls #openContact").unbind();
				jQuery(".noactivecalls #openContact").attr("style","display:block").bind("click", function(event) {
					self.openUrl(href);
					return false;
				});
			} else {
				jQuery(".noactivecalls #openContact").html("New Contact");
				jQuery(".noactivecalls #openContact").unbind();
				jQuery(".noactivecalls #openContact").attr("style","display:block").bind("click", function(event) {
					self.openUrl(Config.create_contact);
					return false;
				});
			}
			//Block popup
			jQuery(".shadow").css({"display":"block"});
			setTimeout(function() {
				if(jQuery(".shadow").css("display") == "block") {
					jQuery(".shadow").css({"display":"none"});
				}
			}, 15000);
			if(typeof contID[1] != 'undefined' && typeof Manager.contacts[contID[1]] != 'undefined' && typeof Manager.contacts[contID[1]]["ID"] != 'undefined')
                //self.messageFlash("hide");
                Manager.currentUser = Manager.contacts[contID[1]];
                Manager.currentUser.CurID = contID[1];
				Manager.widgetCore.GetMessage(Manager.contacts[contID[1]]["ID"], Manager.contacts[contID[1]]["Type"], Manager.contacts[contID[1]]["Ext"]);
		});
	},
    logoutButtonAction: function() {
        var Manager = this.Manager;
        jQuery("#Logout").unbind();
        jQuery("#Logout").bind("click", function(event) {
            if(Manager.log_off == true) {
                jQuery(".shadow").css({"display":"block"});
                Manager.widgetCore.logout();
            }
        })  
    },
	saveButtonAction: function() {
		var self = this;
		var Manager = this.Manager;
		jQuery("form#submitform").live("submit", function() {
			if (jQuery("#rc-panel .tabb.accinfo #busave").css("display") != "none") {
				jQuery("#rc-panel .tabb.accinfo #busave").click();
			}
			return false;
		});
		jQuery("#rc-panel .tabb.accinfo #busave").unbind();
		jQuery("#rc-panel .tabb.accinfo #busave").bind("click", function() {
			if(self.flagStop) {
				return false;
			}
			if(jQuery("#rc-panel .accinfo").is(":visible") && jQuery("#rc-panel .accinfo .slide:first").is(":visible")) {
				jQuery("#rc-panel .accinfo .slide.close input").css("background-color", "");
				//Check login
				var alerts = "";
				
				jQuery("#rc-panel .accinfo .slide.close input").each(function(index) {
					var value = jQuery(this).val();
					var name = jQuery(this).attr("name");
					if (name != "autologin") {
						if (name != "ringex" && value == "") {
							jQuery(this).css("background-color","#FDD");
							alerts = "Please fill required fields"
						}
						else {
							var tmp = value.replace(/[^\d]/g, "");
							if (name == 'ringnum') {
								tmp = (tmp.length == 11) ? tmp : "1" + tmp;
							}
							jQuery(this).val(tmp);
							Manager.loginFields[name] = jQuery(this).val();
						}
					}
				});
				if(alerts != "") {
					if(typeof ErrorHolder == "function") {
						ErrorHolder({code:"PFRF", text:alerts});
					} else {
						//alert(alerts);
					}
					return false;
				} else {
                    //Save autologin
                    if(jQuery("#autologin").parent().hasClass("c")) {
                        CheckBox("save", "autoLogin", true);
                    } else {
                        CheckBox("save", "autoLogin", false);
                    }
					jQuery(".shadow").css({"display":"block"});
					//Check sipSession
					try {
						var query = "SELECT Id, ring__SipSession__c FROM " + Manager.SFDataBaseName + " WHERE Name = '" + Manager.loginFields.ringnum.toString() + "'";
						if (Manager.loginFields.ringex.toString() != "") {
							query += "AND ring__Extension__c = '" + Manager.loginFields.ringex.toString() + "'";
						}
						var result = sforce.connection.query(query);
					} catch(error) {
						self.notLogged();
						if(typeof ErrorHolder == "function") {
							if (error.faultcode == "sf:INVALID_SESSION_ID") {
								ErrorHolder({
									'code': "relogin",
									'text': "Please, refresh page to continue work with RingCentral Controller"
								});
							} 
							else if (error.faultcode == "sf:API_DISABLED_FOR_ORG") {
								ErrorHolder({
									'code': "CR_SF",
                                    'text': "API access has not been enabled for the organization. Contact your salesforce.com administrator to enable API access."
								});
							}
                            else if (error.faultcode == "sf:INVALID_TYPE") {
                                ErrorHolder({
                                    'code': "CR_SF",
                                    'text': "API access for custom objects has not been enabled for the organization or user permissions not set. Contact your salesforce.com administrator."
                                });
                            }
							else {
								ErrorHolder({
									code: "UI_SF",
									text: error
								});
							}
						} else {
							//alert(alerts);
						}
						return false;
					}
					if(result.size == "1") {
						Manager.loginFields.SIP_ID = Manager.sipID = Manager.widgetCore.sipID = result.records.ring__SipSession__c;
					}
					var login_fn = function(self) {
						if(Manager.unsupport == true) {
							Manager.widgetCore.login(Manager.loginFields.ringnum.toString(), Manager.loginFields.ringex.toString(), Manager.loginFields.pass.toString());
						} else {
							setTimeout(function() {
								login_fn(self);
							}, 1000);
						}
					};
					setTimeout(function() {
						login_fn(self);
					}, 1000);
				}
				// 
			} else {
				//Save settings
				jQuery("#rc-panel .tabb.accinfo #busave").css("display","none");
				jQuery("#rc-panel .tabb.accinfo #busave_spinner").css("display","block");
				Manager.updateSFAccount();
				
				self.setOptions();
				
				jQuery(".settings").removeClass('na');
				jQuery("#Logout").parent().css({"display":"none"});
				self.noactiveTab();
				Manager.widgetCore.getList(); 
				self.showMessages();
			}
		});
	},
	getStartEndDate: function(func, value) {
		if(typeof func == "undefined" || typeof value == "undefined") {
			var func = "Month";
			var value = 1;
		}
		var ed = new Date();
		var endDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
		if(typeof ed["set"+func] == "function" && typeof ed["get"+func] == "function") {
			ed["set"+func](ed["get"+func]()-value);
		}
		var startDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
		return {"endDate":endDate, "startDate":startDate};
	},
	
	dndButton: function(flag) {
		if(typeof flag == "undefined" || flag == false) {
			jQuery("#rc-panel .dnd .drop-down").fadeOut("slow").parent().removeClass("na");
		} else {
			jQuery("#rc-panel .dnd .drop-down").fadeIn("slow").parent().addClass("na");
		}
	},
	setStopLight: function(name) {
		var names = ["red", "green", "yellow"];
		jQuery("#rc-panel .svetofor").removeClass(names[0]).removeClass(names[1]).removeClass(names[2]);
		if(typeof name != "undefined" && jQuery.inArray(name, names)) {
			jQuery("#rc-panel .svetofor").addClass(name);
		} else {
			jQuery("#rc-panel .svetofor").addClass(names[0]);
		}
	},
    showSButtons: function() {
        jQuery(".tabb.noactivecalls .rc-content .select.sel").css("display", "block");
        jQuery(".tabb.noactivecalls .rc-content .buttonn").css("display", "inline");  
    },
	showCallInfo: function(number, ring_name) {
		//Show data
		jQuery(".last-call").html(); 
		jQuery(".mainn .greyt.last").css("display", "none");
		
		var phoneArr = number.match(/.{0,3}([\d]{3})([\d]{3})([\d]{4})$/);
		jQuery(".mainn .numberr").html("(" + phoneArr[1] + ") " + phoneArr[2] + "-" + phoneArr[3]);
		
		//Start ringtone
		var self = this;
		try {
			var tmp = ring_name.match(/>([^<]*)</);
			if(tmp != null && typeof tmp[1] != 'undefined') {
				ring_name = tmp[1];
			}
			jQuery.each(self.Ringtones, function(item, i){
				if (this.name == ring_name && ring_name != "None") {
                    var tmp = self.hidden_mp3Tmpl.replace(/{{FILE}}/g, "https://na7.salesforce.com" + this.url);
                    jQuery(".mainn #hidden_mp3_player").remove();
					jQuery(".mainn .numberr").before(tmp);
					self.flashDisabler();
					self.flash_holder.push({'flash_name':"#hidden_mp3_player"});
				}
			});
		}
		catch(e) { }
	}, 
	flashDisabler: function() {
        //Flash_name - ID or Name of flash object element
        //method_name - name of stop method of flash external interface
		var self = this;
		for(index in this.flash_holder) {
            thisFlash = this.flash_holder[index];
			var func = self.Manager.getFunc(thisFlash['flash_name']);

			if (typeof thisFlash["method_name"] != 'undefined') {
				if (typeof func[thisFlash["method_name"]] != "undefined" && func[thisFlash["method_name"]] != null) {
					func[thisFlash["method_name"]]("Stop");
				}
			} else {
				//Simple delete flash
				if (typeof thisFlash['func'] != 'undefined') {
					thisFlash['func']();
				} else {
					jQuery(thisFlash['flash_name']).remove();
				}
			}
		}
		this.flash_holder = [];
	}
}