# Deprecated features, interfaces (and quirks)

Once upon a time, long long ago (okay, maybe yesterday), there existed
an entirely different implementation of discoteq. This api is currently
supported, but will be removed at some point in the future.

Don't worry, we'll give you notice! Everything user facing that changes
(including security issues) will get a big fat warning if you try to
use it. Sadly security fixes will have to be changed immediately. But
everything else will remain until the next major release.

## Properties via chef data bag `/services`

The service data bag is a `JSON` object which contains attributes
relevant to the the clients or peers of a service. These properties are
popluated in the resulting `services` object when `service_disco` is
called, for example:

    services = service_disco %w(statsd foo_cache foo_db)

Each service data bag should specify an `id`, a `discovery` mode of
`role` or `explicit`, and an optional `default` object. An

```json
{
  "id": "foo_cache",
  "discovery": "explicit",
  "environments": {
    "prod": {
      "hosts": [
        "foo-cache-1.prod.example.net",
        "foo-cache-2.prod.example.net"
      ]
    },
    "stg": {
      "hosts": [
        "localhost"
        "foo-cache-1.stg.example.net"
      ]
    },
    "dev": {
      "hosts": [
        "localhost"
      ]
    }
  },
  "default": {
    "port": "11211"
  }
}
```

After running `services = service_disco %w(foo_cache)` on a node with a
`chef_environment` of `prod`, `services.to_json` will contain:

```json
{
  "foo_cache": {
    "hosts": [
      "foo-cache-1.prod.example.net",
      "foo-cache-2.prod.example.net"
    ]
    "port": "11211",
  }
}
```
