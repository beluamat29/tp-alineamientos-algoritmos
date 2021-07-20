include("matrices_de_costo.jl")
include("algoritmo_greedy_random.jl")
include("cadena.jl")
include("busquedaLocal.jl")
include("parseo_de_cadenas.jl")

function grasp(nombreArchivoCadenas, cantidadIteracionesMaximas, cantMejorasBusquedaLocal)
    matriz = matrizDeAminoacidos()
    iteracion = 0

    println("///////////ARRANCO A CORRER GRASP///////////")

    mejoresResultadosBusquedasLocales = []
    while (iteracion < cantidadIteracionesMaximas)
        println("///////////ARRANCO ITERACION NUMERO: ", iteracion, " ///////////")

        corridaRandom = algoritmoGreedyRandom(nombreArchivoCadenas, matriz, 1.5)
        resultadoBusquedaLocal = busquedaLocal(corridaRandom, cantMejorasBusquedaLocal, matriz)
        println("Mejor resultado busqueda local: ", resultadoBusquedaLocal.score)

        mejoresResultadosBusquedasLocales = push!(mejoresResultadosBusquedasLocales, resultadoBusquedaLocal)
        iteracion += 1
    end

    maximoResultado = getMaximoResultado(mejoresResultadosBusquedasLocales)
    println("/////////// MEJOR RESULTADO GRASP: ", maximoResultado.score, " ///////////")

    return maximoResultado
end

function getMaximoResultado(mejoresResultadosBusquedasLocales)
    mejorScore = typemin(Float64)
    mejorResultado =  nothing

    for resultado in mejoresResultadosBusquedasLocales
        if(resultado.score > mejorScore)
            mejorResultado = resultado
            mejorScore = resultado.score
        end
    end

    return mejorResultado
end

result = grasp("archivo_de_cadenas.txt",
10,
10
)
