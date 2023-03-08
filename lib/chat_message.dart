import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.chattext, required this.sender})
      : super(key: key);

  final String chattext;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

//////////////////////////////creating sender's avatar//////////////////////////
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 4, 10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/$sender'),
            maxRadius: 16,
    ),),

/////////////////////////////creating chat message card/////////////////////////
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration:BoxDecoration(
                      borderRadius:const BorderRadius.all(Radius.circular(16)),
                      color: Colors.green[100],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(chattext.trim(), style: const TextStyle(color: Colors.black, fontSize: 15)),
                  ))],))],);}
}
