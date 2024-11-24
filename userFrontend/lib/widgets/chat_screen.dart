// lib/widgets/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../services/api_service.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool isWelcome;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.isWelcome = false,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  String displayText = '';
  
  @override
  void initState() {
    super.initState();
    if (!widget.isUser || widget.isWelcome) {
      _animateText();
    } else {
      displayText = widget.text;
    }
  }

  Future<void> _animateText() async {
    // Change from 50ms to 20ms for faster typing animation
    const Duration typingSpeed = Duration(milliseconds: 20);
    
    for (int i = 0; i <= widget.text.length; i++) {
      await Future.delayed(typingSpeed);
      if (mounted) {
        setState(() {
          displayText = widget.text.substring(0, i);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 4 : 8,
        horizontal: isMobile ? 8 : 16,
      ),
      child: Row(
        mainAxisAlignment: widget.isWelcome 
            ? MainAxisAlignment.center 
            : (widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start),
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: widget.isWelcome 
                  ? (isMobile ? MediaQuery.of(context).size.width * 0.9 : 600)
                  : (isMobile ? MediaQuery.of(context).size.width * 0.75 : 400.0),
              minWidth: widget.isWelcome ? 0 : (isMobile ? 80 : 100.0),
            ),
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: widget.isWelcome 
                  ? Colors.transparent
                  : (widget.isUser ? Colors.blue : Colors.grey[800]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.isUser ? widget.text : displayText,
              style: TextStyle(
                color: Colors.white,
                fontFamily: widget.isWelcome ? 'Courier' : null,
                fontSize: widget.isWelcome ? (isMobile ? 20 : 24) : null,
              ),
              textAlign: widget.isWelcome ? TextAlign.center : TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickPromptCard extends StatelessWidget {
  final String role;
  final String prompt;
  final VoidCallback onTap;

  const QuickPromptCard({
    super.key,
    required this.role,
    required this.prompt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    
    return Card(
      color: Colors.grey[850],
      child: InkWell(
        onTap: () {
          roleProvider.updateRole(role);
          onTap();
        },
        child: Container(
          width: isMobile ? 150 : 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                prompt,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 11 : 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatArea extends StatefulWidget {
  final String selectedRole;

  const ChatArea({
    super.key,
    required this.selectedRole,
  });

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _showPrompts = true;

  final Map<String, List<String>> _quickPrompts = {
    'Engineer': [
      'What are our main tech challenges?',
      'How do we handle technical debt?',
    ],
    'Product Manager': [
      "What is our product roadmap?",
      'How do we prioritize features?',
    ],
    'C-Level': [
      "What is our market position?",
      'What are our key metrics?',
    ],
  };

  @override
  void initState() {
    super.initState();
    _messages.add(const ChatMessage(
      text: "Ask me anything about our org",
      isUser: false,
      isWelcome: true,
    ));
  }

  Widget _buildQuickPrompts() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var role in _quickPrompts.keys)
              QuickPromptCard(
                role: role,
                prompt: _quickPrompts[role]![0],
                onTap: () {
                  setState(() {
                    _showPrompts = false;
                    _handleSubmitted(_quickPrompts[role]![0]);
                  });
                },
              ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        Opacity(
          opacity: 0.6,
          child: Text(
            "Preview of upcoming features...",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Opacity(
          opacity: 0.7,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              QuickPromptCard(
                role: "Engineer", // Using valid role but showing preview
                prompt: "Ask about our PRs and Issues",
                onTap: () {
                  setState(() {
                    _showPrompts = false;
                    _messages.add(ChatMessage(
                      text: "Preview: GitHub Activity",
                      isUser: true,
                    ));
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _messages.add(ChatMessage(
                          text: """📊 GitHub Activity Overview (Preview):

Open PRs: 12
Recent Merges: 8
Active Contributors: 5

Top PR: "Add real-time analytics dashboard"
Status: In Review
Comments: 7
+2,145 lines / -892 lines

Note: This is a preview of upcoming functionality.""",
                          isUser: false,
                        ));
                      });
                    });
                  });
                },
              ),
              QuickPromptCard(
                role: "Product Manager",
                prompt: "Query our technical docs",
                onTap: () {
                  setState(() {
                    _showPrompts = false;
                    // No API call, just show static preview message
                    _messages.add(ChatMessage(
                      text: "Preview: Documentation Search",
                      isUser: true,
                    ));
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _messages.add(ChatMessage(
                          text: """📚 Documentation Match (Preview):

API Endpoints Overview
--------------------
GET /analytics/metrics
POST /chat/completion
PUT /resources/update

Most viewed section: Authentication
Last updated: 2 hours ago
Contributors: 3

Note: This is a preview of upcoming functionality.""",
                          isUser: false,
                        ));
                      });
                    });
                  });
                },
              ),
              QuickPromptCard(
                role: "C-Level",
                prompt: "Get insights from metrics",
                onTap: () {
                  setState(() {
                    _showPrompts = false;
                    _messages.add(ChatMessage(
                      text: "Preview: Performance Metrics",
                      isUser: true,
                    ));
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _messages.add(ChatMessage(
                          text: """📈 Performance Metrics (Preview):

Response Time (ms):
╭─────────────────╮
│    ╭╮          │
│   ╭╯╰╮    ╭╮   │
│  ╭╯  ╰╮╭─╯╰╮  │
│ ╭╯    ╰╯   ╰╮ │
╰─────────────────╯
Last 7 days

Avg: 234ms
Max: 502ms
Min: 98ms
Uptime: 99.9%

Note: This is a preview of upcoming functionality.""",
                          isUser: false,
                        ));
                      });
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.all(isMobile ? 8 : 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
              if (_showPrompts && _messages.length == 1)
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: _buildQuickPrompts(),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 16),
          color: Colors.grey[850],
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Como vamo?',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    _controller.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
    });

    final response = await ApiService.getChatResponse(text, widget.selectedRole);
    
    setState(() {
      _messages.add(ChatMessage(
        text: response.answer,
        isUser: false,
      ));
      
      if (response.context.isNotEmpty) {
        _messages.add(ChatMessage(
          text: """
Related commits:
${response.context.map((c) => '''
• ${c.title}
  By: ${c.author_name}
  When: ${c.timestamp}
  ${c.repository_url}
''').join('\n')}""",
          isUser: false,
        ));
      }
    });
  }
}