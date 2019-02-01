<?php

$context = new ZMQContext();
$client = new ZMQSocket($context, ZMQ::SOCKET_DEALER);
$identity = sprintf ("%04X", rand(0, 0x10000));
$client->setSockOpt(ZMQ::SOCKOPT_IDENTITY, $identity);
$client->connect("tcp://127.0.0.1:53939");

$poll = new ZMQPoll();
$poll->add($client, ZMQ::POLL_IN);

$messages = array_map(function ($x) {return str_shuffle($x);}, array_fill(0, 3, "MEGABUFFER"));
array_map(function($msg) use ($client, $poll) {
    $read = $write = [];
    $client->send($msg);
    $events = $poll->poll($read, $write, 3 * 1000);    
    if ($events) {
        $reply = $client->recv();
        echo "Reply: {$reply}".PHP_EOL;
    }
    return;
}, $messages);