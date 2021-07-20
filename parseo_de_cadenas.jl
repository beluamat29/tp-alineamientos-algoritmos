function parsearListaDeCadenas(nombreArchivo)
    cadenas = []
    open(nombreArchivo) do f

      line = 0

      while ! eof(f)

         s = readline(f)
         line += 1
         cadenas = push!(cadenas, Cadena(s))
      end

    end

    return cadenas
end

parsearListaDeCadenas("archivo_de_cadenas.txt")
