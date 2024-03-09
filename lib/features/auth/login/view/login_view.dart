import '../../../../core/components/app_bar/custom_app_bar.dart';
import '../../../../core/components/button/custom_elevated_text_button.dart';
import '../../../../core/components/container/loading_image_network.dart';
import '../../../../core/components/text_field/general_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  final String _centerLoginLogoUrl =
      'https://firebasestorage.googleapis.com/v0/b/ahzem-ser.appspot.com/o/ps_logo.png?alt=media&token=2f11f8b9-4685-4edb-9443-7c14634a0f06';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Giriş Yap',
        onBackTap: null,
        isHideBackButton: true,
      ),
      body: Padding(
        padding: context.padding.horizontalNormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoadingImageNetwork(
              imageURL: _centerLoginLogoUrl,
              width: context.sized.width * .3,
              height: context.sized.width * .3,
            ),
            context.sized.emptySizedHeightBoxLow3x,
            const GeneralTextFormField(),
            context.sized.emptySizedHeightBoxLow3x,
            CustomElevatedTextButton(
              onPressed: () {},
              padding: context.padding.medium * .6,
              title: 'Giriş',
            ),
          ],
        ),
      ),
    );
  }
}
