import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_theme.dart';
import '../app/routes.dart';
import '../app/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/page_body.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.isRegister = false});
  final bool isRegister;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;
  String _error = '';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      final auth = Get.find<AuthController>();
      if (widget.isRegister) {
        await auth.register(_name.text, _email.text, _password.text);
        if (!mounted) return;
        Get.offNamed(AppRoutes.login);
      } else {
        await auth.login(_email.text, _password.text);
        if (!mounted) return;
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is AuthException
              ? error.message
              : 'Something went wrong. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: PageBody(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        children: [
          FlowerHeader(height: widget.isRegister ? 160 : 220),
          Text(
            widget.isRegister ? 'CREATE\nNEW ACCOUNT' : 'WELCOME\nBACK!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.green, fontSize: 32),
          ),
          TextButton(
            onPressed: _busy
                ? null
                : () => Get.offNamed(
                    widget.isRegister ? AppRoutes.login : AppRoutes.register,
                  ),
            child: Text(
              widget.isRegister
                  ? 'Already registered? Log in here'
                  : 'New here? Create an account',
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _form,
            child: Column(
              children: [
                if (widget.isRegister) ...[
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    enabled: !_busy,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: !_busy,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: _hidePassword,
                  enabled: !_busy,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      tooltip: _hidePassword
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  textInputAction: widget.isRegister
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: widget.isRegister ? null : (_) => _submit(),
                  validator: Validators.required,
                ),
                if (widget.isRegister) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _hidePassword,
                    enabled: !_busy,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) =>
                        Validators.confirmPassword(value, _password.text),
                  ),
                ],
              ],
            ),
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.isRegister ? 'Sign Up' : 'Log In'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Accounts and plant history are stored on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.green, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
