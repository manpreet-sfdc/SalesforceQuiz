public class WhatsAppMessageService {


@AuraEnabled
public static void sendMessage(string mobileno,string message)
{
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


if(mobileno != null)
{
    string jsonString='From='+EncodingUtil.urlEncode('whatsapp:+14155238886', 'UTF-8')+'&Body='+EncodingUtil.urlEncode(message, 'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+mobileno+'', 'UTF-8')+'';
    req.setBody(jsonString);
    System.debug('@@@@@@@@@@@@@@@jsonString' + jsonString);
    try{
        Http http = new Http();
        HTTPResponse res = http.send(req);
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
}
@AuraEnabled
public static void getResponsefromWhatsapp(){
String account = 'AC83c284e8056d7de6b161611d0cde3c6b';  
String token   = '409fb5feab19b7ac0c0a217715c554c7';
http ht =new http();
httprequest req = new httprequest();                                                                    //SM98c03bf21c00424681f1662ebcf7dfa7
req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+account+'/Messages.json');
req.setMethod('GET');
req.setHeader('Content-Type','application/json');
req.setHeader('Content-Type','application/x-www-form-urlencoded');

Blob headerValue = Blob.valueOf(account + ':' + token);
String authorizationHeader = 'BASIC ' +
    EncodingUtil.base64Encode(headerValue);
req.setHeader('Authorization', authorizationHeader);
HTTPResponse res=new HTTPResponse();
res= ht.send(req);
system.debug('@@@'+res);
system.debug('######  '+ res.getBody());

String responseBody = res.getBody();
Map<String, Object> requestInstance = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
String messages = String.valueOf(requestInstance.get('messages')).trim();

System.debug('#######messages' + messages);

}



@AuraEnabled
public static void sendSms(String mobileno,String smsBody){
system.debug('######SMSmobileno'+mobileno);
system.debug('######SsmsBody'+smsBody);
errorResponseWrapper erw;
final String fromNumber = '+18782039559 '; 
String account = 'AC83c284e8056d7de6b161611d0cde3c6b';  
String token   = '409fb5feab19b7ac0c0a217715c554c7';
HttpRequest req = new HttpRequest();
req.setEndpoint ('https://api.twilio.com/2010-04-01/Accounts/'+account+'/SMS/Messages.json');
req.setMethod('POST'); 
req.setHeader('Content-Type','application/json');
req.setHeader('Content-Type','application/x-www-form-urlencoded');
Blob headerValue = Blob.valueOf(account + ':' + token);
String authorizationHeader = 'BASIC ' +
EncodingUtil.base64Encode(headerValue);
req.setHeader('Authorization', authorizationHeader);
if(mobileno != null){
    req.setBody('To='+EncodingUtil.urlEncode(mobileno,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromNumber,'UTF-8')+'&Body='+smsBody);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    system.debug('######SMS '+ res.getBody());
    
    if(res.getStatusCode()==201){
        system.debug('Twilio Success'+mobileno);
    }
    else{
        system.debug('Twilio failed'+mobileno);
        erw =(errorResponseWrapper)json.deserialize(res.getBody(),errorResponseWrapper.class);
        system.debug('Twilio error'+erw.message);
    }
}


}
public class errorResponseWrapper{
String code;
String message;
String moreInfo;
String status;    
}

}
