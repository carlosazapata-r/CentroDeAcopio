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

  # Valida toda la lista y la separa en {validas, rechazadas}
  def validar_todas(entregas, productores, tanques) do
    resultados = for e <- entregas, do: {e, validar_entrega(e, productores, tanques)}

    validas = for {e, {:ok, _}} <- resultados, do: e
    rechazadas = for {e, {:error, motivo}} <- resultados, do: {e, motivo}

    {validas, rechazadas}
  end

  # Convierte el texto en una entrega o {:error, :formato_invalido}
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

  defp validar_productor(codigo, productores) do
    productores
    |> existe_productor?(codigo)
    |> generar_resultado(:productor_desconocido)
  end

  defp validar_tanque(id, tanques) do
    tanques
    |> existe_tanque?(id)
    |> generar_resultado(:tanque_desconocido)
  end

  defp validar_dia(dia) do
    dia
    |> dia_valido?()
    |> generar_resultado(:dia_invalido)
  end

  defp validar_litros(litros) do
    litros
    |> litros_validos?()
    |> generar_resultado(:litros_fuera_de_rango)
  end

  defp validar_grasa(grasa) do
    grasa
    |> grasa_valida?()
    |> generar_resultado(:porcentaje_invalido)
  end


  defp existe_productor?(productores, codigo),
    do: Enum.any?(productores, fn p -> p.codigo == codigo end)

  defp existe_tanque?(tanques, id),
    do: Enum.any?(tanques, fn t -> t.id == id end)

  # is_integer descarta días como 2.5
  defp dia_valido?(dia)
       when is_integer(dia) and dia >= @dia_minimo and dia <= @dia_maximo,
       do: true

  defp dia_valido?(_), do: false

  # is_number descarta textos como "abc"
  defp litros_validos?(litros)
       when is_number(litros) and litros > 0 and litros <= @litros_maximo,
       do: true

  defp litros_validos?(_), do: false

  defp grasa_valida?(grasa)
       when is_number(grasa) and grasa >= @grasa_minima and grasa <= @grasa_maxima,
       do: true

  defp grasa_valida?(_), do: false


  defp generar_resultado(true, _motivo), do: :ok
  defp generar_resultado(false, motivo), do: {:error, motivo}



  defp convertir_numero(texto) do
    case Integer.parse(texto) do
      {entero, ""} -> {:ok, entero}
      _ -> convertir_decimal(texto)
    end
  end

  defp convertir_decimal(texto) do
    case Float.parse(texto) do
      {decimal, ""} -> {:ok, decimal}
      _ -> :error
    end
  end
end
