sub clrscr {
	print(`clear`);
}

sub verifycontinue {
	print("Do you want to continue (y/n): ");
	local $option = <STDIN>;
	while(!($option =~ m/^y$|^n$/i)){
		print("Invalid option, must be \"y\" or \"n\". Try again: ");
		$option = <STDIN>;
	}

	if($option =~ m/^n$/){
		exit(1);
	}
}
 
sub prompt {
	local ($cmd) = @_;
	local $line;
	open(CMD, $cmd . "|");

	while ($line = <CMD>) {
		print("$line");
	}

	close(CMD);
}

sub branchname {
	local $cmd = `git status`;
	return substr((split("\n", $cmd))[0], length("on branch "));
}

sub jiraticket {
	local ($branch) = @_;
	return substr($branch, 0, index($branch, "-", index($branch, "-") + 1));
}

sub validatecommitmessage {
	local ($jira, $msg) = @_;
	unless ($msg) {
		print("Enter the commit message:\n To finish write <EOF> and press enter\n");
		$msg = "";
		local $line = "";
		while(!($line =~ m/<EOF>/g)){
			$line = <STDIN>;
			$msg = $msg . $line;
		}
		$msg =~ s/<EOF>$//;
		chomp($msg);
		$msg = "Jira: $jira\n\nIncludes:\n$msg";
	}
	
	return $msg;
}

sub gitcheckout {
	local ($branch) = @_;
	unless($branch){
		$branch = "master";
	}
	`git checkout $branch`;
}

sub gitpull {
	local $branch = pop(@_);
	local $remote = pop(@_);
	unless($remote){
		$remote = "origin";
	}
	unless($branch){
		$branch = "master";
	}
	prompt("git pull $remote $branch");
}

sub gitaddfiles {
	local $cmd = `git status`;
	local @lines= split(/\n/, $cmd);
	local $askforstage = 0;
	shift(@lines); #On branch ...
	foreach $line (@lines){
		$line =~ s/^\s+|\s+$//g;
		if(($line =~ m/^Changes not staged/i) || ($line =~ m/^Untracked/i) || ($askforstage == 1)){
			$askforstage = 1;
			if(!($line =~ m// || $line =~ m/^\(use \"git /i || $line =~ m/nothing added to commit /i || $line =~ m/no changes added /i)){
				local ($status, $file) = split(":", $line);
				if($status){
					$status =~ s/^\s+|\s+$//g;
					unless($file){
						$file = $status;
						$status = "created";
					}
					$file =~ s/^\s+|\s+$//g;
					print("The file $file has been $status. Add, discard or ignore? (a/d/i):");
					local $option = <STDIN>;
					while(!($option =~ m/^a$|^d$|^i$/i)){
						print("Invalid option, must be \"a\" or \"d\" or \"i\". Try again: ");
						$option = <STDIN>;
					}

					if($option =~ m/^a$/){
						prompt("git add $file");
					}
					elsif($option =~ m/^d$/){
						prompt("git checkout -- $file");
					}
				}
			}
		}
	}
}

sub needtocommit {
	local $cmd = `git status`;
	local @lines= split(/\n/, $cmd);
	local $line = $lines[1];
	if($line =~ m/^nothing to commit/i){
		return 0;
	}
	else{
		return 1;
	}
}

sub gitcommit {
	local ($msg) = @_;
	prompt("git commit -m '$msg'");
}

sub gitpush {
	local $branch = pop(@_);
	local $remote = pop(@_);
	unless($remote){
		$remote = "origin";
	}
	unless($branch){
		$branch = "master";
	}
	prompt("git push $remote $branch");
}

sub gitmerge {
	local $branch = pop(@_);
	unless($branch){
		$branch = "master";
	}
	prompt("git merge $branch");
}

1;