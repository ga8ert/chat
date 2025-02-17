import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/message_model.dart';

class ContactMessageWidgets extends StatelessWidget {
  const ContactMessageWidgets({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh,':',nn,' ',]);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.7,
          minWidth: MediaQuery.of(context).size.width*0.3,
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 30, top: 5, bottom: 20
                ),
                child: Text(
                  message.message,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child:
                      Text(
                        time,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
