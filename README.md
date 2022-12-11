## Getting started


## Install

```

```

## Usage

### Step 1
```dart
import 'package:kalendar/kalendar.dart';
```

### Step 2
```dart
import 'package:flutter/material.dart';
import 'package:kalendar/kalendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Scaffold(
        body: Center(
          child: Kalendar(),
        ),
      ),
    );
  }
}

```
