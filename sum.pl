#!/usr/bin/perl
#my $MAX = 9; my $MAX10 = 2;
my $MAX = 0; my $MAX10 = 0;

while (<>) { chomp();
  @tmp = split /;/, $_;
  if ($tmp[1] eq 'wieś' || $tmp[1] eq 'miasto' ) { #print "$_\n" ;
     $NazwaTyp{$tmp[1]}++;
     $Nazwa{$tmp[0]}++;
     $NazwaWoj{"$tmp[4]"}{"$tmp[0]"}++;
 }
	   }

print "--------------------------------------\n";
for $m (keys %NazwaTyp ) { print "$m = $NazwaTyp{$m}\n"; }

print "--------------------------------------\n";
for $m (sort { $Nazwa{$b} <=> $Nazwa{$a} } keys  %Nazwa ) {
  if ($Nazwa{$m} > $MAX) { print "===;$m;$Nazwa{$m}\n"; } }

print "--------------------------------------\n";
for $w (sort keys %NazwaWoj ) {
for $m (sort { $NazwaWoj{$w}{$b} <=> $NazwaWoj{$w}{$a} } keys  %{$NazwaWoj{$w} } ) {
  if ($NazwaWoj{$w}{$m} > $MAX10) { print "###;$m;$w;$NazwaWoj{$w}{$m}\n"; } }
}
