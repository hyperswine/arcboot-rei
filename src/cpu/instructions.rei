@inline
get_sp: () -> Address {
    @cfg(target_arch = "aarch64")
    return SP.get()
}

@inline
write_sp: (new_addr: Address) {
    @cfg(target_arch = "aarch64")
    return SP.write(new_addr)
}
