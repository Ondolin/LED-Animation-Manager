// Source: https://www.codewithflutter.com/flutter-custom-alert-dialog/

import 'package:flutter/material.dart';

class CustomAllertDialogue extends StatefulWidget {
    const CustomAllertDialogue({
        Key? key,
        required this.title,
        required this.description,
    }) : super(key: key);

    final String title, description;
    
    @override
        State<CustomAllertDialogue> createState() => AlertState();
}

class AlertState extends State<CustomAllertDialogue> {
    @override
    Widget build(BuildContext context) {
        return Dialog(
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
            ),
            child : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(widget.description),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {},
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
        );
    }
}
