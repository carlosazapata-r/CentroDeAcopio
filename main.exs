# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

Code.require_file("datos.exs", __DIR__)
Code.require_file("validacion.exs", __DIR__)
Code.require_file("util.exs", __DIR__)
Code.require_file("liquidacion.exs", __DIR__)
Code.require_file("reportes.exs", __DIR__)

defmodule Principal do
  @moduledoc "Coordina el proceso de liquidación del centro de acopio."

  @doc """
  Carga los datos, mide la validación inicial y la liquidación,
  procesa una entrega adicional, imprime los reportes
  y solicita el comprobante de un productor.
  """
  def ejecutar do
    productores = Datos.productores()
    tanques = Datos.tanques()
    entregas = Datos.entregas()

    # Mide el tiempo de validación de las entregas iniciales.
    {tiempo_validacion, {validas, rechazadas}} =
      :timer.tc(fn ->
        Validacion.validar_todas(entregas, productores, tanques)
      end)

    {validas, rechazadas} =
      solicitar_entrega_adicional(validas, rechazadas, productores, tanques)

    # Mide la liquidación con las entregas válidas, incluida la adicional si fue aceptada.
    {tiempo_liquidacion, liquidacion} =
      :timer.tc(fn ->
        Liquidacion.calcular(productores, validas)
      end)

    imprimir_reportes(validas, rechazadas, productores, tanques, liquidacion)

    Util.mostrar("\nMediciones propias")
    Util.mostrar("Validación inicial: #{tiempo_validacion} microsegundos")
    Util.mostrar("Liquidación semanal: #{tiempo_liquidacion} microsegundos")

    solicitar_comprobante(productores, validas)
  end

  defp solicitar_entrega_adicional(validas, rechazadas, productores, tanques) do
    Util.mostrar("\nIngrese una entrega adicional")
    Util.mostrar("(productor;tanque;dia;litros;grasa)")

    case Util.leer("o Enter para omitir: ") do
      "" ->
        {validas, rechazadas}

      texto ->
        procesar_entrega_adicional(
          texto,
          validas,
          rechazadas,
          productores,
          tanques
        )
    end
  end

  defp procesar_entrega_adicional(texto, validas, rechazadas, productores, tanques) do
    case Validacion.parsear_entrega(texto) do
      {:ok, entrega} ->
        case Validacion.validar_entrega(entrega, productores, tanques) do
          {:ok, entrega_valida} ->
            Util.mostrar("La entrega adicional fue aceptada.")
            {validas ++ [entrega_valida], rechazadas}

          {:error, motivo} ->
            Util.mostrar("La entrega adicional fue rechazada: #{motivo}")
            {validas, rechazadas ++ [{entrega, motivo}]}
        end

      {:error, :formato_invalido} ->
        Util.mostrar("El formato de la entrega no es válido.")
        {validas, rechazadas}
    end
  end

  defp imprimir_reportes(validas, rechazadas, productores, tanques, liquidacion) do
    conteos_rechazos = Reportes.contar_rechazos(rechazadas)
    Reportes.imprimir_r1(rechazadas, conteos_rechazos)

    ocupacion = Reportes.ocupacion_tanques(validas, tanques)
    Reportes.imprimir_r2(ocupacion)

    litros_por_dia = Reportes.litros_por_dia(validas)
    Reportes.imprimir_r3(litros_por_dia)

    liquidacion_ordenada = Reportes.ordenar_liquidacion(liquidacion)
    Reportes.imprimir_r4(liquidacion_ordenada)

    lideres_por_dia = Reportes.lideres_por_dia(validas)
    Reportes.imprimir_r5(lideres_por_dia, productores)

    mejores = Reportes.mejor_calidad(validas, productores)
    Reportes.imprimir_r6(mejores)

    resumen = Reportes.resumen_r7(liquidacion)
    Reportes.imprimir_r7(resumen)

    productores_en_todos =
      Reportes.productores_en_todos_los_tanques(validas, productores, tanques)

    Reportes.imprimir_r8(productores_en_todos)
  end

  defp solicitar_comprobante(productores, validas) do
    codigo = Util.leer("\nIngrese el código del productor para el comprobante: ")

    codigo
    |> Liquidacion.generar_comprobante(productores, validas)
    |> Liquidacion.imprimir_comprobante()
  end
end

Principal.ejecutar()
