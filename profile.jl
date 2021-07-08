struct Profile
    profilePorcentajes #lista de listas
    profileCadenas #lista de listas
end

function inicializarProfile(cadena) #inicializa un nuevo profile con todos los porcentajes en 100%
    #DEVUELVE UNA SOLA COLUMNA. UNA SOLAAAAAA UNAAAAA
    profilePorcentajes = []
    profileCadenas = []
    for (columnaIndex, columa) in enumerate(cadena)
        profilePorcentajes = push!(profilePorcentajes, [1])
        profileCadenas = push!(profileCadenas, [string(cadena[columnaIndex])])
    end

    return Profile(profilePorcentajes, profileCadenas)
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
            stringCadena = join(cadenaColumna) #uno la columna del perfil ej "ACG"
            indiceCaracterExistente = findfirst(nuevoCaracterAAgregar, stringCadena) #encuentro el indice del caracter
            nuevosPorcentajesColumna[indiceCaracterExistente[1]] = nuevosPorcentajesColumna[indiceCaracterExistente[1]] + 0.5 #actualizo el porcentaje en ese indice
            nuevaCadenaColumna = cadenaColumna
        else
            nuevosPorcentajesColumna = push!(nuevosPorcentajesColumna, 0.5) #agrego el nuevo porcentaje
            nuevaCadenaColumna = push!(cadenaColumna, nuevoCaracterAAgregar) #agrego la letra
        end

        #termine CON LA COLUMNA
        nuevoProfilePorcentajes = push!(nuevoProfilePorcentajes, nuevosPorcentajesColumna) #agrego los nuevos porcentajes actualizados al profile nuevo
        nuevaProfileCadena = push!(nuevaProfileCadena, nuevaCadenaColumna) #agrego la letra de la iteracion a la columna

    end

    return Profile(nuevoProfilePorcentajes, nuevaProfileCadena)
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

profile = Profile([[0.75, 0.25],[0.5, 0.5]],
                  [["A", "C"], ["B", "-"]])

res = actualizarProfile(profile, "GE")

res2 = actualizarProfile(res, "ZW")

largoProfile(res2)
