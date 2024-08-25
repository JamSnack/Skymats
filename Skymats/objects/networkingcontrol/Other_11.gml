/// @description Join Server
network_timeout = 60*10;
var _ip = get_string("Enter IP", "26.198.169.147");
var _port = get_string("Enter Port", "6510");

if (_ip != "" && _port != "")
	connect_to_server(_ip, real(string_digits(_port)));