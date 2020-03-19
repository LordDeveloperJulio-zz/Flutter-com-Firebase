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
  String _statusUpload = "Upload não iniciado";
  String _urlRecuperada = null;

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

  Future _uploadImagem() async {
    //Referenciando arquivo
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("fotos").child("foto1.jpg");
    //Fazendo upload
    StorageUploadTask task = arquivo.putFile(_imagem);
    //Controlando progresso do upload
    task.events.listen((storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _statusUpload = "Em progresso";
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _statusUpload = "Enviado com sucesso";
        });
      }
    });
    //Recuperando a URL da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarURLImagem(snapshot);
    });
  }

  Future _recuperarURLImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    print("URL da imagem" + url);
    setState(() {
      _urlRecuperada = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar imagem"),
      ),
      body: Column(
        children: <Widget>[
          Text(_statusUpload),
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
          _imagem == null
              ? Container()
              : RaisedButton(
                  child: Text("Upload Storage"),
                  onPressed: () {
                    _uploadImagem();
                  },
                ),
          _urlRecuperada == null ? Container() : Image.network(_urlRecuperada)
        ],
      ),
    );
  }
}
