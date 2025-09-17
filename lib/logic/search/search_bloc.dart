import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/logic/search/search_event.dart';
import 'package:zybo_test/logic/search/search_state.dart';
import 'package:zybo_test/data/models/product_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
	SearchBloc() : super(SearchInitial()) {
		on<SearchProducts>(_onSearchProducts);
	}

	Future<void> _onSearchProducts(SearchProducts event, Emitter<SearchState> emit) async {
		emit(SearchLoading());
		try {
			final response = await http.get(
				Uri.parse('http://skilltestflutter.zybotechlab.com/api/search?query=${event.query}'),
				headers: {
					'Content-Type': 'application/json',
					'Accept': 'application/json',
				},
			);
			if (response.statusCode == 200) {
				final List data = json.decode(response.body);
				final products = data.map((e) => Product.fromJson(e)).toList();
				emit(SearchLoaded(products));
			} else {
				emit(SearchError('Search failed: ${response.statusCode}\n${response.body}'));
			}
		} catch (e) {
			emit(SearchError('Error: $e'));
		}
	}
}
