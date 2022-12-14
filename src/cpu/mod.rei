# A generic processing element
@derive(Clone, Copy)
Cpu: complex {
    clock: {
        min_freq: f32
        max_freq: f32
        curr_freq: f32
    }

    # all signatures with new(...) -> Self is sugared into Self(...)
    # syntax sugared into ::new() by IDE
    new: (min_freq: f32, max_freq: f32) -> Self {
        Self {
            clock: { min_freq, max_freq, 0 }
        }
    }

    set_freq: (&mut self, new_freq: f32) {
        self.clock.curr_freq = new_freq
    }
}

# Useful abstraction for multicore processors
system ProcessorComplex<const N> {
    cores: [Cpu; N]

    new: (cpus: &[Cpu]) -> Self {
        Self {
            cores: cpus
        }
    }
}

# Adjust the freq of a cpu core or processing element
adjust_freq: (cpu: Cpu, new_freq: f32) {
    cpu.set_freq(new_freq)
}
