public class TriggerHandler {
	
	public static Boolean BY_PASS_BEFORE = false;
    public static Boolean BY_PASS_AFTER = false;
    //----------------As/simplion/2/25/2015 start-----------------------------
    public static Boolean BY_PASS_ACCOUNT_ON_AFTER = false;
    public static Boolean BY_PASS_ACCOUNT_ON_BEFORE = false;
    public static Boolean BY_PASS_IMPLEMENTATION_ON_AFTER = false;
    public static Boolean BY_PASS_IMPLEMENTATION_ON_BEFORE = false;
    public static Boolean BY_PASS_EVENT_ON_BEFORE = false;
    public static Boolean BY_PASS_EVENT_ON_AFTER = false;
    public static Boolean BY_PASS_PARTNER_ACCOUNT_ON_AFTER = false;
    public static Boolean BY_PASS_PARTNER_ACCOUNT_ON_BEFORE = false;
    public static Boolean BY_PASS_CONTACT_ON_AFTER = false;
    public static Boolean BY_PASS_CONTACT_ON_BEFORE = false;
    
    //--------------For Leads---------------------------------------------------
    
    public static Boolean BY_PASS_LEAD_BEFORE = false;
    public static Boolean BY_PASS_LEAD_AFTER = false;
	
	//----------------As/simplion/2/25/2015 end-----------------------------
	
	
	public static Boolean BY_PASS_ACCOUNT_ON_UPDATE = false;
	public static Boolean BY_PASS_ACCOUNT_ON_INSERT = false;

	public static Boolean BY_PASS_CONTACT_ON_UPDATE = false;
	public static Boolean BY_PASS_CONTACT_ON_INSERT = false;

	public static Boolean BY_PASS_OPPORTUNITY_ON_UPDATE = false;
	public static Boolean BY_PASS_OPPORTUNITY_ON_INSERT = false;

	public static Boolean BY_PASS_CASE_ON_UPDATE = false;
	public static Boolean BY_PASS_CASE_ON_INSERT = false;

	public static Boolean BY_PASS_LINEITEM_ON_UPDATE = false;
	public static Boolean BY_PASS_LINEITEM_ON_INSERT = false;

	public static Boolean BY_PASS_RCQUOTE_ON_UPDATE = false;
	public static Boolean BY_PASS_RCQUOTE_ON_INSERT = false;

	public static Boolean BY_PASS_Approver_Trigger = false; 
	private static boolean ALLOW_TRIGGER_REQUEST_ONCE = true;

	public static Boolean BY_PASS_CARRIERDATA_ON_INSERT = false;
	public static Boolean BY_PASS_CARRIERDATA_ON_UPDATE = false;

	public static Boolean BY_PASS_CASE_Trigger = false;

	public static Boolean UPDATE_CONTACT_BMID = false;

	public static Boolean BY_PASS_LEAD_UPDATE = false;

	public static Boolean BY_PASS_CASECOMMENT_ON_UPDATE = false;
	public static Boolean BY_PASS_CASECOMMENT_ON_INSERT = false;

	public static Boolean BY_PASS_PARTNERCOMM_ON_UPDATE = false;
	public static Boolean BY_PASS_PARTNERCOMM_ON_INSERT = false;

	/* Setting Bypass flag for Event Trigger. */
	public static Boolean BY_PASS_EVENT_ON_INSERT = false;
	public static Boolean BY_PASS_EVENT_ON_UPDATE =  false;

	//For Account Hierarchy Total DLS Field updation. Used to store the Ids of the related accounts of the account which is being deleted.
	public static Set<String> RELATED_ACCOUNT_ID_SET = new Set<String>();

	public static Boolean HIDE_VALIDATION_ERROR_ON_IMPLEMENTATION = false;
	public static void HIDE_VALIDATION_ERROR_ON_IMPLEMENTATION() {
		HIDE_VALIDATION_ERROR_ON_IMPLEMENTATION = true;
	}

	public static void BY_PASS_CARRIERDATA_ON_INSERT(){
		BY_PASS_CARRIERDATA_ON_INSERT = true;
	}
	public static void BY_PASS_CARRIERDATA_ON_UPDATE(){
		BY_PASS_CARRIERDATA_ON_UPDATE = true;
	}
	public static void BY_PASS_ACCOUNT_ON_UPDATE() {
		BY_PASS_ACCOUNT_ON_UPDATE = true;
	}
	public static void BY_PASS_ACCOUNT_ON_INSERT() {
		BY_PASS_ACCOUNT_ON_INSERT = true;
	}

	public static void BY_PASS_CONTACT_ON_UPDATE() {
		BY_PASS_CONTACT_ON_UPDATE = true;
	}
	public static void BY_PASS_CONTACT_ON_INSERT() {
		BY_PASS_CONTACT_ON_INSERT = true;
	}

	public static Boolean BY_PASS_LEAD_UPDATE_ON_INSERT = false;

	public static void BY_PASS_LEAD_UPDATE_ON_INSERT() {
		BY_PASS_LEAD_UPDATE_ON_INSERT = true;
	}

	public static void BY_PASS_OPPORTUNITY_ON_UPDATE() {
		BY_PASS_OPPORTUNITY_ON_UPDATE = true;
	}
	public static void BY_PASS_OPPORTUNITY_ON_INSERT() {
		BY_PASS_OPPORTUNITY_ON_INSERT = true;
	}

	public static void BY_PASS_CASE_ON_UPDATE() {
		BY_PASS_CASE_ON_UPDATE = true;
	}
	public static void BY_PASS_CASE_ON_INSERT() {
		BY_PASS_CASE_ON_INSERT = true;
	}
	public static void BY_PASS_LINEITEM_ON_UPDATE() {
		BY_PASS_LINEITEM_ON_UPDATE = true;
	}
	public static void BY_PASS_LINEITEM_ON_INSERT() {
		BY_PASS_LINEITEM_ON_INSERT = true;
	}
	public static void BY_PASS_RCQUOTE_ON_UPDATE() {
		BY_PASS_RCQUOTE_ON_UPDATE = true;
	}
	public static void BY_PASS_RCQUOTE_ON_INSERT() {
		BY_PASS_RCQUOTE_ON_INSERT = true;
	}
	public static void BY_PASS_EVENT_ON_INSERT() {
		BY_PASS_EVENT_ON_INSERT = true;
	}
	public static void BY_PASS_EVENT_ON_UPDATE() {
		BY_PASS_EVENT_ON_UPDATE = true;
	}
	public static void BY_PASS_CASECOMMENT_ON_UPDATE() {
		BY_PASS_CASECOMMENT_ON_UPDATE = true;
	}
	public static void BY_PASS_CASECOMMENT_ON_INSERT() {
		BY_PASS_CASECOMMENT_ON_INSERT = true;
	}
	public static void BY_PASS_PARTNERCOMM_ON_UPDATE() {
		BY_PASS_PARTNERCOMM_ON_UPDATE = true;
	}
	public static void BY_PASS_PARTNERCOMM_ON_INSERT() {
		BY_PASS_PARTNERCOMM_ON_INSERT = true;
	}
	public static void RESET_VARIABLES() {
		BY_PASS_ACCOUNT_ON_UPDATE = false;
		BY_PASS_ACCOUNT_ON_INSERT = false;

		BY_PASS_CONTACT_ON_UPDATE = false;
		BY_PASS_CONTACT_ON_INSERT = false;

		BY_PASS_OPPORTUNITY_ON_UPDATE = false;
		BY_PASS_OPPORTUNITY_ON_INSERT = false;

		BY_PASS_CASE_ON_UPDATE = false;
		BY_PASS_CASE_ON_INSERT = false;

		BY_PASS_LEAD_UPDATE_ON_INSERT = false;

		BY_PASS_LINEITEM_ON_UPDATE = false;
		BY_PASS_LINEITEM_ON_INSERT = false;

		BY_PASS_RCQUOTE_ON_UPDATE = false;
		BY_PASS_RCQUOTE_ON_INSERT = false;

		BY_PASS_CASECOMMENT_ON_UPDATE = false;
		BY_PASS_CASECOMMENT_ON_UPDATE = false;
	}
	public static Boolean ALLOW_TRIGGER_REQUEST_ONCE() {
		if(ALLOW_TRIGGER_REQUEST_ONCE) {
			ALLOW_TRIGGER_REQUEST_ONCE = false;
			return true;
		}
		return ALLOW_TRIGGER_REQUEST_ONCE;
	}


	public static Boolean BY_PASS_UPDATE_ACCOUNT_ACTIVE_DATE = false;
	public static Boolean BY_PASS_SEND_EMAILS = false;
	public static Boolean BY_PASS_SURVEY = false;
	public static Boolean BY_PASS_PARTNER_ACCOUNTS = false;
	public static Boolean BY_PASS_UP_LIST_ACCOUNT = false;
	public static Boolean BY_PASS_IMPLEMENTATION_LEADS = false;
	public static Boolean BY_PASS_DEINITALIZE = false;
	public static Boolean BY_PASS_TOGGLE_NUMBER_PORTING = false;

	public static Boolean CHECK_DUPLICATE = false;
	public static Boolean UPDATE_EMAIL = false;   
	public static Boolean DUPLICATE_CONTACT = false; 

	public static Boolean UPDATE_ACCOUNT_INFORMATION = false;
	public static Boolean ACCOUNT_SHARING_ON_INSERT =false;
	public static Boolean ACCOUNT_SHARING_ON_UPDATE0 = false;
	public static Boolean ACCOUNT_SHARING_ON_UPDATE2 = false;
	public static Boolean UPDATE_PARTNER_CODE_ON_INSERT_AND_UPDATE = false;


}