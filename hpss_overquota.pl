#!/usr/bin/perl -w
use strict;
use warnings;
use POSIX qw(strftime);
use DBI;
use Time::Local 'timelocal';


## mysql database user name
my $user = "****";

## mysql database password
my $pass = "****";

## user hostname : This should be "localhost" but it can be diffrent too
my $host="****";

my $db = "****";

my $today_string = strftime "%m/%d/%Y", localtime;

my ($m, $d, $y) = split '/', $today_string;
my $today_unix_time_6_am = timelocal(0, 0, 6, $d, $m-1, $y);
my $today_unix_time_5_pm = timelocal(0, 0, 17, $d, $m-1, $y);

## SQL query
#my $query = "select name, acct_type, kbytes, kb_softq from quotas_sonexions where DATE(ctime)=CURDATE()";

my $dbh = DBI->connect(join('',
          "DBI:mysql:database=$db;host=$host;",
          qw{
             mysql_ssl=1;
             mysql_ssl_client_key=****;
             mysql_ssl_client_cert=****;
             mysql_ssl_ca_file=****
            }),
            $user, $pass);
my $query = "select name, CASE WHEN type = 'u' THEN 'User' WHEN type = 'p' THEN 'Projects' ELSE type END as type, id, format(bytes,0) as bytes, format(quota,0) as quota from quotas_hpss where ctime >= $today_unix_time_6_am AND ctime <= $today_unix_time_5_pm AND (bytes <> 0 AND quota <>0) AND (bytes > quota) order by type, name";
my $sqlQuery  = $dbh->prepare($query)
or die "Can't prepare $query: $dbh->errstr\n";

my $rv = $sqlQuery->execute
or die "can't execute the query: $sqlQuery->errstr";

my $date = strftime "%m/%d/%Y", localtime;

my $content ="";
$content = $content.join "|",@{$sqlQuery->{NAME}};
$content = $content."\n";
while (our @row= $sqlQuery->fetchrow_array()) {
my $line = join('|',@row);
$content = $content."$line\n";
}
my $rc = $sqlQuery->finish;

print $content;
exit(0);
