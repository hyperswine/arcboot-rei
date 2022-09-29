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
