defmodule Exfmt.Integration.MapTest do
  use ExUnit.Case
  import Support.Integration

  test "maps" do
    assert_format "%{}"
    assert_format "%{a: 1}"
    "%{:a => 1}" ~> "%{a: 1}"
    assert_format "%{1 => 1}"
    assert_format "%{1 => 1, 2 => 2}"
  end

  test "map upsert %{map | key: value}" do
    "%{map | key: value}" ~> "%{map | key: value}"
  end

  test "chained map get" do
    assert_format "map.key.another.a_third"
  end

  test "qualified call into map get" do
    assert_format "Map.new.key"
  end

  test "long map" do
    """
    %{alpha_numeric_integer_long_name_with_lots_of_characters: 1}
    """ ~> """
    %{
      alpha_numeric_integer_long_name_with_lots_of_characters: 1
    }
    """
  end

  test "structs" do
    assert_format "%Person{}"
    assert_format "%Person{age: 1}"
    "%Person{timmy | age: 1}" ~> "%Person{timmy | age: 1}"
    """
    %LongerNamePerson{timmy | name: "Timmy", age: 1}
    """ ~> """
    %LongerNamePerson{timmy |
      name: "Timmy",
      age: 1
    }
    """
    assert_format "%Inspect.Opts{}"
  end

  test "__MODULE__ structs" do
    assert_format "%__MODULE__.Person{}"
    assert_format "%__MODULE__{debug: true}"
  end

  test "variable type struct" do
    assert_format "%struct_type{}"
  end

  test "keys with spaces" do
    assert_format """
    %{"Implemented protocols": :ok}
    """
  end

  test "keys with dashes" do
    assert_format """
    %{"name-space": :ok}
    """
  end

  test "macro contents" do
    assert_format """
    %{unquote_splicing(spec)}
    """
  end

  test "update of map from function" do
    assert_format """
    %{zero(0) | rank: 1}
    """
  end

  test "nested map" do
    assert_format """
    %{
      very_long_variable_name_that_causes_break_mode: %{
        "b" => 1
      }
    }
    """
  end
end
