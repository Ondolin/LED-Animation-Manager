import 'dart:collection';
import 'dart:io';
import 'dart:async';


import 'package:controller/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



import 'package:openapi/api.dart';

import 'package:controller/alert.dart';
import 'package:controller/detail_view.dart';
import 'package:controller/add_layer_page.dart';

void main() async {
    runApp(const MyApp());
}

class PlatformDetails {
    static final PlatformDetails _singleton = PlatformDetails._internal();
    factory PlatformDetails() {
        return _singleton;
    }
    PlatformDetails._internal();
    bool get isDesktop =>
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows;
    bool get isMobile =>
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
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
    late WebSocketChannel _channel;

    ManipulateLayerApi? api;

    final Future<SharedPreferences> _prefsFurutre = SharedPreferences.getInstance();
    late SharedPreferences sharedPreferences;

    StreamSubscription connectToWS(String backend) {
        _channel = WebSocketChannel.connect(Uri.parse("ws://$backend/live"));
        return _channel.stream.listen((data) {
                var json_ = json.decode(String.fromCharCodes(data))["layers"];
                print("$json_");
                setState(() {
                    _layers = json_;
                });
        }, onError: (error) {
            /* Hide the error message */
        }, onDone: () {
            sleep(Duration(seconds: 2));
            connectToWS(backend);
        });
    }

    @override
    void initState() {
        super.initState();
         _prefsFurutre.then((SharedPreferences prefs) {
            
            String? api_key = prefs.getString("api_key");
            String? backend = prefs.getString("backend_url");

            if (api_key != null && backend != null) {


                var auth = ApiKeyAuth("header", "LED-API-KEY");
                auth.apiKey = api_key;

                setState(() {
                    api = ManipulateLayerApi(ApiClient(basePath: "http://$backend", authentication: auth));
                });

                connectToWS(backend);

            } else {
                print("No API Key");
            }

            sharedPreferences = prefs;

        });
    }

    final ScrollController _controller = ScrollController();

    var _layers = [];

    @override
        Widget build(BuildContext context) {

            return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    middle: const Text("LED Controller"),
                    leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.settings, size: 28),
                        onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) {
                                    return Settings(prefs: sharedPreferences);
                                })
                            );
                        },
                    ),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.plus, size: 28),
                        onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) {
                                    return AddLayerPage(api: api);
                                })
                            );
                        },
                    )
                ),
                child: api == null ? 
                    const Center(
                        child: Text("You have to set an API key and backend in the settings.", textAlign: TextAlign.center)
                    ) : 
                    Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Column(
                        children: <Widget>[
                        Expanded(
                            child: _layers.length == 0 ?
                            const Center(
                                child: Text("Currently there are no layers available.", textAlign: TextAlign.center)
                            ) : CupertinoScrollbar(
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
                                        api?.switchLayers(start, current);
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
                                                        await api?.deleteByUuid(_layers[index]["uuid"]);
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
                                                            return AnimationDetailsPage(layers: _layers, index: index, api: api);
                                                        })
                                                    );
                                                },
                                                child: Container(
                                                    height: 80,
                                                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black12 : Colors.white10
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 0.0, 2.0),
                                                        child: Row(
                                                            children: <Widget>[
                                                                Padding(
                                                                    padding: const EdgeInsets.only(right: 5.0),
                                                                    child: Icon(
                                                                        CupertinoIcons.ellipsis_vertical,
                                                                        color: CupertinoTheme.of(context).textTheme.textStyle.color,
                                                                        size: 20.0
                                                                    )
                                                                ),
                                                                get_animation_common_name(_layers[index], context),
                                                                if (PlatformDetails().isDesktop) ...[
                                                                    const Spacer(),
                                                                    const Padding(
                                                                        padding: EdgeInsets.only(right: 15),
                                                                        child: Icon(
                                                                            CupertinoIcons.bin_xmark,
                                                                            color: Colors.red,
                                                                            size: 25.0,
                                                                        )
                                                                    )
                                                                ]
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

Widget get_animation_common_name(LinkedHashMap animation, BuildContext context) {
  
    TextStyle style = TextStyle(color: CupertinoTheme.of(context).textTheme.textStyle.color);

        switch (animation['_type']) {
            case "RainbowWheel":
                return Text("Rainbow Wheel Animation", style: style);
            case "Color":
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Text("Basic Color:", style: style),
                        const SizedBox(width: 10),
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(animation['value']['red'], animation['value']['green'], animation['value']['blue'], 1),
                                borderRadius: BorderRadius.circular(360)
                            ),
                            width: 20,
                            height: 20,
                        )
                    ],  
                );
            case "Crop":
                return Text("Crop Filter (${animation['left']} | ${animation['right']})", style: style);
            case "Timer":
                return Text("Timer", style: style);
            default:
                return Text("Unknown Animation: $animation", style: style);
        }
    }
