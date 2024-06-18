from pywinauto.application import Application
import os
import shutil
import sys
import time

def assert_no_lua_exception(directory):
  if not os.path.isdir(directory):
    return
  
  for root, dirs, files in os.walk(directory):
    for file in files:
      if file.endswith('.txt'):
        raise Exception(f"Found a .txt file: {file}")

print("Remove lua logs")
shutil.rmtree('../Logs')

print("Start mm7.exe")
app = Application(allow_magic_lookup=False).start("../mm7.exe")

try:
  window = app.window(title_re="Might*")
  print("[pywinauto] connected")

  print("Skip 3DO") 
  print("[pywinauto] type key ESC") 
  window.type_keys('{ESC}') 
  time.sleep(0.5)

  print("Click new game") 
  print("[pywinauto] click left at x: 540, y: 210") 
  window.click_input(coords=(540, 210))
  time.sleep(0.5)

  print("Click OK") 
  print("[pywinauto] click left at x: 610, y: 490") 
  window.click_input(coords=(610, 490))
  time.sleep(0.5)

  print("Skip intro") 
  print("[pywinauto] type key ESC") 
  window.type_keys('{ESC}') 
  time.sleep(0.5)

  print("Sleep 4 sec") 
  time.sleep(4.0)
  assert_no_lua_exception("../Logs")

  app.kill()
  print("SmokeTest.py: PASSED") 
except:
  print("SmokeTest.py: FAILED") 
  app.kill()
