import 'package:flutter/material.dart';
import 'package:medio_pasaje/inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        Inicio.ruta: (BuildContext context) => Inicio(),
      },
      initialRoute: "/inicio",
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController saldo = TextEditingController();

  int _counter = 0;
  TextStyle tamLetra = const TextStyle(fontSize: 18);
  Tarjeta carga = Tarjeta();
  Tarjeta carga2 = Tarjeta();
  List<Tarjeta> _tarjetas = [];
  List<Movimiento> _movimientoTren = [], _movimientoMetro = [];
  List colores = [Colors.green, Colors.amber];
  int indice = 0;

  @override
  void initState() {
    /*_loadSaldo();
    _loadMovimientoTren();
    _loadMovimientoMetro();*/
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
    return Scaffold(
      backgroundColor: colores[indice].shade100,
      appBar: AppBar(
        title: Text(_tarjetas[indice].tarjeta),
        titleTextStyle: const TextStyle(fontSize: 30),
        backgroundColor: colores[indice],
        centerTitle: true,
      ),
      body: (false)
          ? Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Saldo",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  Text(
                    "_tarjetas[indice].saldo.toStringAsFixed(2)",
                    style: const TextStyle(fontSize: 90, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (indice == 0)
                      ? Expanded(
                          child: Movimientos(_movimientoTren),
                        )
                      : Expanded(
                          child: Movimientos(_movimientoMetro),
                        ),
                ],
              ),
            )
          : Center(
              child: MaterialButton(
                child: const Text("a??adir Tarjetas"),
                onPressed: () {
                  _anadir();
                },
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: colores[indice],
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    indice = 0;
                  });
                },
                icon: const Icon(
                  Icons.train,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    indice = 1;
                  });
                },
                icon: const Icon(
                  UniconsLine.bus_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        activeBackgroundColor: colores[indice].shade300,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: colores[indice],
        children: [
          SpeedDialChild(
            child: const Icon(
              UniconsLine.dollar_alt,
              color: Colors.white,
            ),
            backgroundColor: colores[indice],
            onTap: () {
              saldo.text = '';
              //alerta_recarga(_tarjetas[indice]);
            },
          ),
          SpeedDialChild(
            child: const Icon(
              UniconsLine.ticket,
              color: Colors.white,
            ),
            backgroundColor: colores[indice],
            onTap: () {
              saldo.text = '';
              //alerta_pasaje(_tarjetas[indice]);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            decoration: BoxDecoration(
                color:
                    (mov.opcion == 'Recarga') ? colores[indice] : Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mov.opcion,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
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
            ),
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
    mov.monto = double.parse(pasaje) * (-1);
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
}*/
