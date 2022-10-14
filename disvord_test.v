module disvord

import x.json2
import os

fn get_token() string {
	content := os.read_file("./config.json") or {panic("./config.json: $err")}
	raw_conf := json2.raw_decode(content) or {panic("raw_conf: $err")}
	conf := raw_conf.as_map()
	tmp := conf['token'] or {panic("tmp")}
	return tmp.str()
}

fn test_create() {
	test_new := new(get_token(), all_allowed) ?
	assert test_new == DisvordBot{
		gateway_url: 'wss://gateway.discord.gg/?v=10&encoding=json'
		token: get_token()
		intents: all_allowed
	}
}
