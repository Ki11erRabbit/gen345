use godot::prelude::*;

mod arraylist;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}
