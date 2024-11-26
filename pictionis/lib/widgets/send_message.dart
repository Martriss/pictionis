import 'package:flutter/material.dart';
import 'package:pictionis/service/message_service.dart';
import 'package:pictionis/theme.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessage();
}

class _SendMessage extends State<SendMessage> {
  final _textFieldController = TextEditingController();

  Future<void> _submitMessage(String value) async {
    if (_textFieldController.text.isEmpty) return; // No need to do something if textField is empty
  
    await MessageService().sendMessage(message: _textFieldController.text, roomID: "TEST");
  }

  Widget _field(String hintText,TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.5)),
          borderSide: const BorderSide(color: MyColors.colorDefault)
        ),
        hintText: hintText,
        hintStyle: basicStyle()
      ),
      autocorrect: false,
      onSubmitted: _submitMessage
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return BottomAppBar(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _field('Tapez ici...', _textFieldController)
      ),
    );
  }
}
