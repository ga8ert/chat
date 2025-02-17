import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/providers/authentication_provider.dart';
import 'package:untitled1/providers/chat_provider.dart';
import 'package:untitled1/utilities/global_methods.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField(
      {super.key,
      required this.contactUID,
      required this.groupId,
      required this.contactImage,
      required this.contactName});

  final String contactUID;
  final String contactName;
  final String contactImage;
  final String groupId;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  //send text message to fireStore
  void sendTextMessage() {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendTextMessage(
        sender: currentUser,
        contactUID: widget.contactUID,
        contactName: widget.contactName,
        contactImage: widget.contactImage,
        message: _textEditingController.text,
        messageType: MessageEnum.text,
        groupId: widget.groupId,
        onSuccess: (){
          _textEditingController.clear();
          _focusNode.requestFocus();
        },
        onError: (error){
          showSnackBar(context, error);
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Constants.fProjectColor,
          border: Border.all(color: Constants.sProjectColor)),
      child: Row(
        children: [
          IconButton(
             onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 200,
                      child: const Center(
                        child: Text('Attachment'),
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.attach_file_outlined),
          ),
          Expanded(
              child: TextFormField(
                controller: _textEditingController,
                focusNode: _focusNode,
            decoration: const InputDecoration.collapsed(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none),
                hintText: 'Type a message'),
          )),
          GestureDetector(
            onTap: sendTextMessage,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.sProjectColor),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_circle_up,
                  color: Constants.fProjectColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
