use std::cmp::Ordering;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Object)]
struct ArrayList {
    vec: Vec<Variant>,
    base: Base<Object>,
}

#[godot_api]
impl IObject for ArrayList {
    fn init(base: Base<Self::Base>) -> Self {
        Self {
            vec: Vec::new(),
            base
        }
    }
}


#[godot_api]
impl ArrayList {
    #[func]
    fn from_array(array: VariantArray) -> Gd<Self> {
        Gd::from_init_fn(|base| {
            let mut vec = Vec::with_capacity(array.len());
            for variant in array.iter_shared() {
                vec.push(variant);
            }

            Self {
                vec,
                base
            }
        })
    }

    #[func]
    fn with_capacity(capacity: i64) -> Gd<Self> {
        Gd::from_init_fn(|base| {
            Self {
                base,
                vec: Vec::with_capacity(capacity as usize)
            }
        })
    }

    #[func]
    fn initialize(size: i64, value: Callable) -> Gd<Self> {
        Gd::from_init_fn(|base| {
            let mut vec = Vec::with_capacity(size as usize);
            for i in 0..size {
                vec.push(value.call(&[Variant::from(i)]))
            }

            Self {
                base,
                vec
            }
        })
    }

    #[func]
    fn append(&mut self, value: Variant) {
        self.vec.push(value);
    }

    #[func]
    fn append_array(&mut self, array: VariantArray) {
        for value in array.iter_shared() {
            self.append(value);
        }
    }

    #[func]
    fn front(&self) -> Variant {
        self.vec.first().cloned().unwrap_or(Variant::nil())
    }

    #[func]
    fn back(&self) -> Variant {
        self.vec.last().cloned().unwrap_or(Variant::nil())
    }

    #[func]
    fn push_front(&mut self, value: Variant) {
        self.vec.push(value);
    }

    #[func]
    fn pop_front(&mut self) -> Variant {
        self.vec.pop().unwrap_or(Variant::nil())
    }

    #[func]
    fn push_back(&mut self, value: Variant) {
        self.vec.push(value);
    }

    #[func]
    fn pop_back(&mut self) -> Variant {
        self.vec.pop().unwrap_or(Variant::nil())
    }

    /// Returns Nil if index is out of bounds
    #[func]
    fn pop_at(&mut self, index: i64) -> Variant {
        if index < 0 || index >= self.vec.len() as i64 {
            godot_error!("Index out of bounds");
            return Variant::nil();
        }
        self.vec.remove(index as usize)
    }

    #[func]
    fn remove_at(&mut self, index: i64) {
        if index < 0 || index >= self.vec.len() as i64 {
            godot_error!("Index out of bounds");
            return;
        }
        self.vec.remove(index as usize);
    }

    #[func]
    fn clear(&mut self) {
        self.vec.clear();
    }

    /// Does not perform a deep copy
    #[func]
    fn duplicate(&self) -> Gd<Self> {
        Gd::from_init_fn(|base| {
            let vec = self.vec.clone();

            Self {
                base,
                vec
            }
        })
    }

    #[func]
    fn insert(&mut self, index: i64, value: Variant) {
        self.vec.insert(index as usize, value);
    }

    /// Returns Nil if index is out of bounds
    #[func]
    fn get(&self, index: i64) -> Variant {
        let index = if index < 0 {
            (self.vec.len() as i64 + index) as usize
        } else {
            index as usize
        };

        self.vec.get(index).cloned().unwrap_or_else(|| {
            godot_error!("Index out of bounds");
            Variant::nil()
        })
    }

    #[func]
    fn set(&mut self, index: i64, value: Variant) {
        let index = if index < 0 {
            (self.vec.len() as i64 + index) as usize
        } else {
            index as usize
        };

        let Some(reference) = self.vec.get_mut(index) else {
            godot_error!("Index out of bounds");
            return
        };

        *reference = value;
    }

    #[func]
    fn size(&self) -> i64 {
        self.vec.len() as i64
    }

    #[func]
    fn capacity(&self) -> i64 {
        self.vec.capacity() as i64
    }

    #[func]
    fn reverse(&mut self) {
        self.vec.reverse();
    }

    #[func]
    fn map(&self, f: Callable) -> Gd<Self> {
        Gd::from_init_fn(|base| {
            let vec = self.vec.iter()
                .map(|variant| f.call(&[variant.clone()]))
                .collect();

            Self{
                base,
                vec,
            }
        })
    }

    #[func]
    fn reduce(&self, accum: Variant, f: Callable) -> Variant {
        self.vec.iter()
            .fold(accum, |accum, value| {
                f.call(&[accum, value.clone()])
            })
    }

    /// f should be a function that returns an integer.
    /// -1 if less than
    /// 0 if equal
    /// 1 if greater than
    #[func]
    fn sort(&mut self, f: Callable) {
        self.vec.sort_by(|a, b| {
            match f.call(&[a.clone(), b.clone()]).try_to::<i64>().unwrap_or_else(|err| {
                godot_error!("{}", err);
                0
            }) {
                0 => Ordering::Equal,
                -1 => Ordering::Less,
                1 => Ordering::Greater,
                _ => {
                    godot_error!("Ordering function should have returned 0, -1, or 1");
                    Ordering::Equal
                }
            }
        })
    }

    #[func]
    fn find(&self, value: Variant) -> i64 {
        let mut index = -1;
        for (i, val) in self.vec.iter().enumerate() {
            if *val == value {
                index = i as i64;
                break;
            }
        }

        index
    }

    #[func]
    fn find_custom(&self, predicate: Callable) -> i64 {
        let mut index = -1;
        for (i, val) in self.vec.iter().enumerate() {
            if predicate.call(&[val.clone()]).try_to::<bool>().unwrap_or_else(|err| {
                godot_error!("{}", err);
                false
            }) {
                index = i as i64;
                break;
            }
        }
        index
    }

    #[func]
    fn rfind(&self, value: Variant) -> i64 {
        let mut index = -1;
        for (i, val) in self.vec.iter().enumerate().rev() {
            if *val == value {
                index = i as i64;
                break;
            }
        }

        index
    }

    #[func]
    fn rfind_custom(&self, predicate: Callable) -> i64 {
        let mut index = -1;
        for (i, val) in self.vec.iter().enumerate().rev() {
            if predicate.call(&[val.clone()]).try_to::<bool>().unwrap_or_else(|err| {
                godot_error!("{}", err);
                false
            }) {
                index = i as i64;
                break;
            }
        }
        index
    }

    #[func]
    fn bsearch(&self, value: Variant, comparator: Callable) -> i64 {
        let result = self.vec.binary_search_by(|a| {
            match comparator.call(&[value.clone(), a.clone()]).try_to::<i64>() {
                Ok(-1) => Ordering::Less,
                Ok(0) => Ordering::Equal,
                Ok(1) => Ordering::Greater,
                Err(err) => {
                    godot_error!("{}", err);
                    Ordering::Less
                }
                Ok(x) => {
                    godot_error!("Comparator function should have returned 0, -1, or 1 but returned: {}", x);
                    Ordering::Less
                }

            }
        });

        match result {
            Ok(index) => index as i64,
            Err(index) => index as i64,
        }
    }

    #[func]
    fn all(&self, method: Callable) -> bool {
        self.vec.iter().all(|x| {
            method.call(&[x.clone()]).try_to::<bool>().unwrap_or_else(|err| {
                godot_error!("{}", err);
                false
            })
        })
    }

    #[func]
    fn any(&self, method: Callable) -> bool {
        self.vec.iter().any(|x| {
            method.call(&[x.clone()]).try_to::<bool>().unwrap_or_else(|err| {
                godot_error!("{}", err);
                false
            })
        })
    }

    #[func]
    fn count(&self, value: Variant) -> i64 {
        self.vec.iter()
            .fold(0, |accum, val| {
                if *val == value {
                    accum + 1
                } else {
                    accum
                }
            })
    }
}

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {

}


