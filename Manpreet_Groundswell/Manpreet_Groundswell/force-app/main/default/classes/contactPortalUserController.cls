public   class contactPortalUserController {
private static Id PORTAL_ACCOUNT_ID = '0018Z00002f5HscQAE';

@AuraEnabled
public static list<Contact> createContact(String FirstName,String LastName, String Mobile,String Email){
List <Contact> contactList = new List<Contact>();
Contact con  = new Contact();
try{
con.FirstName = FirstName;
con.LastName = LastName;
con.Email = Email;
con.Phone = Mobile;
con.GameId__c =contactPortalUserController.generateGameId();
con.accountid =PORTAL_ACCOUNT_ID;
con.IsPlayerBanned__c=false;
contactList.add(con);
database.insert(contactList);
System.debug('@@@@@@@contactList' + contactList);

if(contactList[0].id <> null){
contactPortalUserController.createPortalUser(contactList[0].FirstName,contactList[0].LastName,contactList[0].Email,contactList[0].Phone,contactList[0].id);

}
}

catch(Exception e){

System.debug('Exeption occured'+ e.getMessage());
}
return contactList;
}

@AuraEnabled
public static String generateGameId (){
Integer len = 6;
String str = string.valueof(Math.abs(Crypto.getRandomLong()));
String randomNumber = str.substring(0, len);
system.debug('Random Number-' + randomNumber);
return randomNumber;
}
@Future
public static void createPortalUser(String FirstName,String LastName,String Email,String Phone,String contactId){
try{
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User' Limit 1];
    //  UserRole portalRole = [Select Id,DeveloperName  From UserRole Where DeveloperName  = 'CEO' Limit 1];
    User portalUser = new User(
    UserName = Email+'QuizPlayer',
    FirstName = FirstName,
    LastName = LastName,
    Alias = FirstName.substring(0,2),
    Email = Email,
    Phone = Phone,
    //UserRoleId = portalRole.Id,
        ContactId = contactId,
        ProfileId = portalProfile.Id,
        EmailEncodingKey = 'UTF-8',
        CommunityNickname = email+'PortalUser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );
    Database.insert(portalUser);
    System.debug('@@@@@@@PortalUSer' + portalUser);
}
catch(Exception e){

    System.debug('Exeption occured'+ e.getMessage());
    }

}
@AuraEnabled
    public static String sendMessage(string mobileno,string message)
    {
        System.debug('#######mobileno' + mobileno);
        System.debug('#######message' + message);

        errorResponseWrapper erw;
        final String fromNumber = '+14155238886'; 
        String account = 'AC83c284e8056d7de6b161611d0cde3c6b';  
        String token   = '409fb5feab19b7ac0c0a217715c554c7';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+account+'/Messages.json');
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        Blob headerValue = Blob.valueOf(account + ':' + token);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        HTTPResponse res;
        if(mobileno != null)
        {
            string jsonString='From='+EncodingUtil.urlEncode('whatsapp:+14155238886', 'UTF-8')+'&Body='+EncodingUtil.urlEncode(message, 'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+mobileno+'', 'UTF-8')+'';
            req.setBody(jsonString);
            System.debug('@@@@@@@@@@@@@@@jsonString' + jsonString);
            try{
                Http http = new Http();
                res = http.send(req);
                System.debug('##########res.getBody()' + res.getBody());
                if(res.getStatusCode()==201){
                    system.debug('Twilio Success'+mobileno);
                    WhatsAppMessageService.sendSms (mobileno,message);
                }

                else{
                    system.debug('Twilio failed'+mobileno);
                    erw =(errorResponseWrapper)json.deserialize(res.getBody(),errorResponseWrapper.class);
                    system.debug('Twilio error'+erw.message);
                }
            }
            catch(Exception e){
                system.debug('Error :'+e);
            } 
            
        }
        return res.getBody();
    }
    
    
    public class errorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
}
