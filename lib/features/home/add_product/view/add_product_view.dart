import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/components/button/custom_elevated_text_button.dart';
import '../../../../core/components/button/custom_icon_button.dart';
import '../../../../core/components/text_field/general_form_field.dart';
import '../cubit/add_product_cubit.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductCubit>(
      create: (context) => AddProductCubit(),
      child: const _AddProductView(),
    );
  }
}

class _AddProductView extends StatelessWidget {
  const _AddProductView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();
    return Scaffold(
      key: cubit.scaffoldKey,
      appBar: AppBar(
        title: const Text('Ürün Ekle'),
      ),
      body: SingleChildScrollView(
        padding: context.padding.horizontalLow,
        child: Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildImage(cubit),
              context.sized.emptySizedHeightBoxLow,
              GeneralTextFormField(
                controller: cubit.nameController,
                labelText: 'Ürün İsmi',
              ),
              context.sized.emptySizedHeightBoxLow,
              GeneralTextFormField(
                controller: cubit.categoryController,
                labelText: 'Kategori',
              ),
              context.sized.emptySizedHeightBoxLow,
              GeneralTextFormField(
                controller: cubit.countController,
                labelText: 'Adet',
              ),
              context.sized.emptySizedHeightBoxLow,
              GeneralTextFormField(
                controller: cubit.priceController,
                labelText: 'Ücreti',
              ),
              context.sized.emptySizedHeightBoxLow,
              Row(
                children: [
                  Expanded(
                    child: GeneralTextFormField(
                      controller: cubit.barcodeController,
                      labelText: 'Barkod',
                    ),
                  ),
                  context.sized.emptySizedWidthBoxLow,
                  CustomElevatedTextButton(
                    onPressed: () async {
                      final value = await context.route.navigateToPage(
                        const SimpleBarcodeScannerPage(
                          isShowFlashIcon: true,
                          scanType: ScanType.barcode,
                        ),
                      );
                      if ((value is String) && (value != '-1')) {
                        cubit.scanBarcode(value);
                      }
                    },
                    title: 'Barkodu Tarat',
                  ),
                ],
              ),
              context.sized.emptySizedHeightBoxLow3x,
              CustomElevatedTextButton(
                onPressed: () {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.uploadProduct();
                  }
                },
                title: 'Kaydet',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(AddProductCubit cubit) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state.isDone == true) {
          context.route.pop();
        }
      },
      builder: (context, state) {
        if (state.selectedImage == null) {
          return CustomIconButton(
            iconData: Icons.image,
            size: context.sized.width * 0.6,
            onTap: () => cubit.getImage(),
          );
        } else {
          return InkWell(
            onTap: () => cubit.getImage(),
            child: ClipRRect(
              borderRadius: context.border.lowBorderRadius,
              child: Image.file(state.selectedImage!),
            ),
          );
        }
      },
    );
  }
}
