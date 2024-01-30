class LocalServiceModel {
  String title,
      category,
      description,
      phone,
      imgUrl,
      cityName,
      latitude,
      longitude;
  List<String> searchList;

  LocalServiceModel(
      {required this.title,
      required this.category,
      required this.description,
      required this.phone,
      required this.cityName,
      required this.imgUrl,
      required this.latitude,
      required this.searchList,
      required this.longitude});
}
