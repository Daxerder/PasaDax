import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medio_pasaje/db/sqlite.dart';
import 'package:medio_pasaje/models/clases.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: (_tarjetas.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _tarjetas.length,
                itemBuilder: (BuildContext context, int index) {
                  Tarjeta tarj = _tarjetas[index];
                  return Card(
                    child: Slidable(
                      key: const ValueKey(0),
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                            label: "Recargar",
                            icon: Icons.monetization_on,
                            backgroundColor: Colors.amber,
                            onPressed: ((context) {
                              setState(() {
                                saldo.text = '';
                              });
                              alerta_recarga(tarj);
                            })),
                        SlidableAction(
                            label: "Pasaje",
                            icon: Icons.garage_outlined,
                            backgroundColor: Colors.green,
                            onPressed: ((context) {
                              alerta_pasaje(tarj);
                            }))
                      ]),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Tarjeta: ",
                                style: tamLetra,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                tarj.tarjeta,
                                style: tamLetra,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Saldo: ",
                                style: tamLetra,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                tarj.saldo.toString(),
                                style: tamLetra,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ]),
                    ),
                  );
                },
              ),
            )
          : MaterialButton(
              child: Text("añadir Tarjetas"),
              onPressed: () {
                _anadir();
              },
            ),
    );
  }

  alerta_recarga(Tarjeta tarjeta) {
    AlertDialog alerta = AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: saldo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Saldo Recargado',
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              //color: Colors.deepPurple.shade300,
              child: const Text(
                "Recargar",
                //style: TextStyle(color: Colors.white),
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
        child: Column(
          children: [
            MaterialButton(
              child: Text("Lun-Sab"),
              color: Colors.blue,
              onPressed: () {
                pasaje(tarjeta, "0.75");
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 10),
            MaterialButton(
              child: Text("Dom"),
              color: Colors.blue,
              onPressed: () {
                pasaje(tarjeta, "1.50");
                Navigator.of(context).pop();
              },
            ),
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
