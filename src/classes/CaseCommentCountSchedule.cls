global class CaseCommentCountSchedule implements Schedulable  {
	 global void execute(SchedulableContext ctx) {
	 	CaseCommentCountBatch objCaseCommentCountBatch = new CaseCommentCountBatch(); 
   		objCaseCommentCountBatch.strQuery =	 'Select (Select ParentId, IsPublished, CreatedById, CreatedBy.Email From CaseComments) From Case';		 
		Database.executeBatch(objCaseCommentCountBatch, 200);
	 }
}