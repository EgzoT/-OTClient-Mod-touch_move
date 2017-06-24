touchMoveWindow = nil
touchMoveButton = nil
addTouchMoveWindow = nil
windowType = nil

function init()

  windowType = g_settings.getBoolean('touchMove_isAdvanced')
  if windowType == nil then
    windowType = false
  end

  touchMoveButton = modules.client_topmenu.addRightGameToggleButton('touchMoveButton', tr('Touch Move'), '/touch_move/img_touch_move/moving_keys_icon', toggle)
  touchMoveButton:setOn(true)

  if windowType == false then
    touchMoveWindow = g_ui.loadUI('touch_move', modules.game_interface.getRightPanel())
    touchMoveWindow:setup()
    touchMoveWindow:setContentMinimumHeight(130)
    touchMoveWindow:setContentMaximumHeight(130)
    touchMoveWindow:setHeight(154)
    windowType = true
  else
    touchMoveWindow = g_ui.loadUI('touch_move_advanced', modules.game_interface.getRightPanel())
    touchMoveWindow:setup()
    touchMoveWindow:setContentMinimumHeight(190)
    touchMoveWindow:setContentMaximumHeight(190)
    touchMoveWindow:setHeight(215)
    windowType = false
  end
end

function changeNormalToAdvanced()
  if windowType then
    clear()
    touchMoveWindow:destroy()
    touchMoveWindow = g_ui.loadUI('touch_move_advanced', modules.game_interface.getRightPanel())
    touchMoveWindow:setup()
    windowType = false
    touchMoveWindow:setContentMinimumHeight(190)
    touchMoveWindow:setContentMaximumHeight(190)
    touchMoveWindow:setHeight(215)
    g_settings.set('touchMove_isAdvanced', true)
  else
    clear()
    touchMoveWindow:destroy()
    touchMoveWindow = g_ui.loadUI('touch_move', modules.game_interface.getRightPanel())
    touchMoveWindow:setup()
    windowType = true
    touchMoveWindow:setContentMinimumHeight(130)
    touchMoveWindow:setContentMaximumHeight(130)
    touchMoveWindow:setHeight(154)
    g_settings.set('touchMove_isAdvanced', false)
  end
end

function terminate()
  disconnect(g_game, { onGameEnd = clear })

  touchMoveWindow:destroy()
  touchMoveButton:destroy()

end

function clear()
  local touchMoveList = touchMoveWindow:getChildById('contentsPanel')
  touchMoveList:destroyChildren()
end

function toggle()
  if touchMoveButton:isOn() then
    touchMoveWindow:close()
    touchMoveButton:setOn(false)
  else
    touchMoveWindow:open()
    touchMoveButton:setOn(true)
  end
end

function onMiniWindowClose()
  touchMoveButton:setOn(false)
end

--Moving--

local eventDis = {}

function touchMove(dir)
  if dir == 'N' then
    g_game.walk(North)
  elseif dir == 'S' then
    g_game.walk(South)
  elseif dir == 'W' then
    g_game.walk(West)
  elseif dir == 'E' then
    g_game.walk(East)
  elseif dir == 'NW' then
    g_game.walk(NorthWest)
  elseif dir == 'NE' then
    g_game.walk(NorthEast)
  elseif dir == 'SW' then
    g_game.walk(SouthWest)
  elseif dir == 'SE' then
    g_game.walk(SouthEast)
  end
end

function AutoTouchMove(dir)
  eventDis[true] = cycleEvent(function()
    touchMove(dir)
  end, 50)
end

function AutoTouchMoveEnd()
  removeEvent(eventDis[true])
end

function turnPlayer()
  local playerDir = g_game.getLocalPlayer():getDirection()

  if playerDir == 0 then
    g_game.turn(East)
  elseif playerDir == 1 or playerDir == 5 or playerDir == 4 then
    g_game.turn(South)
  elseif playerDir == 2 then
    g_game.turn(West)
  elseif playerDir == 3 or playerDir == 7 or playerDir == 6 then
    g_game.turn(North)
  end
end