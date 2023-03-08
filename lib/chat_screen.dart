import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'typing.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

///////////////////////////////creating variables///////////////////////////////
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;
  bool _isTyping=false;

/////////////////////////////////changing state/////////////////////////////////
  @override
  void initState() {
    chatGPT = ChatGPT.instance;
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }


//////////////////////////////////////sendMessage///////////////////////////////
  void sendMessage() {

/////////////////////////////////Inserting user message/////////////////////////
    ChatMessage message = ChatMessage(chattext: _textEditingController.text, sender: "user.png" );
    setState(() {
      _messages.insert(0, message);
      _isTyping=true;
    });

    _textEditingController.clear();
    final request = CompleteReq(prompt: message.chattext, model: kTranslateModelV3, max_tokens: 200);
    _subscription = chatGPT!
        .builder("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")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);

/////////////////////////////////Inserting chatgpt message//////////////////////
      ChatMessage botMessage = ChatMessage(chattext: response!.choices[0].text, sender: "bot.png");
      setState(() {
        _isTyping=false;
        _messages.insert(0, botMessage);
      });
    });
  }
////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////_buildTextComposer////////////////////////////
  Widget _buildTextComposer() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(2, 10, 2, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                  child: TextFormField(
                    controller: _textEditingController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x00000000), width: 1,),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x00000000), width: 1,),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x00000000), width: 1,),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x00000000), width: 1,),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: const Color(0xFEF2F2F2),
                    ),
                    maxLines: 1,
                  ),),),
            Container(
              padding: const EdgeInsets.fromLTRB(9, 0, 6, 0),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green,
              ),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.send_rounded, size: 28,),
                onPressed: () => sendMessage(),
              ),),],),);
  }
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
            maxRadius: 18,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/bot.png')),
          ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ChatGPT",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                if(_isTyping) const Typing(),
              ],),],),),
      body: SafeArea(
        child: Column(children: [
            Flexible(
                child: ListView.builder(reverse: true, padding: Vx.m8, itemCount: _messages.length, itemBuilder: (cnx, index) {return _messages[index];})),
            Container(
              child: _buildTextComposer(),
            )],),),
    );
  }
}
