String pad(String input, int amount, {bool left = true}) {
  int diff = amount - input.length;
  if (diff <= 0) {
    return input;
  }
  return left ? " " * diff + input : input + " " * diff;
}
