import '../../../../core/components/dialog/custom_dialog.dart';
import '../../../../core/models/product/product_model.dart';
import '../../add_product/view/add_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../../../../core/components/button/custom_icon_button.dart';
import '../../../../core/components/text_field/general_form_field.dart';
import '../cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Scaffold(
      key: cubit.scaffoldKey,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: () {
              context.route.navigateToPage(
                const AddProductView(),
              );
              cubit.getProductList();
            },
            child: const Icon(Icons.add),
          ),
          context.sized.emptySizedHeightBoxLow,
          FloatingActionButton(
            heroTag: '2',
            onPressed: () async {
              final value = await context.route.navigateToPage(
                const SimpleBarcodeScannerPage(
                  isShowFlashIcon: true,
                  scanType: ScanType.barcode,
                ),
              );
              if (value is String) {
                cubit.searchWithBarcodeProduct(value);
              }
            },
            child: const Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: context.padding.low,
        child: Column(
          children: [
            buildSearchTitle(cubit, context),
            buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget buildProductList() {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final productList = state.productModelList ?? [];
          final searchList = state.searchProductModelList ?? [];
          if (searchList.isNotEmpty) {
            return buildProductListView(searchList);
          } else {
            if (productList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return buildProductListView(productList);
            }
          }
        },
      ),
    );
  }

  ListView buildProductListView(List<ProductModel> productList) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final model = productList[index];
        return Card(
          child: InkWell(
            borderRadius: context.border.lowBorderRadius,
            onTap: () => openProductDialog(context, model),
            child: Padding(
              padding: context.padding.low,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.sized.width * 0.3,
                    child: Center(child: Text(model.name ?? 'boş')),
                  ),
                  SizedBox(
                    width: context.sized.width * 0.1,
                    child: Center(child: Text(model.category ?? 'kategori')),
                  ),
                  SizedBox(
                    width: context.sized.width * 0.1,
                    child: Center(child: Text('${model.count ?? 0}')),
                  ),
                  SizedBox(
                    width: context.sized.width * 0.1,
                    child: Center(child: Text(model.price ?? 'kategori')),
                  ),
                  context.sized.emptySizedWidthBoxLow,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> openProductDialog(BuildContext context, ProductModel model) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
          title: 'Ürün: ${model.name}',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ürün Adı:${model.name}'),
              Text('Ürün Kategori:${model.category}'),
              Text('Ürün Adet:${model.count}'),
              Text('Ürün Fiyat: ${model.price}'),
            ],
          )),
    );
  }

  Form buildSearchTitle(HomeCubit cubit, BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Row(
        children: [
          Expanded(
            child: GeneralTextFormField(
              labelText: 'Ürün Adı',
              controller: cubit.productNameController,
              keyboardType: TextInputType.text,
            ),
          ),
          context.sized.emptySizedWidthBoxLow,
          Expanded(
            child: GeneralTextFormField(
              labelText: 'Barkod',
              controller: cubit.productBarcodeController,
              keyboardType: TextInputType.number,
            ),
          ),
          context.sized.emptySizedWidthBoxLow,
          CustomIconButton(
            iconData: Icons.search,
            toolTip: 'Ara',
            onTap: () {},
          ),
          CustomIconButton(
            toolTip: 'Temizle',
            iconData: Icons.clear,
            onTap: () => cubit.clearSearchProductModelList(),
          ),
        ],
      ),
    );
  }
}
