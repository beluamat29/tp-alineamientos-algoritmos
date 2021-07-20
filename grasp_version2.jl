include("matrices_de_costo.jl")
include("algoritmo_greedy_random.jl")
include("cadena.jl")
include("busquedaLocal.jl")
include("parseo_de_cadenas.jl")

using DelimitedFiles

function grasp(nombreArchivoCadenas, nombreArchivoResultado, cantidadIteracionesMaximas, cantMejorasBusquedaLocal)
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

    guardarResultadoEnArchivo(maximoResultado, nombreArchivoResultado)
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

function guardarResultadoEnArchivo(resultado, nombreArchivoDestino)
    file = open(nombreArchivoDestino, "a")

    write(file, "\n")
    write(file, "-----------------------------------------------------------------")
    write(file, "\n")
    write(file, "Ultimo alineamiento que hiciste:")
    write(file, "\n")
    for cadena in resultado.profile.profileListaDeCadenas
        write(file, cadena)
        write(file, "\n")
    end

    write(file, "\n")
    write(file, "Mejor score:")
    write(file, "\n")
    write(file, string(resultado.score))
    write(file, "\n")
    write(file, "-----------------------------------------------------------------")
    close(file)
end

result = grasp("archivo_de_cadenas.txt",
"achivo_resultado.txt",
1,
2
)
