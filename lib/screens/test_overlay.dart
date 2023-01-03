// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(const OverlayApp());

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OverlayExample(),
    );
  }
}

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  OverlayEntry? overlayEntry;
  int currentPageIndex = 0;

  void createHighlightOverlay() {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
        // Create a new OverlayEntry.
        builder: (BuildContext context) {
      // Align is used to position the highlight overlay
      // relative to the NavigationBar destination.
      return Container(
        width: 100,
        height: 100,
        color: Colors.green.withOpacity(0.7),
        child: ElevatedButton(
            onPressed: () {
              removeHighlightOverlay();
            },
            child: Text("Remove Overlay")),
      );
      // return SafeArea(
      //   child: Align(
      //     alignment: alignment,
      //     heightFactor: 1.0,
      //   ),
      // );
    });

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget)!.insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Sample'),
      ),
      body: ElevatedButton(
        onPressed: () {
          setState(() {
            currentPageIndex = 0;
          });
          createHighlightOverlay();
        },
        child: const Text('Explore'),
      ),
    );
  }
}
