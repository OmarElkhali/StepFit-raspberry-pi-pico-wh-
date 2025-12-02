import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_tracker/di/injection_container.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_cubit.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_state.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_status/auth_status_cubit.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            // appBar: AppBar(),
            body: Stack(
              children: [
                // Fond orange uni au lieu de l'image
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF6F00), // Orange
                        Color(0xFFFF8F00), // Orange clair
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 48.0,
                    ),
                    child: Center(
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          state.maybeWhen(
                              loggedIn: () {
                                final cubit =
                                    BlocProvider.of<AuthStatusCubit>(context);
                                cubit.checkAuthStatus();
                                // Navigator.of(context).pop();
                              },
                              error: (message) {
                                // showCustomAlertDialog(
                                //   context,
                                //   message,
                                //   isErrorDialog: true,
                                //   errorContext: S.of(context).login,
                                // );
                              },
                              orElse: () {});
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            loading: () => _buildColumn(true, context),
                            orElse: () => _buildColumn(false, context),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumn(bool isLoading, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          // Logo du coureur
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/runner_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).allInOneTrack,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
          const Spacer(
            flex: 2,
          ),
          TextFormField(
            controller: _nameController,
            validator: (val) =>
                val!.isEmpty ? S.of(context).enterYourName : null,
            autocorrect: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: S.of(context).enterYourName,
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await BlocProvider.of<AuthCubit>(context).signInAnonymously(
                  name: _nameController.text,
                );
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: !isLoading
                    ? Text(
                        S.of(context).startUsingSteps,
                        style: TextStyle(
                          color: Color(0xFFFF6F00),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFFF6F00)),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
