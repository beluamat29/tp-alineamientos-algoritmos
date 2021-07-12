include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")

function agregarStringVacioAMatriz(W, cantidadFilas, cantidadColumnas)
    for m in 0:cantidadFilas -1
        W[m + 1, 1] = -1 * m
    end

    for j in 0:cantidadColumnas -1
        W[1, j + 1] = -1 * j
    end

    return W
end


str1 = "GTT"
profile = inicializarProfile(str1)

str2 = "AAGTT"
m = length(str1)
n = length(str2)

W = fill(typemin(Float64), m, n)
needle_top_down(profile, str2, m, n, W)
W
#agregarStringVacioAMatriz(W, m , n)
reconstruccion = reconstruccion_top_down(profile, str2, W)

segundoProfile = reconstruccion[3]
str3 = "AAGATGGAT"
m = largoProfile(segundoProfile)
n = length(str3)

W = fill(typemin(Float64), m, n)
needle_top_down(segundoProfile, str3, m, n, W)
W
#agregarStringVacioAMatriz(W, m , n)
reconstruccion = reconstruccion_top_down(segundoProfile, str3, W)
