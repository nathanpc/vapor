#!/usr/bin/perl -w

# bot.pl
#
# IRC bot.

package IRCLog;

use strict;
use warnings;
use Data::Dumper;

use IO::Socket;

# Properties.
my $server = "localhost";
my $nick = "vapor";
my $username = "Vapor";
my $channel = "#home";

# Other variables.
my $socket;

# Send a raw line to the IRC server.
sub irc_send {
	my ($str) = @_;
	print $socket "$str\r\n";
	#print "$str\n";
}

# Connect to the IRC server.
sub irc_connect {
	# Connect.
	print "[INFO] Connecting to $server...\n";
	$socket = new IO::Socket::INET(PeerAddr => $server,
								   PeerPort => 6667,
								   Proto => 'tcp') or
									   die "Couldn't connect to server\n";
	print "[INFO] Connected to $server\n";

	# Log in.
	irc_send("NICK $nick");
	irc_send("USER $username 8 * :IRCLog bot for $channel");

	# Read lines until we have logged in.
	while (my $msg = <$socket>) {
		if ($msg =~ /004/) {
			# Logged in.
			print "[INFO] Logged in as $nick\n";
			last;
		} elsif ($msg =~ /433/) {
			die "[ERROR] Nickname is already in use\n";
		}
	}
}

# Main.
irc_connect();
irc_send("JOIN $channel");

# IRC loop.
while (my $msg = <$socket>) {
	# Remove the crap.
	chop $msg;

	if ($msg =~ /^PING(.*)$/i) {
		irc_send("PONG $1");
	} elsif ($msg =~ /PRIVMSG $channel/i) {
		# Makes sure this is a message from the selected channel.
		my @values = split(" ", $msg);
		if ("$values[1] $values[2]" eq "PRIVMSG $channel") {
			print "$msg\n";
		}
	}
}
