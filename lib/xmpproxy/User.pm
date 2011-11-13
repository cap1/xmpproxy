package xmpproxy::User;
use strict;
use warnings;

use DJabberd::Config::Config;
use DJabberd::Log;
use DJabberd::Roster;
use DJabberd::RosterItem;
our $logger = DJabberd::Log->get_logger();

sub new 
{
	my $class = shift;
	my $self = {};
	bless($self, $class);
	$self->_init(@_);
	return $self;
}


sub _init 
{
	my $self = shift;
	my $name = shift;
	my $passwd = shift;
	my $vhost = shift;
	$self->{queues} = {};
	if(defined($name) && defined($passwd) && defined($vhost))
	{
		$self->{name} = $name;
		$self->{passwd} = $passwd;
		$self->{vhost} = $vhost;
	}
	else
	{
		$logger->warn("Not enough data supplied to create this user");
		return 0;
	}

}



sub add_account
{
	my $self = shift;
	my $jid = shift;
	my $password = shift;
	my $resource = shift;
	if(not defined($self->{queues}->{$jid}))
	{
		$self->{queues}->{$jid} = new DJabberd::Queue::ClientOut(jid => $jid,
									 passwd => $password,
									 resource => $resource,
								 	 vhost => $self->{vhost});
	}
	else
	{	
		$logger->warn("Account $jid already exists");
		return 0;
	}	
	
	return 1;
}

sub delete_account
{
	my $self = shift;

}

#not needed so far
sub fetch_rosters
{
	my $self = shift;
	
	foreach my $client (keys(%{$self->{queues}}))
	{
		$self->{queues}->{$client}->fetch_roster();
	}
	
}

sub set_vhost
{
	my ($self,$vh) = @_;
	#print(ref($self->{vhost}));
	$self->{vhost}= $vh;
}

sub get_roster
{
	my $self = shift;
	my $roster = new DJabberd::Roster; 
	foreach my $client (keys(%{$self->{queues}}))
	{
		#TODO: Merge rosters properly...
		#foreach my $item ($self->{queues}->{$client}->{roster}->items())
		#{
		#		$roster->add($item);
		#}
	}
	return $roster; 
}


1;