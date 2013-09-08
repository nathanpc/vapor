#!/usr/bin/perl -w

# bot.pl
#
# IRC bot.

package IRCLog;

use strict;
use warnings;
use Data::Dumper;

use IO::Socket;
use URI::Find;
use LWP::Simple;
use HTML::HeadParser;

# Properties.
my $server = "irc.freenode.net";
my $nick = "vapor";
my $username = "Vapor";
my $channel = "##dreamincode";

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

SEND_NICK:
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
			print "[INFO] Nickname '$nick' is already in use, trying another one\n";
			$nick .= "_";
			goto SEND_NICK;
		}
	}
}

# Gets the message.
sub strip_msg {
	my ($msg) = @_;

	$msg =~ s/^:.*? ://;
	return $msg;
}

# Interprets a message.
sub parse_msg {
	my ($msg) = @_;

	my $finder = URI::Find->new(sub {
		my($url) = @_;
		if ($url =~ /^(http)|(https)/i) {
			# Get the page content.
			my $content = get($url);
			if (defined $content) {
				# Parse the title and send it to the channel.
				my $html = HTML::HeadParser->new;
				$html->parse($content);

				my $title = $html->header("Title");
				$title =~ s/[\r\n]+$//;

				irc_send("PRIVMSG $channel :^ $title");
			}
		}
	});
	$finder->find(\$msg);
}

# Main.
irc_connect();
irc_send("JOIN $channel");

# IRC loop.
while (my $msg = <$socket>) {
	# Remove the crap.
	chomp $msg;

	if ($msg =~ /^PING(.*)$/i) {
		irc_send("PONG $1");
	} elsif ($msg =~ /PRIVMSG $channel/i) {
		# Makes sure this is a message from the selected channel.
		my @values = split(" ", $msg);
		if ("$values[1] $values[2]" eq "PRIVMSG $channel") {
			parse_msg(strip_msg($msg));
		}
	}
}
