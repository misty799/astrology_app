abstract class AstrologerEvent {}

class FetchAstrologer extends AstrologerEvent {}

class FetchSortedAstrologer extends AstrologerEvent {
  final int index;
  FetchSortedAstrologer({required this.index});
}
