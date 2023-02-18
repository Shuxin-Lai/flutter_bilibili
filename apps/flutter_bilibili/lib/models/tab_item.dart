class TabItem {
  final int id;
  final String title;
  final bool isDefault;
  final bool refreshable;

  TabItem({
    required this.id,
    required this.title,
    this.isDefault = false,
    this.refreshable = false,
  });
}
