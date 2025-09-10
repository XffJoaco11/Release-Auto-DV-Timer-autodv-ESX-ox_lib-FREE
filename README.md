# Release-Auto-DV-Timer-autodv-ESX-ox_lib-FREE

✨ Features

	⏱️ Timed cleanup (configurable interval)

	🔘 Manual command: /autodv

	🔔 ox_lib notifications (countdown + result)

🧹 Two cleanup modes:

	Aggressive: enumerate vehicles, request network control, delete mission/owned entities if empty

	Simple: ClearAreaOfVehicles (fast, less thorough)

🧠 Safety: skip vehicles with a driver; optional safe radius around players

🧩 ESX-friendly; no QBCore dependency


🧪 Preview

<img width="890" height="841" alt="image" src="https://github.com/user-attachments/assets/e5bace4e-0319-4015-b18b-b3b84d4de91e" />



📦 Requirements

	ESX (es_extended)

	ox_lib (must start before this resource)


🚀 Installation

	Drop the resource folder into your resources/

	Add to server.cfg in this order:

	ensure ox_lib
	ensure esx-AutoDV   # or your folder name


🛠️ Configuration

	Quick toggles (in Client/client.lua)
	local DELETE_NEAR_PLAYER_RADIUS = 8.0   -- don’t delete if a player is within X meters
	local SKIP_VEHICLES_WITH_DRIVER = true  -- skip vehicles with driver (NPC/player)
	local USE_AGGRESSIVE_DELETE = true      -- true: enumerate & force delete; false: ClearAreaOfVehicles

Timer & countdown (in Server/server.lua)

	-- Autocleanup
	Citizen.Wait(10800000)   -- interval in ms (3h)
	countdownAlert(5)        -- minutes before cleanup
	clearAllVehicles()

	Optionally gate /autodv to ESX admins/mods by uncommenting the provided block in server.lua.


📖 Commands

	/autodv → starts a configurable countdown then cleans up


🔍 How it works

	Server announces a countdown with ox_lib notifications

	Client receives the clear event

	Aggressive mode iterates the CVehicle pool, takes control, marks mission entity and deletes empty vehicles while respecting safe radius and skip driver flags


❓ FAQ

	Does this delete “owned/garage” vehicles?
	No DB data is touched. It removes world entities. If a player pulls a car from the garage and leaves it outside, Auto DV may delete that entity; the car remains owned in DB and can 	be spawned again.

	It didn’t delete some freshly spawned cars. Why?
	Simple mode skips many mission/owned entities. Use Aggressive mode (default) which requests control and deletes them if empty.

	Delete cars with NPC drivers too?
	Set SKIP_VEHICLES_WITH_DRIVER = false (beware: you will remove traffic in motion).

	Skip “protected” vehicles?
	Hook your own logic in isProtectedVehicle(veh) (e.g., statebags/decors) to avoid deleting specific entities.


🤝 Contributing

	PRs and issues are welcome. Please describe your changes clearly and keep code style consistent.
	If you’re adding config options, consider a config.lua with sensible defaults.


🛡️ License

	Free to use. If the original base had a specific license, please respect it when redistributing.
	If you want a standard license, add an MIT or Apache-2.0 LICENSE file to the repo.


🆘 Support / Contact

	Discord: sweet21
	Free to use. If the original base has a specific license, please respect it when redistributing.

