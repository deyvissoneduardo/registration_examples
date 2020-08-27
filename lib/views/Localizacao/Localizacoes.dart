import 'dart:async';
import 'dart:io';

import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Localizacao/Destino.dart';
import 'package:controle_de_cadastro/widgets/ButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Localizacoes extends StatefulWidget {
  @override
  _LocalizacoesState createState() => _LocalizacoesState();
}

class _LocalizacoesState extends State<Localizacoes> {
  /** controladores **/
  TextEditingController _controllerRota = TextEditingController();
  Completer<GoogleMapController> _controllerMap = Completer();

  /** inicia camera do map **/
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-23.563999, -46.653256)
  );

  /** lista de marcadores **/
  Set<Marker> _marcadores = {};
  Set<Polyline> _polyline = {};

  /** posicao de inicio de rota **/
  LatLng _latLngUsuario;
  Destino _destino = Destino();

  /** cria map **/
  _onMapCreated(GoogleMapController controller) {
    _controllerMap.complete(controller);
  }

  /** movimenta de acordo com usuario **/
  _adicionarListener() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _exibirMarcador(position);
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19
      );
      _movimentarCamera(_posicaoCamera);
    });
  }

  _recuperaUltimaLocalizacao() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _exibirMarcador(position);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 19
        );
        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controllerMap.future;
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcador(Position local) async {
    /** calcula pixel **/
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: pixelRatio),
        "imagens/local.png"
    ).then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: MarkerId("Local Usuario"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(
              title: "Meu local"
          ),
          icon: icone
      );

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _verRota() async {
    /** pegar valor digitado **/
    String enderecoDestino = _controllerRota.text;

    /** cria lista de endereco **/
    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromAddress(enderecoDestino);

    /** config endereco destino **/
    if (listaEnderecos != null && listaEnderecos.length > 0) {
      /** monta a lista **/
      Placemark endereco = listaEnderecos[0];
      _destino.cidade = endereco.administrativeArea;
      _destino.cep = endereco.postalCode;
      _destino.bairro = endereco.subLocality;
      _destino.rua = endereco.thoroughfare;
      _destino.numero = endereco.subThoroughfare;
      _destino.latitudeDestino = endereco.position.latitude;
      _destino.longitudeDestino = endereco.position.longitude;
      /** monta mensagem de confirmacao **/
      String enderecoConfirmacao;
      enderecoConfirmacao = "\n Cidade: " + _destino.cidade;
      enderecoConfirmacao += "\n Rua: " + _destino.rua + ", " + _destino.numero;
      enderecoConfirmacao += "\n Bairro: " + _destino.bairro;
      enderecoConfirmacao += "\n Cep: " + _destino.cep;
      enderecoConfirmacao += "\n latD: " + _destino.latitudeDestino.toString();
      enderecoConfirmacao += "\n lonD: " + _destino.longitudeDestino.toString();

      /** popup de confirmacao **/
      showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text("Confirmação do endereço"),
              content: Text(enderecoConfirmacao),
              contentPadding: EdgeInsets.all(16),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar", style: TextStyle(color: Colors.red),),
                  onPressed: () => Navigator.pop(contex),
                ),
                FlatButton(
                  child: Text(
                    "Confirmar", style: TextStyle(color: Colors.green),),
                  onPressed: () {
                    Navigator.pop(contex);
                  },
                )
              ],
            );
          }
      );
    }
  }

  _montaRota(LatLng latLngLocal, LatLng latLngDestino) {
    _recuperaUltimaLocalizacao();
    Set<Polyline> listaPolyline = {};
    Polyline polyline = Polyline(
        polylineId: PolylineId('polyline'),
        color: temaPadrao.primaryColor,
        points: [
        latLngLocal,
        latLngDestino
        ]
    );
    listaPolyline.add(polyline);
    setState(() {
    _polyline = listaPolyline;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaUltimaLocalizacao();
    _adicionarListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _marcadores,
              polylines: _polyline,
              //-23,559200, -46,658878
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 10, bottom: 12),
                          width: 10,
                          height: 20,
                          child: Icon(Icons.location_on, color: temaViagen
                              .primaryColor, size: 30,),
                        ),
                        hintText: "Meu local",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 1)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: TextField(
                    controller: _controllerRota,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 10, bottom: 18),
                          width: 10,
                          height: 10,
                          child: Icon(Icons.location_searching, color: Colors
                              .black, size: 30,),
                        ),
                        hintText: "Digite o destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 1)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                  padding: Platform.isIOS
                      ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                      : EdgeInsets.all(10),
                  child: ButtonWidget(
                    text: 'Ver Rota',
                    corButton: temaPadrao.primaryColor,
                    corText: Colors.white,
                    onPressed: () {
                      _verRota();
                    },
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

