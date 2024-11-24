import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'widgets/side_panel.dart';
import 'widgets/chat_screen.dart';
import 'package:provider/provider.dart';
import 'providers/role_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleProvider(),
      child: MaterialApp(
        title: 'Como Vamo?',
        theme: ThemeData.dark(),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final roleProvider = Provider.of<RoleProvider>(context);

    return Scaffold(
      drawer: isMobile ? Drawer(
        child: SidePanel(),
      ) : null,
      appBar: isMobile ? AppBar(
        title: const Text('Como Vamo?'),
        backgroundColor: Colors.grey[900],
      ) : null,
      body: isMobile 
        ? ChatArea(selectedRole: roleProvider.selectedRole)
        : Row(
            children: [
              const SidePanel(),
              Expanded(
                child: ChatArea(selectedRole: roleProvider.selectedRole),
              ),
            ],
          ),
    );
  }
}
