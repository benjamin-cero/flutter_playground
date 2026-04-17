import 'dart:io';

void main() async {
  final filepath = r'c:\Users\jovan\Desktop\flutter_playground\lib\main.dart';
  var file = File(filepath);
  var content = await file.readAsString();

  content = content.replaceAll(
      "// import 'package:provider/provider.dart'; // skontati kako ovo radi poslije",
      "import 'package:provider/provider.dart';");

  content = content.replaceAll(
      "{'title': 'Skontaj kako radi Provider', 'done': true}, // TODO!",
      "{'title': 'Skontaj kako radi Provider', 'done': true},\n    {'title': 'Nauci bazne klase (OOP)', 'done': true},");

  final providerCode = '''

// ---------------------------------------------------------
// BAZNE KLASE & PROVIDER (Za pocetnike)
// ---------------------------------------------------------
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class SettingsProvider extends BaseProvider {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _fontSize = fontSize;
    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> changeFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    _fontSize = size;
    notifyListeners();
  }
}
''';

  content = content.replaceAll("void main() {",
      "\$providerCode\nvoid main() {\n  WidgetsFlutterBinding.ensureInitialized();");

  content = content.replaceAll(
      "runApp(const MyApp());",
      "runApp(\n    ChangeNotifierProvider(\n      create: (context) => SettingsProvider(),\n      child: const MyApp(),\n    ),\n  );");

  final myappOld = '''class MyApp extends StatefulWidget {
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
}''';

  final myappNew = '''class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
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
      themeMode: settings.themeMode,
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}''';

  content = content.replaceAll(myappOld, myappNew);

  final mainMenuOld = '''class MainMenuScreen extends StatefulWidget {
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
  }''';

  final mainMenuNew = '''class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
      CounterAppOld(), // moj prvi app
      TodoListScreen(), // vjezbao liste
      ApiTestScreen(), // ucio HTTP requeste (ubilo me)
      AnimationPlayground(), // kul animacije
      TipCalculatorScreen(), // Tip Calculator
      FinanceDashboardScreen(), // NOVO: Finance Dashboard
      SettingsScreen(), // settings
  ];''';

  content = content.replaceAll(mainMenuOld, mainMenuNew);

  final screens = [
    'CounterAppOld',
    'TodoListScreen',
    'ApiTestScreen',
    'AnimationPlayground',
    'TipCalculatorScreen',
    'FinanceDashboardScreen'
  ];

  for (var screen in screens) {
    RegExp exp = RegExp('class \$screen extends StatefulWidget \\{[\\s\\S]*?const \$screen\\(\\{super\\.key, this\\.fontSize = 16\\.0\\}\\);[\\s\\S]*?@override\\s*State<\$screen> createState\\(\\).*?_\\\$screenState\\(\\);\\s+\\}', multiLine: true);
    content = content.replaceAllMapped(exp, (m) => '''class \$screen extends StatefulWidget {
  const \$screen({super.key});

  @override
  State<\$screen> createState() => _\${screen}State();
}''');
  }

  final settingsOld = '''class SettingsScreen extends StatefulWidget {
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
}''';
  final settingsNew = '''class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}''';
  content = content.replaceAll(settingsOld, settingsNew);

  content = content.replaceAll('  @override\n  Widget build(BuildContext context) {',
      '  @override\n  Widget build(BuildContext context) {\n    final fontSize = context.watch<SettingsProvider>().fontSize;');

  content = content.replaceAll('widget.fontSize', 'fontSize');

  content = content.replaceAll('widget.onThemeChanged(value);', 'context.read<SettingsProvider>().changeTheme(value);');
  content = content.replaceAll('widget.onFontSizeChanged(value);', 'context.read<SettingsProvider>().changeFontSize(value);');


  final baseClassModels = '''// ---------------------------------------------------------
// BAZNE KLASE ZA MODELE
// ---------------------------------------------------------
abstract class FinanceItem {
  final String title;
  final double amount;
  final String category;

  FinanceItem({required this.title, required this.amount, required this.category});

  bool get isIncome => amount > 0;
}

class TransactionModel extends FinanceItem {
  final IconData icon;
  final Color color;

  TransactionModel({
    required super.title,
    required super.amount,
    required super.category,
    required this.icon,
    required this.color,
  });
}''';

  content = content.replaceAll('// ---------------------------------------------------------\n// 7. FINANCE DASHBOARD',
      "\$baseClassModels\n// ---------------------------------------------------------\n// 7. FINANCE DASHBOARD");

  final transactionsOld = '''  // Mock podaci za transakcije
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
  ];''';

  final transactionsNew = '''  // Mock podaci za transakcije koristeci nasu novu TransactionModel klasu
  final List<TransactionModel> _transactions = [
    TransactionModel(
      title: 'Početno stanje',
      category: 'Ušteđevina',
      amount: 3794.19,
      icon: Icons.account_balance,
      color: Colors.teal,
    ),
    TransactionModel(
      title: 'Dribbble Pro',
      category: 'Pretplata',
      amount: -15.00,
      icon: Icons.design_services,
      color: Colors.pink,
    ),
    TransactionModel(
      title: 'Plata (Freelance)',
      category: 'Prihod',
      amount: 1250.00,
      icon: Icons.work_outline,
      color: Colors.green,
    ),
    TransactionModel(
      title: 'Kafa sa klijentom',
      category: 'Hrana & Piće',
      amount: -8.50,
      icon: Icons.local_cafe,
      color: Colors.orange,
    ),
    TransactionModel(
      title: 'Supermarket',
      category: 'Namirnice',
      amount: -145.20,
      icon: Icons.shopping_cart,
      color: Colors.blue,
    ),
    TransactionModel(
      title: 'Udemy Kurs',
      category: 'Edukacija',
      amount: -24.99,
      icon: Icons.menu_book,
      color: Colors.purple,
    ),
  ];''';

  content = content.replaceAll(transactionsOld, transactionsNew);
  content = content.replaceAll("item['amount']", "item.amount");
  content = content.replaceAll("void _deleteTransaction(Map<String, dynamic> tx)", "void _deleteTransaction(TransactionModel tx)");
  content = content.replaceAll("Widget _buildTransactionTile(Map<String, dynamic> tx)", "Widget _buildTransactionTile(TransactionModel tx)");

  content = content.replaceAll("tx['amount'] > 0", "tx.isIncome");
  content = content.replaceAll("(tx['color'] as Color)", "tx.color");
  content = content.replaceAll("tx['icon']", "tx.icon");
  content = content.replaceAll("tx['color']", "tx.color");
  content = content.replaceAll("tx['title']", "tx.title");
  content = content.replaceAll("tx['category']", "tx.category");
  content = content.replaceAll("tx['amount']", "tx.amount");

  final addTransOld = '''_transactions.insert(1, {
                            'title': title,
                            'category': isIncome
                                ? 'Ostali Prihodi'
                                : 'Ostali Rashodi',
                            'amount': isIncome ? amount : -amount,
                            'icon': isIncome
                                ? Icons.account_balance_wallet
                                : Icons.shopping_basket,
                            'color': isIncome ? Colors.green : Colors.redAccent,
                          });''';
  final addTransNew = '''_transactions.insert(1, TransactionModel(
                            title: title,
                            category: isIncome
                                ? 'Ostali Prihodi'
                                : 'Ostali Rashodi',
                            amount: isIncome ? amount : -amount,
                            icon: isIncome
                                ? Icons.account_balance_wallet
                                : Icons.shopping_basket,
                            color: isIncome ? Colors.green : Colors.redAccent,
                          ));''';
  content = content.replaceAll(addTransOld, addTransNew);

  await file.writeAsString(content);
}
