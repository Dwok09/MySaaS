defmodule MySaaSWeb.PackagesLive do
  use MySaaSWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, packages: Chocolatey.get_current_packages)}
  end

  def render(assigns) do
    ~H"""
    <h1>Installed Applications</h1>
    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
    <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
                <th scope="col" class="px-6 py-3">
                    Name
                </th>
                <th scope="col" class="px-6 py-3">
                    Version
                </th>
                <th scope="col" class="px-6 py-3">
                    Update
                </th>
                <th scope="col" class="px-6 py-3">
                    Uninstall
                </th>
            </tr>
        </thead>
        <tbody>
            <%= for package <- @packages do %>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"><%= elem(package, 0) %></th>
                <td class="px-6 py-4"><%= elem(package, 1) %></td>
                <td class="px-6 py-4"><button phx-click="update_package" phx-value-package={elem(package, 0)} type="button" class="text-blue-600 hover:text-blue-800">Update</button></td>
                <td class="px-6 py-4"><button phx-click="uninstall_package" phx-value-package={elem(package, 0)} type="button" class="text-blue-600 hover:text-blue-800">Uninstall</button></td>
            </tr>
            <% end %>
        </tbody>
    </table>
    </div>
    """
  end

  def handle_event("refresh_packages", _params, socket) do
    {:noreply, assign(socket, packages: Chocolatey.get_current_packages())}
  end

  def handle_event("update_package", %{"package" => package}, socket) do
    Chocolatey.upgrade_package(package)
    {:noreply, assign(socket, packages: Chocolatey.get_current_packages())}
  end

  def handle_event("uninstall_package", %{"package" => package}, socket) do
    Chocolatey.uninstall_package(package, Chocolatey.get_current_packages)
    {:noreply, assign(socket, packages: Chocolatey.get_current_packages())}
  end
end
