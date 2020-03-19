import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class GaleriaStorage extends StatefulWidget {
  GaleriaStorage({this.url});

  final String url;

  @override
  _GaleriaStorageState createState() => _GaleriaStorageState();
}

class _GaleriaStorageState extends State<GaleriaStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeria do Storage"),
      ),
      body: Column(
        children: <Widget>[Image.network(widget.url)],
      ),
    );
  }
}
