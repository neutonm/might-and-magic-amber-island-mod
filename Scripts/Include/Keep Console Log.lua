-- log all
local LogPath = DevPath..'Logs/'
local LogCount = 9
require'KeepLogs'(LogPath, LogCount)
-- PrintToFile(LogPath..'mm'..offsets.MMVersion..'.txt')  -- optional. To avoid opening particular game folder every time.
