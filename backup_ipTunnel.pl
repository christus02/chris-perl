#Workaround to support for backup ipTunnel in Netscaler


sub ping_test {
    my $dest = shift;
    my $src = shift;
    my $out = qx#ping -c 1 -S $src $dest#;
    if ($out =~ /1 packets received/) {
        return(1);
    } else {
        return(0);
    };
}

sub exec_cmd {
    my $user = "nsroot";
    my $pass = "nsroot";
    my $cmd = shift;
    my $out = qx#nscli -U 127.0.0.1:$user:$pass "$cmd"#;
    return($out);
};

while(1) {
    if (ping_test("100.4.1.1", "100.3.1.10") == 0) {
        print "Primary IPTunnel Failed\n";
        exec_cmd("rm pbr p1");
        exec_cmd("apply ns pbrs");
        exec_cmd("add ns pbr p1 ALLOW -srcIP = 100.3.1.0-100.3.1.255 -destIP = 100.4.1.0-100.4.1.255 -ipTunnel t2");
        exec_cmd("apply ns pbrs");
        exit(0);

    } else {
        print "Ping passed\n";
        sleep(2);
    }
}
