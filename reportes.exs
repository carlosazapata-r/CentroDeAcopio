# Reportes

defmodule Reportes do
  @meta_diaria 2000
  @dias 6
  @motivos [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_invalido,
    :litros_fuera_de_rango,
    :porcentaje_invalido
  ]

  # R1: entregas rechazadas

  # rechazadas es una lista de {entrega, motivo}.
  # Devuelve [{motivo, cantidad}] con los 5 motivos, aunque alguno tenga 0
  def contar_rechazos(rechazadas) do
    frecuencias =
      rechazadas
      |> Enum.map(fn {_entrega, motivo} -> motivo end)
      |> Enum.frequencies()

    for motivo <- @motivos, do: {motivo, Map.get(frecuencias, motivo, 0)}
  end
  def imprimir_r1(rechazadas, conteos) do
    IO.puts("\n R1 Entregas rechazadas :  ")

    # mirar porque dia, litros y grasa pueden venir como texto
    Enum.each(rechazadas, fn {e, motivo} ->
      IO.puts(
        "#{e.productor} | #{e.tanque} | dia #{inspect(e.dia)} | " <>
          "litros #{inspect(e.litros)} | grasa #{inspect(e.grasa)} -> #{motivo}"
      )
    end)

    IO.puts("\nRechazos por motivo:")
    Enum.each(conteos, fn {motivo, cantidad} -> IO.puts("  #{motivo}: #{cantidad}") end)
    :ok
  end
end
