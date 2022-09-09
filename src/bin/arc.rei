@!cfg(feature="arc")

fn main() -> ! {
    info("Launched into arc!")

    @cfg(target_arch = "riscv64")
    riscv_reset()

    @cfg(target_arch = "aarch64")
    aarch64_reset()
}
