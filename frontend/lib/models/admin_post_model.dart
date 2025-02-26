class Post {
  final String name;
  final String dateTime;
  final String description;

  Post({
    required this.name,
    required this.dateTime,
    required this.description,
  });

  static List<Post> samplePosts = [
    Post(
      name: "Event Announcement",
      dateTime: "3 Days ago • 12/Feb 10:30 AM",
      description:
          "Lorem ipsum dolor sit amet et delectus accommodare his consul copiosae legendos at vix ad putent delectus delicata usu.",
    ),
    Post(
      name: "DevArena Deets",
      dateTime: "5 Hours ago • 14/Feb 03:15 PM",
      description:
          "Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes.",
    ),
    Post(
      name: "Project Cycle Deets",
      dateTime: "1 Week ago • 07/Feb 06:45 PM",
      description:
          "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
    ),
  ];
}
