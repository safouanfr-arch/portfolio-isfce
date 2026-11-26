"""Print the network, mask, broadcast and usable endpoints for IPv4 interfaces."""

import argparse
import ipaddress


def describe(value):
    interface = ipaddress.IPv4Interface(value)
    network = interface.network
    first, last = network.network_address, network.broadcast_address
    if network.prefixlen < 31:
        first += 1
        last -= 1
    return network, network.netmask, first, last, int(last) - int(first) + 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("interfaces", nargs="+", help="example: 192.168.4.25/27")
    args = parser.parse_args()
    for value in args.interfaces:
        try:
            network, mask, first, last, usable = describe(value)
        except ValueError as error:
            parser.error(str(error))
        print(f"{value}: network={network} mask={mask} broadcast={network.broadcast_address}")
        print(f"  {usable} usable addresses ({first} to {last})")


if __name__ == "__main__":
    main()
