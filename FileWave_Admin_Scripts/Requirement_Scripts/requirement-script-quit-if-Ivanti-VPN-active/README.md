
In many cases, the command `scutil <<< "show State:/Network/Global/IPv4"` may provide information that a VPN connection is able.

If active, then the output will be something like this:

`<dictionary> {`<br />
  `PrimaryInterface : en1` <br />
  `PrimaryService : net.pulsesecure.pulse.nc.main` <br />
  `Router : 10.0.0.1` <br />
`}` <br />

If NOT active, then the output will be something like this:

`<dictionary> {` <br />
  `PrimaryInterface : en1` <br />
  `PrimaryService : 1234567-1234-1234-1234-123456789` <br />
  `Router : 10.0.0.1` <br />
`}` <br />
