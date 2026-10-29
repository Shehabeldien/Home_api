import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:category_api/features/categories/cubit/category_details_cubit.dart';
import 'package:category_api/features/categories/view/home_page.dart';

class CategoryDetailsPage extends StatelessWidget {
  final int id;
  final String lang;

  const CategoryDetailsPage({super.key, required this.id, required this.lang});

  @override
  Widget build(BuildContext context) {
    final isArabic = lang == "ar";
    return BlocProvider(
      create: (context) => CategoryDetailsCubit()..fetchCategoryById(id, lang),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(),
          body: BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
            builder: (context, state) {
              final cubit = context.read<CategoryDetailsCubit>();

              if (state is CategoryDetailsErrorState) {
                return Center(
                  child: TextButton(
                    onPressed: () => cubit.fetchCategoryById(id, lang),
                    child: Text(isArabic ? "إعادة المحاولة" : "Try again"),
                  ),
                );
              }
              if (state is! CategoryDetailsSuccessState ||
                  cubit.category == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final category = cubit.category!;
              return ListView(
                children: [
                  SizedBox(
                    height: 240,
                    child: CategoryImage(url: category.image),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (category.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            category.description,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFF5A6472),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
