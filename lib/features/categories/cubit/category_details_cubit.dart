import 'package:bloc/bloc.dart';
import 'package:category_api/core/api_constants.dart';
import 'package:category_api/features/categories/model/category_model.dart';
import 'package:dio/dio.dart';

part 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit() : super(CategoryDetailsInitial());

  CategoryModel? category;

  Future<void> fetchCategoryById(int id, String lang) async {
    emit(CategoryDetailsLoadingState());
    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            "Content-Type": "application/json",
            "Accept-Language": lang,
          },
        ),
      ).get(ApiConstants.categoryById(id));

      final data = response.data;
      final json = data["data"] ?? data;
      category = CategoryModel.fromJson(json);
      emit(CategoryDetailsSuccessState());
    } catch (e) {
      emit(CategoryDetailsErrorState());
      print(e);
    }
  }
}
