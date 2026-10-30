import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/presentation/screens/auth/widgets/security_info_widget.dart';
import '../../../core/common_widgets/button_widget.dart';
import '../../../core/common_widgets/text_form_field_widget.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/enums/enums.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/snackbars/snackbars.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPswVisible = true;


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if(!_formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    context.read<AuthBloc>().add(SignInRequestEvent(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconWidget(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              radius: Sizes.circularRadius,
              icon: Iconsax.shield_tick_copy, iconColor: Theme.of(context).primaryColor,
              paddingAll: Sizes.sm,
            ),
            SizedBox(width: Sizes.md),
            Text(appName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm - 1)),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.all(Sizes.md),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: context.screenHeight * 0.04, bottom: Sizes.sm),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                            child: Image.asset(AppAssets.appLogoImg, width: Sizes.imageSizeLg * 1.4)
                        ),
                      ),

                      SizedBox(height: Sizes.md),

                      Text(secureAccess, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm, color: Theme.of(context).primaryColor)),

                      SizedBox(height: Sizes.md),

                      Text(welcomeBack, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: Sizes.sm),
                      Text(signInMsg, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal)),

                      SizedBox(height: Sizes.xl),

                      AutofillGroup(
                        child: BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if(state is SignInSuccess) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.devices,
                              );
                            }else if(state is SignInFailure) {
                              SnackBars.snackMessage(context, description: state.message, messageType: MessageType.error);
                            }
                          },
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(usernameOrEmail, style: Theme.of(context).textTheme.bodyLarge),
                                SizedBox(height: Sizes.sm),

                                TextFormFieldWidget(
                                  controller: _usernameController,
                                  prefixIcon: Iconsax.profile_circle_copy,
                                  // labelText: usernameLabel,
                                  hintText: enterUsernameOrEmail,
                                  autofillHints: [AutofillHints.username, AutofillHints.email],
                                  validator: (value) => (value == null || value.isEmpty) ? enterValidUsername : null,
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                ),

                                SizedBox(height: Sizes.lg),

                                Text(password, style: Theme.of(context).textTheme.bodyLarge),
                                SizedBox(height: Sizes.sm),

                                TextFormFieldWidget(
                                  controller: _passwordController,
                                  prefixIcon: Iconsax.lock_copy,
                                  suffixIcon: isPswVisible ? Iconsax.eye_copy : Iconsax.eye_slash_copy,
                                  // labelText: password,
                                  hintText: passwordSub,
                                  obscureText: isPswVisible,
                                  suffixPressed: () =>  setState(() { isPswVisible = !isPswVisible; }),
                                  autofillHints: const [AutofillHints.password],
                                  validator: (value) => (value == null || value.isEmpty) ? enterValidPassword : null,
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: Sizes.sm),

                      SizedBox(height: Sizes.md + 3),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ButtonWidget(
                            label: signIn,
                            icon: Iconsax.login_copy,
                            buttonWidth: context.screenWidth,
                            buttonHeight: Sizes.xl * 1.5,
                            isLoading: state is SignInLoading,
                            onPressed: _signIn,
                          );
                        },
                      ),

                      SizedBox(height: Sizes.md),

                    ],
                  ),
                ),
              ),

              if (!context.isKeyboardVisible)
             SecurityInfoWidget()

            ],
          ),
        ),
      ),
    );
  }

}
