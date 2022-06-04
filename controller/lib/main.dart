import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'package:openapi/api.dart';

import 'package:controller/alert.dart';
import 'package:controller/detail_view.dart';
import 'package:controller/add_layer_page.dart';

void main() async {
    await dotenv.load(fileName: ".env");
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
        Widget build(BuildContext context) {
            return MediaQuery.fromWindow(
                child: const CupertinoApp(
                    title: "LED Controller",
                    useInheritedMediaQuery: true,
                    theme: CupertinoThemeData(),
                    home: MyHomePage(title: "LED Controller"),
                    localizationsDelegates: [DefaultMaterialLocalizations.delegate],
                )
            );
        }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key, required this.title}) : super(key: key);

    final String title;

    @override
        State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    int _counter = 0;
    bool _toggle = false;

    final _channel =
        WebSocketChannel.connect(Uri.parse("ws://10.2.0.1:777/live"));

    var api;


    _MyHomePageState() {
        _channel.stream.listen((data) {
            var json_ = json.decode(String.fromCharCodes(data))["layers"];
            print("$json_");
            setState(() {
                _layers = json_;
            });
        });


        var auth = ApiKeyAuth("header", "LED-API-KEY");

        var key = dotenv.env["API_KEY"];
        if (key != null) {    
            auth.apiKey = key;
        } else {
            showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                    return const CustomAllertDialogue(
                        title: "No API key",
                        description: "There is no API Key present in this build. It has to be specitied in an .env file.",
                    );
                },
            );
        }

        api = ManipulateLayerApi(ApiClient(basePath: "http://10.2.0.1:777", authentication: auth));

    }

    final ScrollController _controller = ScrollController();

    var _layers = [];

    void _incrementCounter() {
        setState(() {
            _counter++;
        });
    }

    @override
        Widget build(BuildContext context) {
            return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    middle: _toggle ? Text("Hallo world $_counter") : const Text("hallo"),
                    trailing: CupertinoButton(
                        child: const Icon(CupertinoIcons.plus),
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                    return AddLayerPage(api: api);
                                })
                            );
                        },
                    )
                ),
                child: Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Column(
                        children: <Widget>[
                        const Text(
                            'You have pushed the button this many times:',
                        ),
                        Text(
                            '$_counter',
                        ),
                        CupertinoButton.filled(
                            onPressed: _incrementCounter,
                            child: const Text("+"),
                        ),
                        CupertinoSwitch(
                            value: _toggle,
                            onChanged: (bool value) {
                                setState(() {
                                    _toggle = value;
                                });
                        }),
                        Expanded(
                            child: CupertinoScrollbar(
                                thickness: 6.0,
                                thicknessWhileDragging: 10.0,
                                radius: const Radius.circular(34.0),
                                radiusWhileDragging: Radius.zero,
                                thumbVisibility: true,
                                controller: _controller,
                                child: ReorderableListView.builder(
                                    shrinkWrap: true,
                                    scrollController: _controller,
                                    onReorder: (int start, int current) {
                                        api.switchLayers(start, current);
                                    },
                                    itemCount: _layers.length,
                                    proxyDecorator: (w, i, t) {
                                        return Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                color: Colors.black
                                            ),
                                            child: w
                                        );

                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                        return Dismissible(
                                            key: Key(_layers[index]["uuid"]),
                                            background: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                color: Colors.red
                                            ),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (DismissDirection direction) {
                                                setState(() async {
                                                    try {
                                                        await api.deleteByUuid(_layers[index]["uuid"]);
                                                    } catch(e) {
                                                        showDialog(
                                                            barrierColor: Colors.black26,
                                                            context: context,
                                                            builder: (context) {
                                                                return const CustomAllertDialogue(
                                                                    title: "Error while trying to Deleate.",
                                                                    description: "Due to some unknown error, the layer could not get deleted. Plese try again.",
                                                                );
                                                            },
                                                        );
                                                        //TODO ask get route
                                                    }
                                                    _layers.removeAt(index);
                                                });
                                            },
                                            child: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) {
                                                            return AnimationDetailsPage(layers: _layers, index: index);
                                                        })
                                                    );
                                                },
                                                child: Container(
                                                    height: 80,
                                                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                                    child: Container(
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            color: Colors.white10
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 0.0, 2.0),
                                                        child: Row(
                                                            children: <Widget>[
                                                                const Padding(
                                                                    padding: EdgeInsets.only(right: 5.0),
                                                                    child: Icon(
                                                                        CupertinoIcons.ellipsis_vertical,
                                                                        color: Colors.white,
                                                                        size: 20.0
                                                                    )
                                                                ),
                                                                Text(get_animation_common_name(_layers[index]), style: TextStyle(color: Colors.white)),
                                                                const Spacer(),
                                                                const Padding(
                                                                    padding: EdgeInsets.only(right: 15),
                                                                    child: Icon(
                                                                        CupertinoIcons.bin_xmark,
                                                                        color: Colors.red,
                                                                        size: 25.0,
                                                                    )
                                                                )
                                                            ],
                                                        )
                                                    )
                                                )
                                            )
                                        );
                                    },
                                ),
                            )
                        )],
                    )
                ),
            );
        }
}

String get_animation_common_name(LinkedHashMap animation) {
    
        switch (animation["type"]) {
            case "Wheel":
                return "Rainbow Wheel Animation";
            case "Color":
                return "Basic Color";
            default:
                return "Unknown Animation: $animation";
        }
    }
