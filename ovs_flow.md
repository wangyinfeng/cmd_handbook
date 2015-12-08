ovs flow
===========================

## key_extract
```
struct sw_flow_key {
	struct ovs_key_ipv4_tunnel tun_key;  /* Encapsulating tunnel key. */
	struct {
		u32	priority;	/* Packet QoS priority. */
		u32	skb_mark;	/* SKB mark. */
		u16	in_port;	/* Input switch port (or DP_MAX_PORTS). */
	} __packed phy; /* Safe when right after 'tun_key'. */
	u32 ovs_flow_hash;		/* Datapath computed hash value.  */
	u32 recirc_id;			/* Recirculation ID.  */
	struct {
		u8     src[ETH_ALEN];	/* Ethernet source address. */
		u8     dst[ETH_ALEN];	/* Ethernet destination address. */
		__be16 tci;		/* 0 if no VLAN, VLAN_TAG_PRESENT set otherwise. */
		__be16 type;		/* Ethernet frame type. */
	} eth;
	struct {
		u8     proto;		/* IP protocol or lower 8 bits of ARP opcode. */
		u8     tos;		/* IP ToS. */
		u8     ttl;		/* IP TTL/hop limit. */
		u8     frag;		/* One of OVS_FRAG_TYPE_*. */
	} ip;
	struct {
		__be16 src;		/* TCP/UDP/SCTP source port. */
		__be16 dst;		/* TCP/UDP/SCTP destination port. */
		__be16 flags;		/* TCP flags. */
	} tp;
	union {
		struct {
			struct {
				__be32 src;	/* IP source address. */
				__be32 dst;	/* IP destination address. */
			} addr;
			struct {
				u8 sha[ETH_ALEN];	/* ARP source hardware address. */
				u8 tha[ETH_ALEN];	/* ARP target hardware address. */
			} arp;
		} ipv4;
		struct {
			struct {
				struct in6_addr src;	/* IPv6 source address. */
				struct in6_addr dst;	/* IPv6 destination address. */
			} addr;
			__be32 label;			/* IPv6 flow label. */
			struct {
				struct in6_addr target;	/* ND target address. */
				u8 sll[ETH_ALEN];	/* ND source link layer address. */
				u8 tll[ETH_ALEN];	/* ND target link layer address. */
			} nd;
		} ipv6;
	};
} __aligned(BITS_PER_LONG/8); /* Ensure that we can do comparisons as longs. */
```


## flow_lookup

ovs_dp_process_received_packet -> ovs_flow_key_extract -> ovs_dp_process_packet_with_key -> ovs_flow_tbl_lookup_stats -> flow_lookup -> masked_flow_lookup


## flow limit calculate
```
            if (duration > 2000) {
                flow_limit /= duration / 1000;
            } else if (duration > 1300) {
                flow_limit = flow_limit * 3 / 4;
            } else if (duration < 1000 && n_flows > 2000
                       && flow_limit < n_flows * 1000 / duration) {
                flow_limit += 1000;
            }
            flow_limit = MIN(ofproto_flow_limit, MAX(flow_limit, 1000));
```
