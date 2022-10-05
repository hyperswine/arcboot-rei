require = {
    core = { version = "0.1", features = ["log"] }
}

// rein allows you to switch between target views => ctrl shift p -> switch target
target = {
    phantasm_ir = {
        default_target = true
    }
    aarch64_uefi = {}
    riscv64_none = {}
}

bin = {
    default = "arc"
}

// a project can define multiple library targets
// if you do, you have to assign direct submodules @!lib = "lib-name"
// its best to just have a single lib target and/or a few bin targets
lib = {
    default = "lib"
}

// when flashing to disk, include

// ALWAYS ASSUME SSD0/DISK0 is plugged in
// and formatted in this way

// maybe errors can go out to a serial port if thats available
// or parallel

# should be moved to the GPT block LBA0
# NOTE: if exe size goes to more than 4K, raise an error
@assert(binary_size < 4K)
_init: () -> ! {
    const LBA_SIZE = 4K
    const LBA1_BASE = LBA_SIZE
    const EFI_PART = "EFI PART"
    // all errors and core outputs, asserts, expects will be directed here until reset or reimpl'd
    const DEFAULT_SERIAL_OUT = 0x4000_0000

    // read from LBA1
    unsafe {
        let signature = core::ptr::read(LBA1_BASE as u64)
        assert(signature == EFI_PART)

        let first_usable_partition = read(0x28 as u64)
        // read from the LBA

        // assume starting LBA for entries is 2
        let partition_entry_0 = read(LBA1_BASE*2 as PartitionTypeGUID)
        // if nefs, then use it right away
        if partition_entry_0 == NeFSGUID {
            // find first LBA and last LBA
            let first_lba = read(LBA1_BASE*2 + 0x20 as u64)
            let last_lba = read(LBA1_BASE*2 + 0x28 as u64)

            // use the nefs driver to load arcboot proper
            let nefs_partition = nefs::parse_lba(first_lba, last_lba)
            nefs_partition.find_arcboot().execute()
        }
        else {
            err("Couldn't find a supported bootable partition")
        }

        // if reach this point, loop
        loop {}
    }
}

// I feel like we could make some EEPROM
// that executes at 0x0-SIZE
// and finds an Arcboot partition and all
