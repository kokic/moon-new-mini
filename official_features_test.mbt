///|
/// Also see: https://github.com/moonbitlang/x/issues/229
test "Path::normalize posix style on Windows" {
  assert_eq(
    ["C:/usr/local/../bin", "C:\\usr\\local\\..\\bin"].map(x => {
      @path.Path::normalize(@path.Path(x))
    }),
    ["C:\\usr\\bin", "C:\\usr\\bin"],
  )
}
