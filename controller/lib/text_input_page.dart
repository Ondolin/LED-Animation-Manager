import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPage extends StatefulWidget {
    TextPage({Key? key, required this.title, required this.currentText, required this.gostText, required this.onTextChanged}) : super(key: key);

    final String title;
    
    final String currentText;
    final String gostText;

    final Function(String) onTextChanged;

    @override
    State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {

    late TextEditingController _textController;

    String newText = "";

    @override
    void initState() {
        super.initState();
        _textController = TextEditingController(text: widget.currentText);
    }

    @override
    void dispose() {
        _textController.dispose();
        if (newText != "")
            widget.onTextChanged(newText);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: true,
                middle: Text(widget.title)
            ),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 120, 10, 0),
                child: CupertinoTextField(
                    placeholder: widget.currentText == "" ? widget.gostText : widget.currentText,
                    padding: const EdgeInsets.fromLTRB(15, 10, 30, 10),
                    autofocus: true,
                    style: const TextStyle(fontSize: 20),
                    clearButtonMode: OverlayVisibilityMode.always,
                    decoration: BoxDecoration(
                        color: CupertinoTheme.brightnessOf(context) == Brightness.dark ? Colors.white10 : Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    controller: _textController,
                    onChanged: (text) {
                        newText = text;
                    },
                    onEditingComplete: () {
                        Navigator.pop(context);
                    },
                )
            )
        );
    }
}
