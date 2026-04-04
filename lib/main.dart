import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart'; // skontati kako ovo radi poslije

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final fontSize = prefs.getDouble('fontSize') ?? 16.0;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _fontSize = fontSize;
    });
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _changeFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    setState(() {
      _fontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moj Flutter Playground',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: MainMenuScreen(
        onThemeChanged: _changeTheme,
        fontSize: _fontSize,
        onFontSizeChanged: _changeFontSize,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------------------------------------------------
// MAIN MENU (Dodao nakon mjesec dana jer je bilo previse stvari)
// ---------------------------------------------------------
class MainMenuScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final double fontSize;
  final Function(double) onFontSizeChanged;

  MainMenuScreen({
    super.key,
    required this.onThemeChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CounterAppOld(fontSize: 16.0), // moj prvi app
      const TodoListScreen(fontSize: 16.0), // vjezbao liste
      const ApiTestScreen(fontSize: 16.0), // ucio HTTP requeste (ubilo me)
      const AnimationPlayground(fontSize: 16.0), // kul animacije
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        onFontSizeChanged: widget.onFontSizeChanged,
        fontSize: widget.fontSize,
      ), // settings
    ];
  }

  @override
  void didUpdateWidget(MainMenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild screens kada se fontSize promijeni
    _screens = [
      CounterAppOld(fontSize: widget.fontSize),
      TodoListScreen(fontSize: widget.fontSize),
      ApiTestScreen(fontSize: widget.fontSize),
      AnimationPlayground(fontSize: widget.fontSize),
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        onFontSizeChanged: widget.onFontSizeChanged,
        fontSize: widget.fontSize,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Progress \uD83D\uDE80', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black45,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Benjamin (Flutter Dev)', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('Benjamin.cero25@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('B', style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
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
              title: const Text('5. Settings ⚙️'),
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
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
  final double fontSize;

  const CounterAppOld({super.key, this.fontSize = 16.0});

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
      if (brojac > 0) {
        // dodao provjeru da ne ide u minus
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
          const Text(
            'Moj prvi Flutter kod ikada:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shadowColor: Colors.deepPurple.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    'Brojač: $brojac',
                    style: TextStyle(
                      fontSize: widget.fontSize + 16,
                      color: farba,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _smanji,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: _povecaj,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
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

// 2. TODO LIST (Ucenje ListView.builder i Stateful widgeta)

class TodoListScreen extends StatefulWidget {
  final double fontSize;

  const TodoListScreen({super.key, this.fontSize = 16.0});

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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Izbrisan task')));
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w500,
                        decoration: task['done'] ? TextDecoration.lineThrough : null,
                        color: task['done'] ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
  final double fontSize;

  const ApiTestScreen({super.key, this.fontSize = 16.0});

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
      final response = await http.get(
        Uri.parse('https://dummyjson.com/users'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body)['users']; // parsanje JSON-a
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
                ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple.withOpacity(0.15),
                    child: Text(
                      user['firstName'][0],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 20),
                    ),
                  ),
                  title: Text(
                    '${user['firstName']} ${user['lastName']}',
                    style: TextStyle(
                      fontSize: widget.fontSize + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['email']}'),
                      Text(
                        'Firma: ${user['company']['name']}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Zamijenjeno sa lijepim BottomSheet-om umjesto obicnog dialoga!
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // Popravlja problem sa overflowom
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.deepPurple[200],
                                    child: Text(
                                      user['firstName'][0] + user['lastName'][0],
                                      style: const TextStyle(fontSize: 32, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${user['firstName']} ${user['lastName']}',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user['email'],
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  const Divider(height: 32),
                                  ListTile(
                                    leading: const Icon(Icons.work, color: Colors.deepPurple),
                                    title: Text(user['company']['name']),
                                    subtitle: Text('Odjeljenje: ${user['company']['department']}'),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                                    title: Text('${user['address']['city']}'),
                                    subtitle: Text('${user['address']['address']}'),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Zatvori'),
                                  ),
                                  const SizedBox(height: 8), // Dodatni prostor na samom dnu ispod tipke
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
  final double fontSize;

  const AnimationPlayground({super.key, this.fontSize = 16.0});

  @override
  State<AnimationPlayground> createState() => _AnimationPlaygroundState();
}

class _AnimationPlaygroundState extends State<AnimationPlayground>
    with SingleTickerProviderStateMixin {
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
            const Text(
              'Implicit Animations (lake animacije)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                        color: Colors.black.withOpacity(
                          _isExpanded ? 0.3 : 0.1,
                        ),
                        blurRadius: _isExpanded ? 20 : 5,
                        spreadRadius: _isExpanded ? 5 : 0,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _isExpanded ? 'Klikni me opet!' : 'Klikni me!',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),

            // AnimatedOpacity test
            const Text(
              'Fade In / Fade Out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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

            // Eksperimentisanje sa oblicima - uspješno dodan CustomClipper!
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Wave Custom Clipper',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
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

// CustomClipper klasa koju sam konačno skontao kako radi!
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 80, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ---------------------------------------------------------
// 5. SETTINGS SCREEN (Konačno radi!)
// ---------------------------------------------------------
class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(double) onFontSizeChanged;
  final double fontSize;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.fontSize,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;
  ThemeMode _selectedTheme = ThemeMode.light;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = _prefs.getBool('notifications') ?? true;
    _selectedTheme = _prefs.getBool('isDarkMode') ?? false
        ? ThemeMode.dark
        : ThemeMode.light;
    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _saveNotifications(bool value) async {
    await _prefs.setBool('notifications', value);
    setState(() => _notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ==== APPEARANCE SECTION ====
            const Text(
              '🎨 Izgled',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Tema selector
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.palette_outlined, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text('Tema', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<ThemeMode>(
                      title: const Text('Svjetlo'),
                      value: ThemeMode.light,
                      groupValue: _selectedTheme,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          setState(() => _selectedTheme = value);
                          widget.onThemeChanged(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Tamno'),
                      value: ThemeMode.dark,
                      groupValue: _selectedTheme,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          setState(() => _selectedTheme = value);
                          widget.onThemeChanged(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Font size slider
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.text_fields_outlined, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text('Veličina teksta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: widget.fontSize,
                      min: 12,
                      max: 24,
                      divisions: 6,
                      label: widget.fontSize.toStringAsFixed(0),
                      onChanged: (value) {
                        widget.onFontSizeChanged(value);
                      },
                    ),
                    Center(
                      child: Text(
                        'Preview teksta',
                        style: TextStyle(fontSize: widget.fontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ==== NOTIFICATIONS SECTION ====
            const Text(
              '🔔 Notifikacije',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: const Text('Omogući notifikacije', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Primaj upozorenja iz aplikacije'),
                value: _notificationsEnabled,
                onChanged: _saveNotifications,
                activeColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),

            // ==== ABOUT SECTION ====
            const Text(
              'ℹ️ O aplikaciji',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Verzija aplikacije'),
                        Text(
                          '1.0.0',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Flutter verzija'),
                        Text(
                          '3.x.x',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('O aplikaciji'),
                            content: const Text(
                              'Ovo je moj playground za učenje Fluttera!\n\n'
                              'Kroz 4 mjeseca naučio sam:\n'
                              '- Widgets (Stateless, Stateful)\n'
                              '- HTTP & JSON\n'
                              '- Animacije\n'
                              '- State management\n'
                              '- Persistentna pohrana sa SharedPreferences',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Zatvori'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Više informacija'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
