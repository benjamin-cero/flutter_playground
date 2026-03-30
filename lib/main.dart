import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // TODO: fix grade error sa shared prefs
// import 'package:provider/provider.dart'; // skontati kako ovo radi poslije

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moj Flutter Playground',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // useMaterial3: true,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // super stvar
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false, // OBAVEZNO!
    );
  }
}

// ---------------------------------------------------------
// MAIN MENU (Dodao nakon mjesec dana jer je bilo previse stvari)
// ---------------------------------------------------------
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CounterAppOld(), // moj prvi app
    const TodoListScreen(), // vjezbao liste
    const ApiTestScreen(), // ucio HTTP requeste (ubilo me)
    const AnimationPlayground(), // kul animacije
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 4 Months Progress \uD83D\uDE80'),
        elevation: 10,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Jovan (Flutter Dev)'),
              accountEmail: Text('jovan.flutter@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('J', style: TextStyle(fontSize: 24)),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('1. Old Counter App'),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('2. Todo List (State Test)'),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('3. API Fetching (JSON)'),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('4. Animations & UI'),
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings (Not Working Yet)'),
              onTap: () {
                // Pokusaj snackbara
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jos nisam napravio settings \uD83D\uDE2D')),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex], // mijenja screen zavisno sta se klikne
    );
  }
}

// ---------------------------------------------------------
// 1. OLD COUNTER APP (Moja prva aplikacija, ostavio za uspomenu)
// ---------------------------------------------------------
class CounterAppOld extends StatefulWidget {
  const CounterAppOld({super.key});

  @override
  State<CounterAppOld> createState() => _CounterAppOldState();
}

class _CounterAppOldState extends State<CounterAppOld> {
  Color farba = Colors.green;
  int brojac = 0;
  
  void _povecaj() {
    setState(() {
      brojac++;
      farba = Colors.green;
    });
  }

  void _smanji() {
    setState(() {
      if (brojac > 0) { // dodao provjeru da ne ide u minus
        brojac--;
        farba = Colors.red;
      }
    });
  }

  void _resetuj() {
    setState(() {
      brojac = 0;
      farba = Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Moj prvi Flutter kod ikada:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'Brojac: $brojac',
                    style: TextStyle(fontSize: 32, color: farba, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _smanji,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: _povecaj,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (brojac != 0) // if unutar builda! (naucio u mjesecu 2)
                    TextButton.icon(
                      onPressed: _resetuj,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Restuj'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. TODO LIST (Ucenje ListView.builder i Stateful widgeta)
// ---------------------------------------------------------
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textController = TextEditingController();
  
  // Lista mapa za cuvanje stanja svakog itema
  List<Map<String, dynamic>> tasks = [
    {'title': 'Nauci stateless widgete', 'done': true},
    {'title': 'Nauci stateful widgete', 'done': true},
    {'title': 'Skontaj kako radi Provider', 'done': true}, // TODO!
    {'title': 'Napravi portfolio aplikaciju', 'done': true},
  ];

  void _addTask() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        tasks.add({'title': _textController.text, 'done': false});
        _textController.clear();
      });
      FocusScope.of(context).unfocus(); // sakrije tastaturu
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Unesi novi task...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _addTask,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          // ListView.builder je bolji od obicnog ListView za mnogo itema (pise u dok.)
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task['title'] + index.toString()), // mora biti unique
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteTask(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Izbrisan task')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: task['done'],
                      onChanged: (bool? value) {
                        setState(() {
                          tasks[index]['done'] = value!;
                        });
                      },
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['done'] 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                        color: task['done'] ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// 3. API FETCHING (Radio prosli mjesec - JSONPlaceholder)
// ---------------------------------------------------------
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  List<dynamic> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Pokusao praviti model ali je previse komplikovano, koristim dynamic za sad
  // class User { ... } 

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Zove se cim se ucita screen
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // korisim jsonplaceholder jer je besplatan
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      
      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body); // parsanje JSON-a 
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Greška pri učitavanju: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Greska sa internet konekcijom: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _fetchUsers,
                      child: const Text('Pokušaj ponovo'),
                    )
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _fetchUsers,
                child: ListView.separated(
                  itemCount: _users.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple[100],
                        child: Text(user['name'][0]), // prvo slovo imena
                      ),
                      title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user['email']}'),
                          Text('Firma: ${user['company']['name']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Trebao bi napraviti detail screen ali nemam vremena
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(user['name']),
                            content: Text("Ovo je samo test alerta. \nZivi u gradu: ${user['address']['city']}"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
  }
}

// ---------------------------------------------------------
// 4. ANIMATIONS & UI EXPERIMENTS (Ovo mi je najzabavnije)
// ---------------------------------------------------------
class AnimationPlayground extends StatefulWidget {
  const AnimationPlayground({super.key});

  @override
  State<AnimationPlayground> createState() => _AnimationPlaygroundState();
}

class _AnimationPlaygroundState extends State<AnimationPlayground> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  double _opacity = 1.0;
  
  // Pokusao praviti custom AnimationController 
  // late AnimationController _controller;
  // @override void initState() { _controller = AnimationController(vsync: this, duration: Duration(seconds: 1)); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Implicit Animations (lake animacije)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // AnimatedContainer test
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutBack,
                  width: _isExpanded ? 300 : 150,
                  height: _isExpanded ? 200 : 100,
                  decoration: BoxDecoration(
                    color: _isExpanded ? Colors.teal : Colors.orange,
                    borderRadius: BorderRadius.circular(_isExpanded ? 30 : 10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isExpanded ? 0.3 : 0.1),
                        blurRadius: _isExpanded ? 20 : 5,
                        spreadRadius: _isExpanded ? 5 : 0,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _isExpanded ? 'Klikni me opet!' : 'Klikni me!',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            
            // AnimatedOpacity test
            const Text('Fade In / Fade Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: const FlutterLogo(size: 100),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                });
              },
              child: const Text('Toglaj Vidljivost'),
            ),

            const SizedBox(height: 40),
            
            // Eksperimentisanje sa oblicima (ClipPath - nasao na StackOverflowu)
            // TODO: Skontati kako se pravi pravi CustomClipper
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Gradient Container',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            
            const SizedBox(height: 100), // prazan prostor da mogu skrolati
          ],
        ),
      ),
    );
  }
}