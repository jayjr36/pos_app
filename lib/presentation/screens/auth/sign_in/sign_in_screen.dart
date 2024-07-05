import 'package:flutter/material.dart';
import 'package:flutter_pos/app/assets/app_assets.dart';
import 'package:flutter_pos/app/routes/app_routes.dart';
import 'package:flutter_pos/app/services/auth/sign_in_with_google.dart';
import 'package:flutter_pos/app/themes/app_sizes.dart';
import 'package:flutter_pos/app/themes/app_theme.dart';
import 'package:flutter_pos/presentation/widgets/app_button.dart';
import 'package:flutter_pos/presentation/widgets/app_dialog.dart';
import 'package:flutter_pos/presentation/widgets/app_image.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            welcomeMessage(),
            signInButton(),
          ],
        ),
      ),
    );
  }

  Widget welcomeMessage() {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImage(
              image: AppAssets.welcome,
              imgProvider: ImgProvider.assetImage,
            ),
            const SizedBox(height: AppSizes.padding),
            Text(
              'Welcome!',
              style: AppTheme().textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to Flutter POS app',
              textAlign: TextAlign.center,
              style: AppTheme().textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget signInButton() {
    return AppButton(
      text: 'Sign In With Google',
      onTap: () async {
        AppDialog.showDialogProgress();

        var res = await AuthService().signIn();

        AppDialog.closeDialog();

        if (res.isSuccess) {
          AppRoutes.router.refresh();
        } else {
          AppDialog.showErrorDialog(error: res.error?.error);
        }
      },
    );
  }
}
