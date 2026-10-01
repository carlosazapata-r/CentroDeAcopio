# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

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
  # Convierte el texto en una entrega.
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
  # Reglas a evaluar
  # Validar que el productor exista en la lista de productores
    defp validar_productor(codigo, productores) do
    if Enum.any?(productores, fn p -> p.codigo == codigo end) do
      :ok
    else
      {:error, :productor_desconocido}
    end
  end

  defp validar_tanque(id, tanques) do
    if Enum.any?(tanques, fn t -> t.id == id end) do
      :ok
    else
      {:error, :tanque_desconocido}
    end
  end

  # is_integer descarta días como 2.5
  defp validar_dia(dia) when is_integer(dia) and dia >= @dia_minimo and dia <= @dia_maximo,
    do: :ok
  #is_number descarta valores que no sean numeros enteros o decimales
  defp validar_dia(_), do: {:error, :dia_invalido}

  # Validar que los litros estén en el rango permitido
  defp validar_litros(litros) when is_number(litros) and litros > 0 and litros <= @litros_maximo,
    do: :ok

  defp validar_litros(_), do: {:error, :litros_fuera_de_rango}

  defp validar_grasa(grasa)
       when is_number(grasa) and grasa >= @grasa_minima and grasa <= @grasa_maxima,
       do: :ok

  defp validar_grasa(_), do: {:error, :porcentaje_invalido}

  # solo es para enteros y decimales, si sobra texto es error
  defp convertir_numero(texto) do
    case Integer.parse(texto) do
      {entero, ""} ->
        {:ok, entero}

      _ ->
        case Float.parse(texto) do
          {decimal, ""} -> {:ok, decimal}
          _ -> :error
        end
    end
  end
end
