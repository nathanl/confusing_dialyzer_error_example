defmodule Foo do
  @moduledoc """
  Documentation for `Foo`.
  """

  @type a_greeting :: %{greeting: String.t()}

  @spec foo(term()) :: String.t()
  def foo(val) do
    case get_greeting(val) do
      # The dialyzer error says:
      #
      # lib/foo.ex:27:pattern_match
      # The pattern can never match the type.
      #
      # Pattern:
      # %{:greeting => _greeting}
      #
      # Type:
      # nil
      #
      # Dialyzer seems to be saying that `get_greeting/1` will always return
      # `nil`, but that's not true. The other type of value that it can return
      # is not mentioned in this error message.
      # The spec for `get_greeting/1` says it can return `a_greeting()`, which
      # would match here. But its spec is wrong, which is the real problem.
      %{greeting: greeting} ->
        greeting
      nil ->
        "FOOOOOOO"
    end
  end

  # This spec is wrong because the non-nil return value doesn't actually match
  # the `a_greeting()` type, since it isn't a map.
  # But dialyzer doesn't identify this spec as the problem.
  @spec get_greeting(term()) :: a_greeting() | nil
  def get_greeting(val) do
    case val do
      :a ->
        # Whoops, this isn't a map, it's a list of tuples (a "keyword list")
        Enum.map(["hi"], fn word -> {:greeting, word} end)
      _ ->
        nil
    end
  end

end
