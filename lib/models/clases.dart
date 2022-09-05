class Tarjeta {
  int id;
  String tarjeta;
  double saldo;

  Tarjeta({
    this.id = 0,
    this.tarjeta = '', //@required
    this.saldo = 0.0, //@required
  });

  factory Tarjeta.fromJson(Map<String, dynamic> json) => Tarjeta(
        id: json['id'],
        tarjeta: json['tarjeta'],
        saldo: json['saldo'],
      );

  Map<String, dynamic> toJson() => {
        "tarjeta": tarjeta,
        "saldo": saldo,
      };
}

class Movimiento {
  int id;
  String opcion;
  double monto;

  Movimiento({
    this.id = 0,
    this.opcion = '',
    this.monto = 0.0, //@required
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
        id: json['id'],
        opcion: json['opcion'],
        monto: json['monto'],
      );

  Map<String, dynamic> toJson() => {
        "opcion": opcion,
        "monto": monto,
      };
}
