global class migrateObjects {
	
	/*WebService static void migrateNotes(String s){
	Integer count = 0;
	List<Note> notes = new List<Note>();
	String pId;
	String impId;
	List<Note> newNotes = new List<Note>();
		notes = [SELECT Id, parentId, Body, OwnerId, Title FROM Note WHERE parent.type='Contract' LIMIT 1000];
		for(Integer i=0; i<notes.size(); i++){			
			pId = notes[i].parentId;
			if(pId.startsWith('800') && notes[i].OwnerId == '005800000037CiB'){
				count++;
				impId=null;
				String aId = [SELECT AccountId FROM Contract WHERE id=:pId].AccountId;
				system.debug('note ID: ' + notes[i].Id + ', Account Id: ' + aId);
				try{
					impId = [SELECT Id FROM Implementation__c WHERE Account__c=: aid LIMIT 1].Id;
					//if(notes[i].OwnerId == '005800000037CiB'){
						newNotes.add(new Note(Body=notes[i].body, ParentId=impId, Title=notes[i].Title));	
					//}
					//else{
						//newNotes.add(new Note(Body=notes[i].body, ParentId=impId, OwnerId=notes[i].OwnerId, Title=notes[i].Title));
					//}
					delete notes[i];
					
				}
				catch(System.QueryException e){
					if(impId==null){
						//if(notes[i].OwnerId == '005800000037CiB'){
							newNotes.add(new Note(Body=notes[i].body, ParentId=aId, Title=notes[i].Title));	
						//}
						//else{
							//newNotes.add(new Note(Body=notes[i].body, ParentId=aId, OwnerId=notes[i].OwnerId, Title=notes[i].Title));
						//}
						delete notes[i];
					}
				}
			}
			if(count == 48){
			system.debug('ive done 48');
			i=9999;				
			}
		}
		insert newNotes;		
	}
	*/
	
	/*
	 WebService static void createAccounts(){
		List<String> l = new List<String>();



l.add('36773373');
l.add('42538065');
l.add('45211995');
l.add('49173037');
l.add('51873887');
l.add('55651240');
l.add('55651694');
l.add('55659440');
l.add('55670776');
l.add('55724438');
l.add('55777141');
l.add('55790488');
l.add('55797061');
l.add('55820099');
l.add('55878501');
l.add('55890514');
l.add('55897193');
l.add('55905266');
l.add('55944838');
l.add('55964307');
l.add('55975526');
l.add('55988008');
l.add('56005070');
l.add('56015902');
l.add('56027661');
l.add('56097916');
l.add('56106610');
l.add('56135667');
l.add('56158693');
l.add('56190872');
l.add('56234273');
l.add('56241132');
l.add('56242442');
l.add('56295452');
l.add('56295942');
l.add('56297677');
l.add('56308014');
l.add('56356658');
l.add('56386370');
l.add('56387473');
l.add('56401037');
l.add('56426716');
l.add('56461856');
l.add('56470528');
l.add('56470789');
l.add('56476904');
l.add('56477401');
l.add('56506382');
l.add('56562099');
l.add('56586498');
l.add('56598081');
l.add('56638053');
l.add('56655840');
l.add('56665353');
l.add('56691244');
l.add('56715878');
l.add('56725866');
l.add('56745690');
l.add('56748768');
l.add('56756251');
l.add('56769605');
l.add('56791972');
l.add('56813781');
l.add('56820378');
l.add('56821859');
l.add('56822627');
l.add('56823018');
l.add('56824828');
l.add('56870285');
l.add('56870433');
l.add('56873323');
l.add('56873502');
l.add('56875103');
l.add('56884308');
l.add('56884436');
l.add('56910938');
l.add('56960058');
l.add('56993508');
l.add('57001788');
l.add('57015588');
l.add('57029604');
l.add('57031787');
l.add('57047113');
l.add('57111576');
l.add('57137961');
l.add('57149665');
l.add('57184565');
l.add('57201994');
l.add('57211129');
l.add('57213459');
l.add('57216608');
l.add('57221573');
l.add('57229213');
l.add('57232117');
l.add('57245429');
l.add('57245872');
l.add('57249772');
l.add('57252414');
l.add('57254002');
l.add('57264542');
l.add('57280442');
l.add('57304056');
l.add('57311978');
l.add('57332353');
l.add('57357682');
l.add('57368015');
l.add('57369390');
l.add('57393743');
l.add('57399850');
l.add('57400973');
l.add('57402456');
l.add('57415800');
l.add('57416447');
l.add('57439580');
l.add('57441982');
l.add('57447097');
l.add('57451379');
l.add('57458137');
l.add('57461119');
l.add('57469336');
l.add('57499842');
l.add('57503007');
l.add('57503234');
l.add('57525403');
l.add('57526975');
l.add('57530321');
l.add('57533859');
l.add('57550595');
l.add('57570280');
l.add('57572016');
l.add('57592554');
l.add('57604468');
l.add('57607240');
l.add('57646053');
l.add('57675489');
l.add('57681325');
l.add('57681330');
l.add('57688382');
l.add('57708178');
l.add('57713793');
l.add('57714016');
l.add('57725374');
l.add('57733810');
l.add('57737848');
l.add('57743692');
l.add('57743982');
l.add('57746255');
l.add('57747378');
l.add('57748403');
l.add('57751643');
l.add('57753074');
l.add('57775695');
l.add('57787619');
l.add('57789159');
l.add('57800987');
l.add('57805713');
l.add('57808821');
l.add('57810055');
l.add('57811736');
l.add('57817248');
l.add('57820707');
l.add('57839746');
l.add('57874818');
l.add('57877555');
l.add('57886463');
l.add('57891947');
l.add('57911947');
l.add('57912806');
l.add('57927485');
l.add('57928730');
l.add('57932827');
l.add('57933160');
l.add('57933601');
l.add('57954143');
l.add('57963502');
l.add('57967979');
l.add('57969802');
l.add('57970724');
l.add('57972735');
l.add('58008961');
l.add('58011533');
l.add('58024134');
l.add('58033440');
l.add('58034180');
l.add('58037417');
l.add('58049762');
l.add('58056836');
l.add('58071653');
l.add('58076296');
l.add('58082087');
l.add('58088074');
l.add('58092737');
l.add('58100863');
l.add('58102855');
l.add('58137538');
l.add('58154870');
l.add('58155419');
l.add('58156019');
l.add('58169142');
l.add('58212358');
l.add('58230682');
l.add('58263302');
l.add('58264642');
l.add('58270797');
l.add('58294975');
l.add('58295002');
l.add('58295114');
l.add('58296216');
l.add('58303302');
l.add('58303347');
l.add('58307617');
l.add('58325142');
l.add('58329204');
l.add('58334399');
l.add('58334468');
l.add('58334893');
l.add('58335438');
l.add('58339335');
l.add('58348546');
l.add('58352631');
l.add('58355868');
l.add('58360585');
l.add('58370335');
l.add('58377425');
l.add('58377470');
l.add('58377557');
l.add('58379171');
l.add('58390782');
l.add('58408309');
l.add('58431641');
l.add('58438309');
l.add('58439316');
l.add('58446520');
l.add('58460530');
l.add('58462229');
l.add('58466612');
l.add('58467103');
l.add('58476783');
l.add('58477897');
l.add('58484200');
l.add('58506273');
l.add('58520718');
l.add('58535461');
l.add('58586575');
l.add('58593939');
l.add('58596948');
l.add('58597401');
l.add('58611742');
l.add('58636478');
l.add('58637862');
l.add('58639188');
l.add('58652426');
l.add('58652674');
l.add('58684419');
l.add('58684972');
l.add('58701733');
l.add('58701760');
l.add('58701821');
l.add('58701865');
l.add('58706988');
l.add('58707278');
l.add('58735324');
l.add('58813246');
l.add('58813398');
l.add('58835044');
l.add('58850283');
l.add('58857389');
l.add('58857780');
l.add('58868279');
l.add('58872943');
l.add('58897312');
l.add('58898483');
l.add('58902782');
l.add('58914859');
l.add('58916146');
l.add('58925940');
l.add('58927455');
l.add('58927722');
l.add('58927909');
l.add('58939900');
l.add('58941401');
l.add('58955146');
l.add('58970280');
l.add('58972722');
l.add('58972991');
l.add('58996938');
l.add('58998787');
l.add('59004291');
l.add('59006948');
l.add('59015741');
l.add('59018385');
l.add('59019339');
l.add('59024383');
l.add('59036832');
l.add('59038796');
l.add('59044482');
l.add('59045144');
l.add('59047255');
l.add('59076375');
l.add('59076533');
l.add('59089702');
l.add('59098787');
l.add('59101787');
l.add('59104510');
l.add('59116008');
l.add('59142070');
l.add('59143802');
l.add('59162500');
l.add('59162709');
l.add('59162859');
l.add('59162935');
l.add('59172943');
l.add('59176747');
l.add('59192522');
l.add('59192569');
l.add('59192615');
l.add('59225943');
l.add('59233434');
l.add('59236363');
l.add('59237484');
l.add('59252846');
l.add('59274454');
l.add('59283677');
l.add('59290723');




		for(Integer i=0; i<l.size(); i++){
			for(Contract c : [SELECT id, AccountId FROM Contract WHERE RC_User_ID__c =: decimal.valueOf(l.get(i))]){
				//system.debug('UserId: ' + l.get(i).format());
				
				Account newa = new Account(Name='newaccountbyjesse',RC_User_Id__c=l.get(i),RC_sync_status__c='In Sync');
				insert newa;
				//Contact oldc = [SELECT id,firstname,lastname,phone,email FROM Contact WHERE AccountId=:c.AccountId Limit 1];
				Contact newc = new Contact(lastname='newcontactbyJesse',accountId=newa.Id);
				insert newc;
				//c.AccountId=newa.Id;
				//update c;
				system.debug('UserId: ' + l.get(i) + ', AccountId: ' + newa.Id + ', ContactId: ' + newc.Id);
				
			}
		}

		
	}
*/
}