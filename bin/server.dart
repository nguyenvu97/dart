import 'dart:ffi';

void main(List<String> args) async {
  print("object ,shadhhwandas");

  List<int> number = [];
  int a = 1;
  int b = 2;

  number.add(a);
  number.add(b);

  while (b < 100) {
    int next = a + b;
    number.add(next);
    a = b;
    b = next;
  }
  print(number);
}
