#!/usr/bin/perl

use warnings;
use strict;

#Max data length
my $max = 10000;
#Data array
my @mem = (1..$max);
#Array to hold values for while loops
my @while;
#Pointer
my $p = 0;

my $i = 0;

#File with brainfuck code received as argument to perl script
open my $file, $ARGV[0];

@mem = (0) x $max;

#Save file content in one string
my $text = "";
while (<$file>) {
	chomp;
	$text .= $_;
}

#Remove any non-brainfuck chars
$text =~ s/[^\+\-\.\[\],<>]//g; 

while ($i < length($text)) {
	#Current operation
	my $op = substr($text, $i, 1);
	$i++;
	
	my $operations = {
		'<' => sub {
			if ($p == 0) { $p = $max + 1; }
			$p -= 1;
		},
		'>' => sub {
			if ($p == $max) { $p = -1; }
			$p += 1;
		},
		'+' => sub {
			if ($mem[$p] == 255) { $mem[$p] = -1; }
			$mem[$p] += 1;
		},
		'-' => sub {
			if ($mem[$p] == 0) { $mem[$p] = 256; }
			$mem[$p] -= 1;
		},
		'.' => sub {
			print chr($mem[$p]);
		},
		',' => sub {
			my $read = <STDIN>;
			$mem[$p] = ord(substr($read, 0, 1));
		},
		'[' => sub {
			push @while, $i;
		},
		']' => sub {
			if ($mem[$p] != 0) { 
				$i = $while[scalar(@while)-1]; 
			} else { 
				pop @while; 
			}
		}
	};
	$operations->{$op}->();
}
