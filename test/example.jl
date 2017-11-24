# example for README

using DiffWrappers
using DiffResults
f(x) = sum(x .* linspace(0, 1, length(x)));
g = ForwardGradientWrapper(f, 4); # will use length 4 vectors
length(g)
x = ones(4);
gx = g(x);
DiffResults.value(gx)
DiffResults.gradient(gx)
