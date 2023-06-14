class OnbordingContent {
  String image;
  String title;
  String discription;

  OnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<OnbordingContent> contents = [
  OnbordingContent(
      image: 'assets/images/onboard2.png',
      title: 'Holiday Request',
      discription: "Take Control of Your Vacation Days"),
  OnbordingContent(
      image: 'assets/images/onboard1.png',
      title: 'Easy to Use',
      discription: "Request Time Off Anytime, Anywhere "),
  OnbordingContent(
      image: 'assets/images/onboard.png',
      title: 'Say Good Bye ',
      discription: "Say Goodbye to Paperwork, Hello to Smart Holiday Requests"),
];
