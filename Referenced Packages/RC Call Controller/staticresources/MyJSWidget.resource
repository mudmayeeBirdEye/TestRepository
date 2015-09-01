/*
 * Widget UI Class   
 */

var Config = {
    root: window.location.protocol+"//"+window.location.host+"/", //"https://na7.salesforce.com/",
    RC_service: "https://service.ringcentral.com/",
    create_contact: window.location.protocol+"://"+window.location.host+"/003/e?retURL=/home/home.jsp",
    create_lead: window.location.protocol+"://"+window.location.host+"/00Q/e?retURL=/home/home.jsp"
};

//--------------------------------
//---------UI Widget Class constructor
//--------------------------------
var rcWidgetUI = function(widgetCore) {
    //Config vars
    this.data = null;
    this.error = null;
    this.contacts = []; //id,number,name
    this.loginFields = {};
    this.SFDataBaseName = "ring__RingCentral__c";
    this.SFID = null;
    this.callerID = null;
    this.sipID = null;
    this.mailboxInfo = null;
    this.isAuth = false;
    this.log_off = true;
    this.unsupport = false;
    this.lCall = null;
    this.callFlag = null;
    
    this.widgetCore = widgetCore;
    //Init Core
    var self = this;
    this.widgetCore.parseFunction = function(name, data, error) {self.getFun(name, data, error);};
    
    this.mp3Tmpl = '<object type="application/x-shockwave-flash" data="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" width="170" height="20"><param name="movie" value="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" /><param name="bgcolor" value="#E8E8E8" /><param name="FlashVars" value="mp3={{FILE}}" /><embed src="/resource/1290525209000/ring__player_mp3_mini" bgcolor="#E8E8E8" width="170" height="20" name="hidden_mp3_player" quality="high" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash" /></object>';
    this.hidden_mp3Tmpl = '<object id="hidden_mp3_player" type="application/x-shockwave-flash" data="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" width="0" height="0"><param name="movie" value="https://na7.salesforce.com/resource/1290525209000/ring__player_mp3_mini" /><param name="bgcolor" value="#666666" /><param name="FlashVars" value="mp3={{FILE}}&autoplay=1" /></object>';
    
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
}


//--------------------------------
//------- Tools
//--------------------------------
//Global action timer
var GlobalTimer = "";
var GTimerFunc = function() {
    /*$("#rc-panel").bind("click dblclick keypress", function(){
        clearTimeout(GlobalTimer);
        if($("#rc-panel .noactivecalls").is(":hidden")) {
            GlobalTimer = setTimeout(function() { 
                $(".settings").removeClass('na');
                $("#rc-panel .tabb").hide();
                $("#rc-panel .noactivecalls").show();
                $(".pcall").html("Messages");
            }, 10000);
        }
    });*/
};
//Error Alert
var ErrorHolder = function(error) {
    if(error.code != undefined) {
        alert(error.text);
        /*$("#Logout").after("<span>"+error.text+"</span>");
        setTimeout(function() {
            $("#Logout span").animate({opacity: .5}, 5000, "linear", function(){$(this).remove();} );
        },5000);*/
    } else {
        alert("Error wrong format!");
    }
}
//Save option to cookie
var CheckBox = function(flag, name, value) {
    if($.cookie("widget_options") == null) {
        $.cookie("widget_options", JSON.stringify({options:{}}), { path: '/' , expires: 365*100});
    }
    if(flag == "save") {
        var option = JSON.parse($.cookie("widget_options"));
        option[name] = value;
        $.cookie("widget_options", JSON.stringify(option), { path: '/' , expires: 365*100});
        return true;
    } else if(flag == "get") {
        var option = JSON.parse($.cookie("widget_options"));
        return option[name];
    } else if(flag == "getAll") {
        return JSON.parse($.cookie("widget_options"));
    }
}


//--------------------------------
//------- Common Widget Class methods
//--------------------------------
rcWidgetUI.prototype = {
    getFun: function(name, data, error) {
        if(this.checkFun(name)) {  //Check is function exist
            this.data = data;
            this.error = error;
            if(this.error.code == undefined) {
                this[name]();
            } else {
                if(this[name+"_error"] == undefined) {
                    this.common_error();
                } else {
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
    //-------- Common GUI functions
    init: function() {
        $("#Logout").parent().hide();
        $(".pcall").removeClass("log").removeClass("on");
        $("#rc-panel .accinfo").hide();
        $("#rc-panel .accinfo .slide:first").addClass("on");
        $(".shadow").css({"display":"block"});
        //-----
        
        $("#phnum").parent().hide();
        
        if($.cookie('sfwssessionid')!=null) {
            //Init audio
            $(".stop").hide();
            //$(".audio").html(this.audioTmpl);
            //Logout
            var self = this;
            $("#Logout").click(function(event) {
                if(self.log_off == true) {
                    self.widgetCore.logout();
                }
            })//.parent().css({"display":"block"});
            $(".pcall").addClass("log");
        }
    },
    openUrl: function(url) {
        window.parent.location = url;
        //window.location = window.location.toString()+"#redirect="+encodeURIComponent(url);
    },
    despositionButtons: function() {
        var self = this;
        $(".dispositions input[name=butdel]").each(function(index, element) {
            $(this).unbind();
            $(this).bind("click", function() {
                var options = CheckBox("get", "dispositions");
                options.splice(index,1);
                CheckBox("save", "dispositions", options);
                self.createDesposition();   //Create Desposition
                //$(this).parent().parent().parent().remove();
                self.noactiveTab();
            });
        });
        $(".dispositions input[name=butdow]").each(function(index, element) {
            $(this).unbind();
            $(this).bind("click", function() {
                var total_inputs = $(".dispositions input[name=butdow]").length;
                if(index < total_inputs-1) {
                    var options = CheckBox("get", "dispositions");
                    var tmp = options[index+1];
                    options[index+1] = options[index];
                    options[index] = tmp;
                    CheckBox("save", "dispositions", options);
                    self.createDesposition();   //Create Desposition
                    //$('.accinfo .dispositions table tr:eq('+(index+1)+') td:first').html(options[index+1]);
                    //$('.accinfo .dispositions table tr:eq('+(index)+') td:first').html(options[index]);
                    self.noactiveTab();
                }
                return false;
            });
        });
        $(".dispositions input[name=butup]").each(function(index, element) {
            $(this).unbind();
            $(this).bind("click", function() {
                if(index >= 1) {
                    var options = CheckBox("get", "dispositions");
                    var tmp = options[index-1];
                    options[index-1] = options[index];
                    options[index] = tmp;
                    CheckBox("save", "dispositions", options);
                    self.createDesposition();   //Create Desposition
                    //$('.accinfo .dispositions table tr:eq('+(index-1)+') td:first').html(options[index-1]);
                    //$('.accinfo .dispositions table tr:eq('+(index)+') td:first').html(options[index]);
                    self.noactiveTab();
                }
                return false;
            });
        });
    },
    createDesposition: function() {
        //Disposition
        var options = CheckBox("getAll");
        if(options.dispositions != undefined && options.dispositions.length > 0) {
            $('.accinfo .dispositions table tr:first td:first').html(options.dispositions[0]);
            $('.accinfo .dispositions table tr:gt(0)').remove();
            $.each(options.dispositions, function(item, i) {
                if(item > 0) {
                    $('.accinfo .dispositions table tr:first').clone().insertAfter('.accinfo .dispositions table tr:last');
                    $('.accinfo .dispositions table tr:last td:first').html(options.dispositions[item]);
                }   
                //$(".accinfo .select.sel:eq(1) ul").append(appnd);
            });
        } else {    //Default disposition
            $('.accinfo .dispositions table tr:first td:first').html("Good");
            CheckBox("save", "dispositions",["Good"]);
        }
        this.despositionButtons();
    }, 
    setOptions: function() {
        var self = this;
        if($.cookie('sfwssessionid')!=null) {
            var options = CheckBox("getAll");
            //Init Call US
            $(".callusother .select ul").html("");
            $(".mainn .select.sel.aom ul").html("");
            $(".accinfo .select.sel:first ul").html("");
            if(this.accountInfo.forwardingNumbers != undefined && this.accountInfo.forwardingNumbers.length > 0) {
                $.each(this.accountInfo.forwardingNumbers, function(item, i) {
                    var appnd = "<li><a href='#'><strong>Call using "+this.name.content+" "+this.number.content+"</strong></a></li>"; 
                    $(".callusother .select ul").append(appnd);
                    $(".mainn .select.sel.aom ul").append(appnd);
                    $(".accinfo .select.sel:first ul").append(appnd);
                });
            }
            //Ringtones
            $(".accinfo .select.sel:eq(1) ul").html("");
            if(this.Ringtones != undefined && this.Ringtones.length > 0) {
                $.each(this.Ringtones, function(item, i) {
                    var appnd = "<li><a href='#' class='"+this.url+"'><strong>"+this.name+"</strong></a></li>"; 
                    $(".accinfo .select.sel:eq(1) ul").append(appnd);
                });
            }
            //Create Desposition
            self.createDesposition();
            
            //Select method
            $('#rc-panel .noactivecalls .rc-content a:first').click(function(event) {
                $(this).parent().toggleClass("selected");
                return false;
            });
            self.noactiveTab();
            //self.despositionButtons();
            //Add Tails options
            var Other = "<li><a href='#' class='Other'><strong>Other</strong></a></li>"; 
            var None = "<li><a href='#' class='None'><strong>None</strong></a></li>"; 
            $(".accinfo .select.sel:first ul").append(Other);
            $(".mainn .select.sel.aom:first ul").append(Other);
            $(".accinfo .select.sel:first ul").append(None);
            $(".accinfo .select.sel:eq(1) ul").append(None);
            
            //Add effects
            $(".callusother .select ul li:first").addClass("f");
            $(".mainn .select.sel.aom ul li:first").addClass("f");
            $(".accinfo .select.sel:first ul li:first").addClass("f");
            $(".accinfo .select.sel:eq(1) ul li:first").addClass("f");
            
            //Add default choise
            if(this.accountInfo.forwardingNumbers != undefined && this.accountInfo.forwardingNumbers[0] != undefined) {
                $(".callusother .select a strong:first").html(this.accountInfo.forwardingNumbers[0].name.content+" "+this.accountInfo.forwardingNumbers[0].number.content)
                if(options.accinf_select_calling != undefined) {
                    $(".accinfo .select.sel:first a:first").html(options.accinf_select_calling);
                }
            }
            if(options.accinf_select_ringtones != undefined) {
                $(".accinfo .select.sel:eq(1) a strong:first").html(options.accinf_select_ringtones);
            }
            if(options.call_us_loc_select != undefined) {
                $(".callusother .select a strong:first").html(options.call_us_loc_select);
            }
            if(options.mainn_select != undefined) {
                $(".mainn .select.sel.aom a:first").html(options.mainn_select);
            }
            if(options.mainn_omw_select != undefined) {
                $(".mainn .select.sel.omw a:first").html("Reply: "+options.mainn_omw_select);
            }
            var chbox = ["accinfo_chdsca", "accinfo_chocinc"];
            $.each(chbox, function(index, value){
                if(options[value] != undefined && options[value] == false) {
                    $(".accinfo .check #"+value.split("_")[1]).parent().removeClass("c");
                }
            });
            
            $(".callusother .select ul li a strong").each(function(item) {
                $(this).unbind();
                $(this).bind("click", function() {
                    var tmp = $(this).html().replace(/Call using /, "");
                    $(".callusother .select a strong:first").html(tmp);
                    CheckBox("save", "call_us_loc_select",tmp);
                    $(".callusother .select").removeClass("selected");
                    return false;
                }); 
            });
            $(".mainn .select.sel.aom ul li a strong").each(function(item) {    //Answer On
                $(this).unbind();
                $(this).bind("click", function() {
                    var type = item+1;
                    
                    var tmp = $(this).html().replace(/Call using /, "");
                    $(".mainn .select.sel.aom a:first").html(tmp);
                    CheckBox("save", "mainn_select",tmp);
                    $(".mainn .select.sel.aom").removeClass("selected");
                    if($(this).html() == "Other") {
                        $(".mainn .select.sel.aom").next().show().find("#forward").click(function() {
                            self.widgetCore.forwardNumber(self.callerID, type, $(".mainn .select.sel.aom").next().find("input")[0].value.replace(/[^\d]/g, ""));
                            //Should this be here
                            self.showMessages();
                        });
                        $(".mainn .select.sel.aom").next().find("#cancelfor").click(function() {
                            $(".mainn .select.sel.aom").next().hide();
                        });
                        return false;
                    } else {
                        self.widgetCore.forwardNumber(self.callerID, type, $(this).html().replace(/[^\d]/g, ""));
                    }
                    return false;
                }); 
            });
            $(".mainn .select.sel.omw ul li a span").each(function(item) {  //Reply
                $(this).unbind();
                $(this).bind("click", function() {
                    var type = item+1;
                    //divtime
                    
                    var tmp = $(this).html();
                    $(".mainn .select.sel.omw a:first").html(tmp);
                    CheckBox("save", "mainn_omw_select",tmp);
                    $(".mainn .select.sel.omw").removeClass("selected");
                    if($(this).html() == "Other") {
                        $(".mainn .input #enteryr").parent().parent().show();
                        $(".mainn .input #enteryr").parent().parent().find("#sendr").click(function() {
                            self.widgetCore.replyMethod(self.callerID, type, 0, 0, $(".mainn .input #enteryr").val());
                            //Should this be here
                            self.showMessages();
                        });
                        $(".mainn .input #enteryr").parent().parent().find("#canseltime").click(function() {
                            $(".mainn .input.time").parent().hide();
                        });
                        return false;
                    }
                    if($(this).hasClass("cmbi") || $(this).hasClass("wcyb")) {
                        var types = {"hours":2, "minutes":1, "days":3};
                        $(".mainn .input.time").parent().show();
                        $(".mainn .input.time").parent().find("#sendtime").click(function() {
                            self.widgetCore.replyMethod(self.callerID, type, $(".mainn #time_input").val(), types[$(".mainn .radiobut input[type=radio]:checked").attr("id")]);
                            self.showMessages();
                        });
                        $(".mainn .input.time").parent().find("#canseltime").click(function() {
                            $(".mainn .input.time").parent().hide();
                        });
                        return false;
                    }
                    self.widgetCore.replyMethod(self.callerID, type, $(".mainn #time_input").val(), 10, 2, "Test");//: function(id, type, time, period, body) 
                    return false;
                }); 
            });
            $(".accinfo .select.sel:first ul:first li a").each(function(item) {
                $(this).unbind();
                $(this).bind("click", function() {
                    var tmp = $(this).children().html();
                    $(".accinfo .select.sel:first a:first").html(tmp);
                    CheckBox("save", "accinf_select_calling",tmp);
                    $(".accinfo .select").removeClass("selected");
                    $(".accinfo #phnum").parent().hide();
                    if($(this).hasClass("Other")) {
                        $(".accinfo #phnum").parent().change(function() {
                            CheckBox("save", "accinf_select_calling",$(this).val());
                        }).show();
                    }
                    return false;
                }); 
            });
            $(".accinfo .select.sel:eq(1) ul:first li a").each(function(item) {
                $(this).unbind();
                $(this).bind("click", function() {
                    var tmp = $(this).children().html().replace(/Call using /, "");
                    $(".accinfo .select.sel:eq(1) a:first").html(tmp);
                    CheckBox("save", "accinf_select_ringtones",tmp);
                    $(".accinfo .select").removeClass("selected");
                    $(".accinfo #phnum").parent().hide();
                    if(!$(this).hasClass("None")) {
                        $(".accinfo .play-stop").css({"padding-left": "4px"});
                        $(".accinfo .play-stop").html(self.mp3Tmpl.replace(/{{FILE}}/g, $(this).attr("class")));
                        //$(".accinfo .play-stop").find("param[name=FlashVars]").val("mp3="+Config.root.substr(-1)+$(this).attr("class"));
                        //document.getElementById("mp3_player").SetVariable("player:jsUrl", Config.root.substr(-1)+$(this).attr("class"));
                    }
                    return false;
                }); 
            });
            
            if(options.call_us_loc != undefined) {
                if(options.call_us_loc != undefined && options.call_us_loc == false) {
                    $(".callusother .check").removeClass("c");
                } else if(options.call_us_loc != undefined && options.call_us_loc == true) {
                    if(options.call_us_loc_select != undefined) {
                        $(".callusother .select a strong:first").html(options.call_us_loc_select);
                    }
                }
            }
        }
    },
    parsePhoneNumbers: function() {
        var self = this;
        if($.cookie('sfwssessionid')!=null) {
            
            //Select method
            $(".callusother .select").unbind();
            $(".callusother .select").bind("click", function(event) {
                $(this).toggleClass("selected");
                return false;
            });
            //Checkbox 
            $(".callusother .check").unbind();
            $(".callusother .check").bind("click", function(event) {
                $(this).toggleClass("c");
                CheckBox("save", "call_us_loc",$(this).hasClass("c"));
                return false;
            });
            //Cancel action
            $(".callusother #cancelcall").unbind();
            $(".callusother #cancelcall").bind("click", function(event) {
                self.showMessages();
                GTimerFunc();   //Init Global action timer
                return false;
            });
            //Call action
            $(".callusother #call").unbind();
            $(".callusother #call").bind("click", function(event) {
                //Get number
                var number_from = $(".callusother .select.sel a strong").html();
                if(number_from == undefined) {
                    number_from = self.accountInfo.forwardingNumbers[0].number.content
                }
                if(self.sipID != null) {
                    self.widgetCore.ringOut($(".callusother #auslt").val().replace(/[^\d]/g, ""), number_from.replace(/[^\d]/g, ""));
                }
                return false;
            });
        }
    }, 
    notLogged: function() {
        $("#rc-panel .accinfo .slide").removeClass("on");
        $("#rc-panel .accinfo .slide:first").addClass("on").show();
        $("#Logout").parent().hide();
        $(".pcall").removeClass("log").removeClass("on");
        $(".shadow").css({"display":"none"});
        this.showAccinfo();
        $.cookie('sfwssessionid', null, { path: '/' });
    },
    showMessages: function() {
        $("#rc-panel .tabb").hide();
        $("#hidden_mp3_player").remove();
        $("#rc-panel .noactivecalls").show();
        $(".pcall").html("Messages");
    },
    showAccinfo: function() {
        $("#rc-panel .tabb").hide();
        $("#rc-panel .accinfo").show();
        $(".pcall").html("Preferences");
    },
    showPlaceCall: function() {
        $("#rc-panel .tabb").hide();
        $("#rc-panel .callusother").show();
        $(".pcall").html("Place Call");
    },
    showStatus: function() {
        $("#rc-panel .tabb").hide();
        $("#rc-panel .stattus").show();
        $(".pcall").html("Status");
    },
    showMainn: function() {
        $("#rc-panel .tabb").hide();
        $("#rc-panel .mainn .multi-contacts").hide();
        $("#rc-panel .mainn").show();
        $(".pcall").html("Calling");
        
        $(".mainn .input #enteryr").parent().parent().hide();
        $(".mainn .input.time").parent().hide();
    },
    mainnTab: function() {
        var self = this;
        //Select method
        $(".mainn .select.sel.aom a:first").click(function(event) {
            self.widgetCore.startReply(self.callerID);
            $(this).parent().toggleClass("selected");
            return false;
        });
        //Select method
        $(".mainn .select.sel.omw a:first").click(function(event) {
            self.widgetCore.startReply(self.callerID);
            $(this).parent().toggleClass("selected");
            return false;
        });
        
        //Send to Voicemail
        $(".mainn .select.stv").click(function(event) {
            if(self.callerID != null) {
                self.widgetCore.sendToVoiceMail(self.callerID);
            }
            self.showMessages();
            return false;
        });
        //Ignore
        $(".mainn .select.i").click(function(event) {
            if(self.callerID != null) {
                self.widgetCore.rejectCall(self.callerID);
            }
            self.showMessages();
            return false;
        });
        
        //newlead
        $(".mainn #newlead").click(function(event) {
            //self.openUrl(Config.create_lead);
            window.open(Config.create_lead+"?nowidget=true");
            return false;
        });
        //newcon
        $(".mainn #newcon").click(function(event) {
            //self.openUrl(Config.create_contact);
            window.open(Config.create_contact+"?nowidget=true");
            return false;
        });
    },
    noactiveTab: function() {
        var self = this;
        var options = CheckBox("getAll");
        if(options.dispositions != undefined && options.dispositions.length > 0) {
            $('#rc-panel .noactivecalls .rc-content a:first strong').html(options.dispositions[0]);
            $("#rc-panel .noactivecalls .rc-content .select.sel ul").html("");
            $.each(options.dispositions, function(item, i) {
                var appnd = "<li><a href='#'><strong>"+options.dispositions[item]+"</strong></a></li>"; 
                $("#rc-panel .noactivecalls .rc-content .select.sel ul").append(appnd);
            });
        } 
        $("#rc-panel .noactivecalls .rc-content .select.sel ul li a").each(function(item) {
            $(this).unbind(); 
            $(this).bind("click", function() {
                var tmp = $(this).children().html();
                $("#rc-panel .noactivecalls .rc-content a:first strong").html(tmp);
                //CheckBox("save", "accinf_select_ringtones",tmp);
                $("#rc-panel .noactivecalls .rc-content a").parent().removeClass("selected");
                return false;
            }); 
        });
        $("#rc-panel .noactivecalls #set").unbind(); 
        $("#rc-panel .noactivecalls #set").bind("click", function() {
            var number = self.lCall.result.number.content.match(/.?([\d]{3})([\d]{3})([\d]{4})/);
            var time = self.lCall.result.callStartTime.content.match(/[\d]{4}.([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2})/);
            var text = $("#rc-panel .noactivecalls .rc-content .select.sel a:first strong").html();
            self.despositionSFinfo(number[1]+number[2]+number[3], text, self.lCall.result.callStartTime.content);
        });
        $("#clear").unbind(); 
        $("#clear").bind("click", function() {
            var disposition_clear = CheckBox("get", "disposition_clear");
            if(disposition_clear != null) {
                disposition_clear = disposition_clear.split("__");
                CheckBox("save", "disposition_clear",disposition_clear[0]+"__true");
                $(this).parent().parent().parent().hide();
            } else {
                CheckBox("save", "disposition_clear","__true");
                $(this).parent().parent().parent().hide();
            }
            //Save settings
            var account = new sforce.SObject(self.SFDataBaseName);
            account.Id = self.loginFields.SFID;
            account.ring__Settings__c = $.cookie('widget_options');
            sforce.connection.update([account],self.emptyRespons());
        });
    },
    accountInfoTabs: function() {
        $("#rc-panel .accinfo .slide a.down").each(function(index, value) {
            $(this).unbind(); 
            $(this).bind("click", function(event) {
                if($.cookie('sfwssessionid')!=null) {   //If login
                    $("#rc-panel .accinfo .slide").removeClass("on");
                    $(this).parent().addClass("on");
                } 
                return false;
            });
        });
        $("#rc-panel .accinfo .slide a.up").each(function(index, value) {
            $(this).unbind();    
            $(this).bind("click", function(event) {
                if($.cookie('sfwssessionid')!=null) {   //If login
                    $(this).parent().removeClass("on");
                }
                return false;
            });
        });
        $("input#loadrc").unbind();
        $("input#loadrc").bind("click", function(events) {
            window.open(Config.RC_service);
            return false;
        });
        //For accinfo div
        $(".accinfo .slide").each(function(index, element) {
            $(this).find(".select.sel a:first").unbind();
            $(this).find(".select.sel a:first").bind("click", function(event) {
                $(this).parent().toggleClass("selected");
                return false; 
            });
        });
        //Check buttons
        $(".accinfo .check").unbind();
        $(".accinfo .check").bind("click", function(event) {
            $(this).toggleClass("c");
            CheckBox("save", "accinfo_"+$(this).children().attr("id"),$(this).hasClass("c"));
        });
        //Add new disposition
        var self = this;
        $(".accinfo #buttonaddd").unbind();
        $(".accinfo #buttonaddd").bind("click", function() {
            var input = $(".accinfo input[name=dispinp]").val();
            if(input != "") {
                var options = CheckBox("get", "dispositions");
                options.push(input);
                CheckBox("save", "dispositions", options);
                $('.accinfo .dispositions table tr:first').clone().insertAfter('.accinfo .dispositions table tr:last');
                $('.accinfo .dispositions table tr:last td:first').html(input);
                self.despositionButtons();
            }
        });
        
    },
    userListAction: function() {
        var self = this;
        $(".active-calls tbody tr").css({"cursor": "pointer"});
        $(".active-calls tbody tr").each(function(index, element) {
            var contID = $(this).attr("id").split("_");
            //var number = self.contacts[contID[1]]["Number"]; 
            if(self.contacts[contID[1]] && self.contacts[contID[1]]["href"] != undefined) {
                $(this).children().css({"color":"#090"})
            } else {
                var only_SF = CheckBox("get", "accinfo_chdsca");
                if(only_SF != undefined && only_SF) {
                    $(this).hide();
                } 
            }
        });
        $(".shadow").css({"display":"none"});
        $(".active-calls tbody tr").unbind();
        $(".active-calls tbody tr").bind("click", function(event) {
            $(".active-calls tbody tr").removeClass("selected");
            //$(".audio").css({"visibility": "hidden"});
            $(this).addClass("selected");
            var contID = $(this).attr("id").split("_");
            if(self.contacts[contID[1]] != undefined && self.contacts[contID[1]]["Number"] != undefined) {
                var number = self.contacts[contID[1]]["Number"]; 
                $("#callBack").unbind();
                $("#callBack").bind("click", function(event) {
                    var number_from = CheckBox("get", "accinf_select_calling");
                    if(number_from == undefined) {
                        number_from = self.accountInfo.forwardingNumbers[0].number.content
                    }
                    if(self.sipID != null) {
                        self.widgetCore.ringOut(number.replace(/[^\d]/g, ""),number_from.replace(/[^\d]/g, ""));
                    }
                });
            }
            if(self.contacts[contID[1]] && self.contacts[contID[1]]["href"]) {
                var href = self.contacts[contID[1]]["href"];
                $("#opencontact").unbind();
                $("#opencontact").show().bind("click", function(event) {
                    //window.location = href;
                    self.openUrl(href);
                });
            }
            //Init flash player
            self.widgetCore.getMessage(self.contacts[contID[1]]["ID"]);
            //$(".audio").html("");
        });
    },
    saveButtonAction: function() {
        var self = this;
        $("#rc-panel .buttonn input[name=busave]").unbind();
        $("#rc-panel .buttonn input[name=busave]").bind("click", function() {
            if($("#rc-panel .accinfo").is(":visible") && $("#rc-panel .accinfo .slide:first").is(":visible")) {
                $("#rc-panel .accinfo .slide.on input").removeClass("error");
                //Check login
                //if($.cookie('sfwssessionid')==null) {
                var alerts = "";
                
                $("#rc-panel .accinfo .slide.on input").each(function(index) {
                    var value = $(this).val();
                    var name = $(this).attr("name");
                    if(name != "ringex" && value == "") {
                        $(this).parent().addClass("error");
                        alerts = "Please fill requared fields"
                    } else {
                        var tmp = value.replace(/[^\d]/g, "");
                        if(name == 'ringnum') {
                            tmp = (tmp.length == 11) ? tmp : "1"+tmp;
                        }
                        $(this).val(tmp);
                        self.loginFields[name] = $(this).val();
                    }
                });
                if(alerts != "") {
                    ErrorHolder({code:"PFRF", text:alerts});
                    return;
                } else {
                    $(".shadow").css({"display":"block"});
                    var login_fn = function(self) {
                        if(self.unsupport == true) {
                            self.widgetCore.login(self.loginFields.ringnum.toString(), self.loginFields.ringex.toString(), self.loginFields.pass.toString());
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
                var account = new sforce.SObject(self.SFDataBaseName);
                account.Id = self.loginFields.SFID;
                account.ring__Settings__c = $.cookie('widget_options');
                sforce.connection.update([account],self.emptyRespons());
                
                $(".settings").removeClass('na');
                self.noactiveTab();
                self.widgetCore.getList(); 
                self.showMessages();
            }
        });
    },
    //--------------------------------
    //-------- Parsing functions
    isAutorized: function() {
        if(!this.isAuth) {
            if($.cookie('sfwssessionid')!=null) {
                $("#rc-panel .accinfo .slide:first").hide();
                this.showMessages();
                
                this.widgetCore.getList();
                this.widgetCore.getAccount();
                this.parsePhoneNumbers();
                GTimerFunc();   //Init Global action timer
            
                var self = this;
                sforce.connection.query("SELECT Id, ring__Settings__c FROM "+self.SFDataBaseName+" WHERE ring__SessionID__c = '"+$.cookie('sfwssessionid')+"'", 
                        self.emptyRespons(self.parseSFLogin));
            }
        }
    },
    isAutorized_error: function() {
        $("#rc-panel .buttonn input[name=busave]").parent().parent().css({"display":"block"});
        if($.cookie('sfwssessionid')!=null) {
            var self = this;
            sforce.connection.query("SELECT Id, ring__SessionID__c, ring__Extension__c, ring__Password__c, ring__Settings__c, Name FROM "+self.SFDataBaseName+" WHERE ring__SessionID__c = '"+$.cookie('sfwssessionid')+"'", 
                    self.emptyRespons(self.parseSFLogin));
        } else {
            this.notLogged();
        }
        return;
    },
    subscriberLogin: function () {
        //Hide account info tab
        $("#rc-panel .accinfo .slide:first").hide();
        this.showMessages();
        //$("#Logout").parent().css({"display":"block"});
        $(".pcall").removeClass("log");
        $(".stop").hide();
        
        //Check UserId in SF DB
        if($.cookie('sfwssessionid')!=null) {
            var self = this;
            sforce.connection.query("SELECT Id, ring__SessionID__c, ring__Extension__c, ring__Password__c, ring__Settings__c, Name FROM "+self.SFDataBaseName+" WHERE Name = '"+self.loginFields.ringnum+"'", 
                this.emptyRespons(self.updateSFLogin));
        }
        this.log_off = true;
        $("#Logout").unbind();
        $("#Logout").bind("click", function(event) {
            if(self.log_off == true) {
                self.widgetCore.logout();
            }
        })//.parent().css({"display":"block"});
        $(".pcall").addClass("log");
        
        this.widgetCore.getList(); 
        this.widgetCore.getAccount();
        this.parsePhoneNumbers();
        GTimerFunc();   //Init Global action timer

        return this;
    },
    subscriberLogin_error: function() {
        this.notLogged();
        ErrorHolder(this.error); //Global error holder
    },
    listMessages: function () {
        if(this.data['return'] && $.isArray(this.data['return'].result)) {
            var list = this.data['return'].result;
            $(".active-calls tbody").html("");
            var self = this;
            self.contacts = new Array();
            $.each(list, function(index, element) {
                var type = '<td class="tel">&nbsp;</td>';
                var size_type = ' sec';
                if(element.type.content != "messageVoice") {
                    type = '<td class="fax">&nbsp;</td>';
                    size_type = ' pp';
                } 
                var date = element.dateTime.content.match(/^[\d]{2}([\d]{2})\-([\d]{2})\-([\d]{2})/).slice(1);
                var name = "";
                //Save contacts in inner array
                
                if(typeof element.addr != "undefined" && element.addr.content) {
                    name = (element.name != undefined) ? element.name.content : element.addr.content;
                    self.contacts.push({"ID":element.messageId.content, "Name":name, "Number":element.addr.content});
                }
                $(".active-calls tbody").append('<tr id="c_'+index+'">'+type+'<td>'+name+'</td><td>'+date[1]+'/'+date[2]+'/'+date[0]+'</td><td>'+element.size.content+size_type+'</td></tr>');
                if(element.unread.content == "false") {
                    $(".active-calls tbody tr:last").children().css({"color":"#999"});
                }
            });
            $(".active-calls tbody tr:odd").addClass("odd");
            $(".active-calls tbody tr:even").addClass("even");
            $(".noactivecalls .active-calls table").tablesorter({widgets: ['zebra'] }); 
            
            this.SFIntegration();
        } else {
            $(".shadow").css({"display":"none"});
        }
        //Show last call
        var ed = new Date();
        var endDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
        ed.setFullYear(ed.getFullYear()-1);
        startDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
        this.widgetCore.getCallLog(startDate, endDate, "", "1", "1");
        return this;
    },
    reLogin: function() {
        return;
    },
    reLogin_error: function() {
        //Show account info tab
        this.notLogged();
        this.widgetCore.session = "null";
        ErrorHolder(this.error);
    },
    RingOut_callAndGetFirstStatus: function() {
        var self = this;
        this.showStatus();
        //Set status info
        var Name = "";//this.accountInfo.firstName.content+" "+this.accountInfo.lastName.content;
        var number_from = CheckBox("get", "accinf_select_calling");
        if(number_from == undefined) {
            number_from = self.accountInfo.forwardingNumbers[0].number.content;
            Name = self.accountInfo.forwardingNumbers[0].type.content;
        } else {
            $.each(self.accountInfo.forwardingNumbers, function(item, i) {
                if(this.number.content.replace(/[^\d]/g, "") == number_from.replace(/[^\d]/g, "")) {
                    Name = this.type.content;
                }
            });
        }
        var Num_arr = number_from.replace(/[^\d]/g, "").match(/.?([\d]{3})([\d]{3})([\d]{4})/);
        $(".stattus #FromToFrom").html("<strong>From: </strong>"+Name+" ("+Num_arr[1]+") "+Num_arr[2]+"-"+Num_arr[3]);
        $(".stattus #FromToStat").html("<strong>Status: </strong>"+this.data["return"].ringOutStatus.userStatus.content);
        var To = "undefined";
        if(this.data.inputData && this.data.inputData.to) {
            To = this.data.inputData.to.match(/.?([\d]{3})([\d]{3})([\d]{4})/);
        }
        $(".stattus #FromToTo").html("<strong>To: </strong> "+" ("+To[1]+") "+To[2]+"-"+To[3]);
        $(".stattus #FromToStatus").html("<strong>Status: </strong>"+this.data["return"].ringOutStatus.partyStatus.content);
        clearTimeout(GlobalTimer);
        //Call status
        GlobalTimer = setTimeout(function() { 
            self.widgetCore.ringOutStat(self.data["return"].sessionId.content);
        }, 1000);
        $("input#butc").unbind();
        $("input#butc").bind("click", function(event) {
            $("#rc-panel .tabb").hide();
            $("#rc-panel .noactivecalls").show();
            GTimerFunc();   //Init Global action timer
        });
    }, 
    RingOut_callAndGetFirstStatus_error: function() {
        if(this.error.code == "004") {
            this.notLogged();
        }
        return;
    },
    unsupportedMethods: function() {
        this.unsupport = true;
        this.widgetCore.unsupportedFunc(this.data["return"].split(","));
        return;
    },
    RingOut_list: function() {
        return;
    },
    RingOut_status: function() {
        if(this.data["return"].ringOutStatus.userStatus.content == "eGenericError" || this.data["return"].ringOutStatus.partyStatus.content == "eGenericError") {
            clearTimeout(GlobalTimer);
            ErrorHolder({"code":"Call","text":"Cann't make RingOut"});
            this.showMessages();
            return;
        }
        $(".stattus #FromToStat").html("<strong>Status: </strong>"+this.data["return"].ringOutStatus.userStatus.content);
        $(".stattus #FromToStatus").html("<strong>Status: </strong>"+this.data["return"].ringOutStatus.partyStatus.content);
        if(self.data != undefined && self.data["return"] != undefined && self.data["return"].sessionId != undefined) {
            var sessionId = self.data["return"].sessionId.content;
            GlobalTimer = setTimeout(function() { 
                    self.widgetCore.ringOutStat(sessionId);
            }, 1000);
        }
    },
    SIPMessage: function() {
        var self = this;
        this.showMainn();
        this.callerID = this.data["notification"]["id"];
        switch(this.data["notification"]["type"]) {
            case "call":
                if(this.data["notification"]["status"] == "cancel") {
                    this.callFlag = "cancel";
                    this.showMessages();
                    return;
                }
                this.callFlag = "call";
                //Show data
                var phoneArr = this.data["notification"]["number"].match(/.?([\d]{3})([\d]{3})([\d]{4})/);
                $(".mainn .numberr").html("("+phoneArr[1]+") "+phoneArr[2]+"-"+phoneArr[3]);
                var ring_name = CheckBox("get", "accinf_select_ringtones");
                $.each(this.Ringtones, function(item, i) {
                    if(this.name == ring_name) {
                        $(".mainn .numberr").before(self.hidden_mp3Tmpl.replace(/{{FILE}}/g, this.url));
                    }
                });
                
                $(".mainn .greyt:first").html(this.data["notification"]["name"]);
                //Open contact if checked
                var open_contact = CheckBox("get", "accinfo_chocinc");
                if(open_contact != undefined && open_contact) {
                    $(".mainn .select.oc a").click();
                }
                //Find last call
                var ed = new Date();
                var endDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
                ed.setFullYear(ed.getFullYear()-1);
                startDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
                self.widgetCore.getCallLog(startDate, endDate, this.data["notification"]["number"], "1", "1");
                //Get information about caller
                this.contactSFinfo(this.data["notification"]["number"]);
                break;
            case "message": //Update message list
                this.widgetCore.getList(); 
                this.showMessages();
                break;
        }
    },
    getMessage: function() {
        var message_flag = {
            "wav":{"id":"haxe",     "show_name":".haxe_wav#num1",   "method_name":"sendFromJS"},
            "mp3":{"id":"haxe_mp3", "show_name":".haxe_wav#num2",   "method_name":"sendMP3FromJS"},
            "pdf":{"id":"haxe_pdf", "show_name":".haxe_pdf",        "method_name":"sendPDFFromJS"}
            };
        //Add Flash
        if(message_flag[this.data["return"].realExtension.content] != undefined) {
            var flag = message_flag[this.data["return"].realExtension.content];
            var self = this;
            var wavData = this.data["return"].result.content;
            
            $(".haxe_pdf, .haxe_wav#num1, .haxe_wav#num2").removeClass("show");
            $(flag["show_name"]).addClass("show");
            
            setTimeout(function() {
                var M$ =  navigator.appName.indexOf("Microsoft")!=-1;
                var func = (M$ ? window : document)[flag["id"]];
                if(typeof func[flag["method_name"]] == "undefined") {
                    alert("Can not connect with Flash!");
                } else {
                    func[flag["method_name"]](wavData);
                }
                $(".stop").show();
                if(self.data.inputData.messageId != undefined) {
                    self.widgetCore.changeMessageStatus(self.data.inputData.messageId, true);
                    $(".audio .stop").unbind();
                    $(".audio .stop").bind("click", function() {
                         self.widgetCore.deleteMessage(self.data.inputData.messageId);
                         return false;
                    });
                }
            }, 2000);
            return;
        }
        //----End Flash
        return;
    },
    deleteMessage: function() {
        this.widgetCore.getList(); 
        this.parsePhoneNumbers();
    },
    getCallLog: function() {
        $(".mainn .greyt.last").html("Last call, ");
        var lastCall = this.data["return"];
        this.lCall = lastCall;
        if(lastCall.recordCount.content != 0) {
            var self = this;
            if(this.data["inputData"]["recordCount"] == this.data["inputData"]["startRecord"]) {
                var ed = new Date();
                var endDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
                ed.setFullYear(ed.getFullYear()-1);
                var startDate = ed.getFullYear()+"-"+(('0' + (ed.getMonth()+1)).substr(-2))+"-"+(('0' + ed.getDate()).substr(-2));
                setTimeout(function() {
                    var rec_start = (self.callFlag != null && self.callFlag == "call") ? lastCall.recordCount.content-1 : lastCall.recordCount.content;
                    self.callFlag = null;
                    self.widgetCore.getCallLog(startDate, endDate, (self.data["inputData"] != undefined)?self.data["inputData"]["phoneNumber"]:"", rec_start, "1");
                }, 1000);
            } else {
                //2010-10-21T04:25:12-07:00
                var data = lastCall.result.callStartTime.content;
                var time = data.match(/[\d]{4}.([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2}).([\d]{2})/);
                $(".mainn .greyt.last").html("Last call, "+time[1]+"/"+time[2]+", "+time[3]+":"+time[4]);
                var number = lastCall.result.number.content.match(/[+\d]{0,3}([\d]{3})([\d]{3})([\d]{4})/);
                var Name = "";
                for(var i = 0; i < self.contacts.length; i++) {
                    if(lastCall.result.number.content.search(self.contacts[i]["Number"] ) != -1) {
                        Name = self.contacts[i].Name;
                        break;
                    }
                }
                $("#rc-panel .noactivecalls .rc-content .blacktext").html(Name + " ("+number[1]+") "+number[2]+"-"+number[3]+"<br>"+time[1]+"/"+time[2]+", "+time[3]+":"+time[4]);
                $("#rc-panel .noactivecalls .rc-content").show();
                
                self.despositionSFinfo(number[1]+number[2]+number[3]);
            }
        }
    },
    LogOff: function() {
        this.log_off = false;
        this.unsupport = false;
        this.notLogged();
        this.widgetCore.session = "null";  
        $(".active-calls tbody").html(""); 
        $("#Logout").parent().hide();
        $(".pcall").removeClass("log").removeClass("on");
        $("#rc-panel .buttonn input[name=busave]").parent().parent().css({"display":"none"});
    },
    getMailboxInfo: function() {
        var self = this;
        //Check for DND status
        this.mailboxInfo = this.data["return"];
        if(this.mailboxInfo.mailboxInfo.queueState.content == "Agent") {
            if(this.accountInfo.dnd.content == "true") {
                $(".not-avail a").html("Not Avail").parent().addClass('na');
                
            } else {
                $(".not-avail a").html("Avail").parent().removeClass('na');
            }
        } else {    //Not an Agent
            //Simply set DND stat
            if(this.accountInfo.dnd.content == "true") {
                $(".not-avail a").html("Not Avail").parent().addClass('na');
            } else {
                $(".not-avail a").html("Avail").parent().removeClass('na');
            }
        }
        $(".not-avail a").unbind();
        $(".not-avail a").bind("click", function(event) {
            if($(this).parent().hasClass('na')) {
                self.widgetCore.setDND(false);
                $(this).html("Avail").parent().removeClass('na');
            } else {
                self.widgetCore.setDND(true);
                $(this).html("Not Avail").parent().addClass('na');
            }
            return false;
        });
    },
    setDND: function() {
        return;
    },
    getAccountInfo: function() {
        if(this.accountInfo == undefined || JSON.stringify(this.accountInfo).length != JSON.stringify(this.data["return"]).length) {
            this.accountInfo = this.data["return"];
            this.setOptions();  //Init UI
            this.widgetCore.getMailBox();
        }
    },
    SIPRegister: function() {
        $(".pcall").addClass("on");
        if(this.loginFields.SFID != undefined) {
            var account = new sforce.SObject(this.SFDataBaseName);
            account.Id = this.loginFields.SFID;
            account.ring__SipSession__c = this.data.sipId;
            this.sipID = this.data.sipId;
            sforce.connection.update([account],this.emptyRespons());
        } else {
            this.loginFields.SIP_ID = this.sipID = this.data.sipId;
        }
    },
    SIPRegister_error: function() {
        $(".pcall").removeClass("on");
        return;
    },
    //--------------------------------
    //-------- SF integration
    SFIntegration: function() {
        var forLike = [];
        var tmpContacts = {};
        $.each(this.contacts, function(index, element) {
            tmpContacts[element["Number"]] = element;
        });
        $.each(tmpContacts, function(index, element) {
            var tmp = element["Number"].match(/.?([\d]{3})([\d]{3})([\d]{4})/);
            forLike.push("'%("+tmp[1]+") "+tmp[2]+"-"+tmp[3]+"%'");
            forLike.push("'%"+element["Number"].replace(/[^\d]/g, "")+"%'");
        });
        //SF integration
        var self = this;
        sforce.connection.query("SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE "+forLike.join(" OR Phone LIKE ")+" LIMIT 20", this.emptyRespons(self.parseSFResult));
    },
    parseSFResult: function(self, result) {
        var it = new sforce.QueryResultIterator(result);
        var html = [];
        while(it.hasNext()) {
            var record = it.next();
            $.each(self.contacts, function(index, element) {
                if(element["Number"] == record.Phone.replace(/[^\d]/g, "")) {
                    self.contacts[index]['href'] = Config.root + record.Id;
                }
            });
        }
        self.userListAction();
    },
    contactSFinfo: function(number) {
        var forLike = [];
        var tmp = number.match(/.?([\d]{3})([\d]{3})([\d]{4})/);
        forLike.push("'%("+tmp[1]+") "+tmp[2]+"-"+tmp[3]+"%'");
        forLike.push("'%"+number.replace(/[^\d]/g, "")+"%'");
        
        //SF integration
        var self = this;
        sforce.connection.query("SELECT Id, Name, Account.Name, Phone FROM Contact WHERE Phone LIKE "+forLike.join(" OR Phone LIKE ")+" LIMIT 20", this.emptyRespons(self.parseSFcontacts));
    },
    setOpenContact: function(self, record) {
        $(".mainn .select.oc a").unbind();
        $(".mainn .select.oc a").bind("click",function() {
            window.open(Config.root + record.Id+"?nowidget=true");
            self.widgetCore.startReply(self.callerID);
            return false;
        });
        if(record.Account != null) {
            $(".mainn .greyt:eq(1)").html(record.Account.Name);
        } else {
            $(".mainn .greyt:eq(1)").hide();
        }
    },
    parseSFcontacts: function(self, result) {
        var it = new sforce.QueryResultIterator(result);
        if(it.records.length == 0) {    //No user 
            $(".mainn .greyt:eq(1)").hide();
            $(".mainn .select.oc").hide();
        } else if(it.records.length == 1) {
            self.setOpenContact(self, it.records[0]);
        } else {
            self.setOpenContact(self, it.next());
            $(".mainn .multi-scroll").html("").parent().show();
            while(it.hasNext()) {
                var record = it.next();
                $(".mainn .multi-scroll").append("<p>"+record.Name+"</p><p>Last call: </p><p>Type: Contact</p><div class='buttonn'><input id='openbut' name='openbut' value='Open' type='button'></div><br><br>");
            }
        }
    },
    despositionSFinfo: function(number, text, time) {
        var self = this;
        if(this.mailboxInfo != undefined && this.mailboxInfo.mailboxId) {
            var userID = this.mailboxInfo.mailboxId.content;
            if(number == undefined) {   //Return ALL
                //Do nothing
            } else if(number != undefined && text == undefined) {   //Return current number record
                var forLike = [];
                var tmp = number.match(/.?([\d]{3})([\d]{3})([\d]{4})/);
                forLike.push("'%("+tmp[1]+") "+tmp[2]+"-"+tmp[3]+"%'");
                forLike.push("'%"+number.replace(/[^\d]/g, "")+"%'");
                var sql = "SELECT Id, LastName, FirstName, Phone, Fax, MobilePhone, (SELECT Id, Status, Description, CreatedDate FROM Tasks WHERE ReminderDateTime = "+self.lCall.result.callStartTime.content+") FROM Contact WHERE Phone LIKE "+forLike.join(" OR Phone LIKE ")+"  LIMIT 20";
                sforce.connection.query(sql, this.emptyRespons(self.parseSFdespositions));
            } else if(number != undefined && text != undefined && time != undefined) {  //Save disposition
                self.text = text;
                self.callStart = time;
                self.callNumber = number;
                var forLike = [];
                var tmp = number.match(/.?([\d]{3})([\d]{3})([\d]{4})/);
                forLike.push("'%("+tmp[1]+") "+tmp[2]+"-"+tmp[3]+"%'");
                forLike.push("'%"+number.replace(/[^\d]/g, "")+"%'");
                sforce.connection.query("SELECT Id, LastName, FirstName, Phone FROM Contact WHERE Phone LIKE "+forLike.join(" OR Phone LIKE ")+" LIMIT 20", this.emptyRespons(self.parseSFdespositions));
            }
        }
    },
    parseSFdespositions: function(self, result) {
        var it = new sforce.QueryResultIterator(result);
        if(it.records.length == 0) {    //No desposition 
            //
        } else { //if(it.records.length == 1) {
            var record = it.records[0];
            if(self.text != undefined) {
                var task = new sforce.SObject("Task");
                task.Description = task.Subject = self.text;
                task.ReminderDateTime = self.callStart;
                task.WhoId  = record.Id;
                sforce.connection.create([task],self.emptyRespons());
                setTimeout(function() {
                    self.text = undefined;
                    self.callStart = undefined;
                    self.callNumber = undefined;
                    self.despositionSFinfo(self.callNumber);
                }, 2000);
            } else {
                if(record.Tasks != undefined && record.Tasks.size >= 1) {
                    var disposition_clear = CheckBox("get", "disposition_clear");
                    var ID = (record.Tasks.records[0] == undefined) ? record.Tasks.records.Id : record.Tasks.records[0].Id;
                    if(disposition_clear != null) {
                        disposition_clear = disposition_clear.split("__");
                        
                        if(disposition_clear.length == 2 && disposition_clear[1] == "true" && disposition_clear[0] == ID) {   //ID the same
                            //Do nothing
                            $("#rc-panel .noactivecalls .rc-content").hide();
                        } else {
                            CheckBox("save", "disposition_clear", ID);
                            $("#rc-panel .noactivecalls .rc-content .select.sel a:first").hide();
                            $("#rc-panel .noactivecalls .rc-content .select.sel ul").hide();
                            $("#rc-panel .noactivecalls .rc-content .buttonn #set").hide();
                            var Des = (record.Tasks.records[0] == undefined) ? record.Tasks.records.Description : record.Tasks.records[0].Description;
                            $("#rc-panel .noactivecalls .rc-content .select.sel").removeClass("select").css({"margin-left": "4px"}).append("<strong>Desposition: "+Des+"</strong>");
                        }
                    } else {
                        CheckBox("save", "disposition_clear", ID);
                        $("#rc-panel .noactivecalls .rc-content .select.sel a:first").hide();
                        $("#rc-panel .noactivecalls .rc-content .select.sel ul").hide();
                        $("#rc-panel .noactivecalls .rc-content .buttonn #set").hide();
                        var Des = (record.Tasks.records[0] == undefined) ? record.Tasks.records.Description : record.Tasks.records[0].Description;
                        $("#rc-panel .noactivecalls .rc-content .select.sel").removeClass("select").css({"margin-left": "4px"}).append("<strong>Desposition: "+Des+"</strong>");
                    }
                }
            }
        } 
    },
    parseSFLogin: function(self, result) {
        var it = new sforce.QueryResultIterator(result);
        if(it.records.length == 0) {    //No user logedin
            if(typeof self.loginFields.ringnum != "undefined") {
                var account = new sforce.SObject(self.SFDataBaseName);
                account.ring__SessionID__c = $.cookie('sfwssessionid');
                account.ring__Extension__c = self.loginFields.ringex;
                account.ring__Password__c = self.loginFields.pass;
                account.Name = self.loginFields.ringnum;
                sforce.connection.create([account],self.emptyRespons());
            } else {
                self.notLogged();
            }
        } else {
            var record = it.next();
            self.loginFields.SFID = record.Id.toString();
            if(record.Name != undefined) {
                self.loginFields.ringnum = record.Name.toString();
                self.loginFields.ringex = (record.ring__Extension__c == null)?"":record.ring__Extension__c.toString();
                self.loginFields.pass = record.ring__Password__c.toString();
                $(".shadow").css({"display":"block"});
                self.widgetCore.login(self.loginFields.ringnum, self.loginFields.ringex, self.loginFields.pass);
            }
            $.cookie("widget_options", record.ring__Settings__c, { path: '/' });
            self.createDesposition();
            self.noactiveTab();
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
    },
    updateSFLogin: function(self, result) {
        var it = new sforce.QueryResultIterator(result);
        if(it.records.length == 0) {    //No user logedin
            $.cookie("widget_options", null, { path: '/' });
            if(typeof self.loginFields.ringnum != "undefined") {
                var account = new sforce.SObject(self.SFDataBaseName);
                account.ring__SessionID__c = $.cookie('sfwssessionid');
                account.ring__Extension__c = self.loginFields.ringex;
                account.ring__Password__c = self.loginFields.pass;
                account.Name = self.loginFields.ringnum;
                sforce.connection.create([account],self.emptyRespons());
            } else {
                self.notLogged();
            }
        } else {
            var record = it.next();
            var account = new sforce.SObject(self.SFDataBaseName);
            account.Id = record.Id;
            self.loginFields.SFID = record.Id;
            account.ring__SessionID__c = $.cookie('sfwssessionid');
            $.cookie("widget_options", record.ring__Settings__c, { path: '/' });
            self.createDesposition();
            self.noactiveTab();
            sforce.connection.update([account],self.emptyRespons());
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
    },
    emptyRespons: function(func) {
        var self = this;
        if(func == undefined) {
            var func = function(self, result) {
                if(result[0] != undefined && result[0].success == "false") {
                    self.displaySFError(self, result);
                }
            };
        }
        return {
            onSuccess : function(result) {return func(self, result);},
            onFailure : function(result) {self.displaySFError(self, result);}
        };
    },
    displaySFError: function (self, error) {
        if(error.faultcode == "sf:INVALID_SESSION_ID") {
            ErrorHolder({'code':"SF",'text':"This page does not support integration with SF API"});
            self.userListAction();
        } else {
            ErrorHolder({'code':"SF",'text':"oops something went wrong ... " + error});
        }
    }
    
}

//--------------------------------
//------- Main 
//--------------------------------
var GUI;
$(document).ready(
    function () {
        if(window.location.search=="?nowidget=true") {
            $("#rc-panel").hide()
            return false;
        }
        var widget = new rcWidgetCore();
        GUI = new rcWidgetUI(widget);
        
        //--------------
        GUI.init(); //Init UI
        GUI.accountInfoTabs();  //Create tabs slider
        GUI.mainnTab();
        //GUI.noactiveTab();
        GUI.saveButtonAction(); //Save button
        
        //Settings button
        $(".settings a").unbind();
        $(".settings a").bind("click", function(event) {
            if($(this).parent().hasClass('na')) {
                $(this).parent().removeClass('na');
                if($.cookie('sfwssessionid')!=null) {
                    $("#Logout").parent().css({"display":"none"});
                    GUI.noactiveTab();
                    GUI.widgetCore.getList(); 
                    GUI.showMessages();
                    //Save settings
                    var account = new sforce.SObject(GUI.SFDataBaseName);
                    account.Id = GUI.loginFields.SFID;
                    account.ring__Settings__c = $.cookie('widget_options');
                    sforce.connection.update([account],GUI.emptyRespons());
                }
            } else {
                $(this).parent().addClass('na');
                GUI.showAccinfo();
                if($("#rc-panel .accinfo").is(":visible") && $("#rc-panel .accinfo .slide:first").is(":hidden")) {
                    $("#Logout").parent().css({"display":"block"});
                }
            }
            GTimerFunc();
            $("#rc-panel").click();
            return false;
        });
        
        window.onerror = function(error) {};
        
        //---------------
});
//Global function for Flash Bridge
var showNumber = function(arg) {
    clearTimeout(GlobalTimer);
    GUI.showPlaceCall();
    
    var tmp = arg.toString();
    tmp = tmp.replace(/[^\d]*/g,'');
    $(".callusother #auslt").val(tmp);
    tmp = ""; 
}

