struct Profile
    profilePorcentajes #lista de listas
    profileCadenas #lista de listas
    profileListaDeCadenas
end

function inicializarProfile(cadena) #inicializa un nuevo profile con todos los porcentajes en 100%
    #DEVUELVE UNA SOLA COLUMNA. UNA SOLAAAAAA UNAAAAA
    profilePorcentajes = []
    profileCadenas = []
    for (columnaIndex, columa) in enumerate(cadena)
        profilePorcentajes = push!(profilePorcentajes, [1])
        profileCadenas = push!(profileCadenas, [string(cadena[columnaIndex])])
    end

    return Profile(profilePorcentajes, profileCadenas, [cadena])
end

function actualizarProfile(profile, cadena) #devuelve un nuevo profile con los porcentajes actualizados
    nuevoProfilePorcentajes = []
    nuevaProfileCadena = []

    for (columnaIndex, columa) in enumerate(cadena)
        porcentajesColumna = profile.profilePorcentajes[columnaIndex] # [0.25, 0.5, 0.25] profiles de la columna
        cadenaColumna = profile.profileCadenas[columnaIndex] #[g, t, _] cadena de la columna

        nuevoCaracterAAgregar = string(cadena[columnaIndex]) #letrita a agregar
        nuevosPorcentajesColumna = []

        for porcentaje in porcentajesColumna #recorro todos los items de la columna
            nuevosPorcentajesColumna = push!(nuevosPorcentajesColumna, porcentaje/2) #divido los porcentajes en 2
        end

        if(nuevoCaracterAAgregar in cadenaColumna)
            ###ACTUALIZACION DEL PORCENTAJE
            stringCadena = join(cadenaColumna) #uno la columna del perfil ej "ACG"
            indiceCaracterExistente = findfirst(nuevoCaracterAAgregar, stringCadena) #encuentro el indice del caracter
            nuevosPorcentajesColumna[indiceCaracterExistente[1]] = nuevosPorcentajesColumna[indiceCaracterExistente[1]] + 0.5 #actualizo el porcentaje en ese indice
            nuevaCadenaColumna = cadenaColumna
            ###ACTUALIZACION DE COLUMNA DE LETRAS
        else
            nuevosPorcentajesColumna = push!(nuevosPorcentajesColumna, 0.5) #agrego el nuevo porcentaje
            nuevaCadenaColumna = push!(cadenaColumna, nuevoCaracterAAgregar) #agrego la letra
        end

        #termine CON LA COLUMNA
        nuevoProfilePorcentajes = push!(nuevoProfilePorcentajes, nuevosPorcentajesColumna) #agrego los nuevos porcentajes actualizados al profile nuevo
        nuevaProfileCadena = push!(nuevaProfileCadena, nuevaCadenaColumna) #agrego la letra de la iteracion a la columna

    end

    return Profile(nuevoProfilePorcentajes, nuevaProfileCadena, push!(profile.profileListaDeCadenas, cadena))
end

function agregarCadenaAListaDeCadenas(profile, cadena)
    return Profile(profile.profilePorcentajes, profile.profileCadenas, push!(profile.profileListaDeCadenas, cadena))
end

function largoProfile(profile) #devuelve el largo del profile (cantidad de columnas)
    return size(profile.profilePorcentajes)[1]
end

function obtenerPorcentajesColumna(profile, numeroDeColumna)
    return profile.profilePorcentajes[numeroDeColumna]
end

function obtenerCadenaColumna(profile, numeroDeColumna)
    return profile.profileCadenas[numeroDeColumna]
end

function agregarColumnaDeGaps(profile, numeroColumna)
    nuevosPorcentajes = vcat(profile.profilePorcentajes[1: numeroColumna - 1], [[1]], profile.profilePorcentajes[numeroColumna : end])
    nuevasCadenas = vcat(profile.profileCadenas[1: numeroColumna - 1], [["-"]], profile.profileCadenas[numeroColumna : end])

    #####Debo insertar strings en las cadenas que ya tenia guardada
    #####para que el alineamiento que guardo sea consistente
    nuevosStrings = []
    for string in profile.profileListaDeCadenas
        nuevoString = string[1:numeroColumna - 1] * "-" * string[numeroColumna:end]
        nuevosStrings = push!(nuevosStrings, nuevoString)
    end
    return Profile(nuevosPorcentajes, nuevasCadenas, nuevosStrings)
end

function agregarGapsSoloEnStrings(profile, numeroColumna)
    nuevosStrings = []
    for string in profile.profileListaDeCadenas
        nuevoString = string[1:numeroColumna - 1] * "-" * string[numeroColumna:end]
        nuevosStrings = push!(nuevosStrings, nuevoString)
    end
    return Profile(profile.profilePorcentajes, profile.profileCadenas, nuevosStrings)
end

function cantidadDeFilas(profile)
    return length(profile.profileListaDeCadenas)
end

function imprimirProfile(profile)
    altoProfile =  cantidadDeFilas(profile)
    for numeroFila in 1:altoProfile
        for columna in 1:largoProfile(profile)
            if(numeroFila < length(profile.profileCadenas[columna]))
                print("|",profile.profileCadenas[columna][numeroFila], "|")
            else
                print("|", profile.profileCadenas[columna][end], "|")
            end
        end
        print("\n")
    end
end
