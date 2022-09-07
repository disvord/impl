module disvord

import net.websocket
import term
import time
import json

struct DisvordBot {
	gateway_url string
pub:
	token string
	intents Intent
mut:
	ws websocket.Client

	session_id string
	sequence int
	heartbeat_interval int
	last_heartbeat i64
}

pub fn new(token string, intents Intent) ?DisvordBot {
	mut ret := DisvordBot{
		gateway_url: "wss://gateway.discord.gg/?v=10&encoding=json"
		token: token
		intents: intents
	}
	ret.ws = websocket.new_client(ret.gateway_url)?
	return ret
}

pub fn (mut dsv DisvordBot) connect() {
	dsv.ws.connect() or { println(term.red('error on connect: $err')) }

	dsv.ws.listen() or { println(term.red('error on listen: $err')) }

	for true {
		time.sleep(1)
		if time.now().unix - dsv.last_heartbeat > dsv.heartbeat_interval {
			heartbeat := HeartbeatPacket {
				op: Op.heartbeat,
				d: dsv.sequence
			}
			dsv.ws.write_string(json.encode(heartbeat).str)
			dsv.last_heartbeat = time.now().unix
		}
	}

}