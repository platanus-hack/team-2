// lib/widgets/side_panel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';

class GithubRepo {
  String url;
  String token;
  bool isConnected;

  GithubRepo({
    required this.url,
    this.token = '',
    this.isConnected = false,
  });
}

class SidePanel extends StatefulWidget {
  const SidePanel({super.key});

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  List<GithubRepo> resources = [];

  @override
  void initState() {
    super.initState();
    resources.add(GithubRepo(
      url: 'https://github.com/fastapi/fastapi',
    ));
  }

  @override 
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final roleProvider = Provider.of<RoleProvider>(context);
    
    return Container(
      width: isMobile ? null : 300,
      color: Colors.grey[900],
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Role:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: roleProvider.selectedRole,
            isExpanded: true,
            dropdownColor: Colors.grey[850],
            items: ['Engineer', 'Product Manager', 'C-Level']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => roleProvider.updateRole(value!),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Resources:', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    resources.add(GithubRepo(url: ''));
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final repo = resources[index];
                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('URL:', 
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                            if (index != 0)
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () {
                                  setState(() {
                                    resources.removeAt(index);
                                  });
                                },
                              ),
                          ],
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter resource URL',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          controller: TextEditingController(text: repo.url),
                          onChanged: (value) => setState(() => repo.url = value),
                        ),
                        const SizedBox(height: 8),
                        const Text('Access Token:', 
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter PAT (optional)',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          obscureText: true,
                          controller: TextEditingController(text: repo.token),
                          onChanged: (value) => setState(() {
                            repo.token = value;
                            repo.isConnected = value.isNotEmpty;
                          }),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              repo.isConnected ? Icons.check_circle : Icons.error_outline,
                              size: 16,
                              color: repo.isConnected ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              repo.isConnected ? 'Connected' : 'No token',
                              style: TextStyle(
                                fontSize: 12,
                                color: repo.isConnected ? Colors.green : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}