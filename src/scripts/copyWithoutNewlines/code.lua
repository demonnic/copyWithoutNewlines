local function getSelectedText(window, startCol, startRow, endCol, endRow)
  -- Check whether there's an actual selection
  if startCol == endCol and startRow == endRow then return "" end
  local parsed = ""
  -- Loop through each symbol within the range
  for lineNum = startRow, endRow do
    local cStart = lineNum == startRow and startCol or 0
    moveCursor(window, cStart, lineNum)
    local cEnd = lineNum == endRow and endCol or #getCurrentLine() - 1
    selectSection(window, cStart, cEnd - cStart + 1)
    parsed = parsed .. (getSelection(window) or "")
    if lineNum ~= endRow then parsed = parsed .. "\n" end
  end
  return parsed
end
local handler = function(event, menu, ...)
  local text = getSelectedText(...)
  local withoutNewLines = text:gsub(" \n", " ")
  withoutNewLines = withoutNewLines:gsub("-\n", "")
  withoutNewLines = withoutNewLines:gsub("\n", " ")
  setClipboardText(withoutNewLines)
end
addMouseEvent("Copy without newlines", "copyWithoutNewLines")
registerNamedEventHandler("demonnic", "copy without new lines", "copyWithoutNewLines", handler)
