import 'package:category_api/features/categories/cubit/category_cubit.dart';
import 'package:category_api/features/categories/model/category_model.dart';
import 'package:category_api/features/categories/view/category_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..fetchCategories(),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final cubit = context.read<CategoryCubit>();
          final isArabic = cubit.lang == "ar";

          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F7F9),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  isArabic ? "الأقسام" : "Categories",
                  style: const TextStyle(
                    color: Color(0xFF1B2430),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: cubit.changeLanguage,
                    child: Text(
                      isArabic ? "English" : "العربية",
                      style: const TextStyle(color: Color(0xFF2E6BE6)),
                    ),
                  ),
                ],
              ),
              body: _buildBody(context, state, cubit, isArabic),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CategoryState state,
    CategoryCubit cubit,
    bool isArabic,
  ) {
    if (state is CategoryLoadingState || state is CategoryInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CategoryErrorState) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic
                  ? "تعذر تحميل الأقسام. تأكد من الاتصال."
                  : "Couldn't load categories. Check your connection.",
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: cubit.fetchCategories,
              child: Text(isArabic ? "إعادة المحاولة" : "Try again"),
            ),
          ],
        ),
      );
    }

    if (cubit.categories.isEmpty) {
      return Center(
        child: Text(isArabic ? "لا توجد أقسام بعد" : "No categories yet"),
      );
    }

    return RefreshIndicator(
      onRefresh: cubit.fetchCategories,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cubit.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final category = cubit.categories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CategoryDetailsPage(id: category.id, lang: cubit.lang),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E9EE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CategoryImage(url: category.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B2430),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryImage extends StatelessWidget {
  final String url;
  const CategoryImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: const Color(0xFFEEF2F8),
      child: const Icon(
        Icons.category_outlined,
        size: 40,
        color: Color(0xFF9AA5B4),
      ),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
