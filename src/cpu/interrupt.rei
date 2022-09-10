@cfg(target_arch = "aarch64") {

fn set_entry_interrupt_handler(vector_table_addr: u64, handler_addr: u64) {
    unsafe {
        write(addr=vector_table_addr, handler_addr)
    }
}

fn get_interrupt_table() -> Address {
    VTABLE.get()
}

const MAX_KTHREADS = 512

mut SP_ARRAY = Mutex([Address; MAX_KTHREADS])

type GenericInterruptHandler = fn()

# The first handler
fn entry_interrupt_handler(interrupt_code: u64) {
    // save state, all regs. Dont care about anything else, could be cached or whatever or write through (usually the kernel stack is write back)

    // save userspace sp
    let user_sp = SP_EL0.get()
    let user_regs = user_regs()

    Stack::push(user_sp)
    Stack::push(user_regs)

    // NOTE: each kernel thread has its own SP_EL1
    // accessible automatically on the current cpu core?
    // uhh yea I guess
    // and all kernel threads have access to a globally mutexed sp array corresponding to their thread id
    // how to tell the id of the thread?
    // maybe only care if sync interrupt

    let vtable = get_interrupt_table()
    unsafe {
        let interrupt_handler_addr = read_volatile(addr=vtable+interrupt_code*8) as GenericInterruptHandler
        interrupt_handler_addr()
    }
}

}