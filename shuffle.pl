use List::Util qw(shuffle);

open(IN, "tgplist.txt");
@infile = <IN>;

open(OUT, ">shuffled.txt");

@infile = shuffle @infile;


for $line (@infile){
    print OUT "$line";

}

close(OUT);
close(IN);
