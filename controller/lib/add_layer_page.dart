import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

class AddLayerPage extends StatefulWidget {
    AddLayerPage({Key? key, required this.api}) : super(key: key);

    ManipulateLayerApi api;

    @override
        State<AddLayerPage> createState() => _AddLayerState();
}

class Group {
    final String title;
    final List<String> items;

    Group({required this.title, required this.items});
}

class _AddLayerState extends State<AddLayerPage> {

    final ScrollController _controller = ScrollController();

    final List<Group> groups = <Group>[
        Group(title: "Static", items: ["Color value"]),
        Group(title: "Moving", items: ["Rainbow Wheel"]),
        Group(title: "Filter", items: ["Crop", "Blur"])
    ];

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(
                    automaticallyImplyLeading: true,
                    middle: Text("Add Layer"),
                ),
                child: Container(
                    child: Column(
                        // margin: const EdgeInsets.only(top: 100.0),
                        children: [
                            Expanded(
                                child: CupertinoScrollbar(
                                    thickness: 6.0,
                                    thicknessWhileDragging: 10.0,
                                    radius: const Radius.circular(34.0),
                                    radiusWhileDragging: Radius.zero,
                                    thumbVisibility: true,
                                    controller: _controller,
                                    child: ListView.builder(
                                        controller: _controller,
                                        itemCount: groups.length,
                                        itemBuilder: (BuildContext context, index) {
                                            return LayerGroupSelect(group: groups[index]);
                                        },
                                    ),
                                )
                            )
                        ]
                    )
                )
            );
        }
}

class LayerGroupSelect extends StatelessWidget {
    const LayerGroupSelect({Key? key, required this.group}) : super(key: key);

    final Group group;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Text(group.title),
                Column(
                    children: List<Widget>.generate(group.items.length, (index) => 
                         Dismissible(
                            key: Key("group-$index"),
                            background: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                color: Colors.green
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) {},
                            child: Container(
                                height: 80,
                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white10
                                    ),
                                    padding: const EdgeInsets.fromLTRB(16.0, 2.0, 0.0, 2.0),
                                    child: Row(
                                        children: <Widget>[
                                            Text(group.items[index]),
                                            const Spacer(),
                                            const Padding(
                                                padding: EdgeInsets.only(right: 15),
                                                child: Icon(
                                                    CupertinoIcons.add_circled_solid,
                                                    color: Colors.green,
                                                    size: 30.0,
                                                )
                                            )
                                        ],
                                    )
                                )
                            )
                        )
                    )
                )
            ]
        );
    }

}

void addLayerByName(String name, ManipulateLayerApi api, BuildContext context) {
    switch (name) {
        case "Color value":
            // create some values
            //Color pickerColor = Color(0xff443a49);
            //Color currentColor = Color(0xff443a49);

            //// ValueChanged<Color> callback
            //void changeColor(Color color) {
            //  setState(() => pickerColor = color);
            //}

            //// raise the [showDialog] widget
            //showDialog(
            //  context: context,
            //  child: AlertDialog(
            //    title: const Text('Pick a color!'),
            //    content: SingleChildScrollView(
            //      child: ColorPicker(
            //        pickerColor: pickerColor,
            //        onColorChanged: changeColor,
            //      ),
            //      // Use Material color picker:
            //      //
            //      // child: MaterialPicker(
            //      //   pickerColor: pickerColor,
            //      //   onColorChanged: changeColor,
            //      //   showLabel: true, // only on portrait mode
            //      // ),
            //      //
            //      // Use Block color picker:
            //      //
            //      // child: BlockPicker(
            //      //   pickerColor: currentColor,
            //      //   onColorChanged: changeColor,
            //      // ),
            //      //
            //      // child: MultipleChoiceBlockPicker(
            //      //   pickerColors: currentColors,
            //      //   onColorsChanged: changeColors,
            //      // ),
            //    ),
            //    actions: <Widget>[
            //      ElevatedButton(
            //        child: const Text('Got it'),
            //        onPressed: () {
            //          setState(() => currentColor = pickerColor);
            //          Navigator.of(context).pop();
            //        },
            //      ),
            //    ],
            //  ),
            //);
        break;
        case "Rainbow Wheel":

        break;
        case "Crop":

        break;
        case "Blur":

        break;
        default:
    }
}
