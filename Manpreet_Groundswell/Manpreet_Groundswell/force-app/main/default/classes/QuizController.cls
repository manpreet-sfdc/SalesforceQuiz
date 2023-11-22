public with sharing class QuizController {
private static Id PORTAL_ACCOUNT_ID = '0018Z00002f5HscQAE';

public static void getContactPhoneNo(){
    Map<String,String> conPhoneMap =  new  Map<String,String>(); 
    List<Contact> conList = [Select GameId__c,accountid from Contact where GameId__c!='' AND accountid =:PORTAL_ACCOUNT_ID];
    if(conList.size()>0){
        for(User u :[SELECT Id,Contact.Id,Contact.GameId__c,Phone,Profile.Name FROM User WHERE Profile.Name = 'Customer Community User' 
        AND ContactId IN :conList]){
            conPhoneMap.put(u.Phone,u.Contact.GameId__c);
            // WhatsAppMessageService.sendMessage();

        }
        System.debug('###conPhoneMap' +conPhoneMap);
    }
    if(conPhoneMap.size()>0){
    }

}
@AuraEnabled
public static String getLeadPhone(){
String phone = '';
List <Lead> leadlist = [Select id, phone,IsInterestedInQuiz__c from lead where IsInterestedInQuiz__c =true];

if(leadlist.size()>0){
phone  =  leadlist[0].Phone;
System.debug('@@@@@phone' + phone);
}
return phone;

}
@AuraEnabled
public static List<Quiz_Question__c> getQuestions(Integer offset){
List<Quiz_Question__c> questionsList = [Select id, Question__c,Answer_A__c, Answer_B__c ,Answer_C__c,Answer_D__c,Correct_Answer__c from Quiz_Question__c Limit 1 OFFSET :offset];

System.debug('@@@@@@questionsList' + questionsList);
return questionsList;
}
}
