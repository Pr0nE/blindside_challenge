import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:blindside_challenge/pages/home_page.dart';
import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/extensions/context_extensions.dart';

/// Various types of authentication in app.
enum AuthType {
  login,
  register,
}

/// Authentication page.
/// 
/// Contains both `registering` and `login` functionalities.
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passController;
  late final GlobalKey<FormState> _formKey;

  late AuthType _currentAuthType;
  late bool _isLoading;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _currentAuthType = AuthType.login;
    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAuthSelector(context),
                    _buildTextFields(context),
                    _buildAuthButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildAuthSelector(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildSelectorButton(type: AuthType.login),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSelectorButton(type: AuthType.register),
            ),
          ],
        ),
      );

  Widget _buildTextFields(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              //TODO validator: _emailValidator,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              //TODO validator: _passValidator,
            ),
          ],
        ),
      );

  Widget _buildSelectorButton({required AuthType type}) => TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
            backgroundColor: MaterialStateProperty.all(
              type == _currentAuthType ? Colors.blue : Colors.transparent,
            )),
        child: Text(
          type == AuthType.login ? 'Login' : 'Register',
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () => setState(() => _currentAuthType = type),
      );

  Widget _buildAuthButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: _isLoading ? null : onAuthButtonPressed,
            child: _isLoading
                ? const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _currentAuthType == AuthType.login ? 'Login' : 'Register',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      );

  Future<void> onAuthButtonPressed() async {
    UserCredential? userCredential;

    if (_currentAuthType == AuthType.login) {
      userCredential = await _loginWithEmailPass(
        email: _emailController.text,
        pass: _passController.text,
      );
    } else if (_currentAuthType == AuthType.register) {
      userCredential = await _registerWithEmailPass(
        email: _emailController.text,
        pass: _passController.text,
      );
    }

    if (userCredential != null) {
      _onUserSuccessLogin(userCredential);
    }
  }

  void _onUserSuccessLogin(UserCredential credential) {
    context.showSnackBar(
      'You have successfully logged in as ${credential.user?.email}!',
    );

    Navigator.of(context).pushReplacement(
      FadePageRoute((BuildContext context) => const HomePage()),
    );
  }

  Future<UserCredential?> _registerWithEmailPass({
    required String email,
    required String pass,
  }) async {
    setState(() => _isLoading = true);

    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      context.showSnackBar(e.message ?? 'An Error occurred');
    } finally {
      setState(() => _isLoading = false);
    }

    return null;
  }

  Future<UserCredential?> _loginWithEmailPass({
    required String email,
    required String pass,
  }) async {
    setState(() => _isLoading = true);
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      context.showSnackBar(e.message ?? 'An Error occurred');
    } finally {
      setState(() => _isLoading = false);
    }
    return null;
  }
}
