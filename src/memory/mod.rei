@cfg(target_arch = "aarch64") {

ttbr1: () -> u64 { TTBR1.get() }
ttbr0: () -> u64 { TTBR0.get() }

set_ttbr0: (val: u64) { TTBR0.set(val) }
set_ttbr1: (val: u64) { TTBR1.set(val) }

const N_ENTRIES_4K = 512
const DEFAULT_PAGE_SIZE = 4096

const N_SECONDS_SLEEP = 1

#*
    Walk each table recursively, printing out the data of each
    Until there is an invalid descriptor
*#
walk_table_4k: (table_addr: u64, descriptor_type: DescriptorType) {
    info("At table of type $descriptor_type at addr $table_addr")

    for ind in 0..N_ENTRIES_4K {
        let res = unsafe {
            read_volatile(addr=(table_addr+ind*8))
        }
        // cast res as DescriptorType
        let res = res as descriptor_type
        // get the descriptor type of the page table it points to
        let next_level_addr = res.next_level_addr
        let next_desc_type = res.descriptor_type

        // print
        info("Descriptor = $res")

        @cfg(option="wait-after-log")
        sleep(N_SECONDS_SLEEP)

        walk_table_4k(next_level_addr, next_desc_type)
    }
}

}

# Generic stack abstraction for the kernel, e.g. for N kernel thread contexts
Stack: complex {
    # Push some data T onto the stack
    push<T: Write>: (t: T) {
        let sp = get_sp()
        unsafe {
            write_volatile(addr=sp, t)
        }
        // lower stack pointer
        write_sp(sp + sizeof(t))
    }
}

Block: [u8; 4096]

// DMA a block of memory ( does not implement data link layer protocols)
// Pad the rest of the memory

Dma: enum u64 => Read | Write

DmaArea: {
    action_start_addr: u64
    action_addr: u64

    // allow device to fetch the memory directly
    dma_to: (&mut self, blocks: &[Block]) {
        blocks.for_each(b => {
            (self.action_start_addr as *const u64).write(&b)
            (self.action_addr as *const u64).write(Dma::Read)
        })
    }
}

// hmm I dont know actually anymore...
// maybe arcboot for wrapping other stuff like limine and coreboot and etc...
// and responsible for setting up a "proper" supervisor environment
// for the riscv arch

// while arcboot exposes a few kernel independent "H mode" functions
// just in case
// and for arcvisor

// the kernel shouldnt know about architectures
// it should be using abstractions
// arcboot should be defining abstractions, not using them
// and wrap around all Von Neumann platform dependent features...

// neutron should also start spx:system
// and intercept interrupts in S-Mode
// and other faults

// arcboot simply makes doing that easier
