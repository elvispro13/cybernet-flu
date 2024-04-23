import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:cybernet/services/login_service.dart';
import 'package:cybernet/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Logo(titulo: 'Inicio de sesión'),
              _Formulario(),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Formulario extends ConsumerStatefulWidget {
  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends ConsumerState<_Formulario> {
  final usuarioCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool cargando = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contextoPaginaProvider.notifier).state = context;
    });
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _formItemsDesign(
              Icons.person,
              TextFormField(
                controller: usuarioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                ),
                validator: (valor) =>
                    valor!.isEmpty ? 'Usuario requerido' : null,
                textInputAction: TextInputAction.next,
              ),
            ),
            _formItemsDesign(
              Icons.lock,
              TextFormField(
                  obscureText: true,
                  controller: passwordCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  validator: (valor) =>
                      valor!.isEmpty ? 'Contraseña requerida' : null,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) =>
                      _iniciarSesion(usuarioCtrl.text, passwordCtrl.text)),
            ),
            ElevatedButton(
              onPressed: () =>
                  _iniciarSesion(usuarioCtrl.text, passwordCtrl.text),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: cargando
                  ? const CircularProgressIndicator()
                  : const SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _iniciarSesion(String usuario, String password) async {
    // final biometricAuth = await LocalAuth.authenticate();
    // if (!biometricAuth) return;
    if (!formKey.currentState!.validate()) return;
    setState(() => cargando = true);

    final res = await LoginService.iniciarSesion(usuario, password);

    setState(() => cargando = false);
    if (!res.success) {
      ref.read(alertaProvider.notifier).state = res.message;
      // if (mounted) mostrarAlerta(context, 'Aviso', res.message);
      return;
    }

    ref.read(loginProvider.notifier).state = res.data;

    ref.read(appRouterProvider).goNamed('loading');
  }

  _formItemsDesign(icon, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }
}

// final u = Usuario();
// u.User = usuario;
// u.Password = password;
// await u.save();
