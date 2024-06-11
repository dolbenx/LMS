defmodule LoanmanagementsystemWeb.Admin.UserLive.UserLiveFilterComponent do
  use LoanmanagementsystemWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="modal-body">
      <.modal return_to={Routes.user_index_path(@socket, :index)}>
      <form class="dataTables_filter" phx-submit="filter">
        <div class="modal-header">
        <h5 class="modal-title"><i class='subheader-icon fal fa-filter'><%= @page%></i></h5>
      </div>
      <div class="modal-body">
            <div class="row form-group">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="first_name" class="form-label">First Name </label>
                        <input type="search" class="form-control" value={@params["filter"]["first_name"]} name="first_name" placeholder="First Name" aria-describedby="basic-addon3">
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="form-group">
                        <label for="last_name" class="form-label">Last Name </label>
                        <input type="search" class="form-control" value={@params["filter"]["last_name"]} name="last_name" placeholder="Last Name" aria-describedby="basic-addon3">
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="form-group">
                        <label for="username" class="form-label">Username </label>
                        <input type="search" class="form-control" value={@params["filter"]["username"]} name="username" placeholder="Username" aria-describedby="basic-addon3">
                    </div>
                </div>

               <div class="col-md-6">
                    <div class="form-group">
                         <label for="phone" class="form-label">Phone</label>
                         <input type="search" class="form-control" value={@params["filter"]["phone"]} name="phone" placeholder="Phone" aria-describedby="basic-addon3">

                    </div>
                </div>

                <div class="col-md-6">
                    <div class="form-group">
                         <label for="email" class="form-label">Email</label>
                         <input type="search" class="form-control" value={@params["filter"]["email"]} name="email" placeholder="Email" aria-describedby="basic-addon3">

                    </div>
                </div>

              <div class="col-md-6">
                    <div class="form-group">
                         <label for="sex" class="form-label">sex</label>
                         <select class="form-control" name="sex">
                         <option  class="form-control" value="" selected  aria-describedby="basic-addon3">
                         </option>
                         <option  class="form-control" value={@params["filter"]["F"]}  aria-describedby="basic-addon3">
                         F
                         </option>
                         <option  class="form-control" value={@params["filter"]["M"]}  aria-describedby="basic-addon3">
                         M
                         </option>
                         </select>

                    </div>
                </div>
            </div>

            <div class="col-md-6">
                    <div class="form-group">
                         <label for="name" class="form-label">User Role</label>
                         <select name="name" id="name" class="form-control">
                              <option value="" selected>-- Role --</option>
                              <%= for role <- @roles do %>
                                  <option phx-value-province={role.name}>Admin</option>
                              <% end %>
                          </select>
                    </div>
                </div>
        </div>
      <div class="modal-footer">
        <button  type="submit"  phx_disable_with ="filtering...", class="btn btn-info submit"> <i class="fal fa-filter"></i> Filter </button>
      </div>
      </form>
      </.modal>
    </div>
    """
end


def update(assigns, socket) do
  {:ok,
   socket
   |> assign(assigns)}
end
end
