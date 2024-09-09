//chaque action qui doit etre effectue au niveau de UI doit se traduit par une 
//action ou event au niveau de bloc pour le traiter et emettre un emit
//le bloc fait appelle au repository et emet le message
import 'package:bloc/bloc.dart';
import 'package:chatbot_gpt/model/chatbotmodel.dart';
import 'package:chatbot_gpt/repository/chatbotrepository.dart';

abstract class ChatBotEvent{}

class AskGptEvent extends ChatBotEvent{
  final String query;

  AskGptEvent({required this.query});
}

abstract class ChatBotState{
  final List<Message> messages;

  ChatBotState({required this.messages});
}

class ChatBotPendingState extends ChatBotState{
  ChatBotPendingState({required super.messages});
  
}

class ChatBoteSuccessState extends ChatBotState{
  ChatBoteSuccessState({required super.messages});
}

class ChatBoteErrorState extends ChatBotState{
  final String errorMessage;
  ChatBoteErrorState({ required this.errorMessage,required super.messages});
}

class ChatBotInitialState extends ChatBotState{
  ChatBotInitialState():super(messages: [
    Message(message: "Hello", type: "user"),
    Message(message: "How can I help you", type: "assistant")
  ]);
  
}

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState>{
  final ChatBotRepository chatBotRepository= ChatBotRepository();
  late ChatBotEvent lastEvent;

  ChatBotBloc():super(ChatBotInitialState()){
    on((AskGptEvent event, emit) async{
      lastEvent =event;
      emit(ChatBotPendingState(messages: state.messages));
      List<Message> currentmessages= state.messages;
      currentmessages.add(Message(message: event.query, type: "user"));
      try {
        Message responseMessage =await chatBotRepository.askLLMGPT(event.query);
        
        currentmessages.add(responseMessage);
        emit(ChatBoteSuccessState(messages: currentmessages));
      } catch (err) {
        emit(ChatBoteErrorState(errorMessage: err.toString(), messages: state.messages));
      }
    },);

  }
  
}