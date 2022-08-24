import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:medio_pasaje/db/sqlite.dart';
import 'package:medio_pasaje/models/clases.dart';
import 'package:unicons/unicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tarjetas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController saldo = TextEditingController();

  int _counter = 0;
  TextStyle tamLetra = TextStyle(fontSize: 18);
  Tarjeta carga = Tarjeta();
  Tarjeta carga2 = Tarjeta();
  List<Tarjeta> _tarjetas = [];
  List colores = [Colors.green, Colors.amber];
  int indice = 0;

  @override
  void initState() {
    _loadSaldo();
    super.initState();
  }

  _loadSaldo() async {
    List<Tarjeta> lista = await DB.db.getTarjetas();
    setState(() {
      _tarjetas = lista;
    });
  }

  void _anadir() async {
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
      body: (_tarjetas.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Saldo",
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      _tarjetas[indice].saldo.toString(),
                      style:
                          const TextStyle(fontSize: 90, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          : MaterialButton(
              child: Text("añadir Tarjetas"),
              onPressed: () {
                _anadir();
              },
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
              alerta_recarga(_tarjetas[indice]);
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
              alerta_pasaje(_tarjetas[indice]);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
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
  }

  recarga(Tarjeta tarjeta, String pasaje) async {
    Tarjeta nueva = Tarjeta();
    nueva.id = tarjeta.id;
    nueva.tarjeta = tarjeta.tarjeta;
    nueva.saldo = tarjeta.saldo + double.parse(pasaje);

    await DB.db.modificarSaldo(nueva);
    _loadSaldo();
  }
}
