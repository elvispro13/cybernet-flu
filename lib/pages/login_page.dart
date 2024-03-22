import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/routes/router.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            formItemsDesign(
              Icons.person,
              TextFormField(
                controller: usuarioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                ),
                validator: (valor) =>
                    valor!.isEmpty ? 'Usuario requerido' : null,
              ),
            ),
            formItemsDesign(
              Icons.lock,
              TextFormField(
                obscureText: true,
                controller: passwordCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                validator: (valor) =>
                    valor!.isEmpty ? 'Contraseña requerida' : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // print('Usuario: ${usuarioCtrl.text}');
                  // print('Contraseña: ${passwordCtrl.text}');
                  ref.read(appRouterProvider).goNamed('home');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Center(
                      child: Text(
                    'Ingresar',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ))),
            ),
          ],
        ),
      ),
    );
  }
}

formItemsDesign(icon, item) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Card(child: ListTile(leading: Icon(icon), title: item)),
  );
}
