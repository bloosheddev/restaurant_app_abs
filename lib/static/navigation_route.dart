enum NavigationRoute {
  mainRoute("/main"),
  favoriteRoute("/favorite");

  const NavigationRoute(this.name);
  final String name;
}
