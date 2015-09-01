/**************************************************************************************************
* Project Name..........: Telus-RC S2S                                                            *
* File..................: S2SConnectionHelperCls.class                                    		  *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: September 1, 2014                                                       *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: September 3, 2014                                                       *
* Description...........: General helper class for getting S2S connection informations			  *
**************************************************************************************************/
public class S2SConnectionHelperCls {

	/****************************************************************************************
	 * @Description - Method to get Network Connection Id     								* 
	 * @params String																		*			                                       
	 * @return Id      			                                                        	*
	 ***************************************************************************************/
    public static Set<Id> getConnectionId(String connectionName) {
    	Set<Id> connectionIdSet = new Set<Id>();
        List<PartnerNetworkConnection> partnerNetConList =
           [Select id from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
        
        if ( partnerNetConList.size() != 0 ) {
        	for(PartnerNetworkConnection pnc : partnerNetConList){
        		connectionIdSet.add(pnc.Id);
        	}
        }
        return connectionIdSet;
    }

}