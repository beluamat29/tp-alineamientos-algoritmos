include("matrices_de_costo.jl")
include("algoritmo_greedy_random.jl")
include("busquedaLocal.jl")
include("grasp_version2.jl")

function grasp(nombreArchivoCadenas, nombreArchivoResultado, limiteIteracionesSinMejora, cantidadIteracionesMaximas, cantMejorasBusquedaLocal)
    matriz = matrizDeAminoacidos()
    iteracionesSinMejora = 0
    iteracion = 0

    println("///////////ARRANCO A CORRER GRASP///////////")

    mejorScore = 0
    mejorResultado = nothing

    while (iteracionesSinMejora < limiteIteracionesSinMejora && iteracion < cantidadIteracionesMaximas)
        println("///////////ARRANCO ITERACION NUMERO: ", iteracion, " ///////////")

        corridaRandom = algoritmoGreedyRandom(nombreArchivoCadenas, matriz, 1.5)
        resultadoBusquedaLocal = busquedaLocal(corridaRandom, cantMejorasBusquedaLocal, matriz)

        if(resultadoBusquedaLocal.score > mejorScore)
            #Hubo una mejora
            println("hubo una mejora, el nuevo score es: ", resultadoBusquedaLocal.score)
            mejorScore = resultadoBusquedaLocal.score
            mejorResultado = resultadoBusquedaLocal
            iteracionesSinMejora = 0

        else
            println("NO hubo mejora")
            #Queda una iteracion menos
            iteracionesSinMejora += 1
        end

        iteracion += 1
        println(mejorScore)
    end

    guardarResultadoEnArchivo(mejorResultado, nombreArchivoResultado)
    return mejorResultado
end

grasp("archivo_de_cadenas.txt",
"achivo_resultado.txt",
10,
20,
10
)
