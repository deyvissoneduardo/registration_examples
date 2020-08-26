import 'package:carousel_pro/carousel_pro.dart';
import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Viagens/Viagens.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/EspacosWidgets.dart';
import 'package:flutter/material.dart';

class DetalhesViagens extends StatefulWidget {
  /** espeda dados passados por parametros **/
  Viagens viagens;

  DetalhesViagens(this.viagens);
  @override
  _DetalhesViagensState createState() => _DetalhesViagensState();
}

class _DetalhesViagensState extends State<DetalhesViagens> {
  Viagens _viagens;

  /** consulta fotos albuns **/
  List<Widget> _getFotosAlbuns() {
    List<dynamic> listaUrlImagens = _viagens.photos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viagens = widget.viagens;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_viagens.title),
      ),
      body: Stack(
        children: <Widget>[
          /** imagens **/
          ListView(
            children: <Widget>[
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getFotosAlbuns(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: false,
                  dotIncreasedColor: temaPadrao.primaryColor,
                ),
              ),
              /** conteudo **/
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /** datas **/
                    Text('Inico da viagem ${_viagens.dateInit}'),
                    Text('Fim da viagem ${_viagens.dateEnd}'),
                    /** espacamento **/
                    EspacoWidget(),
                    /** nome descricao **/
                    Text(
                      'Como foi a viagem: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /** texto da descricao **/
                    Text(
                      '${_viagens.description}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          /** btn **/
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: Text(
                  'Voltar a tela de Cadastros',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: temaPadrao.primaryColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_CADASTROS);
              },
            ),
          )
        ],
      ),
    );
  }
}
