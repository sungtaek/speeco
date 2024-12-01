
enum Owner {
  USER,
  COACH,
}

class Message {
  Owner owner;
  String text;
  Message(this.owner, this.text);
}