import 'dart:convert';

import 'package:chatbot_gpt/model/chatbotmodel.dart';
import 'package:http/http.dart' as http;

//c'est dans le dossier repositoryu on cree les connexion avec le Backend, on y met les connexion htpp avec les erreur etc

class ChatBotRepository{
  Future<Message> askLLMGPT(String query) async{
    var url = "https://api.openai.com/v1/chat/completions";
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                      "Authorization": "Bearer ...."
                    };
                    var prompt = {
                      "model": "gpt-3.5-turbo",
                      "messages": [
                        {"role": "user", "content": query}
                      ],
                      "temperature": 0
                    };

                    try {
                       http.Response response=await http.post(Uri.parse(url), headers: headers, body: json.encode(prompt));
                       if(response.statusCode==200){
                        Map<String, dynamic> result= jsonDecode(response.body);
                        Message message=Message(message: result['choices'][0]['message']['content'], type: "assistant");
                        return message;
                       }
                       else{
                        return throw('Error ${response.statusCode}');
                       }
                    }catch(err){
                      return throw('err ${err.toString()}');
                    }
                        
  }
}