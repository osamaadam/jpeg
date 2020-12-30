function num = nextNumberDivisibleByN(x, N)
  num = (x + N) - mod(x, N);
end