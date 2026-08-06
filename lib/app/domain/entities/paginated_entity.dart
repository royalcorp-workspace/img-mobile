class PaginatedEntity<T> {
  final List<T> data;
  final int totalCount;
  final bool hasMore;
  final int page;
  final int itemsPerPage;

  PaginatedEntity({
    required this.data,
    required this.totalCount,
    required this.hasMore,
    required this.page,
    required this.itemsPerPage,
  });
}
