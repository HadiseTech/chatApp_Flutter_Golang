class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.isOnline,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Cold Face',
  imageUrl: 'assets/images/cold_face.jpg',
  isOnline: true,
);

// USERS
final User black_panter = User(
  id: 1,
  name: 'Balck Panter',
  imageUrl: 'assets/images/black_panter.jpg',
  isOnline: true,
);
final User black_widow = User(
  id: 2,
  name: 'Black Widow',
  imageUrl: 'assets/images/black_widow.jpg',
  isOnline: true,
);
final User captain_america = User(
  id: 3,
  name: 'Captain America',
  imageUrl: 'assets/images/captain.jpg',
  isOnline: false,
);
final User hulk = User(
  id: 4,
  name: 'Hulk',
  imageUrl: 'assets/images/hulk.jpg',
  isOnline: false,
);
final User scarlet_witch = User(
  id: 5,
  name: 'Scarlet Witch',
  imageUrl: 'assets/images/scarletwitch.jpg',
  isOnline: true,
);
final User spider_man = User(
  id: 6,
  name: 'Spider Man',
  imageUrl: 'assets/images/spiderman.png',
  isOnline: false,
);
final User thor = User(
  id: 6,
  name: 'Thor',
  imageUrl: 'assets/images/thor.jpg',
  isOnline: false,
);

var user_images = {
  0: 'assets/images/thor.jpg',
  1: 'assets/images/spiderman.png',
  2: 'assets/images/scarletwitch.jpg',
  3: 'assets/images/hulk.jpg',
  4: 'assets/images/captain.jpg',
  5: 'assets/images/black_widow.jpg',
  6: 'assets/images/black_panter.jpg'
};
