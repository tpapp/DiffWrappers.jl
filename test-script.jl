# test script to be run on Travis
Pkg.clone(pwd())
Pkg.add("DiffResults")
Pkg.checkout("DiffResults")     # latest master for precompilation
Pkg.build("DiffWrappers")
Pkg.test("DiffWrappers"; coverage=true)
