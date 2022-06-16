import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:openapi/api.dart';
import 'package:throttling/throttling.dart';

class AnimationDetailsPage extends StatefulWidget {
    AnimationDetailsPage({Key? key, required this.layers, required this.index, required this.api}) : super(key: key);

    final List<dynamic> layers;

    final int index;

    final ManipulateLayerApi api;

    final thr = Debouncing(duration: const Duration(milliseconds: 10));

    @override
        State<AnimationDetailsPage> createState() => _AnimationDetailState();
}

class _AnimationDetailState extends State<AnimationDetailsPage> {

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: true,
                middle: Text("${widget.layers[widget.index]['_type']} layer ${widget.index + 1}")
            ),
            child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                    children: [
                        Container(child: (widget.layers[widget.index]['_type'] == "Color") ? 
                            Theme(
                                data: ThemeData.dark(),
                                child: Material(
                                    child: ColorPicker(
                                        pickerColor: Color.fromRGBO(
                                            widget.layers[widget.index]['value']['red'],
                                            widget.layers[widget.index]['value']['green'],
                                            widget.layers[widget.index]['value']['blue'],
                                            1
                                        ),
                                        enableAlpha: false,
                                        onColorChanged: (Color color) {
                                            widget.thr.debounce(() {
                                                widget.api.changeColorLayer(widget.layers[widget.index]['uuid'], ColorProp(red: color.red, green: color.green, blue: color.blue));
                                            });
                                        }
                                    ),
                                )
                            )    
                        : null),
                    ],
                )
            )
        );
    }
}
