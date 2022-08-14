import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shop_app/cubit/login_cubit.dart';
import 'package:shop_app/themes/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key, HomeModel? homeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: LoginCubit.get(context).homeModel != null &&
                  LoginCubit.get(context).categoriesModel != null,
              builder: (context) => ProductsBuilder(
                  LoginCubit.get(context).homeModel!,
                  LoginCubit.get(context).categoriesModel!,
                  context),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()));
        });
  }

  Widget ProductsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // علشان نعمل سلايدر بنزل باكدج اسمها carouselSlider
            // بتاخد ايتمز
            CarouselSlider(
              items: model.data!.banners!
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 24,
                      color: DefaultColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoryItem(
                            categoriesModel.data!.data![index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemCount: categoriesModel.data!.data!.length),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "New Products",
                    style: TextStyle(
                      fontSize: 24,
                      color: DefaultColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              // هيطلع ايرور bottom OverFlowed
              // هنحل المشكلة دي لما نعمل Main Acess Spacing
              // كمان هنعمل cross Axis Spacing عشان نفصل بين الصور المعروضة وبعضها
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              // بعدين هنعمل childAspectRatio:1\1.5,
              // ونحط height للصورة
              childAspectRatio: 1 / 1.5,
              children: List.generate(
                model.data!.products!.length,
                (index) =>
                    buildGridProducts(model.data!.products![index], context),
              ),
            ),
          ],
        ),
      );
  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image!),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          Container(
            width: 120,
            color: Colors.black.withOpacity(.8),
            child: Text(
              model.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
  Widget buildGridProducts(Products product, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // لو عاوز اكتب على المنتجات الي عليها خصم discount
                  // بعمل wrap للصورة
                  // بcolumn
                  // بعدين بغير الكولمن بstack
                  // بحط تحت الصورة كونتينر فيه تيكست مكتوب فيه ديسكاونت وادي للتيكست ستايل بخط ولون وادي الكونتينر ستايل بلون
                  // بعدين بحط شرط بقاعدة لو الشرطية ان الخصم لا يساوي صفر علشان تظهر كلمة ديسكاونت على المنتجات الي عليها خصم بس
                  Stack(
                    // علشان كلمة ديسكاونت تتكتب تحت على الشمال بنعمل alingment
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: NetworkImage(product.image!),
                        width: double.infinity,
                        height: 200,
                      ),
                      if (product.discount != 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.red,
                          child: const Text(
                            "Discount",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        )
                    ],
                  ),
                  Text(
                    product.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${product.price!.round()} AR',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DefaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // بنحط شرط قبل النص بتاع السعر قبل الخصم علشان يظهر السعر قبل الخصم على المنتجات الي عليها خصم بس
                      if (product.discount != 0)
                        Text(
                          '${product.oldPrice.round()} AR',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      /*
ازاي اشغل زرار الفيفورت ؟؟
بنروح على الكيوبت زي مابجيب الداتا من الهوم موديل وبقدر استخرج ليسته للبرودكتس 
هنعمل ليسته لعدد البرودكتس هو موجود معاك في الفيفورتس ولا لا ؟
علشان عايز لما ادوس ابدل بين الفيفورت او لا طب ازاي ؟
هنعمله ماب  
عبارة عن
 Map<int, bool >
 هتشيل الاي دي الخاص بالبرودكت وترو او فولس 
بعدين ننزل في dioHelper.postData 
في اقواس ال.then(value){
  هنكتب 
    homeModel!.data!.products!.forEach((element) {
        favorites.addAll({
          element.id!:element.inFavorites!
        });
        كده هو هيلف وهيملى 
}
                      */
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          LoginCubit.get(context).changeFavorites(product.id!);
                          print(product.id);
                        },
                        icon: CircleAvatar(
                            backgroundColor:
                                LoginCubit.get(context).favorites[product.id]!
                                    ? DefaultColor
                                    : Colors.grey,
                            radius: 17,
                            child: const Icon(Icons.favorite_border)),
                        iconSize: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
