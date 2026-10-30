import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02Screen(),
    );
  }
}

class Lab02Screen extends StatefulWidget {
  const Lab02Screen({super.key});

  @override
  State<Lab02Screen> createState() => _Lab02ScreenState();
}

class _Lab02ScreenState extends State<Lab02Screen> {
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  String _selectedRole = 'Student';

  static const List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  Future<void> _selectMaterialDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateUtils.dateOnly(DateTime.now()),
    );

    if (!mounted || picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Widget _buildSheet({
    required BuildContext sheetContext,
    required Widget child,
  }) {
    return Container(
      color: CupertinoColors.systemBackground.resolveFrom(sheetContext),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 240,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Done'),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return _buildSheet(
          sheetContext: sheetContext,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumDate: DateTime(1950),
            maximumDate: DateUtils.dateOnly(DateTime.now()),
            onDateTimeChanged: (date) {
              if (!mounted) return;

              setState(() {
                _selectedDate = DateUtils.dateOnly(date);
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _showCupertinoRolePicker() async {
    final controller = FixedExtentScrollController(
      initialItem: _roles.indexOf(_selectedRole),
    );

    try {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (sheetContext) {
          return _buildSheet(
            sheetContext: sheetContext,
            child: CupertinoPicker(
              scrollController: controller,
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                if (!mounted) return;

                setState(() {
                  _selectedRole = _roles[index];
                });
              },
              children: _roles
                  .map((role) => Center(child: Text(role)))
                  .toList(),
            ),
          );
        },
      );
    } finally {
      controller.dispose();
    }
  }

  Widget _buildPickers() {
    return PickerSection(
      selectedDate: _selectedDate,
      selectedRole: _selectedRole,
      roles: _roles,
      onMaterialDatePressed: _selectMaterialDate,
      onCupertinoDatePressed: _showCupertinoDatePicker,
      onCupertinoRolePressed: _showCupertinoRolePicker,
      onRoleChanged: (role) {
        setState(() {
          _selectedRole = role;
        });
      },
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const ImageSection(imagePath: 'assets/images/lake.jpg'),
        const TitleSection(
          name: 'Oeschinen Lake',
          location: 'Kandersteg, Switzerland',
          starCount: 41,
        ),
        const ActionButtonsSection(),
        const TextSection(),
        _buildPickers(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: const [
                StudentDetailsSection(),
                SizedBox(height: 16),
                ImageSection(imagePath: 'assets/images/lake.jpg'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: [
                const TitleSection(
                  name: 'Oeschinen Lake',
                  location: 'Kandersteg, Switzerland',
                  starCount: 41,
                ),
                const ActionButtonsSection(),
                const TextSection(),
                _buildPickers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitView()
                : _buildLandscapeView();
          },
        ),
      ),
    );
  }
}

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'MARCUS TING ZHONG SHENG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Student ID: BCS24020031',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Divider(height: 32),
            Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '"To become a professional software engineer and develop innovative technology."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            color: Colors.blueGrey.shade100,
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.landscape,
                  size: 64,
                  color: Colors.blueGrey,
                ),
                SizedBox(height: 8),
                Text('Lake image unavailable'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.red),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  void _showMessage(BuildContext context, String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$action selected')),
      );
  }

  Widget _buildButton(
      BuildContext context,
      IconData icon,
      String label,
      ) {
    return Expanded(
      child: TextButton(
        onPressed: () => _showMessage(context, label),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(context, Icons.call, 'CALL'),
        _buildButton(context, Icons.near_me, 'ROUTE'),
        _buildButton(context, Icons.share, 'SHARE'),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Oeschinen Lake is located above Kandersteg in the Swiss Alps. '
            'Surrounded by mountains, the lake is a popular destination '
            'for hiking, photography, and enjoying nature. '
            'Visitors can explore scenic trails and admire the clear '
            'blue water and beautiful mountain views.',
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
        ),
      ),
    );
  }
}

class PickerSection extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onMaterialDatePressed;
  final VoidCallback onCupertinoDatePressed;
  final VoidCallback onCupertinoRolePressed;
  final ValueChanged<String> onRoleChanged;

  const PickerSection({
    super.key,
    required this.selectedDate,
    required this.selectedRole,
    required this.roles,
    required this.onMaterialDatePressed,
    required this.onCupertinoDatePressed,
    required this.onCupertinoRolePressed,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${selectedDate.year}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Date & Role Pickers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected date: $dateText',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onMaterialDatePressed,
              child: const Text('Material Date Picker'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onCupertinoDatePressed,
              child: const Text('Cupertino Date Picker'),
            ),
            const Divider(height: 32),
            Text(
              'Selected role: $selectedRole',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              items: roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onRoleChanged(value);
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onCupertinoRolePressed,
              child: const Text('Cupertino Role Picker'),
            ),
          ],
        ),
      ),
    );
  }
}