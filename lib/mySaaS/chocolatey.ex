defmodule Chocolatey do
  def install_package(package, current_packages) do
    if !package_installed?(package, current_packages) do
      case System.cmd("choco", ["install", package, "-y"]) do
        {_output, 0} ->
          IO.puts("Successfully installed #{package}")
        {output, _} ->
          IO.puts("Failed to install #{package}")
          output
      end
    else
      IO.puts("Package #{package} is already installed, upgrading to latest version.")
      upgrade_package(package)
    end
  end

  def uninstall_package(package, current_packages) do
    if not package_installed?(package, current_packages) do
      IO.puts("Package #{package} is not installed.")
    else
      case System.cmd("choco", ["uninstall", package, "-y", "--remove-dependencies"]) do
        {_output, 0} ->
          IO.puts("Successfully uninstalled #{package}")
        {output, _} ->
          IO.puts("Failed to uninstall #{package}")
          IO.puts(output)
      end
    end
  end

  def upgrade_package(package) do
    case System.cmd("choco", ["upgrade", package, "-y"]) do
      {_output, 0} ->
        IO.puts("Successfully upgraded #{package}")
      {output, _} ->
        IO.puts("Failed to upgrade #{package}")
        output
    end
  end

  def upgrade_all_packages do
    case System.cmd("choco", ["upgrade", "all", "-y"]) do
      {_output, 0} ->
        IO.puts("Successfully upgraded all packages")
      {output, _} ->
        IO.puts("Failed to upgrade all packages")
        output
    end
  end

  def get_current_packages do
    case System.cmd("choco", ["list"]) do
      {output, 0} ->
        # Split the output into lines, filter out unwanted lines, and parse each line
        packages =
          output
          |> String.split("\n")
          |> Enum.filter(fn line ->
            not (String.contains?(line, "Chocolatey v") or String.contains?(line, "packages installed"))
          end)
          |> Enum.reduce(%{}, fn line, acc ->
            case String.split(line, " ") do
              [name, version | _] -> Map.put(acc, String.downcase(name), String.trim(version))
              _ -> acc
            end
          end)
        packages
      {output, _} ->
        IO.puts("Failed to get current Chocolatey packages")
        output
    end
  end

  def package_installed?(package, current_packages) do
    Map.has_key?(current_packages, String.downcase(package))
  end
end

# Chocolatey.install_package("firefox", Chocolatey.get_current_packages())
# IO.inspect(Chocolatey.get_current_packages())
# Chocolatey.upgrade_package("firefox")
# Chocolatey.uninstall_package("firefox", Chocolatey.get_current_packages())
# IO.inspect(Chocolatey.get_current_packages())
# Chocolatey.upgrade_all_packages()
