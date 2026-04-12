import re

with open(r'c:\Users\jovan\Desktop\flutter_playground\lib\main.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update _deleteTask
res = content.replace('''  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }''', '''  void _deleteTask(int index) {
    final deletedTask = tasks[index];
    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task izbrisan'),
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
  }''')

# 2. Update onDismissed
res = res.replace('''                onDismissed: (direction) {
                  _deleteTask(index);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Izbrisan task')));
                },''', '''                onDismissed: (direction) => _deleteTask(index),''')

# 3. Add UserModel class and replace dynamic
res = res.replace('''class _ApiTestScreenState extends State<ApiTestScreen> {
  List<dynamic> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Pokusao praviti model ali je previse komplikovano, koristim dynamic za sad
  // class User { ... }''', '''class UserModel {
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
  String _errorMessage = '';''')

# 4. _fetchUsers parsing
res = res.replace('''        setState(() {
          _users = json.decode(response.body)['users']; // parsanje JSON-a
          _isLoading = false;
        });''', '''        setState(() {
          final List dynamicList = json.decode(response.body)['users'];
          _users = dynamicList.map((data) => UserModel.fromJson(data)).toList();
          _isLoading = false;
        });''')

# 5. API Skeleton Loader
res = res.replace('''    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty''', '''    return _isLoading
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
        : _errorMessage.isNotEmpty''')

# 6. API List View UI updating fields
res = res.replace('''                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple.withOpacity(0.15),
                    child: Text(
                      user['firstName'][0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 20,
                      ),
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
                  ),''', '''                  leading: CircleAvatar(
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
                  ),''')

# 7. API Details Modal updates
res = res.replace('''                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.deepPurple[200],
                                    child: Text(
                                      user['firstName'][0] +
                                          user['lastName'][0],
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${user['firstName']} ${user['lastName']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user['email'],
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
                                    title: Text(user['company']['name']),
                                    subtitle: Text(
                                      'Odjeljenje: ${user['company']['department']}',
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                    ),
                                    title: Text('${user['address']['city']}'),
                                    subtitle: Text(
                                      '${user['address']['address']}',
                                    ),
                                  ),''', '''                                  CircleAvatar(
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
                                  ),''')

# 8. Finance Dashboard Delete Tx + Add Tx
res = res.replace('''  void _showAddTransactionDialog(BuildContext context) {''', '''  void _deleteTransaction(Map<String, dynamic> tx) {
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

  void _showAddTransactionDialog(BuildContext context) {''')

# 9. Finance ProgressBar Setup
res = res.replace('''              _buildIncomeExpenseRow(
                Icons.arrow_upward,
                'Rashodi',
                '\\$ ${_totalExpense.abs().toStringAsFixed(2)}',
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }''', '''              _buildIncomeExpenseRow(
                Icons.arrow_upward,
                'Rashodi',
                '\\$ ${_totalExpense.abs().toStringAsFixed(2)}',
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
  }''')


# 10. Swipe to delete Finance Item
res = res.replace('''  Widget _buildTransactionTile(Map<String, dynamic> tx) {
    final bool isIncome = tx['amount'] > 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),''', '''  Widget _buildTransactionTile(Map<String, dynamic> tx) {
    final bool isIncome = tx['amount'] > 0;
    return Dismissible(
      key: Key(tx.hashCode.toString()),
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
        margin: const EdgeInsets.only(bottom: 12),''')

res = res.replace('''        trailing: Text(
          isIncome
              ? '+ \\$${tx['amount'].toStringAsFixed(2)}'
              : '- \\$${tx['amount'].abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }''', '''        trailing: Text(
          isIncome
              ? '+ \\$${tx['amount'].toStringAsFixed(2)}'
              : '- \\$${tx['amount'].abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    ));
  }''')

with open(r'c:\Users\jovan\Desktop\flutter_playground\lib\main.dart', 'w', encoding='utf-8') as f:
    f.write(res)
print("done")
