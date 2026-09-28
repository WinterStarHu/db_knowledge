# Precedence Order for a Host Computer in Multiple Access Control List Assignments

The access control list assigned to a domain has a lower precedence than those assigned to the subdomains.
For multiple access control lists that are assigned to the host computer and its domains, the access control list that is assigned to the host computer takes precedence over those assigned to the domains.
The access control list assigned to a domain has a lower precedence than those assigned to the subdomains.For example, Oracle Database first selects the access control list assigned to the host `server.us.example.com`, ahead of other access control lists assigned to its domains. If additional access control lists were assigned to the sub domains, their order of precedence is as follows:
- server.us.example.com
- *.us.example.com
- *.example.com
- *.com
- *
Similarly, for multiple access control lists that are assigned to the IP address (both IPv4 and IPv6) and the subnets it belongs to, the access control list that is assigned to the IP address takes precedence over those assigned to the subnets. The access control list assigned to a subnet has a lower precedence than those assigned to the smaller subnets it contains.
For example, Oracle Database first selects the access control list assigned to the IP address `192.0.2.3`, ahead of other access control lists assigned to the subnets it belongs to. If additional access control lists were assigned to the subnets, their order of precedence is as follows:
````
- 192.0.2.3 (or ::ffff:192.0.2.3)
````
- 192.0.2.3/31 (or ::ffff:192.0.2.3/127)
````
- 192.0.2.3/30 (or ::ffff:192.0.2.3/126)
````
- 192.0.2.3/29 (or ::ffff:192.0.2.3/125)
- ...
``````
- 192.0.2.3/24 (or ::ffff:192.0.2.3/120 or 192.0.2.*)
- ...
``````
- 192.0.2.3/16 (or ::ffff:192.0.2.3/112 or 192.0.*)
- ...
``````
- 192.0.2.3/8 (or ::ffff:192.0.2.3/104 or 192.*)
- ...
- ::ffff:192.0.2.3/95
- ::ffff:192.0.2.3/94
- ...
- *
