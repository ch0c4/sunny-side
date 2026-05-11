# SunnySide – Copilot Instructions

Godot 4.6 top-down 2D farming/adventure game written in GDScript. GL Compatibility renderer, 640×360 viewport scaled to 1280×640, nearest-neighbour texture filtering (pixel art).

## Running the project

Open in the Godot 4.6 editor and press **F5** (or run `godot --path .`). There are no automated tests or external build steps.

## Architecture overview

### Autoloads (global singletons – `Systems/`)

| Autoload | Purpose |
|---|---|
| `Events` | Signal bus – emit/connect here for decoupled cross-node communication |
| `Stash` | Holds the three global `Inventory` objects (`inventory`, `tools_inventory`, `action_inventory`) |
| `MainInstance` | Holds a reference to the active `Player` node |
| `SaveManager` | JSON save/load; discovers saveable nodes via the `"saveable"` group |
| `Utils` | Scene instantiation helpers (`instantiate_scene_on_level`, etc.) |
| `Constants` | Shared enums (e.g. `ROCK_TYPE`) |

### State machine (`Scripts/StateMachine/`)

All stateful actors (player, harvestables, collectables, interactives) use a `StateMachine` node with `State` child nodes.

- Each state extends `State` and overrides `enter()`, `exit()`, `update(delta)`, `physics_update(delta)`.
- Transition by emitting `transitionned.emit(self, "StateName")` (case-insensitive lookup).
- Force an external transition: `state_machine.force_transitition_to("StateName")`.
- State names in the scene tree must match the string used in transitions.

### Inventory system (`Scripts/Inventory/`)

- `Item` – `Resource` subclass; `.tres` files live in `Collectable/resources/`.
- `ItemBox` – holds one `Item` + `amount` (0–99); setting `amount = 0` clears the item.
- `Inventory` – `RefCounted`, fluent API: `Inventory.new().set_size(15).add_item(item, 1)`. Emits `item_box_changed`.
- All inventory access goes through `Stash.*` autoload at runtime.

### Interaction system

- Interactable objects expose `get_interaction_state(tool_name: StringName) -> StringName`.
- `PlayerActionComponent` calls this on the nearest `Interaction` area and tells the state machine which state to enter.
- `Interaction` (Area2D, layer 6) handles highlight/click detection; the owning node supplies the state name.

### Save / load pattern

- Nodes that need persistence: call `add_to_group(SaveManager.SAVEABLE_GROUP)` in `_ready()`.
- Implement `serialize() -> Dictionary` and `deserialize(data: Dictionary) -> void`.
- `SaveManager` uses the node's scene-relative path as the key within each level's save block.
- Save file: `res://sunny_side_save.json` (dev) / `user://sunny_side_save.json` (release); toggle via `SaveManager.save_path`.

### Level transitions

- `Transition` (Area2D, `@tool`) placed in a level references a `connection` Resource shared with its counterpart in the destination level.
- Player entering a `Transition` emits `Events.transition_entered`; `World` handles level swap and repositions the player at the matching exit point.

## Key conventions

### Physics layers (2D)

| # | Name |
|---|---|
| 1 | World |
| 2 | Player |
| 3 | Enemy |
| 4 | PlayerHurtbox |
| 5 | EnemyHurtbox |
| 6 | Interaction |

### Damage (Hitbox / Hurtbox)

- `Hitbox` (Area2D) emits `hit_hurtbox(hurtbox)` and calls `hurtbox.hurt.emit(self)`.
- `Hurtbox` (Area2D) exposes `is_invincible`; setting it to `true` also disables monitoring.
- Both live on their own physics layers (4/5) and only detect each other.

### CharacterMover

Static utility – never instantiated. Call `CharacterMover.accelerate_in_direction(...)`, `.decelerate(...)`, `.move(...)`, `.apply_knockback(...)` from state scripts.

### Signal connections

- Connect/disconnect `Events.*` signals inside state `enter()`/`exit()` to avoid stale connections.
- Use `CONNECT_DEFERRED` when connecting in `_ready()` to signals that might fire during the same frame (see `World._ready()`).

### UID files

Every `.gd` and `.tscn` file has a paired `.uid` file. Never delete or hand-edit `.uid` files; Godot manages them automatically. Prefer `uid://...` paths over `res://...` paths in `preload()` calls.
