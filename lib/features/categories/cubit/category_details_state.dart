part of 'category_details_cubit.dart';

sealed class CategoryDetailsState {}

final class CategoryDetailsInitial extends CategoryDetailsState {}

final class CategoryDetailsLoadingState extends CategoryDetailsState {}

final class CategoryDetailsSuccessState extends CategoryDetailsState {}

final class CategoryDetailsErrorState extends CategoryDetailsState {}
