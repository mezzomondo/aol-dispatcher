# ZeroMQ Haskell ROUTER server example
## (with a Php DEALER client)

Cfr. Pieter Hintjens, Code Connected Volume 1, pag. 107 at the moment [available for free](http://hintjens.wdfiles.com/local--files/main%3Afiles/cc1pe.pdf).

The only fundamental difference is that the client has been "pulled out", due to the actual requirements of [Azienda-Online](https://aol.azienda-online.it/).

## Prerequisites
You need ZeroMQ installed ([follow the instructions](http://zeromq.org/area:download)) and the [php-zmq enabled](http://zeromq.org/bindings:php) to run the client.

## To run the server
Use [Haskell Stack](https://www.haskellstack.org) and...

```stack server.hs```

(the very firs time it'll take a while)

## To run the client
```php client.php```
