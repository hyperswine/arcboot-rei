@!cfg(feature="arc")

// in core, you can directly tamper with _init:
// if _init is defined, then core:: will not define it again
@no_mangle
_init: () -> Status => main()

// SP should already be set
// DRAM should already be started
// MMIO and DMA depends on the ACPI controller and the DMA controller

main: () -> Status {
    info("Launched into arc!")

    // ensure booted into from M-MODE
    if EXECUTION_MODE == Machine => log::info("Seems like a valid boot!")
    else => log::info("Did not boot from Machine Mode, was this intentional?")

    // set to Hypervisor mode
    EXECUTION_MODE.set(Hypervisor)

    // setup paging and memory map. In those fns, probably query the power controller and other platform specific features

    @cfg(target_arch = "riscv64")
    riscv_reset()

    @cfg(target_arch = "aarch64")
    aarch64_reset()

    // get a device map from the memory map
    let devices = memory_map.devices()
}
