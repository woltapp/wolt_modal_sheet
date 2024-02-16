import 'package:flutter/material.dart';
import 'package:rework_experiments/wolt_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _TestScreen(),
    );
  }
}

class _TestScreen extends StatelessWidget {
  const _TestScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: .5,
          // heightFactor: .7,
          child: WoltPage(
            header: const _CollapsedContent('header', Colors.blue),
            footer: const _CollapsedContent('footer', Colors.green),
            slivers: [
              const SliverAppBar.medium(
                backgroundColor: Colors.amber,
              ),
              SliverList.builder(
                itemBuilder: (context, index) {
                  debugPrint('1st seq $index');
                  return _Slice(index);
                },
                itemCount: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsedContent extends StatefulWidget {
  final String title;
  final Color color;

  const _CollapsedContent(this.title, this.color);

  @override
  State<_CollapsedContent> createState() => _CollapsedContentState();
}

class _CollapsedContentState extends State<_CollapsedContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: widget.color,
      height: _isExpanded ? 300 : 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(widget.title)),
          Checkbox(
            value: _isExpanded,
            onChanged: (value) => setState(() => _isExpanded = value!),
          ),
        ],
      ),
    );
  }
}

class _Slice extends StatelessWidget {
  final int index;

  const _Slice(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(8),
      height: 300,
      child: Text('Item $index'),
    );
  }
}
