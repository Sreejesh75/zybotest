import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
	const SearchEvent();
	@override
	List<Object?> get props => [];
}

class SearchProducts extends SearchEvent {
	final String query;
	const SearchProducts(this.query);

	@override
	List<Object?> get props => [query];
}
