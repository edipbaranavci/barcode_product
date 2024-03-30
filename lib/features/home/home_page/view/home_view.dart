import 'package:barcode_products/features/home/search_product/view/search_product_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/components/container/loading_image_network.dart';
import '../../../../core/components/dialog/custom_dialog.dart';
import '../../../../core/models/product/product_model.dart';
import '../../add_product/view/add_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
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
      floatingActionButton: buildFABs(context, cubit),
      body: Padding(
        padding: context.padding.low,
        child: Column(
          children: [
            buildTitle(context),
            buildProductList(cubit),
          ],
        ),
      ),
    );
  }

  Column buildFABs(BuildContext context, HomeCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: '1',
          onPressed: () => context.route.navigateToPage(
            SearchProductView(
              productModelList: cubit.state.productModelList ?? [],
            ),
          ),
          child: const Icon(Icons.search),
        ),
        context.sized.emptySizedHeightBoxLow,
        FloatingActionButton(
          heroTag: '2',
          onPressed: () async {
            await context.route
                .navigateToPage(
                  const AddProductView(),
                )
                .whenComplete(() async => await cubit.getProductList());
          },
          child: const Icon(Icons.add),
        ),
      ],
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

  Widget buildProductList(HomeCubit cubit) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: cubit.productsCollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Bir Sorun Var!');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final list = (snapshot.data!.docs.map((DocumentSnapshot e) =>
                      ProductModel.fromJson(e.data() as Map<String, dynamic>)))
                  .toList();
              cubit.changeProductModelList(list);
              return buildProductListView(list);
            }
          }),
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
}
