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
  # Convierte el texto "productor;tanque;dia;litros;grasa" en una entrega.
  # Si el formato está mal devuelve {:error, :formato_invalido}
  def parsear_entrega(texto) do
    campos =
      texto
      |> String.trim()
      |> String.split(";")
      |> Enum.map(&String.trim/1)

    with [productor, tanque, dia_texto, litros_texto, grasa_texto] <- campos,
         {dia, ""} <- Integer.parse(dia_texto),
         {:ok, litros} <- convertir_numero(litros_texto),
         {:ok, grasa} <- convertir_numero(grasa_texto) do
      {:ok, %{productor: productor, tanque: tanque, dia: dia, litros: litros, grasa: grasa}}
    else
      _ -> {:error, :formato_invalido}
    end
  end
end
