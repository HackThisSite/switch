-- HackThisSite Missions Framework

require "hts/functions";
io = require "io";

api = freeswitch.API();

-- Answers and sets up stuff
session:answer();
session:set_tts_parms("flite", "rms");
session:setVariable("auth", "0");

session:speak("Welcome to the HackThisSite P B X Missions.");
session:sleep(500);

session:speak("Please enter your User I D followed by the # key.");
id = session:getDigits(10, "#", 15000);
--freeswitch.consoleLog("info", "DTMF response: " .. id .. ".\n");

if id == "" then
  session:speak("Invalid User I D!");
  session:hangup();
end

session:speak("Please enter your User PIN Number followed by the # key.");
pin = session:getDigits(10, "#", 15000);
--freeswitch.consoleLog("info", "DTMF response: " .. pin .. ".\n");

if pin == "" then
  session:speak("Invalid PIN!");
  session:hangup();
end

if authenticate(id, pin) then
  session:speak("You have been authenticated.");
else
  session:speak("You could not be authenticated. Please call and try again.");
  session:hangup();
end

session:speak("Please select a Mission I D followed by the # key.");

while command ~= "" do
  command = session:getDigits(2, "#", 25000);
  if command ~= "" then
    do_mission(command);
  end
end

session:speak("Goodbye.");

-- Hangs up the call :)
session:hangup();
