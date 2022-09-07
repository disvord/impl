module main

import disvord

fn main() {
	mut client := disvord.new("test token here", disvord.all_allowed) ?

	//client.when("")

	client.connect()
}
