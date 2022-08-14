import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/reusable.dart';
import 'package:shop_app/shop_app/search/search_cubit/search_cubit.dart';
import 'package:shop_app/shop_app/search/search_cubit/search_states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        label: 'Search',
                        onSubmit: (String text) {
                          SearchCubit.get(context).search(text);
                        },
                        prefix: Icons.search,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Search must be Entered";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is SearchLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is SearchSuccessState)
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => buildListProduct(
                                Cubit,
                                SearchCubit.get(context)
                                    .model!
                                    .data!
                                    .data![index],
                                context,
                                isOldPrice: false),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: SearchCubit.get(context)
                                .model!
                                .data!
                                .data!
                                .length,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
