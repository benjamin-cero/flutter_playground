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

  const MainMenuScreen({
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
      const TipCalculatorScreen(fontSize: 16.0), // Tip Calculator
      const FinanceDashboardScreen(fontSize: 16.0), // NOVO: Finance Dashboard
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
      TipCalculatorScreen(fontSize: widget.fontSize),
      FinanceDashboardScreen(fontSize: widget.fontSize),
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
        title: const Text(
          'Flutter Progress \uD83D\uDE80',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black45,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Benjamin (Flutter Dev)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                'Benjamin.cero25@gmail.com',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'B',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
              leading: const Icon(Icons.calculate),
              title: const Text('5. Tip Calculator 💰'),
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('6. Finance Dashboard 📈'),
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('7. Settings ⚙️'),
              onTap: () {
                setState(() => _selectedIndex = 6);
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
              padding: const EdgeInsets.symmetric(
                vertical: 50.0,
                horizontal: 40.0,
              ),
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
                      label: const Text('Resetuj'),
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
    final deletedTask = tasks[index];
    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Zadatak izbrisan'),
        action: SnackBarAction(
          label: 'Poništi',
          onPressed: () {
            setState(() {
              tasks.insert(index, deletedTask);
            });
          },
        ),
      ),
    );
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
                onDismissed: (direction) => _deleteTask(index),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
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
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : null,
                        color: task['done'] ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
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

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String companyName;
  final String department;
  final String city;
  final String address;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyName,
    required this.department,
    required this.city,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      companyName: json['company']?['name'] ?? '',
      department: json['company']?['department'] ?? '',
      city: json['address']?['city'] ?? '',
      address: json['address']?['address'] ?? '',
    );
  }
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

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
      final response = await http.get(Uri.parse('https://dummyjson.com/users'));

      if (response.statusCode == 200) {
        setState(() {
          final List dynamicList = json.decode(response.body)['users'];
          _users = dynamicList.map((data) => UserModel.fromJson(data)).toList();
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
        ? ListView.separated(
            itemCount: 6,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, _) {
              final baseColor = Theme.of(context).disabledColor.withOpacity(0.1);
              final highlightColor = Theme.of(context).disabledColor.withOpacity(0.05);
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: baseColor,
                ),
                title: Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4)),
                  margin: const EdgeInsets.only(bottom: 8, right: 100),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 200, decoration: BoxDecoration(color: highlightColor, borderRadius: BorderRadius.circular(4)), margin: const EdgeInsets.only(bottom: 4)),
                    Container(height: 12, width: 120, decoration: BoxDecoration(color: highlightColor, borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              );
            },
          )
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple.withOpacity(0.15),
                    child: Text(
                      user.firstName.isNotEmpty ? user.firstName[0] : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                      fontSize: widget.fontSize + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text(
                        'Firma: ${user.companyName}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Zamijenjeno sa lijepim BottomSheet-om umjesto obicnog dialoga!
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // Popravlja problem sa overflowom
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
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
                                      '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Divider(height: 32),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.work,
                                      color: Colors.deepPurple,
                                    ),
                                    title: Text(user.companyName),
                                    subtitle: Text(
                                      'Odjeljenje: ${user.department}',
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                    ),
                                    title: Text(user.city),
                                    subtitle: Text(
                                      user.address,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Zatvori'),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ), // Dodatni prostor na samom dnu ispod tipke
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
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 40,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 80,
      size.width,
      size.height - 40,
    );
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.palette_outlined, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text(
                          'Tema',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.text_fields_outlined,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Veličina teksta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                title: const Text(
                  'Omogući notifikacije',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Primaj upozorenja iz aplikacije'),
                value: _notificationsEnabled,
                onChanged: _saveNotifications,
                activeThumbColor: Colors.deepPurple,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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

// ---------------------------------------------------------
// 6. TIP CALCULATOR SCREEN (Novi task za commit!)
// ---------------------------------------------------------
class TipCalculatorScreen extends StatefulWidget {
  final double fontSize;

  const TipCalculatorScreen({super.key, this.fontSize = 16.0});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _tipPercentage = 10.0;
  double _tipAmount = 0.0;
  double _totalAmount = 0.0;
  int _splitCount = 1;

  void _calculateTip() {
    double billAmount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _tipAmount = billAmount * (_tipPercentage / 100);
      _totalAmount = billAmount + _tipAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Napojnica i Račun 😎',
              style: TextStyle(
                fontSize: widget.fontSize + 4,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Ukupan iznos računa (KM)',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: (value) => _calculateTip(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Napojnica:',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_tipPercentage.toInt()}%',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 30,
              divisions: 6,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  _tipPercentage = value;
                  _calculateTip();
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Broj osoba (Split):',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_splitCount',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _splitCount.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: Theme.of(context).colorScheme.secondary,
              onChanged: (value) {
                setState(() {
                  _splitCount = value.toInt();
                });
              },
            ),
            const SizedBox(height: 28),
            Card(
              elevation: 8,
              shadowColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Samo napojnica:',
                            style: TextStyle(
                              fontSize: widget.fontSize,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${_tipAmount.toStringAsFixed(2)} KM',
                            style: TextStyle(
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.white30, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ukupno:',
                            style: TextStyle(
                              fontSize: widget.fontSize + 2,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_totalAmount.toStringAsFixed(2)} KM',
                            style: TextStyle(
                              fontSize: widget.fontSize + 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (_splitCount > 1) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white30, height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Colors.white70,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Po osobi:',
                                  style: TextStyle(
                                    fontSize: widget.fontSize + 2,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${(_totalAmount / _splitCount).toStringAsFixed(2)} KM',
                              style: TextStyle(
                                fontSize: widget.fontSize + 6,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 7. FINANCE DASHBOARD (Portfolio / Posao ready UI)
// ---------------------------------------------------------
class FinanceDashboardScreen extends StatefulWidget {
  final double fontSize;

  const FinanceDashboardScreen({super.key, this.fontSize = 16.0});

  @override
  State<FinanceDashboardScreen> createState() => _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock podaci za transakcije
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Početno stanje',
      'category': 'Ušteđevina',
      'amount': 3794.19,
      'icon': Icons.account_balance,
      'color': Colors.teal,
    },
    {
      'title': 'Dribbble Pro',
      'category': 'Pretplata',
      'amount': -15.00,
      'icon': Icons.design_services,
      'color': Colors.pink,
    },
    {
      'title': 'Plata (Freelance)',
      'category': 'Prihod',
      'amount': 1250.00,
      'icon': Icons.work_outline,
      'color': Colors.green,
    },
    {
      'title': 'Kafa sa klijentom',
      'category': 'Hrana & Piće',
      'amount': -8.50,
      'icon': Icons.local_cafe,
      'color': Colors.orange,
    },
    {
      'title': 'Supermarket',
      'category': 'Namirnice',
      'amount': -145.20,
      'icon': Icons.shopping_cart,
      'color': Colors.blue,
    },
    {
      'title': 'Udemy Kurs',
      'category': 'Edukacija',
      'amount': -24.99,
      'icon': Icons.menu_book,
      'color': Colors.purple,
    },
  ];

  double get _totalBalance =>
      _transactions.fold(0.0, (sum, item) => sum + item['amount']);
  double get _totalIncome => _transactions
      .where((item) => (item['amount'] as double) > 0)
      .fold(0.0, (sum, item) => sum + item['amount']);
  double get _totalExpense => _transactions
      .where((item) => (item['amount'] as double) < 0)
      .fold(0.0, (sum, item) => sum + item['amount']);

  @override
  void initState() {
    super.initState();
    // Animacija koja se pokrene cim se ucita ekran - profesionalni dojam
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Vrlo bitno za otpustanje memorije
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER SEKCIJA (Balance Card)
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildBalanceCard(context),
                  ),
                  const SizedBox(height: 28),

                  // 2. BRZE AKCIJE (Quick Actions)
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildQuickActions(),
                  ),
                  const SizedBox(height: 32),

                  // 3. NEDAVNE TRANSAKCIJE (Recent Transactions)
                  Text(
                    'Nedavne Transakcije',
                    style: TextStyle(
                      fontSize: widget.fontSize + 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._transactions.map((tx) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: _buildTransactionTile(tx),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () => _showAddTransactionDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // --- IZDVOJENE METODE ZA CISTIJI KOD (Clean Code princip) ---

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ukupan Balans',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '\$ ${_totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.fontSize + 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIncomeExpenseRow(
                Icons.arrow_downward,
                'Prihodi',
                '\$ ${_totalIncome.toStringAsFixed(0)}',
                Colors.greenAccent,
              ),
              _buildIncomeExpenseRow(
                Icons.arrow_upward,
                'Rashodi',
                '\$ ${_totalExpense.abs().toStringAsFixed(2)}',
                Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (_totalIncome == 0 && _totalExpense == 0) return const SizedBox.shrink();
    final totalAmount = _totalIncome + _totalExpense.abs();
    final incomePercentage = totalAmount > 0 ? _totalIncome / totalAmount : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Odnos Prihoda i Rashoda',
          style: TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Expanded(
                flex: (incomePercentage * 100).toInt() > 0 ? (incomePercentage * 100).toInt() : 1,
                child: Container(height: 6, color: Colors.greenAccent),
              ),
              Expanded(
                flex: ((1 - incomePercentage) * 100).toInt() > 0 ? ((1 - incomePercentage) * 100).toInt() : 1,
                child: Container(height: 6, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseRow(
    IconData icon,
    String label,
    String amount,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionBtn(Icons.send, 'Pošalji'),
        _buildActionBtn(Icons.account_balance_wallet, 'Računi'),
        _buildActionBtn(Icons.pie_chart, 'Statistika'),
        _buildActionBtn(Icons.more_horiz, 'Više'),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: widget.fontSize - 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _deleteTransaction(Map<String, dynamic> tx) {
    final index = _transactions.indexOf(tx);
    if (index == -1) return;

    setState(() {
      _transactions.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transakcija izbrisana'),
        action: SnackBarAction(
          label: 'Poništi',
          onPressed: () {
            setState(() {
              _transactions.insert(index, tx);
            });
          },
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nova transakcija',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Naziv (npr. Plata, Kafa)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Iznos',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixText: '\$ ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tip transakcije:',
                        style: TextStyle(fontSize: 16),
                      ),
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(12),
                        isSelected: [isIncome, !isIncome],
                        onPressed: (index) {
                          setModalState(() {
                            isIncome = index == 0;
                          });
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Prihod'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Rashod'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final title = titleController.text;
                      final amountText = amountController.text.replaceAll(
                        ',',
                        '.',
                      );
                      final amount = double.tryParse(amountText) ?? 0.0;

                      if (title.isNotEmpty && amount > 0) {
                        setState(() {
                          _transactions.insert(1, {
                            'title': title,
                            'category': isIncome
                                ? 'Ostali Prihodi'
                                : 'Ostali Rashodi',
                            'amount': isIncome ? amount : -amount,
                            'icon': isIncome
                                ? Icons.account_balance_wallet
                                : Icons.shopping_basket,
                            'color': isIncome ? Colors.green : Colors.redAccent,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Dodaj transakciju'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> tx) {
    final bool isIncome = tx['amount'] > 0;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteTransaction(tx),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (tx['color'] as Color).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tx['icon'], color: tx['color']),
        ),
        title: Text(
          tx['title'],
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          tx['category'],
          style: TextStyle(fontSize: widget.fontSize - 4),
        ),
        trailing: Text(
          isIncome
              ? '+ \$${tx['amount'].toStringAsFixed(2)}'
              : '- \$${tx['amount'].abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    ));
  }
}
