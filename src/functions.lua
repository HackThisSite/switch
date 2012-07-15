http = require "socket.http";

function do_mission(a)
	local msna = "/usr/local/etc/freeswitch/scripts/hts/missions/" .. a .. ".lua";

	local file = io.open(msna, "r");

	if file ~= nil then
		io.close(file);
		dofile(msna);
		local res = session:getVariable("msres");
		if res then
			session:speak("You have successfully solved this mission!");
		end
	else
		session:speak("That mission does not exist. Please try again.");
		session:sleep(250);
	end

	return;
end

function authenticate(uid, pin)
	b, c, h = http.request("http://www.hackthissite.org/pbx.php?userId=" .. uid .. "&pbxPin=".. pin);

	if b == "true" then
		return true;
	end
	return false;
end
