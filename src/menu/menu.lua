htsroot = "/usr/local/etc/freeswitch/scripts/hts/"
soundsroot = "/usr/local/share/freeswitch/sounds/hts/"

session:answer()
do 
  session:setAutoHangup(false)
  session:set_tts_parms("flite", "rms")
  session:sleep(2000)
  digits = session:playAndGetDigits(1, 4, 3, 3000, "#", soundsroot .. 'menu.wav', '', '\\d+')
  
  if     digits == "1" then
--    session:execute("transfer", "missions")
    dofile(htsroot .. 'missions.lua')
  elseif digits == "2" then
    session:execute("conference", "public")
  elseif digits == "3" then 
    session:execute("playback","local_stream://htsradio") -- Each caller is hooked into the same stream.
--    session:execute("playback","shout://radio.htscdn.org:8000/stream") -- Creates a new stream for every caller. Bad...
  elseif digits == "88" then session:execute("playback","tone_stream://%(1000,0,1000);loops=-1")
  elseif digits == "99" then session:execute("echo")
  elseif digits == "1234" then
    session:streamFile(soundsroot .. 'coffee.wav')
    session:sleep(2000)
  elseif digits == "0" then
    session:execute("voicemail", "default newcomms.hackthissite.org staff")
  elseif digits == nil then
    session:speak("You did not enter any extension.")
  else
    session:speak("You entered an invalid extension. Try again.")
    session:transfer("menu")
  end

  session:streamFile(soundsroot .. 'bye.wav')
  session:hangup()
end
