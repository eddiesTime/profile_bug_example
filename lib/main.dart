import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _keyGenerationMs = 0;
  int _rsaEncryptionMedian = 0;
  int _rsaDecryptionMedian = 0;
  String _decryptedCipher = '';

  void runRsaOperations() async {
    // Generate RSA keys
    final startTime = DateTime.now();
    final KeyPair keyPair = await RSA.generate(4096);
    String plainText = 'Hello World!';
    String cipher = '';

    _keyGenerationMs = DateTime.now().difference(startTime).inMilliseconds;
    print('RSA key generation took: $_keyGenerationMs ms');

    // Run RSA encryption test
    final times = <int>[];
    for (var i = 0; i < 5; i++) {
      var startTime = DateTime.now();
      cipher =
          await RSA.encryptOAEP(plainText, '', Hash.SHA256, keyPair.publicKey);
      times.add(DateTime.now().difference(startTime).inMilliseconds);
    }
    times.sort((a, b) => a.compareTo(b));
    _rsaEncryptionMedian = times[2];
    print('Encryption time (Median): $_rsaEncryptionMedian ms');

    final times2 = <int>[];
    for (var i = 0; i < 5; i++) {
      var startTime = DateTime.now();
      _decryptedCipher =
          await RSA.decryptOAEP(cipher, '', Hash.SHA256, keyPair.privateKey);
      times2.add(DateTime.now().difference(startTime).inMilliseconds);
    }
    times2.sort((a, b) => a.compareTo(b));
    _rsaDecryptionMedian = times2[2];
    print('Decryption time (Median): $_rsaDecryptionMedian ms');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'RSA Operations',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text('DEBUG Mode: $kDebugMode'),
            const Text('PROFILE Mode: $kProfileMode'),
            Text(
              'RSA Key Generation: $_keyGenerationMs ms',
            ),
            Text(
              'RSA Encryption Median: $_rsaEncryptionMedian ms',
            ),
            Text(
              'RSA Decryption Median: $_rsaDecryptionMedian ms',
            ),
            Text('Decrypted Cipher: $_decryptedCipher'),
            ElevatedButton(
                onPressed: runRsaOperations,
                child: const Text('Run RSA Operations')),
          ],
        ),
      ),
    );
  }
}
