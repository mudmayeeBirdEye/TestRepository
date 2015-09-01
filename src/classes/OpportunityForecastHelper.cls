global class OpportunityForecastHelper {
	WebService static void setEndDateOfMonth(string oppID) { 	  
		Opportunity oppObj = new Opportunity(id = oppID);
		Date firstDayOfMonth = System.today().toStartOfMonth();
		Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
		oppObj.CloseDate = lastDayOfMonth;
		update oppObj;
	}
	
	WebService static void setEndDateOfQuater(string oppID) { 	  
		Opportunity oppObj = new Opportunity(id = oppID);
		oppObj.CloseDate = setCurrentQuarter();
		update oppObj;
	}
	
	private static Date setCurrentQuarter() {
    	Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
    	//Integer FiscalYearStartMonth  = 7;
		Date fiscalYearStartDate;
		Integer quarter;
		if(system.today().month() >= FiscalYearStartMonth) {
    		fiscalYearStartDate = date.newinstance(system.today().year(), FiscalYearStartMonth, 1);
    		quarter = ((system.today().month() - FiscalYearStartMonth) / 3) + 1;
		}
		else {
    		fiscalYearStartDate = date.newinstance(system.today().year() - 1, FiscalYearStartMonth, 1);
    		quarter = ((12 + system.today().month() - FiscalYearStartMonth) / 3) + 1;
		}    
		Integer addMonths = quarter * 3;
		Date lastDateOfThisQuarter = fiscalYearStartDate;
		lastDateOfThisQuarter = lastDateOfThisQuarter.addMonths(addMonths).addDays(-1);
		return lastDateOfThisQuarter;
    }
}