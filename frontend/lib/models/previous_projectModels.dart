// TODO Implement this library.

class PreviousProjectData{
  final String title;
  final String subtitle;
  final String description;
  final String image;

  PreviousProjectData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
  });

  // Method to create a Project object from JSON

  // factory PreviousProjectData.fromJson(Map<String, dynamic> json) {
  //   return PreviousProjectData(
  //     title: json['title'],
  //     subtitle: json['subtitle'],
  //     description: json['description'],
  //     image: json['image'],
  //   );
  // }
}

//dummy data for development
final dummyPreviousProjectData = [
    PreviousProjectData(
      title: "UI/UX 42",
      subtitle: "Budgeting application",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      image: "assets/images/game.png",
    ),
    PreviousProjectData(
      title: "Dev Track",
      subtitle: "Project management tool",
      description: "A tool to track developer progress in real-time.",
      image: "assets/images/dtlogo.png",
    ),
    PreviousProjectData(
      title: "E-commerce App",
      subtitle: "Shopping made easy",
      description: "An intuitive mobile shopping experience.",
      image: "assets/images/elmoo.jpg",
    ),
  ];