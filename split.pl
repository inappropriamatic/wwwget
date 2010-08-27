# This program splits up a shuffled list of tgps, and prepares them all to be crawled with wget.
# You need:
#    A shuffled list of tgp links (shuffle.txt), probably generated from shuffle.pl
#    A wget command to run on all those links (tgpwget.txt)
#    Gnu screen
#    wget

# this is a shuffled list of tgp links.  we are splitting it into parts to be run in parallel
open(IN, "shuffled.txt");
$num_partitions = 5;

# we are going to run each wget inside of screen, and we are using a screenrc to do it
open(SCREENCONF, ">screenconfig");

# get the long wget command for ripping a tgp
open(WGETCOMMAND, "tgpwget.txt");
@command = <WGETCOMMAND>;
$command = $command[0];



@infile = <IN>;

$num_lines = int($#infile / $num_partitions) + 1;

for $i (1..$num_partitions){
    # make the directory, stuff the tgplist into it
    `mkdir wwwget_$i`;
    open (OUT, ">./wwwget_$i/tgplist.txt");
    
    for $k ( (1..$num_lines) ){
        print OUT pop(@infile);
    }
    close(OUT);
    
    # update the screenrc we are going to use
    # runs wget at a lower priority from each of the subdirectories created
    print SCREENCONF "chdir ./wwwget_$i\n";
    print SCREENCONF "screen -t \"wwwget_$i\" $i nice -14 $command\n";
    print SCREENCONF "chdir ..\n";
    
} # end of num_partitions for

close(SCREENCONF);
close(IN);

