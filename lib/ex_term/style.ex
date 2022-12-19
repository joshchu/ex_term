defmodule ExTerm.Style do
  @moduledoc false
  defstruct [
    :height,
    :width,
    :color,
    :bgcolor,
    :blink,
    :frame,
    :intensity,
    conceal: false,
    italic: false,
    underline: false,
    crossed_out: false,
    overlined: false
  ]

  colors = ~w(black red green yellow blue magenta cyan white)a
  light_colors = Enum.map(colors, &:"light-#{&1}")

  quoted_color_type =
    Enum.reduce(
      colors ++ light_colors,
      &quote do
        unquote(&1) | unquote(&2)
      end
    )

  @type color :: unquote(quoted_color_type)
  @type t :: %__MODULE__{
          height: nil | String.t(),
          width: nil | String.t(),
          color: nil | color | String.t(),
          bgcolor: nil | color | String.t(),
          blink: nil | :rapid | :slow,
          intensity: nil | :bright | :faint,
          frame: :framed | :encircled,
          conceal: boolean,
          italic: boolean,
          underline: boolean,
          crossed_out: boolean,
          overlined: boolean
        }

  def new, do: %__MODULE__{}

  @keys ~w(height width color bgcolor blink intensity frame conceal italic underline crossed_out overlined)a
  def to_iodata(style) do
    Enum.flat_map(@keys, &kv_to_css(&1, Map.get(style, &1)))
  end

  defp kv_to_css(key, value) do
    List.wrap(if value, do: [key, ":", value, "; "])
  end
end

defimpl Phoenix.HTML.Safe, for: ExTerm.Style do
  defdelegate to_iodata(css), to: ExTerm.Style
end