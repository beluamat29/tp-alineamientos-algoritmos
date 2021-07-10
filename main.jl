include("profile.jl")
include("needleman.jl")

function agregarStringVacioAMatriz(W, cantidadFilas, cantidadColumnas)
    println(cantidadFilas)
    println(cantidadColumnas)
    for m in 0:cantidadFilas - 1
        W[m + 1, 1] = -1 * m
    end

    for j in 0:cantidadColumnas - 1
        W[1, j + 1] = -1 * j
    end

    return W
end


str1 = "ACGT"
profile = inicializarProfile(str1)

str2 = "GGAAGT"
m = length(str1)
n = length(str2)

W = fill(typemin(Int64), m , n )
needle_top_down(profile, str2, m, n, W)
W

#reconstruccion_top_down(str1, str2, W)
