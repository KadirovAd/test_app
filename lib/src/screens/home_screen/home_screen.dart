import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_work/src/bloc/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _apiData = '';
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchApiData();
  }

  Future<void> _fetchApiData() async {
    try {
      final response = await http.get(Uri.parse('https://catfact.ninja/fact'));
      if (response.statusCode == 200) {
        setState(() {
          _apiData = json.decode(response.body)['fact'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _apiData = 'Failed to fetch data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedIndex == 0
              ? _buildApiData()
              : _buildProfile(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Cat Fact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildApiData() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(_error.isNotEmpty ? _error : _apiData),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Username:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Text(state.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold));
              }
              return const Text('Unknown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
            },
          ),
        ],
      ),
    );
  }
}
