import '../../../../core/components/container/loading_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/components/button/custom_icon_button.dart';
import '../../../../core/components/dialog/custom_dialog.dart';
import '../../../../core/components/text_field/general_form_field.dart';
import '../../../../core/models/product/product_model.dart';
import '../cubit/search_product_cubit.dart';

class SearchProductView extends StatelessWidget {
  const SearchProductView({super.key, required this.productModelList});
  // gelen sayfadan listenin son halinde arama yapmak için....
  final List<ProductModel> productModelList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchProductCubit>(
      create: (context) => SearchProductCubit(productModelList),
      child: const _SearchProductView(),
    );
  }
}

class _SearchProductView extends StatelessWidget {
  const _SearchProductView();

  void openProductDialog(BuildContext context, ProductModel model) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: LoadingImageNetwork(
              imageURL: model.photoUrl ?? '',
              isRounded: true,
              width: context.sized.width * 0.5,
            ),
          ),
          context.sized.emptySizedHeightBoxLow,
          Center(
            child: Text(
              'Ürün Adı:${model.name}',
              style: context.general.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          context.sized.emptySizedHeightBoxLow,
          Text('Ürün Kategori:${model.category}'),
          context.sized.emptySizedHeightBoxLow,
          Text('Ürün Adet:${model.count}'),
          context.sized.emptySizedHeightBoxLow,
          Text('Ürün Fiyat: ${model.price}'),
          context.sized.emptySizedHeightBoxLow,
          Text('Barkod: ${model.barcode}'),
          context.sized.emptySizedHeightBoxLow,
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchProductCubit>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ürün Arama...'),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        floatingActionButton: buildFAB(context, cubit),
        body: Padding(
          padding: context.padding.horizontalLow,
          child: Column(
            children: [
              buildSearchTitle(cubit, context),
              context.sized.emptySizedHeightBoxLow,
              buildTitle(context),
              context.sized.emptySizedHeightBoxLow,
              buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTitle(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: context.sized.width * 0.3,
            child: const Center(
                child: RotatedBox(quarterTurns: 3, child: Text('Ürün Adı'))),
          ),
          SizedBox(
            width: context.sized.width * 0.1,
            child: const Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text('Kategori'),
              ),
            ),
          ),
          SizedBox(
            width: context.sized.width * 0.1,
            child: const RotatedBox(
                quarterTurns: 3, child: Center(child: Text('Adet'))),
          ),
          SizedBox(
            width: context.sized.width * 0.1,
            child: const RotatedBox(
                quarterTurns: 3, child: Center(child: Text('Fiyat'))),
          ),
          context.sized.emptySizedWidthBoxLow,
        ],
      ),
    );
  }

  Expanded buildList() {
    return Expanded(
      child: BlocBuilder<SearchProductCubit, SearchProductState>(
        builder: (context, state) {
          final searchList = state.searchProductModelList ?? [];
          if (searchList.isNotEmpty) {
            return buildProductListView(searchList);
          } else {
            return buildProductListView(state.productModelList);
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

  FloatingActionButton buildFAB(
      BuildContext context, SearchProductCubit cubit) {
    return FloatingActionButton(
      heroTag: 'scan_barcode',
      onPressed: () async {
        final value = await context.route.navigateToPage(
          const SimpleBarcodeScannerPage(
            isShowFlashIcon: true,
            cancelButtonText: 'İptal',
            scanType: ScanType.barcode,
          ),
        );
        if (value is String && value != '-1') {
          cubit.searchWithBarcodeProduct(value);
        }
      },
      child: const Icon(Icons.camera_alt_rounded),
    );
  }

  Form buildSearchTitle(SearchProductCubit cubit, BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Row(
        children: [
          Expanded(
            child: GeneralTextFormField(
              labelText: 'Ürün Adı',
              controller: cubit.productNameController,
              onChanged: (p0) {
                cubit.searchWithNamedProduct();
              },
              keyboardType: TextInputType.text,
            ),
          ),
          context.sized.emptySizedWidthBoxLow,
          Expanded(
            child: GeneralTextFormField(
              labelText: 'Barkod',
              controller: cubit.productBarcodeController,
              keyboardType: TextInputType.text,
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
