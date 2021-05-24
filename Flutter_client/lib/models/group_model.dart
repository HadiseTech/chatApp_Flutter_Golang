class Group {
  final int id;
  final String name;
  final String imageUrl;
  final int member;

  Group({
    this.id,
    this.name,
    this.imageUrl,
    this.member,
  });
}



List<Group> groups = [
  Group(
      id: 0,
      name: "Group One",
      imageUrl: 'assets/images/ironman.jpg',
      member: 5),
  Group(
      id: 1,
      name: "Group Two",
      imageUrl: "/assets/images.ironman.jpg",
      member: 5)
];
