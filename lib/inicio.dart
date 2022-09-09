import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:medio_pasaje/db/sqlite.dart';
import 'package:medio_pasaje/models/clases.dart';
import 'package:unicons/unicons.dart';

class Inicio extends StatefulWidget {
  static const String ruta = "/inicio";

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  TextEditingController saldo = TextEditingController();

  int _counter = 0;
  TextStyle tamLetra = const TextStyle(fontSize: 18);
  Tarjeta carga = Tarjeta();
  Tarjeta carga2 = Tarjeta();
  List<Tarjeta> _tarjetas = [];
  List<Movimiento> _movimientoTren = [], _movimientoMetro = [];
  List colores = [Colors.green, Colors.amber];
  int indice = 0;
  bool mostrar = false;

  @override
  void initState() {
    _loadSaldo();
    _loadMovimientoTren();
    _loadMovimientoMetro();
    super.initState();
  }

  _loadSaldo() async {
    List<Tarjeta> lista = await DB.db.getTarjetas();
    setState(() {
      _tarjetas = lista;
    });
  }

  _loadMovimientoTren() async {
    List<Movimiento> lista = await MovimientoDBTren.db.getMovimiento();
    setState(() {
      _movimientoTren = lista;
    });
  }

  _loadMovimientoMetro() async {
    List<Movimiento> lista = await MovimientoDBMetro.db.getMovimiento();
    setState(() {
      _movimientoMetro = lista;
    });
  }

  _anadir() async {
    carga.tarjeta = 'Tren Electrico';
    carga.saldo = 0.0;
    await DB.db.nuevo(carga);

    carga2.tarjeta = 'Metropolitano';
    carga2.saldo = 0.0;
    await DB.db.nuevo(carga2);
    _loadSaldo();
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 255, 255, 255),
      appBar: AppBar(
        title: (indice == 0)
            ? const Text("Tren Electrico")
            : const Text("Metropolitano"),
        titleTextStyle: const TextStyle(fontSize: 30),
        backgroundColor: colores[indice],
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(children: [
          ListTile(
            leading: Icon(
              Icons.arrow_back,
              color: colores[indice],
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train_outlined,
              color: colores[0],
            ),
            title: const Text("Tren Electrico"),
            onTap: () {
              setState(() {
                indice = 0;
                Navigator.of(context).pop();
              });
            },
          ),
          ListTile(
            leading: Icon(
              UniconsLine.bus,
              color: colores[1],
            ),
            title: const Text("Metropolitano"),
            onTap: () {
              setState(() {
                indice = 1;
                Navigator.of(context).pop();
              });
            },
          ),
        ]),
      ),
      body: (_tarjetas.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Card(
                          color: const Color.fromARGB(240, 255, 255, 255),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  mostrar = !mostrar;
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: (mostrar)
                                        ? Row(
                                            children: [
                                              Icon(
                                                UniconsLine.eye_slash,
                                                color: colores[indice],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "Ocultar Saldo",
                                                style: TextStyle(
                                                    color: colores[indice]),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Icon(
                                                UniconsLine.eye,
                                                color: colores[indice],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "Mostrar Saldo",
                                                style: TextStyle(
                                                    color: colores[indice]),
                                              ),
                                            ],
                                          ),
                                  ),
                                  Container(
                                    child: (mostrar)
                                        ? Text(
                                            "S/. ${_tarjetas[indice].saldo.toStringAsFixed(2)}")
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1.0, color: Colors.black12))),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Ultimos Movimientos",
                            style: TextStyle(color: colores[indice]))
                      ],
                    ),
                  ),
                  (indice == 0)
                      ? Expanded(
                          child: Movimientos(_movimientoTren),
                        )
                      : Expanded(
                          child: Movimientos(_movimientoMetro),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colores[indice]),
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                alerta_pasaje(_tarjetas[indice]);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    UniconsLine.ticket,
                                    color: colores[indice],
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Pasaje",
                                    style: TextStyle(color: colores[indice]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: MaterialButton(
                              color: colores[indice],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                alerta_recarga(_tarjetas[indice]);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Recargar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: MaterialButton(
                color: colores[indice],
                child: const Text(
                  "añadir Tarjetas",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _anadir();
                },
              ),
            ),
    );
  }

  Widget Movimientos(List<Movimiento> lista) {
    if (lista.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: lista.length,
        itemBuilder: (BuildContext context, int index) {
          int cont = lista.length - 1 - index;
          Movimiento mov = lista[cont];
          return Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12))
                /*color:
                    (mov.opcion == 'Recarga') ? colores[indice] : Colors.red*/
                ),
            //margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    mov.opcion,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Text(
                  (mov.opcion == 'Recarga')
                      ? " S/. ${mov.monto.toStringAsFixed(2)}"
                      : "- S/. ${mov.monto.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 15,
                      color: (mov.opcion == 'Recarga') ? null : Colors.red),
                ),
              ],
            ),
            /*Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mov.opcion,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mov.monto.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),*/
          );
        },
      );
    } else {
      return const Text("Sin movimientos");
    }
  }

  alerta_recarga(Tarjeta tarjeta) {
    AlertDialog alerta = AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              cursorColor: colores[indice],
              controller: saldo,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              ],
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colores[indice],
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colores[indice],
                  ),
                ),
                labelText: 'Saldo Recargado',
                labelStyle: TextStyle(color: colores[indice]),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              color: colores[indice].shade300,
              child: const Text(
                "Recargar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                recarga(tarjeta, saldo.text);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  alerta_pasaje(Tarjeta tarjeta) {
    AlertDialog alerta = AlertDialog(
      content: SingleChildScrollView(
        child: (indice == 0)
            ? Column(
                children: [
                  MaterialButton(
                    color: colores[indice],
                    child: const Text(
                      "Lun-Sab",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      pasaje(tarjeta, "0.75");
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    color: colores[indice],
                    child: const Text(
                      "Dom",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      pasaje(tarjeta, "1.50");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  TextFormField(
                    cursorColor: colores[indice],
                    controller: saldo,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colores[indice],
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colores[indice],
                        ),
                      ),
                      labelText: 'Pasaje',
                      labelStyle: TextStyle(color: colores[indice]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    color: colores[indice].shade300,
                    child: const Text(
                      "Pasaje",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      pasaje(tarjeta, saldo.text);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  pasaje(Tarjeta tarjeta, String pasaje) async {
    Tarjeta nueva = Tarjeta();
    nueva.id = tarjeta.id;
    nueva.tarjeta = tarjeta.tarjeta;
    nueva.saldo = tarjeta.saldo - double.parse(pasaje);
    await DB.db.modificarSaldo(nueva);
    _loadSaldo();
    Movimiento mov = Movimiento();
    mov.opcion = 'Pasaje';
    mov.monto = double.parse(pasaje);
    if (indice == 0) {
      if (_movimientoTren.length == 10) {
        await MovimientoDBTren.db.eliminar(_movimientoTren[0].id);
      }
      await MovimientoDBTren.db.nuevo(mov);
      _loadMovimientoTren();
    } else {
      if (_movimientoMetro.length == 10) {
        await MovimientoDBMetro.db.eliminar(_movimientoMetro[0].id);
      }
      await MovimientoDBMetro.db.nuevo(mov);
      _loadMovimientoMetro();
    }
  }

  recarga(Tarjeta tarjeta, String pasaje) async {
    Tarjeta nueva = Tarjeta();
    nueva.id = tarjeta.id;
    nueva.tarjeta = tarjeta.tarjeta;
    nueva.saldo = tarjeta.saldo + double.parse(pasaje);
    await DB.db.modificarSaldo(nueva);
    _loadSaldo();
    Movimiento mov = Movimiento();
    mov.opcion = 'Recarga';
    mov.monto = double.parse(pasaje);
    if (indice == 0) {
      if (_movimientoTren.length == 10) {
        await MovimientoDBTren.db.eliminar(_movimientoTren[0].id);
      }
      await MovimientoDBTren.db.nuevo(mov);
      _loadMovimientoTren();
    } else {
      if (_movimientoMetro.length == 10) {
        await MovimientoDBMetro.db.eliminar(_movimientoMetro[0].id);
      }
      await MovimientoDBMetro.db.nuevo(mov);
      _loadMovimientoMetro();
    }
  }
}
