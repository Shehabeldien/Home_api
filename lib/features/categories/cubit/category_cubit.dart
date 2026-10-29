import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:category_api/core/api_constants.dart';
import 'package:category_api/features/categories/model/category_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  List<CategoryModel> categories = [];
  String lang = "en";

  Future<void> fetchCategories() async {
    emit(CategoryLoadingState());
    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            "Content-Type": "application/json",
            "Accept-Language": lang,
          },
        ),
      ).get(ApiConstants.categories);

      final data = response.data;

      List apiList = data is List ? data : data["data"];
      categories = apiList.map((e) => CategoryModel.fromJson(e)).toList();
      emit(CategorySuccessState());
    } catch (e) {
      emit(CategoryErrorState());
      print(e);
    }
  }

  void changeLanguage() {
    lang = lang == "en" ? "ar" : "en";
    fetchCategories();
  }
}
