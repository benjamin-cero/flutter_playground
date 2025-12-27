import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
 Color farba = Colors.green;
 int brojac = 0;
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
            actions: [
              if(brojac!=0)
              Padding(
                padding: const EdgeInsets.only(right: 40),
              child: IconButton(
                icon: const Icon(Icons.refresh),
              onPressed: (){
                setState(() {
                  brojac = 0;
                  farba = Colors.blue;
                });
              },
              ),
              ),
            ],
          ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
            setState(() {
              brojac++;
              farba = Colors.green;
            });
          },
          child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: (){
            setState(() {
              brojac--;
              farba = Colors.red;
            });
          },
          child: const Icon(Icons.remove),
          ),
        ],
      ),

      body: Center(
        child: Text('Brojac: $brojac',
        style: TextStyle(fontSize: 24,color: farba)),
      ),
    );
  }
}