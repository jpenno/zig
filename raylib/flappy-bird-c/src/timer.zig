pub const Timer = struct {
    duration: f32,
    timer: f32,

    pub fn init(duration: f32) Timer {
        return Timer{
            .duration = duration,
            .timer = 0,
        };
    }

    pub fn tick(self: *Timer, dt: f32) bool {
        self.timer += dt;

        if (self.timer >= self.duration) {
            self.timer = 0;
            return true;
        }
        return false;
    }
};
