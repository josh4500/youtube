abstract class Style<T> {
  T dark();
  T light();
  T portrait();
  T landscape();
  T merge(T style);
}
