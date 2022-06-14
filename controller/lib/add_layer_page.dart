import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
        Group(title: "Static", items: ["Color Value"]),
        Group(title: "Moving", items: ["Rainbow Wheel"]),
        Group(title: "Filter", items: ["Crop", "Blur"])
    ];

    void _showBottomDialog(Widget child) {
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                    top: false,
                    child: child,
                ),
            )
        );
    }

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
                                            return LayerGroupSelect(group: groups[index], api: widget.api,);
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

class LayerGroupSelect extends StatefulWidget {
    const LayerGroupSelect({Key? key, required this.group, required this.api}) : super(key: key);

    final Group group;
    final ManipulateLayerApi api;
    
    @override
    State<LayerGroupSelect> createState() => LayerGroupState();
}

class LayerGroupState extends State<LayerGroupSelect> {

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Text(widget.group.title),
                Column(
                    children: List<Widget>.generate(widget.group.items.length, (index) => 
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
                                            Text(widget.group.items[index]),
                                            const Spacer(),
                                            CupertinoButton(
                                                onPressed: () async {

                                                    Color pickerColor = Color(0xff443aff);
                                                    bool cancel = false;
        
                                                    if (["Color Value"].contains(widget.group.items[index])) {
                                                        await showCupertinoDialog(
                                                            context: context, 
                                                            builder: (BuildContext context) {
                                                                return CupertinoAlertDialog(
                                                                    title: const Text("Pick a color!"),
                                                                    content: SingleChildScrollView(
                                                                        child: Theme(
                                                                            data: ThemeData.dark(),
                                                                            child: Material(
                                                                                child: ColorPicker(
                                                                                    pickerColor: pickerColor,
                                                                                    onColorChanged: (Color color) { pickerColor = color; },
                                                                                    enableAlpha: false,
                                                                                    // hexInputBar: true,
                                                                                    displayThumbColor: true,
                                                                                ),
                                                                            )
                                                                        )
                                                                    ),
                                                                    actions: <Widget>[
                                                                        CupertinoButton(
                                                                            child: const Text("Cancel"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                cancel = true;
                                                                            },
                                                                        ),
                                                                        CupertinoButton(
                                                                            child: const Text("Finish"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                            },
                                                                        ),
                                                                    ],
                                                                );
                                                            },
                                                        );
                                                    }

                                                    print("$pickerColor");

                                                    int range_1 = 0;
                                                    int range_2 = 150;

                                                    if (["Crop"].contains(widget.group.items[index])) {

                                                        TextEditingController controller_1 = TextEditingController(text: "$range_1");
                                                        controller_1.selection = TextSelection(baseOffset: 0, extentOffset: "$range_1".length);

                                                        TextEditingController controller_2 = TextEditingController(text: "$range_2");
                                                        controller_2.selection = TextSelection(baseOffset: 0, extentOffset: "$range_2".length);

                                                        await showCupertinoDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                                return CupertinoAlertDialog(
                                                                    title: const Text("Pick a range."),
                                                                    content: Column(
                                                                        children: <Widget>[
                                                                            CupertinoTextField(
                                                                                controller: controller_1, 
                                                                                autofocus: true,
                                                                                keyboardType: TextInputType.number,
                                                                                onChanged: (value) => range_1 = int.parse(value),
                                                                            ),
                                                                            CupertinoTextField(
                                                                                controller: controller_2,
                                                                                autofocus: true,
                                                                                keyboardType: TextInputType.number,
                                                                                onChanged: (value) => range_2 = int.parse(value)
                                                                            ),
                                                                        ],
                                                                    ),
                                                                    actions: <Widget>[
                                                                        CupertinoButton(
                                                                            child: const Text("Cancel"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                cancel = true;
                                                                            },
                                                                        ),
                                                                        CupertinoButton(
                                                                            child: const Text("Finish"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                            },
                                                                        ),
                                                                    ],

                                                                );
                                                            }
                                                        );
                                                    }

                                                    if (["Rainbow Wheel"].contains(widget.group.items[index])) {
                                                        await showCupertinoDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                                return CupertinoAlertDialog(
                                                                    title: const Text("Sure?"),
                                                                    content: const Text("Are you sure you want to add this layer?"),
                                                                    actions: <Widget>[
                                                                        CupertinoButton(
                                                                            child: const Text("Cancel"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                cancel = true;
                                                                            },
                                                                        ),
                                                                        CupertinoButton(
                                                                            child: const Text("Add"),
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                            },
                                                                        ),
                                                                    ],
                                                                );
                                                            },
                                                        );
                                                    }

                                                    if (!cancel) {
                                                        switch (widget.group.items[index]) {
                                                            case "Color Value":

                                                                widget.api.addColorLayer(ColorProp(red: pickerColor.red, green: pickerColor.green, blue: pickerColor.blue));
                                                                break;
                                                            case "Rainbow Wheel":
                                                                widget.api.addWheelLayer();
                                                                break;
                                                            case "Crop":
                                                                widget.api.addCropFilterLayer(CropFilterProps(left: range_1, right: range_2));
                                                        }    
                                                    }

                                                    

                                                },
                                                child: const Padding(
                                                    padding: EdgeInsets.only(right: 15),
                                                    child: Icon(
                                                        CupertinoIcons.add_circled_solid,
                                                        color: Colors.green,
                                                        size: 30.0,
                                                    )
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
