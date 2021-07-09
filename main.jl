include("profile.jl")
include("needleman.jl")

str1 = "AGTA"
profile = inicializarProfile(str1)

str2 = "AGTA"
m = length(str1)
n = length(str2)

W = fill(typemin(Int64), m, n)

s = needle_top_down(profile, str2, m, n, W)
println(W)
#reconstruccion_top_down(str1, str2, W)
