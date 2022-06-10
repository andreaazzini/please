defmodule Mix.Tasks.Please do
  @moduledoc """
  Implements Elixir code from looking at test files
  """

  use Mix.Task

  @impl Mix.Task
  def run([test_file]) do
    {:ok, _} = Application.ensure_all_started(:telemetry)
    Supervisor.start_link([{Finch, name: Please.Finch}], strategy: :one_for_one)

    read_and_infer(test_file)
  end

  def read_and_infer(file_path) do
    case File.read(file_path) do
      {:ok, file_data} ->
        # 1. Turn our test file into a raw text prompt
        [_, test_module_name] = Regex.run(~r"defmodule\s(.*)\sdo", file_data)
        file_name = String.replace(test_module_name, "Test", "")
        module_name = "Please." <> file_name

        prompt = default_prompt(file_data, module_name)
        # prompt = rps_prompt(file_data, module_name)
        # prompt = palindrome_prompt(file_data, module_name)
        # prompt = fizzbuzz_prompt(file_data, module_name)
        # prompt = enm_prompt(file_data, module_name)

        # 2. Send completion request
        output =
          prompt
          |> infer()
          |> handle_response()

        # 3. Print the proposed implementation to the console
        output_content = "defmodule #{module_name} do\n" <> output
        IO.puts("\n💡 This was the proposed implementation:")
        IO.puts(output_content)

        # 4. Write the implementation and save the module file in lib/
        output_file_path = "lib/" <> String.downcase(file_name) <> ".ex"
        File.write(output_file_path, output_content)

        # 5. Re-compile
        Code.compile_file(output_file_path)

        # 6. Run the test file
        System.put_env("MIX_ENV", "test")
        Mix.Tasks.Test.run([file_path])

        # 7. Clean up
        File.rm(output_file_path)

      error ->
        error
    end
  end

  defp infer(prompt) do
    url = System.get_env("PLEASE_URL")

    headers = build_headers()
    payload = build_payload(prompt)

    :post
    |> Finch.build(url, headers, payload)
    |> Finch.request(Please.Finch)
  end

  defp handle_response(response) do
    case response do
      {:ok, %{body: json_response}} ->
        Jason.decode!(json_response)
        |> Map.get("choices")
        |> List.first()
        |> Map.get("text")

      error ->
        error
    end
  end

  defp build_payload(prompt) do
    model = System.get_env("PLEASE_MODEL")

    Jason.encode!(%{
      "model" => model,
      "prompt" => prompt,
      "temperature" => 0,
      "max_tokens" => 2000,
      "top_p" => 1
    })
  end

  defp build_headers() do
    key = System.get_env("PLEASE_KEY")

    %{
      "Authorization" => "Bearer #{key}",
      "Content-Type" => "application/json"
    }
  end

  defp default_prompt(file_data, module_name) do
    """
    Write an Elixir function that satisfies the following tests:
    #{file_data}

    defmodule #{module_name} do
    """
  end

  defp rps_prompt(file_data, module_name) do
    """
    Write an Elixir function that satisfies the following tests (use case instead of if):
    #{file_data}

    defmodule #{module_name} do
    """
  end

  defp palindrome_prompt(file_data, module_name) do
    """
    Write an Elixir function that satisfies the following tests (use String.reverse/1):
    #{file_data}

    defmodule #{module_name} do
    """
  end

  defp fizzbuzz_prompt(file_data, module_name) do
    """
    Write an Elixir function that satisfies the following tests (use Enum.map/2, and don't use inline functions):
    #{file_data}

    defmodule #{module_name} do
    """
  end

  defp enm_prompt(file_data, module_name) do
    """
    Write an Elixir function that satisfies the following tests without using the original Enum module from the Elixir standard library:
    #{file_data}

    defmodule #{module_name} do
    """
  end
end
