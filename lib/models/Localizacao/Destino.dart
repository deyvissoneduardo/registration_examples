
class Destino {
 /** atributos **/
  String _rua;
  String _numero;
  String _cidade;
  String _bairro;
  String _cep;
  double _latitude;
  double _latitudeDestino;
  double _longitude;
  double _longitudeDestino;

Destino();

  double get latitudeDestino => _latitudeDestino;

  set latitudeDestino(double value) {
    _latitudeDestino = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  double get longitudeDestino => _longitudeDestino;

  set longitudeDestino(double value) {
    _longitudeDestino = value;
  }
}