# SDS011

## Interface specification:
 
Pin | Name | explain                                        |
--- | ---- | ---------------------------------------------- |
1   | CTL  | Control pin, reserved                          |
2   | 1um  | >0.3 Micron particle concentration, PWM Output |
3   | 5V   | 5V power input                                 |
4   | 25um | >2.5 Micron particle concentration, PWM Output |
5   | GND  | GND                                            |
6   | R    | Serial port receiver RX                        |
7   | T    | Serial port transmission TX                    |

The pitch of Interface is 2.54mm
 
## Communication protocol:
 
Serial communication protocol: 9600 8N1. (Rate of 9600, data bits 8, parity none, stop bits 1)

Serial report communication cycle: 1+0.5 seconds

Data frame (10 bytes): 

```
message header + order+ data(6 bytes) + checksum + message trailer
```

The number of bytes | Name            | Content         | 
------------------- | --------------- | --------------- |
0                   | message header  | AA              |
1                   | order           | C0              |
2                   | data 1          | PM2.5 low byte  |
3                   | data 2          | PM2.5 high byte |
4                   | data 3          | PM10 low byte   |
5                   | data 4          | PM10 high byte  |
6                   | data 5          | 0(reserved)     |
7                   | data 6          | 0(reserved)     |
8                   | checksum        | checksum        |
9                   | message trailer | AB              |

### Content details

Checksum: `data 1 + data 2 + ...+ data 6`

PM2.5 data content: `PM2.5 (ug/m3) = ((PM2.5 high byte*256 ) + PM2.5 low byte)/10`

PM10 data content: `PM10 (ug/m3) = ((PM10 high byte*256 ) + PM10 low byte)/10`

