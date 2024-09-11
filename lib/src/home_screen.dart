import 'package:flutter/material.dart';
import 'package:logix_cis_mobile_app/src/Auth/login_screen.dart';
import 'package:logix_cis_mobile_app/src/ImageCapture/camera_screen.dart';
import 'package:logix_cis_mobile_app/src/Services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _loadToken() async {
    final token = await AuthService.getToken();
    setState(() {
      _token = token;
    });
    //print('Retrieved token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()))
            },
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Welcome to the home screen!'),
          const SizedBox(height: 20),
          //if (_token != "") Text('Token: $_token'),
          //const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Image Capture'),
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CameraScreen()),
              )
            },
          )
        ],
      )),
    );
  }
}
