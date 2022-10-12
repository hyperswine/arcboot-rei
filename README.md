# Arcboot

![Arcboot](/Arcboot.png)

Arcboot in Rei. Arcboot is the hammer, Neutron is the engineer.

## Rei VM

For ReiVM, a lot of things are handled for us. Even CPU speeds and stuff. All we want from it is a portable, working build that can scale when needed.

## Design

Arcboot is to be the first program run by a system when e.g. the CPU boots and starts executing at a fixed address. Arcboot implements the Arc API which kernel programs can use to gain access to platform dependent functionality in a uniform manner. So a kernel using Arc does not have to worry about architectures or ISA's at all, nor any special system conditions as they are all handled and wrapped by Arc.

Some functions defined in arcboot may be imported into neutron. Some may be shared by both either through duplication or a fixed memory vDSO. Hence Arcboot has stronger ELF and memory functionalities and drivers.

## Arc API

The Arc API is a low level API that wraps around platform dependent systems and concepts such as virtual memory, cpu ISAs and interrupts, cpu and memory privileges, etc.

A kernel that uses Arc can directly tinker with those settings in a useful way for e.g. userspace processes and sparx to work effectively. That is the key role of Neutron, to simply supervise the system state, directly handle hardware interrupts and any syscalls to gain access to a specific device.
