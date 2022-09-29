@!cfg(feature="arc")

// in core, you can directly tamper with _init:
@no_mangle
_init: () -> ! {
    main()

    loop {}
}

main: () -> Status {
    info("Launched into arc!")

    @cfg(target_arch = "riscv64")
    riscv_reset()

    @cfg(target_arch = "aarch64")
    aarch64_reset()
}
