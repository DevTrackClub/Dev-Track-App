// final List<Map<String, String>> projects = List.generate(
//   6,
//       (index) => {
//     "name": "Project name",
//     "team": "Team A",
//     "description": "Lorem ipsum dolor sit amet.",
//   },
// );
class Domain {
  final int id;
  final String name;

  Domain({required this.id, required this.name});

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
