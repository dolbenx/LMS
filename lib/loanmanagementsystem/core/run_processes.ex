defmodule Core.RunProcesses do
  def fire_process(url, body, headers, options) do
    parent = self()

    spawn(fn ->
      send(
        parent,
        {self(), :call,
         HTTPoison.post(
           url,
           body,
           headers,
           options
         )}
      )
    end)
  end

  def recieve_process(pid) do
    receive do
      {^pid, :call, value} ->
        value
    end
  end
end
