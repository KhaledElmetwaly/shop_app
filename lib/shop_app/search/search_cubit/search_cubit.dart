import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/reusable.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/network/end_point.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shop_app/search/search_cubit/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel? model;
  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.PostData(
      url: SEARCH,
      token: token,
      data: {'text': text},
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
