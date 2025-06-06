import 'package:flutter/material.dart';
import 'package:pictionis/service/message_service.dart';
import 'package:pictionis/theme.dart';

class SendMessage extends StatefulWidget {
  final String roomID;
  const SendMessage({
    super.key,
    required this.roomID,
  });

  @override
  State<SendMessage> createState() => _SendMessage();
}

class _SendMessage extends State<SendMessage> {
  final _textFieldController = TextEditingController();

  Future<void> _submitMessage(String value) async {
    if (_textFieldController.text.isEmpty) {
      return; // No need to do something if textField is empty
    }

    await MessageService()
        .sendMessage(message: _textFieldController.text, roomID: widget.roomID);
    _textFieldController.clear();
  }

  Widget _field(String hintText, TextEditingController controller) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                borderSide: const BorderSide(color: MyColors.colorDefault)),
            hintText: hintText,
            hintStyle: basicStyle()),
        autocorrect: false,
        onSubmitted: _submitMessage);
  }

  Widget _button() {
    return IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          _submitMessage(_textFieldController.text);
        },
        tooltip: 'Envoyer',
        style: IconButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: CircleBorder(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return BottomAppBar(
      // color: Colors.grey[50],
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Expanded(child: _field('Tapez ici...', _textFieldController)),
              const SizedBox(width: 4),
              _button()
            ],
          )),
    );
  }
}
