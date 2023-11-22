public with sharing class showParticipantList {

    @Auraenabled
    public static List<Contact> getParticipantsList(){

        return [Select id,FirstName,GameId__c,Email,Phone from Contact where  GameId__c!='' AND IsPlayerBanned__c=false];
        
    }


}
