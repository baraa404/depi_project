//
import 'package:depi_project/modules/product.module.dart';
import 'package:dio/dio.dart';

class ProductService {
  final Dio dio = Dio();
  Future<ProductsModel> getProduct({required String barcode}) async {
    final api =
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json?'
        'fields=product_name,brands,quantity,nutriscore_grade,ecoscore_grade,ingredients_text,allergens_tags,nutriments,categories_tags,image_url,nova_group';
    try {
      Response response = await dio.get(api);

      ProductsModel product = ProductsModel.fromJson(response.data);
      return product;
    } catch (e) {
      throw Exception('faild to load product');
    }
  }
}

void main() async {
  ProductsModel data = await ProductService().getProduct(barcode: '3017624010701');
  print(data.product!.imageUrl);
}
