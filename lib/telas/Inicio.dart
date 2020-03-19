import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  File _imagem;

  Future _recuperarImagem(bool daCamera) async {
    File _imagemSelecionada;
    if (daCamera == true) {
      _imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      _imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = _imagemSelecionada;
    });
  }

  Future _uploadImagem() async{
    //Referenciando arquivo
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("fotos").child("foto1.jpg");
    //Fazendo upload
    arquivo.putFile(_imagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar imagem"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Câmera"),
            onPressed: () {
              _recuperarImagem(true);
            },
          ),
          RaisedButton(
            child: Text("Galeria"),
            onPressed: () {
              _recuperarImagem(false);
            },
          ),
          _imagem == null ? Container() : Image.file(_imagem),
          RaisedButton(
            child: Text("Upload Storage"),
            onPressed: () {
              _uploadImagem();
            },
          ),
        ],
      ),
    );
  }
}
