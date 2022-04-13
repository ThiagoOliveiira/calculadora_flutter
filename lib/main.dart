import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var mostrador = '';
  var resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      extendBodyBehindAppBar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          mostrador.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 50),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      resultado.isNotEmpty
                          ? const Flexible(
                              child: Text(
                                '= ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                                softWrap: true,
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        child: Text(
                          resultado.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // retira o scrol da tela
            primary: false,
            crossAxisCount: 4,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: [
              // Primeira linha
              botao('AC', color: Colors.black),
              botao('del', icon: Icons.backspace, color: Colors.black),
              botao('%', color: Colors.black),
              botao('/', color: Colors.amber),

              // Segunda linha  de numeros
              botao('7', numero: 7),
              botao('8', numero: 8),
              botao('9', numero: 9),
              botao('x', color: Colors.amber),

              // Terceira linha  de numeros
              botao('4', numero: 4),
              botao('5', numero: 5),
              botao('6', numero: 6),
              botao('-', color: Colors.amber),

              // Quarta linha  de numeros
              botao('1', numero: 1),
              botao('2', numero: 2),
              botao('3', numero: 3),
              botao('+', color: Colors.amber),

              // Quinta linha  de numeros
              botao(''),
              botao('0', numero: 0, largura: 300),
              botao(','),
              botao('=', color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  botao(dynamic text,
      {Color color = Colors.grey,
      double largura = 50,
      numero,
      IconData? icon}) {
    return GestureDetector(
      child: Container(
        color: color,
        child: Center(
            child: icon == null
                ? Text(
                    text,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  )),
      ),
      onTap: () {
        setState(() {
          if (text == 'AC') {
            mostrador = '';
            resultado = '';
          }
          if (mostrador.length <= 16 && numero != null) {
            mostrador += numero.toString();
          } else if (mostrador.length > 16 && text != 'AC') {
            final snackBar = SnackBar(
              content: const Text(
                'Máximo atingido!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: (Colors.red),
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'Fechar',
                onPressed: () {},
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            operacoes(text);
          }
        });
      },
    );
  }

  void operacoes(text) {
    if (text == '+' ||
        text == '-' ||
        text == '/' ||
        text == 'x' ||
        text == '%' ||
        text == ',') {
      setState(() {
        mostrador += text.toString();
      });
    } else if (text == '=') {
      equalPressed(text);
    }
  }

  // function para calcular as entradas
  void equalPressed(text) {
    String finaluserinput = mostrador;
    finaluserinput = mostrador.replaceAll('x', '*').replaceAll(',', '.');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();

    dynamic eval = exp.evaluate(EvaluationType.REAL, cm);
    resultado = eval.toString();
  }
}
