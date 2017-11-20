BRAKING_HONK = "deltic-stop"
STARTING_HONK = "deltic-start"

HONK_ON_START = true
HONK_FOR_STATION = true
HONK_FOR_SIGNAL = true
HONK_COOLDOWN = 120

local function init_global()
  global = global or {}
  global.honks = global.honks or {}
end

script.on_configuration_changed(init_global)
script.on_init(init_global)

function playSoundAtEntity(sound, entity)
  entity.surface.create_entity({name = sound, position = entity.position})
end

function attemptHonk(sound, train, tick)
  local entity
  if train.speed >= 0 and #train.locomotives.front_movers > 0 then
    entity = train.locomotives.front_movers[1]
    global.honks[entity.unit_number] = global.honks[entity.unit_number] or {}
    if global.honks[entity.unit_number][sound] and
        tick - global.honks[entity.unit_number][sound] < HONK_COOLDOWN then
    else
      global.honks[entity.unit_number][sound] = tick
      playSoundAtEntity(sound, entity)
    end
  end
  if train.speed <= 0 and #train.locomotives.back_movers > 0 then
    entity = train.locomotives.back_movers[#train.locomotives.back_movers]
    global.honks[entity.unit_number] = global.honks[entity.unit_number] or {}
    if global.honks[entity.unit_number][sound] and
        tick - global.honks[entity.unit_number][sound] < HONK_COOLDOWN then
    else
      global.honks[entity.unit_number][sound] = tick
      playSoundAtEntity(sound, entity)
    end
  end 
end

script.on_event("honk", function(event)
  local player = game.players[event.player_index]
  if player.vehicle then
    if player.vehicle.type == "locomotive" and player.vehicle.train.manual_mode then
      if player.vehicle.train.speed == 0 then
        playSoundAtEntity(STARTING_HONK, player)
      else
        playSoundAtEntity(BRAKING_HONK, player)
      end
    end
  end
end)

script.on_event("toggle-train-control", function(event)
  if not game.active_mods["PickerExtended"] then
    local player = game.players[event.player_index]
    if player.vehicle then
      if player.vehicle.type == "locomotive" then
        player.vehicle.train.manual_mode = not player.vehicle.train.manual_mode
      end
    end
  end
end)

script.on_event(defines.events.on_train_changed_state, function(event)
  if HONK_ON_START and event.train.state == defines.train_state.on_the_path then
    attemptHonk(STARTING_HONK, event.train, event.tick)
  elseif HONK_FOR_STATION and event.train.state == defines.train_state.arrive_station then
    attemptHonk(BRAKING_HONK, event.train, event.tick)
  elseif HONK_FOR_SIGNAL and event.train.state == defines.train_state.arrive_signal then
    attemptHonk(BRAKING_HONK, event.train, event.tick)
  end
end)

on_entity_removed = function (event)
  if event.entity.type == "locomotive" then
    global.honks[event.entity.unit_number] = nil
  end
end

script.on_event(defines.events.on_preplayer_mined_item, on_entity_removed)
script.on_event(defines.events.on_robot_pre_mined, on_entity_removed)
script.on_event(defines.events.on_entity_died, on_entity_removed)