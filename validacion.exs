# Validación de entregas

defmodule Validacion do
  @dia_minimo 1
  @dia_maximo 6
  @litros_maximo 800
  @grasa_minima 0
  @grasa_maxima 15

  # Valida una entrega en el orden del enunciado.
  # Devuelve {:ok, entrega} o {:error, motivo} con el primer motivo que falle.
  def validar_entrega(entrega, productores, tanques) do
    with :ok <- validar_productor(entrega.productor, productores),
         :ok <- validar_tanque(entrega.tanque, tanques),
         :ok <- validar_dia(entrega.dia),
         :ok <- validar_litros(entrega.litros),
         :ok <- validar_grasa(entrega.grasa) do
      {:ok, entrega}
    end
  end
  # Valida toda la lista y la separa en {validas, rechazadas}.
  # rechazadas es una lista de {entrega, motivo}
  def validar_todas(entregas, productores, tanques) do
    resultados = for e <- entregas, do: {e, validar_entrega(e, productores, tanques)}

    validas = for {e, {:ok, _}} <- resultados, do: e
    rechazadas = for {e, {:error, motivo}} <- resultados, do: {e, motivo}

    {validas, rechazadas}
  end

end
