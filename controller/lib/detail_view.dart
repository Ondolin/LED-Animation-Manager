import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationDetailsPage extends StatefulWidget {
    AnimationDetailsPage({Key? key, required this.layers, required this.index}) : super(key: key);

    List<dynamic> layers;

    int index;

    @override
        State<AnimationDetailsPage> createState() => _AnimationDetailState();
}

class _AnimationDetailState extends State<AnimationDetailsPage> {

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    automaticallyImplyLeading: true,
                    middle: Text("Hallo")
                ),
                child: Padding(padding: EdgeInsets.only(top: 100.0),child: Text("jj ${widget.layers.length}", style: TextStyle(color: Colors.cyan)))
            );
        }
}
