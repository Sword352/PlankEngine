package classes;

import Sys.sleep;
#if discord_rpc
import discord_rpc.DiscordRpc;
#end

#if hldiscord
import discord.Api;
#end

#if hl
import hl.Bytes;
#end

using StringTools;

class DiscordClient
{
	#if discord_rpc
	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "814588678700924999",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			// trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin'"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin'",
			smallImageKey: smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});

		// trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}

	#elseif hldiscord
	public function new()
		{
			trace("Discord Client starting...");
			Api.init("814588678700924999", "00000000");
			trace("Discord Client started.");
	
			while (true)
			{
				sleep(2);
			}
	
			Api.release();
		}
	
		public static function shutdown()
		{
			Api.release();
		}
	
		static function onReady()
		{
			Api.updatePresence(null, "In the Menus", false);
			Api.updateLargeImageKey("icon");
			Api.updateLargeImageText("Friday Night Funkin'");
		}
	
		static function onError(_code:Int, _message:String)
		{
			trace('Error! $_code : $_message');
		}
	
		static function onDisconnected(_code:Int, _message:String)
		{
			trace('Disconnected! $_code : $_message');
		}
	
		public static function initialize()
		{
			var DiscordDaemon = sys.thread.Thread.create(() ->
			{
				new DiscordClient();
			});
			trace("Discord Client initialized");
		}
	
		public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
		{
			var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;
	
			if (endTimestamp > 0)
			{
				endTimestamp = startTimestamp + endTimestamp;
			}
	
			Api.updatePresence(state, details, false);
			Api.updateLargeImageKey("icon");
			Api.updateLargeImageText("Friday Night Funkin'");
			Api.updateSmallImageKey(smallImageKey, false);
			Api.updateStartTimestamp(Std.int(startTimestamp / 1000), false);
			Api.updateEndTimestamp(Std.int(endTimestamp / 1000), false);
	
			// trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
		}
	#else
	/*
	public function new()
		{
			trace("Discord Client starting...");
			DiscordTest.DiscordRpc.init("814588678700924999", onReady, onDisconnected, onError, onJoinGame, onSpectateGame, onJoinRequest, 1,  "00000000");
			trace("Discord Client started.");
	
			while (true)
			{
				DiscordTest.DiscordRpc.process();
				sleep(2);
			}
	
			DiscordTest.DiscordRpc.shutdown();
		}
	
		public static function shutdown()
		{
			DiscordTest.DiscordRpc.shutdown();
		}
	
		static function onReady(userID:Bytes, username:Bytes, discriminator:Bytes, avatar:Bytes)
		{
			DiscordTest.DiscordRpc.state =  "Just testin' my hl discord externs";
			DiscordTest.DiscordRpc.updatePresence();
		}

		static function onJoinRequest(userID:Bytes, username:Bytes, discriminator:Bytes, avatar:Bytes)
		{
			trace('Not implemented! $userID $username $discriminator $avatar');
		}

		static function onSpectateGame(_secret:Bytes) {
			trace('Not implemented! $_secret');
		}
	
		static function onError(_code:Int, _message:Bytes)
		{
			trace('Error! $_code : $_message');
		}

		static function onJoinGame(_secret:Bytes)
		{
			trace('Not implemented! $_secret');
		}
	
		static function onDisconnected(_code:Int, _message:Bytes)
		{
			trace('Disconnected! $_code : $_message');
		}
	
		public static function initialize()
		{
			var DiscordDaemon = sys.thread.Thread.create(() ->
			{
				new DiscordClient();
			});
			trace("Discord Client initialized");
		}
	
		public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
		{
			var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;
	
			if (endTimestamp > 0)
			{
				endTimestamp = startTimestamp + endTimestamp;
			}
	
			// Api.updatePresence(state, details, false);
			// Api.updateLargeImageKey("icon");
			// Api.updateLargeImageText("Friday Night Funkin'");
			// Api.updateSmallImageKey(smallImageKey, false);
			// Api.updateStartTimestamp(Std.int(startTimestamp / 1000), false);
			// Api.updateEndTimestamp(Std.int(endTimestamp / 1000), false);
	
			// trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
		}
		*/
	#end
}
