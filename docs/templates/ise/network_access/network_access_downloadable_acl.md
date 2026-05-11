# Downloadable ACL

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Elements` » `Results` » `Downloadable ACLs`

{{ doc_gen }}

### Examples

Example-1 Network Access Downloadable ACL with IPv4 Restriction to Single Host

This example demonstrates a Cisco ISE network access downloadable ACL (DACL) configured to provide highly restrictive IPv4 network access. The DACL "DACL1" is defined with dacl_type set to IPV4 and contains two access control entries: the first rule permits IP traffic from any source to a single destination host at 192.168.1.1, while the second rule denies all other IP traffic with an implicit deny-all statement.

```yaml
ise:
  network_access:
    policy_elements:
      downloadable_acls:
        - name: DACL1
          description: My dacl
          dacl_type: IPV4
          dacl_content: |
            permit ip any host 192.168.1.1
            deny ip any any
```

Example-2 Network Access Downloadable ACL for Guest Internet with Private Network Exclusion

This example demonstrates a Cisco ISE downloadable ACL configured for guest network access with internet-only connectivity while blocking internal corporate resources. The DACL "Guest_Internet_Only" uses dacl_type IPV4 and implements a security policy that permits essential internet services including DNS resolution (UDP port 53), web browsing (TCP ports 80, 443, and 8080 for HTTP, HTTPS, and alternate HTTP), while explicitly denying access to all RFC 1918 private IP address ranges: 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16. The final permit statement allows all remaining IP traffic, effectively granting unrestricted internet access while preventing lateral movement into internal corporate networks. 

```yaml
ise:
  network_access:
    policy_elements:
      downloadable_acls:
        - name: Guest_Internet_Only
          description: Guest access with internet only, no internal network access
          dacl_type: IPV4
          dacl_content: |
            permit udp any any eq 53
            permit tcp any any eq 80
            permit tcp any any eq 443
            permit tcp any any eq 8080
            deny ip any 10.0.0.0 0.255.255.255
            deny ip any 172.16.0.0 0.15.255.255
            deny ip any 192.168.0.0 0.0.255.255
            permit ip any any
```

Example-3 Network Access Downloadable ACL for VoIP Phone Communication and Management

This example demonstrates a Cisco ISE downloadable ACL configured specifically for IP phone network access, enabling voice communication and device management services. The DACL "VoIP_Phone_Access" uses dacl_type IPV4 and implements a comprehensive policy that permits Cisco Unified Communications Manager signaling to the voice subnet 10.100.0.0/16 on port 2000 and TCP ports 16384-32767, allows Real-Time Protocol (RTP) media streams on UDP ports 16384-32767 for voice and video transmission, and enables phone provisioning and management through HTTP (port 80), HTTPS (port 443), Cisco IP phone services (port 6970), TFTP for configuration downloads (UDP port 69), DNS resolution (UDP port 53), and NTP time synchronization (UDP port 123). ICMP is permitted for network troubleshooting and reachability testing, with a final explicit deny blocking all other traffic. 

```yaml
ise:
  network_access:
    policy_elements:
      downloadable_acls:
        - name: VoIP_Phone_Access
          description: Voice VLAN and call manager access for IP phones
          dacl_type: IPV4
          dacl_content: |
            permit tcp any 10.100.0.0 0.0.255.255 eq 2000
            permit tcp any 10.100.0.0 0.0.255.255 range 16384 32767
            permit udp any any range 16384 32767
            permit tcp any any eq 443
            permit tcp any any eq 80
            permit tcp any any eq 6970
            permit udp any any eq 53
            permit udp any any eq 69
            permit udp any any eq 123
            permit icmp any any
            deny ip any any
```